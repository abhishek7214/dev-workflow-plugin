#!/usr/bin/env bash
# Verify service health after deployment
# Usage: verify-health.sh <base-url> [max-retries] [delay-seconds]

set -euo pipefail

BASE_URL="${1:?Usage: verify-health.sh <base-url> [max-retries] [delay-seconds]}"
MAX_RETRIES="${2:-5}"
DELAY="${3:-10}"

ENDPOINTS=("/_healthz" "/_readyz")

echo "Verifying deployment health at ${BASE_URL}"
echo "Max retries: ${MAX_RETRIES}, Delay: ${DELAY}s"
echo "---"

for endpoint in "${ENDPOINTS[@]}"; do
  URL="${BASE_URL}${endpoint}"
  ATTEMPT=1
  SUCCESS=false

  while [ $ATTEMPT -le $MAX_RETRIES ]; do
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 5 "$URL" 2>/dev/null || echo "000")

    if [ "$HTTP_CODE" -ge 200 ] && [ "$HTTP_CODE" -lt 300 ]; then
      echo "${endpoint}: OK (HTTP ${HTTP_CODE})"
      SUCCESS=true
      break
    else
      echo "${endpoint}: attempt ${ATTEMPT}/${MAX_RETRIES} — HTTP ${HTTP_CODE}"
      ATTEMPT=$((ATTEMPT + 1))
      if [ $ATTEMPT -le $MAX_RETRIES ]; then
        sleep "$DELAY"
      fi
    fi
  done

  if [ "$SUCCESS" = false ]; then
    echo "${endpoint}: FAILED after ${MAX_RETRIES} attempts" >&2
    exit 1
  fi
done

echo "---"
echo "All health checks passed."
