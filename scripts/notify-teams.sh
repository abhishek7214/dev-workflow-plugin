#!/usr/bin/env bash
# Send a message to Microsoft Teams via incoming webhook
# Usage: notify-teams.sh "<message>" [webhook_url]
#
# Environment variables:
#   TEAMS_WEBHOOK_URL - Webhook URL for the Teams channel

set -euo pipefail

MESSAGE="${1:?Usage: notify-teams.sh '<message>' [webhook_url]}"
WEBHOOK_URL="${2:-${TEAMS_WEBHOOK_URL:-}}"

if [ -z "$WEBHOOK_URL" ]; then
  echo "Error: TEAMS_WEBHOOK_URL not set and no webhook URL provided as second argument" >&2
  exit 1
fi

BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")
COMMIT=$(git log -1 --format="%h %s" 2>/dev/null || echo "unknown")
USER=$(git config user.name 2>/dev/null || echo "unknown")
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S %Z')

PAYLOAD=$(cat <<EOF
{
  "type": "message",
  "attachments": [
    {
      "contentType": "application/vnd.microsoft.card.adaptive",
      "content": {
        "type": "AdaptiveCard",
        "\$schema": "http://adaptivecards.io/schemas/adaptive-card.json",
        "version": "1.4",
        "body": [
          {
            "type": "TextBlock",
            "text": "Deployment Notification",
            "weight": "Bolder",
            "size": "Medium",
            "color": "Accent"
          },
          {
            "type": "FactSet",
            "facts": [
              { "title": "Branch", "value": "${BRANCH}" },
              { "title": "Commit", "value": "${COMMIT}" },
              { "title": "Deployed by", "value": "${USER}" },
              { "title": "Time", "value": "${TIMESTAMP}" }
            ]
          },
          {
            "type": "TextBlock",
            "text": "${MESSAGE}",
            "wrap": true
          }
        ]
      }
    }
  ]
}
EOF
)

RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" \
  -H "Content-Type: application/json" \
  -d "$PAYLOAD" \
  "$WEBHOOK_URL")

if [ "$RESPONSE" -ge 200 ] && [ "$RESPONSE" -lt 300 ]; then
  echo "Teams notification sent successfully (HTTP $RESPONSE)"
else
  echo "Failed to send Teams notification (HTTP $RESPONSE)" >&2
  exit 1
fi
