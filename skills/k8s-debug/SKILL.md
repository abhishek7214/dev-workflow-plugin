---
description: Debug a Kubernetes deployment — check pod status, events, resource usage, config issues, and correlate with recent deployments. Provide service name as argument.
---

# Kubernetes Debug

Full diagnostic of a Kubernetes deployment for troubleshooting.

## Arguments

"$ARGUMENTS": service/deployment name, optionally with namespace flag `-n <namespace>`

## Steps

1. **Deployment overview**:
   - Get the deployment details — replicas desired vs ready, strategy, image version
   - Check if a rollout is in progress
   - Compare the running image tag to the latest pipeline build

2. **Pod health check**:
   - List all pods for the deployment
   - For each pod show: status, restarts, age, node
   - Flag any pods in bad states: CrashLoopBackOff, ImagePullBackOff, Pending, OOMKilled, Evicted

3. **Events timeline**:
   - Get recent events for the namespace filtered to this deployment
   - Sort chronologically
   - Highlight: FailedScheduling, Unhealthy (probe failures), BackOff, FailedMount, OOMKilling

4. **Resource check**:
   - Get resource requests/limits for the containers
   - Check current CPU/memory usage vs limits
   - Flag if pods are near OOM or CPU throttling

5. **Config validation**:
   - Check environment variables from configmaps/secrets
   - Verify referenced configmaps and secrets exist
   - Check if any mounted volumes are missing

6. **Network & connectivity**:
   - Check if the service exists and has endpoints
   - Verify ingress/route configuration if applicable
   - Check if readiness/liveness probes are passing

7. **Correlate with recent changes**:
   - Check the deployment's last rollout timestamp
   - Cross-reference with recent pipeline runs using `/dev-workflow:ado-pipeline runs`
   - If a recent deployment happened, check if issues started after that

8. **Output format**:
   ```
   ## K8s Debug Report: <deployment-name>

   ### Deployment
   Image: <image:tag>
   Replicas: <ready>/<desired>
   Last deployed: <timestamp>

   ### Pod Status
   | Pod | Status | Restarts | Age | Node |
   |-----|--------|----------|-----|------|
   | ... | ...    | ...      | ... | ...  |

   ### Issues Found
   1. [CRITICAL] <issue description>
   2. [WARNING] <issue description>

   ### Recent Events
   - <timestamp> <event>

   ### Resource Usage
   CPU: <used>/<limit> | Memory: <used>/<limit>

   ### Root Cause Analysis
   <diagnosis based on all collected evidence>

   ### Recommended Actions
   1. <action>
   2. <action>
   ```

## Examples

- `/dev-workflow:k8s-debug isd-service`
- `/dev-workflow:k8s-debug isd-service -n staging`
