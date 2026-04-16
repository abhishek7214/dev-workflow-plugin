---
description: Review a pull request for security, performance, and correctness. Provide with a PR number or URL.
---

# PR Review

Review the pull request specified by "$ARGUMENTS".

## Steps

1. **Identify the PR**: Parse the PR number or URL from the arguments. If only a number is given, use the current repository context.

2. **Fetch PR details**: Use the Azure DevOps MCP tools to:
   - Get PR metadata: `get_pull_request` (title, author, target branch, status)
   - Get PR changes: `get_pull_request_changes` (files changed)
   - Get PR comments: `get_pull_request_comments` (existing review comments)

3. **Read changed files**: For each changed file, read the current version and understand the diff.

4. **Review for**:
   - **Security**: SQL injection, XSS, command injection, secrets in code, OWASP top 10
   - **Performance**: N+1 queries, missing indexes, unnecessary allocations, blocking calls
   - **Correctness**: Logic errors, edge cases, null handling, error handling
   - **Code quality**: Naming, duplication, SOLID principles, test coverage
   - **Database migrations**: Schema changes, backward compatibility, data loss risk

5. **Output format**:
   ```
   ## PR Review: <title>

   ### Summary
   <1-2 sentence overview>

   ### Critical Issues
   - [file:line] Issue description

   ### Suggestions
   - [file:line] Suggestion

   ### Approved / Changes Requested
   ```

6. **Optionally post comments**: If the user asks, use `add_pull_request_comment` to post review comments directly on the PR.

Use `azure-devops-fynd` or `azure-devops-jio` MCP tools depending on which organization the repo belongs to. Ask the user if unclear.
