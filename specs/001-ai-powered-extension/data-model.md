# Data Model: AI Powered ToDo ChatBot Extension

**Date**: 2026-02-11
**Feature**: 001-ai-powered-extension
**Status**: Complete

## Overview

This data model extends the existing Phase-II ToDo application database with new tables to support conversational AI functionality while maintaining full compatibility with existing schema. The design supports stateless operation with complete conversation history tracking.

## Entity Relationships

```
Conversation (1) → (Many) Message
Message (Many) → (1) Todo (via tool operations)
```

## Extended Database Schema

### New Tables

#### Conversation Table
- **Table Name**: `conversations`
- **Purpose**: Track individual chat sessions per user

| Field | Type | Constraints | Description |
|-------|------|-------------|-------------|
| id | UUID | PRIMARY KEY, NOT NULL | Unique identifier for conversation |
| user_id | UUID | FOREIGN KEY, NOT NULL | Reference to user (maintains Phase-II compatibility) |
| created_at | TIMESTAMP | NOT NULL, DEFAULT NOW() | When conversation started |
| updated_at | TIMESTAMP | NOT NULL, DEFAULT NOW() | Last activity in conversation |

#### Message Table
- **Table Name**: `messages`
- **Purpose**: Store all messages and tool invocations in conversation history

| Field | Type | Constraints | Description |
|-------|------|-------------|-------------|
| id | UUID | PRIMARY KEY, NOT NULL | Unique message identifier |
| conversation_id | UUID | FOREIGN KEY, NOT NULL | Reference to parent conversation |
| role | VARCHAR(20) | NOT NULL, CHECK | One of: 'user', 'assistant', 'tool' |
| content | TEXT | NOT NULL | Message content or response text |
| tool_name | VARCHAR(100) | NULL | Name of MCP tool invoked (if any) |
| tool_input | JSONB | NULL | Input parameters sent to tool |
| tool_output | JSONB | NULL | Result returned from tool |
| timestamp | TIMESTAMP | NOT NULL, DEFAULT NOW() | When message occurred |

### Preserved Tables (Phase-II Compatibility)

#### Todo Table (Unchanged)
- **Table Name**: `todos`
- **Purpose**: Maintain existing todo functionality (unchanged to preserve Phase-II API compatibility)

| Field | Type | Constraints | Description |
|-------|------|-------------|-------------|
| id | UUID | PRIMARY KEY, NOT NULL | Unique todo identifier |
| title | VARCHAR(255) | NOT NULL | Todo title |
| description | TEXT | NULL | Optional description |
| completed | BOOLEAN | NOT NULL, DEFAULT FALSE | Completion status |
| created_at | TIMESTAMP | NOT NULL, DEFAULT NOW() | Creation time |
| updated_at | TIMESTAMP | NOT NULL, DEFAULT NOW() | Last update time |
| user_id | UUID | FOREIGN KEY, NOT NULL | Owner of the todo |

## Indexes for Performance

### Conversation Table Indexes
- `idx_conversations_user_id`: Index on user_id for user-specific queries
- `idx_conversations_created_at`: Index on created_at for chronological ordering

### Message Table Indexes
- `idx_messages_conversation_id`: Index on conversation_id for conversation history retrieval
- `idx_messages_timestamp`: Index on timestamp for chronological ordering
- `idx_messages_role`: Index on role for filtering message types
- `idx_messages_conversation_timestamp`: Composite index for efficient conversation history queries

## Validation Rules

### Conversation Constraints
- Each conversation must have a valid user_id that references existing user
- created_at and updated_at are automatically managed by triggers

### Message Constraints
- role must be one of 'user', 'assistant', or 'tool'
- If role is 'tool', then tool_name must be provided
- If tool_name is provided, then tool_input and tool_output must be valid JSON
- conversation_id must reference an existing conversation

### Referential Integrity
- All foreign key relationships enforce referential integrity
- Cascading deletes not used to preserve historical data

## State Transitions

### Message States
Messages are immutable once created, representing a permanent record of the conversation history.

### Todo States
Todos maintain their existing state transitions (completed/uncompleted) through MCP tools, with all changes tracked in messages.

## Access Patterns

### Primary Queries
1. **Conversation History**: Retrieve full conversation history for context reconstruction
   - Query: `SELECT * FROM messages WHERE conversation_id = ? ORDER BY timestamp ASC`
   - Index: `idx_messages_conversation_timestamp`

2. **User Conversations**: List conversations for a specific user
   - Query: `SELECT * FROM conversations WHERE user_id = ? ORDER BY updated_at DESC`
   - Index: `idx_conversations_user_id`

3. **Tool Invocations**: Find all tool invocations for audit/tracing
   - Query: `SELECT * FROM messages WHERE role = 'tool' AND conversation_id = ?`
   - Index: `idx_messages_role`

## Data Lifecycle

### Creation
- New conversation created when user initiates first chat
- Messages added sequentially as conversation progresses

### Updates
- Messages are immutable (append-only log)
- Conversation updated_at field updated on each new message

### Retention
- Historical data maintained indefinitely for audit and debugging
- Future enhancement may include configurable retention policies

## Extension Points

### Future Enhancements
- Metadata fields for conversation tagging/classification
- Summary fields for conversation analytics
- Attachment support for richer interactions

### MCP Tool Integration
- Tool-specific result fields can be added to tool_output JSON
- Performance metrics can be added to track tool effectiveness

## Compatibility Guarantees

### Phase-II API Compatibility
- All existing todo table operations remain unchanged
- Existing API endpoints continue to function identically
- Foreign key relationships to user_id preserved

### Migration Path
- New tables can be added without affecting existing functionality
- No schema changes to existing tables required
- Backward compatibility maintained for all existing operations