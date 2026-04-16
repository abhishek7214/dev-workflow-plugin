---
description: Send a message to Microsoft Teams channel via webhook. Provide the message as argument, or it will auto-generate a deployment notification.
---

# Notify Teams

Send a notification to Microsoft Teams.

## Configuration

The webhook URL must be set as environment variable `TEAMS_WEBHOOK_URL`, or passed in the plugin's MCP config.

## Steps

1. **Determine message**: 
   - If "$ARGUMENTS" is provided, use it as the message body
   - If no argument, auto-generate a deployment notification:
     - Get current branch: `git branch --show-current`
     - Get latest commit: `git log -1 --oneline`
     - Get current user: `git config user.name`
     - Format as deployment notification

2. **Build Teams message payload** (Adaptive Card format):
   ```json
   {
     "type": "message",
     "attachments": [
       {
         "contentType": "application/vnd.microsoft.card.adaptive",
         "content": {
           "type": "AdaptiveCard",
           "$schema": "http://adaptivecards.io/schemas/adaptive-card.json",
           "version": "1.4",
           "body": [
             {
               "type": "TextBlock",
               "text": "Deployment Notification",
               "weight": "Bolder",
               "size": "Medium"
             },
             {
               "type": "FactSet",
               "facts": [
                 { "title": "Branch", "value": "<branch>" },
                 { "title": "Commit", "value": "<commit>" },
                 { "title": "Deployed by", "value": "<user>" },
                 { "title": "Time", "value": "<timestamp>" }
               ]
             },
             {
               "type": "TextBlock",
               "text": "<custom message if any>",
               "wrap": true
             }
           ]
         }
       }
     ]
   }
   ```

3. **Send via webhook**: Use the notify-teams.sh script or curl:
   ```bash
   curl -H "Content-Type: application/json" -d '<payload>' "$TEAMS_WEBHOOK_URL"
   ```

4. **Report**: Confirm message was sent successfully or show error.

## Example usage

- `/dev-workflow:notify-teams Deploying isd-service to SIT from branch feature/attendance`
- `/dev-workflow:notify-teams` (auto-generates from git context)
