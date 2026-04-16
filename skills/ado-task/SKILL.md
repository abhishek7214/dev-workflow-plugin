---
description: Manage Azure DevOps work items — create, read, update tasks, stories, features, and bugs. Provide action and details as argument.
---

# Azure DevOps Work Items

Manage work items (tasks, stories, features, bugs) in Azure DevOps.

## Arguments

"$ARGUMENTS" format: `<action> <details>`

Actions:
- `list` — List work items (optionally filter by type, state, assigned to)
- `get <id>` — Get work item details by ID
- `create <type> <title>` — Create a new work item (Task, User Story, Feature, Bug)
- `update <id> <field=value>` — Update a work item field
- `link <id1> <id2>` — Link two work items
- `search <query>` — Search work items by text

## Steps

### List work items
- Use `list_work_items` or `search_work_items` MCP tool
- Display as table: ID, Type, Title, State, Assigned To

### Get work item
- Use `get_work_item` with the provided ID
- Show all fields: title, description, state, assigned to, iteration, area, tags, linked items

### Create work item
- Use `create_work_item` with:
  - Type: Task, User Story, Feature, or Bug
  - Title from arguments
  - Ask user for description, priority, assignment if not provided
- Report the created work item ID and URL

### Update work item
- Use `update_work_item` with the ID and field updates
- Common fields: State, AssignedTo, Title, Description, Priority, Tags
- Confirm the update was applied

### Link work items
- Use `manage_work_item_link` to create relationships
- Common link types: Parent/Child, Related, Predecessor/Successor

### Search
- Use `search_work_items` with the query text
- Display matching results as a table

## Organization

Use `azure-devops-fynd` or `azure-devops-jio` tools. If the user hasn't specified which org, ask them.

## Examples

- `/dev-workflow:ado-task get 12345`
- `/dev-workflow:ado-task create "User Story" Implement attendance mark-in API`
- `/dev-workflow:ado-task update 12345 State=Active`
- `/dev-workflow:ado-task search attendance mark-in`
- `/dev-workflow:ado-task list assigned to me`
