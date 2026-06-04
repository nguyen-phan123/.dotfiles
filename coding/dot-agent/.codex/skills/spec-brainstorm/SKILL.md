---
name: spec-brainstorm
description: Use when the user runs /spec-brainstorm or asks to turn an idea into OpenSpec-native planning artifacts with Superpowers-style clarification gates.
---

# Spec Brainstorm

Turn a rough idea into OpenSpec-native artifacts without touching implementation code.

## Hard Gate

Do not edit application source code, tests, migrations, configuration, or implementation files.

This workflow may only create or update files under `openspec/changes/<change-id>/`.

## Workflow

1. Detect the OpenSpec root at `openspec/`.
2. If `openspec/` is missing, stop and tell the user to initialize OpenSpec first.
3. Read existing `openspec/specs/` and non-archived `openspec/changes/`.
4. Classify the idea as clear, ambiguous, conflicting, or too broad.
5. If ambiguous, conflicting, or too broad, ask exactly one high-leverage question and stop.
6. If clear, create a kebab-case change id from the user's intent.
7. Create `openspec/changes/<change-id>/proposal.md`.
8. Create `openspec/changes/<change-id>/design.md` only when technical architecture or tradeoffs are needed.
9. Create `openspec/changes/<change-id>/tasks.md`.
10. Create `openspec/changes/<change-id>/specs/<capability>/spec.md` when behavior requirements are clear.
11. Report created paths and stop before implementation.

## Artifact Rules

`proposal.md` must explain why the change exists, what changes, and what is out of scope.

`design.md` must explain architecture, data flow, risks, and rejected alternatives.

`tasks.md` must be an implementation checklist using markdown checkboxes.

`spec.md` must use requirement language with scenarios.

## Clarification Rules

Ask one question when:

- the user intent can produce multiple incompatible specs
- an existing active change already covers the same area
- the requested scope spans unrelated capabilities
- acceptance criteria cannot be inferred from existing specs

Do not ask several questions in one response.

## Output Style

Be concise. Lead with the current state, then the next action.
