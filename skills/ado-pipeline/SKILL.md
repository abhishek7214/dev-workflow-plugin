---
description: Manage Azure DevOps pipelines — list, trigger, check status, view logs. Provide action as argument.
---

# Azure DevOps Pipelines

Manage CI/CD pipelines in Azure DevOps.

## Arguments

"$ARGUMENTS" format: `<action> <details>`

Actions:
- `list` — List all pipelines in the project
- `runs [pipeline-name]` — List recent runs for a pipeline
- `status <run-id>` — Check status of a pipeline run
- `trigger <pipeline-name> [branch]` — Trigger a pipeline run
- `logs <run-id>` — View logs for a pipeline run
- `artifacts <run-id>` — Download pipeline artifacts

## Steps

### List pipelines
- Use `list_pipelines` MCP tool
- Display: ID, Name, Last Run Status, Last Run Date

### List runs
- Use `list_pipeline_runs` for the specified pipeline
- Display: Run ID, Status, Result, Branch, Start Time, Duration

### Check status
- Use `get_pipeline_run` with the run ID
- Use `pipeline_timeline` for stage-level details
- Display: overall status, each stage's status, duration

### Trigger pipeline
- Use `trigger_pipeline` with pipeline name/ID and branch
- Confirm with user before triggering
- Report the new run ID and URL
- Suggest using `status` to monitor progress

### View logs
- Use `get_pipeline_log` for the run ID
- If a specific stage/job failed, focus on those logs
- Summarize key errors or warnings

### Download artifacts
- Use `download_pipeline_artifact` for the run ID
- Report downloaded artifact location

## Organization

Use `azure-devops-fynd` or `azure-devops-jio` tools depending on context.

## Examples

- `/dev-workflow:ado-pipeline list`
- `/dev-workflow:ado-pipeline trigger isd-service-build main`
- `/dev-workflow:ado-pipeline status 54321`
- `/dev-workflow:ado-pipeline logs 54321`
- `/dev-workflow:ado-pipeline runs isd-service-build`
