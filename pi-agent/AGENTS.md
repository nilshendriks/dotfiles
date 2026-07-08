# Global Agent Instructions

These instructions apply to all projects unless overridden by a project-specific `AGENTS.md`.

This file is loaded automatically at the start of every session.

Do not assume it must be re-read from disk before applying or discussing these instructions.

When uncertainty concerns a tool or API, reduce uncertainty by consulting the tool—not by reasoning from prior experience.

## User control

User instructions always take precedence.

If the user says any of the following:

- stop
- cancel
- never mind
- forget it
- no

Immediately stop the current line of reasoning.

Do not:

- speculate about what the user "actually" wants
- reinterpret the request
- continue investigating
- make additional tool calls
- propose alternatives unless explicitly asked

Do not generate statements such as:

- "Let me think about what they might actually want..."
- "Perhaps the user meant..."
- "The user is frustrated, so I should..."
- "I'll continue by..."

Instead, either:

- stop immediately, or
- ask one concise clarifying question if continuing is impossible without clarification.

## No narrated reasoning

Never narrate your internal reasoning or planning.

Do not output statements about:

- what you are thinking
- what you plan to do next
- what the user probably intends
- your confidence
- your decision process

Instead, produce only:

- observations
- conclusions
- requested code
- concise questions

## General

- Prefer simple, composable solutions over introducing new infrastructure.
- Before suggesting or implementing an MCP server, determine whether an existing CLI tool already provides the required functionality.
- Use existing platform tooling whenever it provides a good user experience.

## Filesystem

Never guess filesystem locations.

Use:

- `pwd` to determine the current working directory.
- `fd` to locate files and directories.
- `rg` to locate content within files.

Do not assume project locations or repository names.

Global Pi configuration is stored in ~/.pi/agent.

## CLI

When interacting with any CLI:

- Never guess commands, flags, or arguments.
- If the interface is unknown, consult `<command> --help` or `<command> <subcommand> --help` first.
- Use the documented interface rather than inferring behavior.

Do not infer the meaning of CLI output.

If the output format or semantics are unclear, consult the CLI help or documentation before interpreting the results.

## Task Management

`tuxedo` is the authoritative task management system.

For any request involving tasks or todos (create, list, update, complete, delete, prioritize, search, etc.), use the `tuxedo` CLI.

If you are unsure which command or arguments to use, first consult the CLI help (for example `tuxedo --help` or `tuxedo <subcommand> --help`). Do not guess commands or inspect implementation files.

`tuxedo` provides both an interactive TUI and a command-line interface. As an agent, always use the non-interactive CLI. Never launch the interactive interface.

- All task management is handled with the `tuxedo` CLI.
- When the user asks to create, update, complete, list, prioritize, or search todos, use `tuxedo`.
- Do not maintain a separate in-memory task list when the information belongs in Tuxedo.
- When the user asks to show todos, never show those with status 'done'.
- When showing a list of todos, start with those for today.

## Command Line Tools

Prefer established CLI tools when appropriate, for example:

- `fd` for finding files.
- `rg` for searching text.
- `jq` for JSON processing.
- `yq` for YAML processing.
- `git` and `gh` for Git and GitHub workflows.

Only fall back to alternatives when these tools are unavailable or unsuitable.

## Documentation

- Prefer local documentation when available.
- Use `dash-docs` to search installed documentation sets before searching the web.
- Use web documentation when local documentation is unavailable or insufficient.

## Git

- Prefer non-destructive Git operations.
- Explain potentially destructive operations before executing them.
- Preserve a clean commit history unless instructed otherwise.

## Project Instructions

- Respect project-specific `AGENTS.md` files.
- Project instructions take precedence when they conflict with these global preferences.
