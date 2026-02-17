---
description: "Task list for AI Powered ToDo ChatBot Extension implementation"
---

# Tasks: AI Powered ToDo ChatBot Extension

**Input**: Design documents from `/specs/001-ai-powered-extension/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: Tests are OPTIONAL - only included if explicitly requested in the feature specification.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- **Web app**: `backend/src/`, `frontend/src/`
- Paths shown below follow the plan.md structure

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure

- [ ] T001 Verify existing Phase-II backend structure and dependencies
- [ ] T002 [P] Install OpenAI API SDK in backend/package.json
- [ ] T003 [P] Configure environment variables for OpenAI API key in backend/.env
- [ ] T004 [P] Setup TypeScript configuration if not already present in backend/tsconfig.json

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

### Database Extension

- [ ] T005 Create database migration for conversations table in backend/migrations/001_create_conversations.sql
- [ ] T006 Create database migration for messages table in backend/migrations/002_create_messages.sql
- [ ] T007 Add indexes for conversations table (user_id, created_at) in backend/migrations/003_add_conversation_indexes.sql
- [ ] T008 Add indexes for messages table (conversation_id, timestamp, role) in backend/migrations/004_add_message_indexes.sql
- [ ] T009 Run migrations and verify Phase-II todo schema remains unchanged

### Data Models

- [ ] T010 [P] Create Conversation model in backend/src/models/conversation.model.js
- [ ] T011 [P] Create Message model in backend/src/models/message.model.js
- [ ] T012 Verify existing Todo model remains unchanged in backend/src/models/todo.model.js

### MCP Tool Framework

- [ ] T013 Create MCP tool base interface with JSON schema validation in backend/src/services/mcp-tools/base-tool.js
- [ ] T014 Create tool registry for managing available MCP tools in backend/src/services/mcp-tools/tool-registry.js
- [ ] T015 Implement tool execution logger for traceability in backend/src/services/mcp-tools/tool-logger.js

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel

---

## Phase 3: User Story 1 - Natural Language Todo Creation (Priority: P1) 🎯 MVP

**Goal**: Users can create todos using natural language commands like "Add a task to complete math homework tomorrow at 5pm"

**Independent Test**: Send natural language creation request to chat endpoint and verify new todo is created in database with correct details

### MCP Tool for User Story 1

- [ ] T016 [US1] Implement create_todo MCP tool with JSON schema in backend/src/services/mcp-tools/create-todo.tool.js
- [ ] T017 [US1] Add input validation for create_todo tool (title, user_id, scheduled_at)
- [ ] T018 [US1] Implement stateless database persistence in create_todo tool
- [ ] T019 [US1] Add action logging to create_todo tool

### Chat Service Foundation

- [ ] T020 [US1] Implement conversation context reconstruction in backend/src/services/chat.service.js
- [ ] T021 [US1] Implement message storage functionality in backend/src/services/chat.service.js
- [ ] T022 [US1] Add conversation state management (stateless) in backend/src/services/chat.service.js

### AI Agent Integration

- [ ] T023 [US1] Create AI agent service with OpenAI integration in backend/src/services/ai-agent.service.js
- [ ] T024 [US1] Implement system prompt for todo creation intent recognition in backend/src/services/ai-agent.service.js
- [ ] T025 [US1] Implement tool selection logic for create_todo in backend/src/services/ai-agent.service.js
- [ ] T026 [US1] Implement structured tool input generation from natural language in backend/src/services/ai-agent.service.js
- [ ] T027 [US1] Implement natural language response formatting in backend/src/services/ai-agent.service.js

### Chat Endpoint

- [ ] T028 [US1] Create POST /chat endpoint in backend/src/routes/chat.route.js
- [ ] T029 [US1] Implement chat controller with request validation in backend/src/controllers/chat.controller.js
- [ ] T030 [US1] Integrate chat service with AI agent in backend/src/controllers/chat.controller.js
- [ ] T031 [US1] Implement response formatting (agent_response, invoked_tool, tool_result, conversation_state) in backend/src/controllers/chat.controller.js
- [ ] T032 [US1] Add error handling for chat endpoint in backend/src/controllers/chat.controller.js

### Basic Chat UI

- [ ] T033 [US1] Create chat interface component in frontend/src/components/ChatInterface.jsx
- [ ] T034 [US1] Implement message display (user and assistant bubbles) in frontend/src/components/ChatInterface.jsx
- [ ] T035 [US1] Add message input and send functionality in frontend/src/components/ChatInterface.jsx
- [ ] T036 [US1] Integrate chat UI with POST /chat endpoint in frontend/src/services/chat.service.js

**Checkpoint**: At this point, User Story 1 should be fully functional - users can create todos via natural language

---

## Phase 4: User Story 2 - Natural Language Todo Management (Priority: P2)

**Goal**: Users can update, delete, and list todos using natural language commands

**Independent Test**: Send natural language management requests (update, delete, list) and verify operations execute correctly

### MCP Tools for User Story 2

- [ ] T037 [P] [US2] Implement update_todo MCP tool with JSON schema in backend/src/services/mcp-tools/update-todo.tool.js
- [ ] T038 [P] [US2] Implement delete_todo MCP tool with JSON schema in backend/src/services/mcp-tools/delete-todo.tool.js
- [ ] T039 [P] [US2] Implement list_todos MCP tool with JSON schema in backend/src/services/mcp-tools/list-todos.tool.js
- [ ] T040 [P] [US2] Implement get_todo_by_id MCP tool with JSON schema in backend/src/services/mcp-tools/get-todo-by-id.tool.js
- [ ] T041 [US2] Add input validation for all US2 MCP tools
- [ ] T042 [US2] Add stateless database persistence for all US2 MCP tools
- [ ] T043 [US2] Add action logging for all US2 MCP tools

### AI Agent Enhancement

- [ ] T044 [US2] Extend system prompt to recognize update/delete/list intents in backend/src/services/ai-agent.service.js
- [ ] T045 [US2] Implement tool selection logic for update/delete/list operations in backend/src/services/ai-agent.service.js
- [ ] T046 [US2] Enhance structured input generation for management operations in backend/src/services/ai-agent.service.js
- [ ] T047 [US2] Enhance response formatting for list results in backend/src/services/ai-agent.service.js

### UI Enhancement

- [ ] T048 [US2] Add todo list display in chat responses in frontend/src/components/ChatInterface.jsx
- [ ] T049 [US2] Implement rich formatting for todo items in chat in frontend/src/components/TodoDisplay.jsx

**Checkpoint**: At this point, User Stories 1 AND 2 should both work independently - full CRUD via natural language

---

## Phase 5: User Story 3 - AI Agent MCP Tool Integration (Priority: P3)

**Goal**: Ensure AI agent only uses MCP tools, never directly accesses database, with full enforcement and traceability

**Independent Test**: Verify all AI operations go through MCP tools, no direct DB access occurs, and all actions are logged

### Enforcement Layer

- [ ] T050 [US3] Implement MCP tool schema validator in backend/src/services/mcp-tools/schema-validator.js
- [ ] T051 [US3] Add tool call validation middleware in backend/src/middleware/tool-validation.middleware.js
- [ ] T052 [US3] Implement database access blocker for AI agent context in backend/src/services/ai-agent.service.js
- [ ] T053 [US3] Add malformed tool input rejection in backend/src/services/mcp-tools/tool-registry.js

### Validation & Error Handling

- [ ] T054 [US3] Implement structured error responses for tool failures in backend/src/services/mcp-tools/base-tool.js
- [ ] T055 [US3] Add error logging for all tool execution failures in backend/src/services/mcp-tools/tool-logger.js
- [ ] T056 [US3] Implement graceful degradation for AI agent errors in backend/src/services/ai-agent.service.js

### Audit System

- [ ] T057 [US3] Create audit log table migration in backend/migrations/005_create_audit_logs.sql
- [ ] T058 [US3] Implement comprehensive action logging (user message, agent decision, tool name, tool I/O, response) in backend/src/services/audit.service.js
- [ ] T059 [US3] Add conversation replay functionality in backend/src/services/audit.service.js
- [ ] T060 [US3] Ensure deterministic traceability for all operations in backend/src/services/audit.service.js

### Developer Mode UI

- [ ] T061 [US3] Add developer mode toggle in frontend/src/components/ChatInterface.jsx
- [ ] T062 [US3] Implement tool invocation status display in frontend/src/components/ToolDebugPanel.jsx
- [ ] T063 [US3] Show tool name, input, and output in debug panel in frontend/src/components/ToolDebugPanel.jsx
- [ ] T064 [US3] Add AI reasoning trace display (optional) in frontend/src/components/ToolDebugPanel.jsx

**Checkpoint**: All user stories should now be independently functional with full enforcement and audit capabilities

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

### UI Polish

- [ ] T065 [P] Ensure responsive design for all screen sizes in frontend/src/components/ChatInterface.jsx
- [ ] T066 [P] Add loading states and animations in frontend/src/components/ChatInterface.jsx
- [ ] T067 [P] Implement error message display in UI in frontend/src/components/ErrorDisplay.jsx
- [ ] T068 [P] Add conversation history scrolling and pagination in frontend/src/components/ChatInterface.jsx

### Performance Optimization

- [ ] T069 Optimize conversation context reconstruction queries in backend/src/services/chat.service.js
- [ ] T070 Add database query result caching (stateless) in backend/src/services/cache.service.js
- [ ] T071 Implement request rate limiting for chat endpoint in backend/src/middleware/rate-limit.middleware.js

### Documentation & Validation

- [ ] T072 [P] Update API documentation with chat endpoint details in backend/docs/api.md
- [ ] T073 [P] Create deployment guide in docs/deployment.md
- [ ] T074 Run quickstart.md validation and update as needed
- [ ] T075 Verify Phase-II API compatibility with integration tests

### Security Hardening

- [ ] T076 [P] Add input sanitization for user messages in backend/src/middleware/sanitization.middleware.js
- [ ] T077 [P] Implement conversation access authorization in backend/src/middleware/auth.middleware.js
- [ ] T078 Add OpenAI API key rotation support in backend/src/config/openai.config.js

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3-5)**: All depend on Foundational phase completion
  - User stories can then proceed in parallel (if staffed)
  - Or sequentially in priority order (P1 → P2 → P3)
- **Polish (Phase 6)**: Depends on all desired user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2) - No dependencies on other stories
- **User Story 2 (P2)**: Can start after Foundational (Phase 2) - Extends US1 but independently testable
- **User Story 3 (P3)**: Can start after Foundational (Phase 2) - Adds enforcement to US1/US2 but independently testable

### Within Each User Story

- MCP tools before AI agent integration
- AI agent before chat endpoint
- Chat endpoint before UI
- Core implementation before enhancements

### Parallel Opportunities

- All Setup tasks marked [P] can run in parallel
- All Foundational database migrations can run sequentially, but models can be parallel
- MCP tool framework components can run in parallel
- Once Foundational phase completes, all user stories can start in parallel (if team capacity allows)
- Within US2, all four MCP tools marked [P] can be implemented in parallel
- All Polish tasks marked [P] can run in parallel

---

## Parallel Example: User Story 2

```bash
# Launch all MCP tools for User Story 2 together:
Task: "Implement update_todo MCP tool in backend/src/services/mcp-tools/update-todo.tool.js"
Task: "Implement delete_todo MCP tool in backend/src/services/mcp-tools/delete-todo.tool.js"
Task: "Implement list_todos MCP tool in backend/src/services/mcp-tools/list-todos.tool.js"
Task: "Implement get_todo_by_id MCP tool in backend/src/services/mcp-tools/get-todo-by-id.tool.js"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL - blocks all stories)
3. Complete Phase 3: User Story 1
4. **STOP and VALIDATE**: Test User Story 1 independently
5. Deploy/demo if ready - users can now create todos via natural language

### Incremental Delivery

1. Complete Setup + Foundational → Foundation ready
2. Add User Story 1 → Test independently → Deploy/Demo (MVP - todo creation!)
3. Add User Story 2 → Test independently → Deploy/Demo (Full CRUD!)
4. Add User Story 3 → Test independently → Deploy/Demo (Full enforcement & audit!)
5. Each story adds value without breaking previous stories

### Parallel Team Strategy

With multiple developers:

1. Team completes Setup + Foundational together
2. Once Foundational is done:
   - Developer A: User Story 1 (T016-T036)
   - Developer B: User Story 2 (T037-T049)
   - Developer C: User Story 3 (T050-T064)
3. Stories complete and integrate independently

---

## Constitutional Compliance Checkpoints

After each user story phase, verify:

- ✅ **Agent-First Architecture**: AI agent reasons and decides which MCP tools to invoke
- ✅ **Stateless Execution**: No in-memory session state; conversation context reconstructed from DB
- ✅ **Tool-Mediated Action**: All data operations occur through MCP tools only
- ✅ **Deterministic Side Effects**: All actions traceable and persisted in Message table
- ✅ **Clear Separation of Concerns**: Agent logic, tool execution, and UI layers remain separate
- ✅ **MCP Tool Compliance**: All tools follow strict schemas and are stateless
- ✅ **API Compatibility**: Phase-II APIs remain unchanged and functional
- ✅ **No Manual Coding**: All implementation occurs through MCP tools

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
- Verify Phase-II APIs remain functional after each phase
- Ensure no direct database access by AI agent at any point
- All MCP tools must be stateless and persist changes directly to database