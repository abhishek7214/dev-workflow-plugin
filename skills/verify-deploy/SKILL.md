---
description: Verify a deployment by checking pipeline status and health endpoints. Provide pipeline run ID or URL as argument.
---

# Verify Deployment

Check the status of a deployment and verify the service is healthy.

## Steps

1. **Check pipeline status**:
   - If "$ARGUMENTS" contains a pipeline run ID or URL, use `get_pipeline_run` to check status
   - If no argument, use `list_pipeline_runs` to find the most recent run for the current repo
   - Show: status (queued/inProgress/completed), result (succeeded/failed), duration

2. **Check pipeline timeline**: Use `pipeline_timeline` to see individual stage/job status:
   - Build stage
   - Test stage
   - Deploy stage
   - Show any failed stages with their error logs via `get_pipeline_log`

3. **Health check** (if deployment succeeded):
   - Ask the user for the service URL or use known endpoints
   - Check `/_healthz` and `/_readyz` endpoints using web fetch
   - Report health status

4. **Output format**:
   ```
   ## Deployment Status

   Pipeline: <name> | Run: #<id>
   Status: <status> | Result: <result>
   Duration: <time>

   ### Stages
   - Build: passed
   - Test: passed
   - Deploy: passed

   ### Health Check
   - /_healthz: OK
   - /_readyz: OK

   Deployment verified successfully.
   ```

5. **On failure**: If any stage failed:
   - Fetch logs for the failed stage using `get_pipeline_log`
   - Show relevant error messages
   - Suggest next steps (retry, check logs, rollback)

Use `azure-devops-fynd` or `azure-devops-jio` MCP tools depending on context.
