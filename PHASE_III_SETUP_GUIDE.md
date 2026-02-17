# Phase-III AI Chatbot Setup Guide

## 🎯 What Was Implemented

Phase-III extends your existing Phase-II Todo application with:
- ✅ AI-powered natural language todo management
- ✅ Agent-First architecture (AI agent + MCP tools)
- ✅ Stateless REST API with conversation context reconstruction
- ✅ Full traceability and audit logging
- ✅ Modern chat UI with debug mode
- ✅ Phase-II APIs remain fully functional

## 📋 Prerequisites

1. **OpenAI API Key** - Get one at https://platform.openai.com/api-keys
2. Python 3.8+ installed
3. Node.js 18+ installed

## 🚀 Setup Instructions

### Step 1: Configure OpenAI API Key

Add your OpenAI API key to the backend `.env` file:

```bash
cd New2_phase2_heckathone/backend
```

Edit the `.env` file and add:
```
OPENAI_API_KEY=your-openai-api-key-here
```

### Step 2: Install Backend Dependencies

```bash
# Make sure you're in the backend directory
cd New2_phase2_heckathone/backend

# Activate virtual environment (Windows)
.\venv\Scripts\activate

# Install new dependencies
pip install -r requirements.txt
```

### Step 3: Run Database Migrations

The new tables (conversations, messages) will be created automatically when you start the backend.

### Step 4: Start Backend Server

```bash
# Make sure virtual environment is activated
# Make sure you're in the backend directory
uvicorn src.main:app --reload --host 0.0.0.0 --port 8000
```

Backend will be available at:
- API: http://localhost:8000
- API Docs: http://localhost:8000/docs

### Step 5: Start Frontend Server

Open a NEW terminal:

```bash
cd New2_phase2_heckathone/frontend

# Install dependencies (if needed)
npm install

# Start development server
npm run dev
```

Frontend will be available at: http://localhost:3000

## 🎮 How to Use the AI Chatbot

1. **Login** to your account at http://localhost:3000
2. **Navigate** to http://localhost:3000/chat
3. **Start chatting** with natural language commands:

### Example Commands

**Create Todos:**
- "Add a task to buy groceries tomorrow"
- "Create a todo for finishing the report by Friday"
- "Remind me to call mom at 5pm"

**List Todos:**
- "Show my pending tasks"
- "What are my completed todos?"
- "List all my tasks"

**Update Todos:**
- "Mark my homework as completed"
- "Complete the grocery shopping task"
- "Update my meeting task to done"

**Delete Todos:**
- "Delete the meeting task"
- "Remove my gym todo"

## 🔍 Debug Mode

Click "Show Debug Mode" in the chat interface to see:
- Which MCP tool was invoked
- Tool input parameters
- Tool output results
- Full traceability of AI actions

## 🏗️ Architecture Overview

```
User Message
    ↓
POST /chat (Stateless REST endpoint)
    ↓
Store message in DB
    ↓
Reconstruct conversation history from DB
    ↓
AI Agent (OpenAI GPT-4)
    ↓
Decides which MCP tool to invoke
    ↓
MCP Tool (create_todo, update_todo, delete_todo, list_todos)
    ↓
Persists changes directly to database
    ↓
Tool result stored in DB
    ↓
AI Agent generates natural language response
    ↓
Response returned to user
```

## ✅ Constitutional Compliance

- ✅ **Agent-First Architecture**: AI agent reasons and decides which tools to invoke
- ✅ **Stateless Execution**: No in-memory session state; conversation reconstructed from DB
- ✅ **Tool-Mediated Action**: All data operations through MCP tools only
- ✅ **Deterministic Side Effects**: All actions traceable and persisted
- ✅ **Clear Separation of Concerns**: Agent, tools, and UI are separate layers
- ✅ **MCP Tool Compliance**: All tools follow strict JSON schemas
- ✅ **API Compatibility**: Phase-II APIs remain unchanged
- ✅ **Horizontal Scalability**: Fully stateless architecture

## 🧪 Testing Phase-II Compatibility

Phase-II APIs should still work:

```bash
# Test existing todo endpoints
curl http://localhost:8000/tasks

# Test health check
curl http://localhost:8000/health
```

## 📁 New Files Created

### Backend:
- `src/models/conversation.py` - Conversation and Message models
- `src/services/mcp_tools/base_tool.py` - Base MCP tool class
- `src/services/mcp_tools/create_todo_tool.py` - Create todo tool
- `src/services/mcp_tools/update_todo_tool.py` - Update todo tool
- `src/services/mcp_tools/delete_todo_tool.py` - Delete todo tool
- `src/services/mcp_tools/list_todos_tool.py` - List todos tool
- `src/services/mcp_tools/tool_registry.py` - Tool registry
- `src/services/ai_agent_service.py` - AI agent with OpenAI
- `src/services/chat_service.py` - Stateless chat service
- `src/api/chat.py` - Chat API endpoint

### Frontend:
- `src/components/ChatInterface.tsx` - Chat UI component
- `src/app/chat/page.tsx` - Chat page

## 🐛 Troubleshooting

### "OPENAI_API_KEY not found"
- Make sure you added the API key to `backend/.env`
- Restart the backend server after adding the key

### "Module not found" errors
- Run `pip install -r requirements.txt` in backend
- Make sure virtual environment is activated

### Chat UI not loading
- Make sure you're logged in
- Check browser console for errors
- Verify backend is running on port 8000

### Database errors
- Delete `backend/todo.db` and restart backend to recreate tables
- Check that SQLModel is properly installed

## 🎉 Success Criteria

You'll know it's working when:
1. ✅ You can send natural language messages in the chat
2. ✅ AI creates/updates/deletes/lists todos based on your messages
3. ✅ Debug mode shows which tools were invoked
4. ✅ Phase-II todo list still works normally
5. ✅ All actions are logged and traceable

## 📊 Next Steps

- Add more sophisticated natural language understanding
- Implement conversation history UI
- Add voice input support
- Create analytics dashboard for AI usage
- Add more MCP tools for advanced features
