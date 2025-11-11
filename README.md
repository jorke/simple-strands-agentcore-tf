
## setup
```
uv venv
source venv/bin/activate

uv sync

```

## strands agent

`python strands_agent.py '{"prompt": "What is the weather now?"}'`

## agent core
```
> agentcore configure -e simple_agent.py

Configuring Bedrock AgentCore...
✓ Using file: simple_agent.py

🏷️  Inferred agent name: simple_agent
Press Enter to use this name, or type a different one (alphanumeric without '-')
Agent name [simple_agent]:
✓ Using agent name: simple_agent

🔍 Detected dependency file: pyproject.toml
Press Enter to use this file, or type a different path (use Tab for autocomplete):
Path or Press Enter to use detected dependency file: pyproject.toml
✓ Using requirements file: pyproject.toml

🔐 Execution Role
Press Enter to auto-create execution role, or provide execution role ARN/name to use existing
Previously configured: arn:aws:iam::XX:role/AmazonBedrockAgentCoreSDKRuntime-ap-southeast-2-9d6fae7ebe
Execution role ARN/name (or press Enter to auto-create):
✓ Will auto-create execution role

🏗️  ECR Repository
Press Enter to auto-create ECR repository, or provide ECR Repository URI to use existing
Previously configured: XX.dkr.ecr.ap-southeast-2.amazonaws.com/bedrock-agentcore-simple_agent
ECR Repository URI (or press Enter to auto-create):
✓ Will auto-create ECR repository

🔐 Authorization Configuration
By default, Bedrock AgentCore uses IAM authorization.
Configure OAuth authorizer instead? (yes/no) [no]: no
✓ Using default IAM authorization

🔒 Request Header Allowlist
Configure which request headers are allowed to pass through to your agent.
Common headers: Authorization, X-Amzn-Bedrock-AgentCore-Runtime-Custom-*
Configure request header allowlist? (yes/no) [no]: no
✓ Using default request header configuration
Configuring BedrockAgentCore agent: simple_agent

Memory Configuration
Tip: Use --disable-memory flag to skip memory entirely

✅ MemoryManager initialized for region: ap-southeast-2
Existing memory resources found:
  1. simple_agent_mem-La7ZnXHM4l
     ID: simple_agent_mem-La7ZnXHM4l

Options:
  • Enter a number to use existing memory
  • Press Enter to create new memory
Your choice: 1
✓ Using existing memory: simple_agent_mem-La7ZnXHM4l
Using existing memory resource: simple_agent_mem-La7ZnXHM4l
Found existing memory ID from previous launch: simple_agent_mem-La7ZnXHM4l
Generated Dockerfile: .bedrock_agentcore/simple_agent/Dockerfile
Keeping 'simple_agent' as default agent
╭────────────────────────────────────────────────────────────────────── Configuration Success ──────────────────────────────────────────────────────────────────────╮
│ Agent Details                                                                                                                                                     │
│ Agent Name: simple_agent                                                                                                                                          │
│ Runtime: Docker                                                                                                                                                   │
│ Region: ap-southeast-2                                                                                                                                            │
│ Account: XX                                                                                                                                                       │
│                                                                                                                                                                   │
│ Configuration                                                                                                                                                     │
│ Execution Role: Auto-create                                                                                                                                       │
│ ECR Repository: Auto-create                                                                                                                                       │
│ Authorization: IAM (default)                                                                                                                                      │
│                                                                                                                                                                   │
│                                                                                                                                                                   │
│ Memory: Short-term memory (30-day retention)                                                                                                                      │
│                                                                                                                                                                   │
│ 📄 Config saved to: ./simple-strands-agent/.bedrock_agentcore.yaml                                                                                                │
│                                                                                                                                                                   │
│ Next Steps:                                                                                                                                                       │
│    agentcore launch                                                                                                                                               │
╰───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯


> agentcore launch

🚀 Launching Bedrock AgentCore (codebuild mode - RECOMMENDED)...
   • Build ARM64 containers in the cloud with CodeBuild
   • No local Docker required (DEFAULT behavior)
   • Production-ready deployment

💡 Deployment options:
   • agentcore launch                → CodeBuild (current)
   • agentcore launch --local        → Local development
   • agentcore launch --local-build  → Local build + cloud deploy

Creating memory resource for agent: simple_agent
⠼ Launching Bedrock AgentCore...✅ MemoryManager initialized for region: ap-southeast-2
⠦ Launching Bedrock AgentCore...🔎 Retrieving memory resource with ID: simple_agent_mem-La7ZnXHM4l...
⠋ Launching Bedrock AgentCore...  Found memory: simple_agent_mem-La7ZnXHM4l
Found existing memory in cloud: simple_agent_mem-La7ZnXHM4l
Existing memory has 0 strategies
✅ Using existing STM-only memory
Starting CodeBuild ARM64 deployment for agent 'simple_agent' to account XX (ap-southeast-2)
Setting up AWS resources (ECR repository, execution roles)...
Getting or creating ECR repository for agent: simple_agent
✅ Reusing existing ECR repository: XX.dkr.ecr.ap-southeast-2.amazonaws.com/bedrock-agentcore-simple_agent
⠋ Launching Bedrock AgentCore...✅ ECR repository available: XX.dkr.ecr.ap-southeast-2.amazonaws.com/bedrock-agentcore-simple_agent
Getting or creating execution role for agent: simple_agent
Using AWS region: ap-southeast-2, account ID: XX
Role name: AmazonBedrockAgentCoreSDKRuntime-ap-southeast-2-9d6fae7ebe
⠙ Launching Bedrock AgentCore...✅ Reusing existing execution role: arn:aws:iam::XX:role/AmazonBedrockAgentCoreSDKRuntime-ap-southeast-2-9d6fae7ebe
✅ Execution role available: arn:aws:iam::XX:role/AmazonBedrockAgentCoreSDKRuntime-ap-southeast-2-9d6fae7ebe
Preparing CodeBuild project and uploading source...
⠹ Launching Bedrock AgentCore...Getting or creating CodeBuild execution role for agent: simple_agent
Role name: AmazonBedrockAgentCoreSDKCodeBuild-ap-southeast-2-9d6fae7ebe
⠸ Launching Bedrock AgentCore...Reusing existing CodeBuild execution role: arn:aws:iam::XX:role/AmazonBedrockAgentCoreSDKCodeBuild-ap-southeast-2-9d6fae7ebe
⠼ Launching Bedrock AgentCore...Using dockerignore.template with 45 patterns for zip filtering
Including Dockerfile from ./simple-strands-agent/.bedrock_agentcore/simple_agent in source.zip
⠴ Launching Bedrock AgentCore...Uploaded source to S3: simple_agent/source.zip
⠏ Launching Bedrock AgentCore...Created CodeBuild project: bedrock-agentcore-simple_agent-builder
Starting CodeBuild build (this may take several minutes)...
⠹ Launching Bedrock AgentCore...Starting CodeBuild monitoring...
🔄 QUEUED started (total: 0s)
⠼ Launching Bedrock AgentCore...✅ QUEUED completed in 1.0s
🔄 PROVISIONING started (total: 1s)
⠋ Launching Bedrock AgentCore...✅ PROVISIONING completed in 8.4s
🔄 DOWNLOAD_SOURCE started (total: 9s)
⠦ Launching Bedrock AgentCore...✅ DOWNLOAD_SOURCE completed in 2.1s
🔄 BUILD started (total: 12s)
⠦ Launching Bedrock AgentCore...✅ BUILD completed in 20.0s
🔄 POST_BUILD started (total: 32s)
⠹ Launching Bedrock AgentCore...✅ POST_BUILD completed in 9.4s
🔄 FINALIZING started (total: 41s)
⠦ Launching Bedrock AgentCore...✅ FINALIZING completed in 1.0s
🔄 COMPLETED started (total: 42s)
✅ COMPLETED completed in 0.0s
🎉 CodeBuild completed successfully in 0m 41s
CodeBuild completed successfully
✅ CodeBuild project configuration saved
Deploying to Bedrock AgentCore...
Passing memory configuration to agent: simple_agent_mem-La7ZnXHM4l
⠧ Launching Bedrock AgentCore...✅ Agent created/updated: arn:aws:bedrock-agentcore:ap-southeast-2:XX:runtime/simple_agent-vQqH7962le
Observability is enabled, configuring Transaction Search...
⠧ Launching Bedrock AgentCore...CloudWatch Logs resource policy already configured
⠇ Launching Bedrock AgentCore...X-Ray trace destination already configured
X-Ray indexing rule already configured
✅ Transaction Search already fully configured
🔍 GenAI Observability Dashboard:
   https://console.aws.amazon.com/cloudwatch/home?region=ap-southeast-2#gen-ai-observability/agent-core
Polling for endpoint to be ready...
⠋ Launching Bedrock AgentCore...Agent endpoint: arn:aws:bedrock-agentcore:ap-southeast-2:XX:runtime/simple_agent-vQqH7962le/runtime-endpoint/DEFAULT
Deployment completed successfully - Agent: arn:aws:bedrock-agentcore:ap-southeast-2:XX:runtime/simple_agent-vQqH7962le
╭─────────────────────────────────────────────────────────────── Deployment Success ───────────────────────────────────────────────────────────────╮
│ Agent Details:                                                                                                                                   │
│ Agent Name: simple_agent                                                                                                                         │
│ Agent ARN: arn:aws:bedrock-agentcore:ap-southeast-2:XX:runtime/simple_agent-vQqH7962le                                                           │
│ ECR URI: XX.dkr.ecr.ap-southeast-2.amazonaws.com/bedrock-agentcore-simple_agent:latest                                                           │
│ CodeBuild ID: bedrock-agentcore-simple_agent-builder:4de6d8c3-56a8-4e52-ab87-9daa056a05f2                                                        │
│                                                                                                                                                  │
│ 🚀 ARM64 container deployed to Bedrock AgentCore                                                                                                 │
│                                                                                                                                                  │
│ Next Steps:                                                                                                                                      │
│    agentcore status                                                                                                                              │
│    agentcore invoke '{"prompt": "Hello"}'                                                                                                        │
│                                                                                                                                                  │
│ 📋 CloudWatch Logs:                                                                                                                              │
│    /aws/bedrock-agentcore/runtimes/simple_agent-vQqH7962le-DEFAULT --log-stream-name-prefix "2025/10/30/[runtime-logs]"                          │
│    /aws/bedrock-agentcore/runtimes/simple_agent-vQqH7962le-DEFAULT --log-stream-names "otel-rt-logs"                                             │
│                                                                                                                                                  │
│ 🔍 GenAI Observability Dashboard:                                                                                                                │
│    https://console.aws.amazon.com/cloudwatch/home?region=ap-southeast-2#gen-ai-observability/agent-core                                          │
│                                                                                                                                                  │
│ ⏱️  Note: Observability data may take up to 10 minutes to appear after first launch                                                              │
│                                                                                                                                                  │
│ 💡 Tail logs with:                                                                                                                               │
│    aws logs tail /aws/bedrock-agentcore/runtimes/simple_agent-vQqH7962le-DEFAULT --log-stream-name-prefix "2025/10/30/[runtime-logs]" --follow   │
│    aws logs tail /aws/bedrock-agentcore/runtimes/simple_agent-vQqH7962le-DEFAULT --log-stream-name-prefix "2025/10/30/[runtime-logs]" --since 1h │
╰──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯

```

## Invoke

`agentcore invoke '{"prompt": "What is the weather now?"}'`# simple-strands-agentcore-tf
