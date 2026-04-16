---
description: Create a pull request from the current branch. Optionally provide target branch as argument.
---

# Create Pull Request

Create a pull request for the current branch.

## Steps

1. **Gather context**:
   - Run `git status` to check for uncommitted changes — warn the user if any exist
   - Run `git branch --show-current` to get the current branch name
   - Run `git log main..HEAD --oneline` to see all commits being included
   - Run `git diff main...HEAD --stat` to see changed files summary

2. **Determine target branch**: Use "$ARGUMENTS" if provided, otherwise default to `main`.

3. **Ensure branch is pushed**: Check if the remote tracking branch exists. If not, push with `git push -u origin <branch>`.

4. **Draft PR content**:
   - **Title**: Short (under 70 chars), derived from branch name and commit messages
   - **Description**: Summarize what changed, why, and how to test
   - Use this format:
     ```
     ## Summary
     - Bullet points of changes

     ## Related Work Items
     - Link any Azure DevOps work items if branch name contains an ID

     ## Test Plan
     - How to verify these changes
     ```

5. **Create the PR**: Use Azure DevOps MCP tool `create_pull_request` with:
   - Source branch: current branch
   - Target branch: from step 2
   - Title and description from step 4
   - Auto-link work items if IDs found in branch name or commits

6. **Report**: Show the PR URL and summary to the user.

Use `azure-devops-fynd` or `azure-devops-jio` MCP tools depending on context. Ask the user if unclear.
