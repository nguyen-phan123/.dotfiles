# Issue tracker: Local Markdown Files

Issues and PRDs for this repo live as local markdown files under the `docs/issues/` directory. This keeps the issue tracker completely offline, self-contained, and fully version-controlled in Git.

## Conventions

- **Directory**: `docs/issues/`
- **File Naming**: Sequentially numbered with a slug, e.g., `docs/issues/0001-setup-agent-configs.md`.

### Metadata Format

Every issue file starts with a standardized markdown header:

```markdown
# Issue #0001: [Issue Title]

**Status**: Open
**Labels**: ready-for-agent, bug

## Description

[Issue details and description go here]

## Comments

- **Comment by [User/Agent]**: [Comment text]
```

### Shell Operations

- **Create an issue**: Create a new file `docs/issues/000N-<slug>.md` with the metadata format above.
- **Read an issue**: View the file directly: `cat docs/issues/0001-*.md`.
- **List issues**: List the files: `ls docs/issues/` or read metadata: `grep -H "^**Status**" docs/issues/*.md`.
- **Comment on an issue**: Append the comment under the `## Comments` section in the file.
- **Apply / remove labels**: Edit the `**Labels**` line in the file's header.
- **Close**: Edit the `**Status**` line in the file's header to `**Status**: Closed`.

## When a skill says "publish to the issue tracker"

Create a new local markdown file in `docs/issues/`.

## When a skill says "fetch the relevant ticket"

Read the corresponding local issue file: `cat docs/issues/0001-*.md`.

