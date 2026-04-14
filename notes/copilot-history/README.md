# Copilot History Workflow

This folder stores your permanent, git-tracked Copilot conversation notes.

## Quick Start
Run from the repository root:

```powershell
./scripts/new-copilot-log.ps1 -Topic "tsql-upsert-fix"
```

Optional fields:

```powershell
./scripts/new-copilot-log.ps1 -Topic "function-perf" -Prompt "How can I optimize this scalar UDF?" -Summary "Switched to an inline TVF and added index guidance."
```

The script creates a timestamped file in this folder using `TEMPLATE.md`.

## Suggested Habit
- Create one log file per meaningful Copilot session.
- Summarize final decisions and next steps.
- Commit these notes with your code changes for traceability.

## Retrieval
- Browse files in this folder by date.
- Use text search in VS Code for topics, decisions, or commands.
