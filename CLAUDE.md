<!-- rtk-instructions v2 -->
# 🚀 RTK (Rust Token Killer) - Token-Optimized CLI Commands

> [!IMPORTANT]
> **GOLDEN RULE**: Always prefix commands with `rtk`.
> If RTK has a dedicated filter for a command, it will automatically optimize it. If not, it passes it through raw/unchanged.
> Even in command chains connected by `&&`, you must prefix each command with `rtk`.

```bash
# ❌ INCORRECT (Command chains without prefixing each item)
git add . && git commit -m "msg" && git push

# ✅ CORRECT (Prefix every command in the chain)
rtk git add . && rtk git commit -m "msg" && rtk git push
```

---

## 🛠️ RTK Command Reference by Workflow

### 1. 📦 Build & Compile (80-90% savings)
```bash
rtk cargo build         # Filter and group Cargo build logs
rtk cargo check         # Filter and check Cargo syntax errors
rtk cargo clippy        # Clippy warnings grouped logically by file (80% saved)
rtk tsc                 # TypeScript compiler errors grouped by file/code (83% saved)
rtk lint                # ESLint / Biome violations cleanly grouped (84% saved)
rtk prettier --check    # List only files that need formatting (70% saved)
rtk next build          # Next.js build output with clean route metrics (87% saved)
```

### 2. 🧪 Test Runners (60-99% savings)
```bash
rtk cargo test          # Display Cargo test failures only (90% saved)
rtk go test             # Display Go test failures only (90% saved)
rtk jest                # Display Jest test failures only (99.5% saved)
rtk vitest              # Display Vitest test failures only (99.5% saved)
rtk playwright test     # Display Playwright test failures only (94% saved)
rtk pytest              # Display Python test failures only (90% saved)
rtk rake test           # Display Ruby test failures only (90% saved)
rtk rspec               # Display RSpec test failures only (60% saved)
rtk test <cmd>          # Generic test wrapper - isolates failures only
```

### 🐙 3. Git Operations (59-80% savings)
```bash
rtk git status          # Compact, readable status report
rtk git log             # Compact log listing (works with all git flags)
rtk git diff            # Ultra-compact diff layout (80% saved)
rtk git show            # Compact commit details (80% saved)
rtk git add             # Ultra-compact file staging confirmations (59% saved)
rtk git commit          # Ultra-compact commit confirmations (59% saved)
rtk git push            # Compact branch pushing status
rtk git pull            # Compact branch pulling details
rtk git branch          # Clean branch list
rtk git fetch           # Clean fetch info
rtk git stash           # Clean stash list
rtk git worktree        # Clean worktree information
```
> [!NOTE]
> Git passthrough works for ALL git subcommands, including those not listed above.

### 🐙 4. GitHub CLI (26-87% savings)
```bash
rtk gh pr view <num>    # Compact pull request details (87% saved)
rtk gh pr checks        # Clean view of PR status checks (79% saved)
rtk gh run list         # Compact workflow runs lists (82% saved)
rtk gh issue list       # Compact issue tracker lists (80% saved)
rtk gh api              # Flattened and filtered API responses (26% saved)
```

### 📦 5. JS/TS Package Management (70-90% savings)
```bash
rtk pnpm list           # Compact dependency tree (70% saved)
rtk pnpm outdated       # Compact list of outdated packages (80% saved)
rtk pnpm install        # Compressed installation summaries (90% saved)
rtk npm run <script>    # Filtered and clean npm script output
rtk npx <cmd>           # Filtered npx executor output
rtk prisma              # Prisma DB logs without ASCII art (88% saved)
```

### 🔍 6. File Searching & Reading (60-75% savings)
```bash
rtk ls <path>           # Compact tree format file listing (65% saved)
rtk read <file>         # Intelligent code file reading with comments filter (60% saved)
rtk grep <pattern>      # Search results neatly grouped by file (75% saved)
rtk find <pattern>      # Find results grouped by directory (70% saved)
```

### 🐛 7. Debugging & Analysis (70-90% savings)
```bash
rtk err <cmd>           # Isolate and filter errors only from any CLI command
rtk log <file>          # Deduplicated log views with occurrence counts
rtk json <file>         # Structural outline of a JSON file without values
rtk deps                # Clean dependency structure overview
rtk env                 # Compact list of environment variables
rtk summary <cmd>       # Generate a smart, dense summary of CLI output
rtk diff                # Compressed, line-by-line diff summaries
```

### 🐳 8. Infrastructure & Docker (85% savings)
```bash
rtk docker ps           # Compact container lists
rtk docker images       # Compact image lists
rtk docker logs <c>     # Deduplicated container logs
rtk kubectl get         # Compact Kubernetes resource views
rtk kubectl logs        # Deduplicated pod logs
```

### 🌐 9. Network (65-70% savings)
```bash
rtk curl <url>          # Compacted HTTP response headers and payloads (70% saved)
rtk wget <url>          # Compacted download progress logs (65% saved)
```

### ⚙️ 10. Meta Commands
```bash
rtk gain                # View token savings statistics
rtk gain --history      # View execution history alongside token savings
rtk discover            # Scan Claude Code shell sessions for missed RTK usages
rtk proxy <cmd>         # Debugging proxy (runs commands completely unfiltered)
rtk init                # Append RTK directives directly to project CLAUDE.md
rtk init --global       # Append RTK directives globally to ~/.claude/CLAUDE.md
```

---

## 📈 Token Savings Metrics

| Category | Commands | Avg. Token Reduction |
| :--- | :--- | :--- |
| **Tests** | `vitest`, `playwright`, `cargo test`, `jest` | **90-99%** |
| **Infrastructure**| `docker`, `kubectl` | **85%** |
| **Build** | `next`, `tsc`, `lint`, `prettier` | **70-87%** |
| **Package Managers**| `pnpm`, `npm`, `npx` | **70-90%** |
| **Files / Search** | `ls`, `read`, `grep`, `find` | **60-75%** |
| **Network** | `curl`, `wget` | **65-70%** |
| **Git** | `status`, `log`, `diff`, `add`, `commit` | **59-80%** |
| **GitHub** | `gh pr`, `gh run`, `gh issue` | **26-87%** |

<!-- /rtk-instructions -->

## Agent skills

### Issue tracker

GitHub Issues using the `gh` CLI. See `docs/agents/issue-tracker.md`.

### Triage labels

Standard triage label vocabulary (`needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`). See `docs/agents/triage-labels.md`.

### Domain docs

Multi-context layout defined by [CONTEXT-MAP.md](file:///Users/diqit/Documents/GitHub/config/dotfiles/CONTEXT-MAP.md), pointing to per-directory contexts. See [domain.md](file:///Users/diqit/Documents/GitHub/config/dotfiles/docs/agents/domain.md).
