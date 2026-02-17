# Quickstart Guide: AI Powered ToDo ChatBot Extension

**Feature**: 001-ai-powered-extension
**Date**: 2026-02-11
**Status**: Planning Complete

## Overview

This guide provides a quick reference for developers implementing the AI Powered ToDo ChatBot Extension. The system extends the existing Phase-II ToDo application with conversational AI capabilities while maintaining strict architectural principles.

## Architecture Principles

### Agent-First Architecture
- AI agents reason and decide which MCP tools to invoke
- Agents NEVER directly access the database
- All data operations occur through MCP tools only

### Stateless Operation
- Server holds NO in-memory session state
- Conversation context reconstructed from database on EVERY request
- Enables horizontal scalability

### Tool-Mediated Action
- All AI actions occur through MCP tools
- MCP tools are stateless and persist changes directly to database
- Strict input/output schemas enforced

## Key Components

### 1. Chat Endpoint (`POST /chat`)

**Location**: `backend/src/routes/chat.route.js`

**Request**:
```json
{
  "user_id": "uuid",
  "conversation_id": "uuid",
  "message": "Add a task to complete math homework tomorrow at 5pm"
}
```

**Response**:
```json
{
  "agent_response": "I've created a new todo...",
  "invoked_tool": "create_todo",
  "tool_result": { "success": true, "todo_id": "uuid" },
  "conversation_state": { "conversation_id": "uuid", "message_count": 2 }
}
```

### 2. AI Agent Service

**Location**: `backend/src/services/ai-agent.service.js`

**Responsibilities**:
- Interpret natural language user input
- Decide which MCP tool to invoke (if any)
- Generate structured tool input following JSON schemas
- Format natural language responses

**Key Methods**:
- `processMessage(conversationHistory, userMessage)` - Main entry point
- `selectTool(userIntent)` - Determine appropriate MCP tool
- `generateToolInput(toolName, userMessage)` - Create structured input
- `formatResponse(toolResult)` - Generate natural language response

### 3. MCP Tools

**Location**: `backend/src/services/mcp-tools/`

**Available Tools**:
- `create-todo.tool.js` - Create new todo
- `update-todo.tool.js` - Update existing todo
- `delete-todo.tool.js` - Delete todo
- `list-todos.tool.js` - List/filter todos
- `get-todo-by-id.tool.js` - Retrieve specific todo

**Tool Interface**:
```javascript
{
  name: "create_todo",
  schema: { /* JSON Schema */ },
  execute: async (input) => {
    // 1. Validate input against schema
    // 2. Perform database operation
    // 3. Log action for traceability
    // 4. Return structured result
  }
}
```

### 4. Chat Service

**Location**: `backend/src/services/chat.service.js`

**Responsibilities**:
- Store incoming user messages
- Reconstruct conversation context from database
- Orchestrate AI agent and MCP tool invocations
- Persist tool results and agent responses

**Key Methods**:
- `handleChatMessage(userId, conversationId, message)` - Main orchestrator
- `reconstructContext(conversationId)` - Load conversation history
- `storeMessage(conversationId, role, content, toolData)` - Persist messages

## Database Schema

### New Tables

**conversations**:
```sql
CREATE TABLE conversations (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES users(id),
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);
```

**messages**:
```sql
CREATE TABLE messages (
  id UUID PRIMARY KEY,
  conversation_id UUID NOT NULL REFERENCES conversations(id),
  role VARCHAR(20) NOT NULL CHECK (role IN ('user', 'assistant', 'tool')),
  content TEXT NOT NULL,
  tool_name VARCHAR(100),
  tool_input JSONB,
  tool_output JSONB,
  timestamp TIMESTAMP NOT NULL DEFAULT NOW()
);
```

## Request Flow

```
1. User sends message → POST /chat
2. Chat controller validates request
3. Chat service stores user message in DB
4. Chat service reconstructs conversation history from DB
5. AI agent processes message with full context
6. AI agent decides to invoke MCP tool (or respond directly)
7. MCP tool executes (stateless, persists to DB, logs action)
8. Tool result stored in messages table
9. AI agent generates natural language response
10. Response returned to user with full traceability
```

## Development Workflow

### 1. Implement MCP Tools First
Start with the MCP tools as they are the foundation:
```bash
# Create tool with strict schema
backend/src/services/mcp-tools/create-todo.tool.js
```

### 2. Implement Chat Service
Build the stateless orchestration layer:
```bash
backend/src/services/chat.service.js
```

### 3. Integrate AI Agent
Connect the AI agent with tool selection logic:
```bash
backend/src/services/ai-agent.service.js
```

### 4. Add Chat Endpoint
Expose the functionality via REST API:
```bash
backend/src/routes/chat.route.js
backend/src/controllers/chat.controller.js
```

## Testing Strategy

### Unit Tests
- Test each MCP tool independently
- Test AI agent tool selection logic
- Test conversation context reconstruction

### Integration Tests
- Test full chat flow end-to-end
- Test MCP tool invocation from AI agent
- Test database persistence and retrieval

### Contract Tests
- Validate MCP tool inputs/outputs against schemas
- Validate API request/response formats

## Configuration

### Environment Variables
```env
OPENAI_API_KEY=your_api_key_here
DATABASE_URL=postgresql://user:pass@localhost:5432/todos
NODE_ENV=development
```

### AI Agent Configuration
```javascript
{
  model: "gpt-4",
  temperature: 0.7,
  maxTokens: 500,
  systemPrompt: "You are a helpful assistant for managing todos..."
}
```

## Common Patterns

### Pattern 1: Stateless Context Reconstruction
```javascript
async function reconstructContext(conversationId) {
  const messages = await db.query(
    'SELECT * FROM messages WHERE conversation_id = $1 ORDER BY timestamp ASC',
    [conversationId]
  );
  return messages.map(formatMessageForAgent);
}
```

### Pattern 2: MCP Tool Invocation
```javascript
async function invokeTool(toolName, input) {
  const tool = mcpTools[toolName];

  // Validate input
  const valid = validateSchema(input, tool.schema.input);
  if (!valid) throw new ValidationError();

  // Execute (stateless, persists to DB)
  const result = await tool.execute(input);

  // Log for traceability
  await logToolInvocation(toolName, input, result);

  return result;
}
```

### Pattern 3: Agent Response Generation
```javascript
async function generateResponse(conversationHistory, toolResult) {
  const prompt = buildPrompt(conversationHistory, toolResult);
  const response = await aiClient.complete(prompt);
  return response.text;
}
```

## Troubleshooting

### Issue: Agent accessing database directly
**Solution**: Ensure all database operations go through MCP tools. Review code for any direct DB queries in agent service.

### Issue: Conversation context not reconstructed
**Solution**: Verify messages are being stored correctly and query is ordered by timestamp.

### Issue: Tool schema validation failing
**Solution**: Check that tool input matches JSON schema exactly. Use schema validation library.

## Next Steps

1. Review [data-model.md](./data-model.md) for complete schema details
2. Review [contracts/](./contracts/) for API and tool schemas
3. Proceed to task generation with `/sp.tasks`
4. Begin implementation following TDD principles

## References

- [Feature Specification](./spec.md)
- [Implementation Plan](./plan.md)
- [Research Summary](./research.md)
- [Data Model](./data-model.md)
- [API Contracts](./contracts/chat-api.yaml)
- [MCP Tool Contracts](./contracts/mcp-tools.json)