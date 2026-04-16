---
description: Check Kubernetes pod logs for debugging — build failures, bugs, incorrect output. Provide service name, pod name, or error keyword as argument.
---

# Kubernetes Logs

Fetch and analyze Kubernetes pod logs for debugging.

## Arguments

"$ARGUMENTS" can be:
- A service/deployment name (e.g., `isd-service`)
- A full pod name (e.g., `isd-service-7d4b8c6f9-x2k4m`)
- `<service> --since 30m` — logs from the last 30 minutes
- `<service> --error` — filter for errors/exceptions only
- `<service> --previous` — logs from the previous (crashed) container
- `<service> -n <namespace>` — specify namespace (defaults to current context namespace)

## Steps

1. **Find the pod**:
   - If a deployment/service name is given, list pods matching that name
   - Use the kubernetes MCP tools to list pods filtered by label or name prefix
   - If multiple pods exist (replicas), check all of them or ask which one

2. **Check pod status first**:
   - Get pod details — status, restarts, events
   - If pod is in CrashLoopBackOff, OOMKilled, or Error state, report that immediately
   - Show recent pod events (image pull errors, scheduling failures, readiness probe fails)

3. **Fetch logs**:
   - Get container logs from the pod
   - If `--previous` flag is set, fetch logs from the previous terminated container
   - If `--since` is specified, limit to that time window (default: last 15 minutes)
   - If the pod has multiple containers (sidecars), fetch from the main app container first

4. **Analyze the logs**:
   - Look for: `Exception`, `Error`, `FATAL`, `WARN`, stack traces, `OutOfMemoryError`
   - Look for Spring Boot specific: `BeanCreationException`, `ApplicationContextException`, `FlywayException`, `HikariPool` errors
   - Look for deployment issues: `Connection refused`, `Connection timed out`, DNS resolution failures
   - Look for application errors: HTTP 5xx responses, database connection failures, Kafka consumer lag

5. **Output format**:
   ```
   ## Pod Logs: <pod-name>

   ### Pod Status
   Status: Running | CrashLoopBackOff | Error
   Restarts: <count>
   Age: <duration>

   ### Errors Found
   - [timestamp] ERROR <class> — <message>
     <relevant stack trace lines>

   ### Recent Warnings
   - [timestamp] WARN <message>

   ### Summary
   <1-2 sentence diagnosis of what's going wrong>

   ### Suggested Fix
   <actionable next step>
   ```

6. **Follow-up suggestions**:
   - If it's a DB migration error → check Flyway migration files
   - If it's a connection error → check service/configmap/secret configs
   - If it's OOM → check resource limits
   - If it's a build failure → suggest checking the pipeline logs with `/dev-workflow:ado-pipeline logs`
   - If it's an application bug → point to the relevant source file and line number

## Examples

- `/dev-workflow:k8s-logs isd-service`
- `/dev-workflow:k8s-logs isd-service --since 30m`
- `/dev-workflow:k8s-logs isd-service --previous`
- `/dev-workflow:k8s-logs isd-service --error`
- `/dev-workflow:k8s-logs isd-service -n production`
