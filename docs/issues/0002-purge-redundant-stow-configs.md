# Issue #0002: Purge Redundant Stow Configs

**Status**: Closed
**Labels**: ready-for-agent, feature, architecture

## Parent

- Issue #0001: Antigravity Stow Cleanup and Path Consolidation

## What to build

Purge all redundant `rules` and `workflows` directories from both `agent/dot-agent/.gemini/` and `agent/dot-agent/.gemini/antigravity/` within the Stow package directory, ensuring only `GEMINI.md`, `antigravity/skills`, and `antigravity/global_workflows` are stowed. Furthermore, decouple both `.gemini/` and `.codex/` config folders by removing the shared `global/` folder and establishing direct, level-correct relative symlinks (`../../../../.agents/skills`, `../../../../.agents/workflows`) to the project-local `.agents/` folder.

## Acceptance criteria

- [x] Redundant directories rules/ and workflows/ are deleted from `.gemini/` and `.gemini/antigravity/`.
- [x] Folder `agent/dot-agent/global/` is deleted entirely.
- [x] Client configurations under `.gemini/` and `.codex/` contain direct level-correct relative symlinks back to `.agents/`.
- [x] Stowed global plugins (`chrome-devtools-plugin`, `google-antigravity-sdk`) are successfully copied into the workspace package.

## Blocked by

None - can start immediately

## Comments

- **Comment by Antigravity**: Task completed successfully as a vertical slice. Symlinks decoupled and verified.
