terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.20.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.6.2"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-2"
}

variable "agent_name" {
  description = "Base name for the agent resources"
  type        = string
  default     = "tf-agent-example"
}

variable "runtime_name" {
  description = "Name for the Bedrock AgentCore runtime"
  type        = string
  default     = "tf_simple_agent"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Project     = "project"
    Environment = "dev"
  }
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_ecr_repository" "agent" {
  name                 = var.agent_name
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}

locals {
  # Track changes to source files
  source_files = {
    dockerfile = fileexists("${path.module}/Dockerfile") ? filemd5("${path.module}/Dockerfile") : ""
    agent_py   = fileexists("${path.module}/agent.py") ? filemd5("${path.module}/agent.py") : ""
    pyproject  = fileexists("${path.module}/pyproject.toml") ? filemd5("${path.module}/pyproject.toml") : ""
    uv_lock    = fileexists("${path.module}/uv.lock") ? filemd5("${path.module}/uv.lock") : ""
  }

  # Create a hash of all source files combined
  source_hash = substr(sha256(join("", values(local.source_files))), 0, 12)
}

resource "null_resource" "docker_build_push" {
  triggers = local.source_files

  provisioner "local-exec" {
    command = <<-EOT
      set -e
      
      aws ecr get-login-password --region ${var.aws_region} | \
        docker login --username AWS --password-stdin \
        ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com      
      docker build --platform linux/arm64 \
        -t ${var.agent_name}:${local.source_hash} \
        ${path.module}
      docker tag ${var.agent_name}:${local.source_hash} \
        ${aws_ecr_repository.agent.repository_url}:${local.source_hash}
      docker push ${aws_ecr_repository.agent.repository_url}:${local.source_hash}
    EOT
  }

  depends_on = [aws_ecr_repository.agent]
}

# IAM Role for Bedrock AgentCore
resource "aws_iam_role" "agent" {
  name = "${var.agent_name}-role"
  tags = var.tags

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "bedrock-agentcore.amazonaws.com"
        }
        Action = "sts:AssumeRole"
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
          ArnLike = {
            "aws:SourceArn" = "arn:aws:bedrock-agentcore:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:*"
          }
        }
      }
    ]
  })
}

# IAM Policy for agent
resource "aws_iam_role_policy" "agent" {
  name = "${var.agent_name}-policy"
  role = aws_iam_role.agent.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ECRImageAccess"
        Effect = "Allow"
        Action = [
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchCheckLayerAvailability"
        ]
        Resource = aws_ecr_repository.agent.arn
      },
      {
        Sid    = "ECRTokenAccess"
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:DescribeLogStreams",
          "logs:CreateLogGroup"
        ]
        Resource = "arn:aws:logs:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/bedrock-agentcore/runtimes/*"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:DescribeLogGroups"
        ]
        Resource = "arn:aws:logs:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:log-group:*"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/bedrock-agentcore/runtimes/*:log-stream:*"
      },
      {
        Effect = "Allow"
        Action = [
          "xray:PutTraceSegments",
          "xray:PutTelemetryRecords",
          "xray:GetSamplingRules",
          "xray:GetSamplingTargets"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:PutMetricData"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "cloudwatch:namespace" = "bedrock-agentcore"
          }
        }
      },
      {
        Sid    = "GetAgentAccessToken"
        Effect = "Allow"
        Action = [
          "bedrock-agentcore:GetWorkloadAccessToken",
          "bedrock-agentcore:GetWorkloadAccessTokenForJWT",
          "bedrock-agentcore:GetWorkloadAccessTokenForUserId"
        ]
        Resource = [
          "arn:aws:bedrock-agentcore:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:workload-identity-directory/default",
          "arn:aws:bedrock-agentcore:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:workload-identity-directory/default/workload-identity/dogos-*"
        ]
      },
      {
        Sid    = "BedrockModelInvocation"
        Effect = "Allow"
        Action = [
          "bedrock:InvokeModel",
          "bedrock:InvokeModelWithResponseStream"
        ]
        Resource = [
          "arn:aws:bedrock:*::foundation-model/*",
          "arn:aws:bedrock:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:*"
        ]
      }
    ]
  })
}

resource "aws_bedrockagentcore_agent_runtime" "runtime" {
  agent_runtime_name = var.runtime_name
  tags         = var.tags
  role_arn     = aws_iam_role.agent.arn

  agent_runtime_artifact {
    container_configuration {
      container_uri = "${aws_ecr_repository.agent.repository_url}:${local.source_hash}"
    }
  }

  network_configuration {
    network_mode = "PUBLIC"
  }

  protocol_configuration {
    server_protocol = "HTTP"
  }

  environment_variables = {
    AWS_REGION = data.aws_region.current.region
  }

  depends_on = [
    null_resource.docker_build_push,
    aws_iam_role_policy.agent
  ]
}


output "runtime_arn" {
  description = "Runtime ARN"
  value       = aws_bedrockagentcore_agent_runtime.runtime.agent_runtime_arn
}

output "runtime_id" {
  description = "Runtime ID"
  value       = aws_bedrockagentcore_agent_runtime.runtime.agent_runtime_id
}

output "ecr_repository_url" {
  description = "ECR Repository URL"
  value       = aws_ecr_repository.agent.repository_url
}

output "image_tag" {
  description = "Docker image tag based on source code hash"
  value       = local.source_hash
}
