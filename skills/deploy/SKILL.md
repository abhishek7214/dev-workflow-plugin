---
description: Deploy a branch or trigger a pipeline. Provide branch name, tag pattern, or pipeline name as argument.
---

# Deploy

Deploy the specified branch or trigger a pipeline run.

## Arguments

"$ARGUMENTS" can be:
- A branch name (e.g., `main`, `feature/xyz`) — will create a deploy tag
- A tag pattern (e.g., `deploy.sit.v1`) — will push this tag
- `pipeline:<name>` — will trigger a pipeline by name directly
- Empty — will deploy the current branch

## Steps

### Option A: Tag-based deployment (default)

1. **Determine branch**: Use the argument or current branch via `git branch --show-current`
2. **Generate tag**: Create tag in format `deploy.<env>.<timestamp>` where env is derived from context:
   - `sit` for feature/develop branches
   - `uat` for release branches
   - `prod` for main (requires explicit user confirmation)
3. **Confirm with user**: Show what tag will be created and on which commit
4. **Create and push tag**:
   ```bash
   git tag <tag-name>
   git push origin <tag-name>
   ```
5. **Notify**: If Teams webhook is configured, call the notify-teams skill to announce the deployment

### Option B: Pipeline trigger (when argument starts with `pipeline:`)

1. **Find pipeline**: Use `list_pipelines` to find the pipeline by name
2. **Confirm with user**: Show pipeline name and branch to run on
3. **Trigger**: Use `trigger_pipeline` MCP tool with the branch and pipeline ID
4. **Report**: Show the pipeline run URL

## Post-deploy

After triggering deployment:
- Show the pipeline/deployment URL
- Suggest running `/dev-workflow:verify-deploy` to check status
- Suggest running `/dev-workflow:notify-teams` if not already done

Use `azure-devops-fynd` or `azure-devops-jio` MCP tools depending on context. Ask if unclear.
