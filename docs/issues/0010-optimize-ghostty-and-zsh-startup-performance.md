# Spec: Optimize Ghostty and Zsh Shell Startup Performance

## Problem Statement

When opening a new Ghostty terminal window, opening new tabs, splitting multiplexer panes, or executing commands, the user experiences severe latency and poor performance. Benchmarking reveals that interactive shell initialization takes nearly 6 seconds (~5.93s) per session primarily due to synchronous heavy tool initializations (such as SDKMAN candidate path resolution and prompt evaluation). In addition, GPU rendering in Ghostty is burdened by continuous background alpha-compositing and idle cursor blinking.

## Solution

Optimize both shell startup and terminal rendering configurations to achieve sub-second shell load times (<0.4s) and smooth 120Hz terminal rendering without background CPU/GPU spikes. This is achieved by lazy-loading heavy environment managers (SDKMAN), pre-setting static environment variables, and tuning Ghostty configuration settings for macOS Metal rendering.

## User Stories

1. As a developer, I want new Ghostty windows and tabs to open instantaneously (<400ms), so that I can start typing commands without noticeable waiting time.
2. As a developer, I want SDKMAN to initialize on-demand only when I invoke `sdk` or Java toolchain commands, so that daily non-Java shell tasks do not pay a multi-second startup penalty.
3. As a developer, I want `JAVA_HOME` and basic Java binaries to remain accessible in default PATH, so that build tools and IDEs can locate Java without triggering full SDKMAN initialization on every shell launch.
4. As a developer, I want Ghostty cursor blinking to be disabled or optimized, so that the terminal does not waste GPU cycles or trigger continuous WindowServer redraws when idle.
5. As a developer, I want Ghostty background opacity and rendering properties to be optimized for macOS Metal compositing, so that typing and scrolling maintain high frame rates.
6. As a developer, I want the prompt evaluation to execute without `$TERM` missing warnings or script evaluation pauses, so that the terminal startup produces clean output without spurious error logs.
7. As a developer, I want to retain full compatibility with existing flutter, dart, node, and custom CLI aliases, so that my development workflow is uninterrupted.
8. As a developer, I want to synchronize terminal configuration changes seamlessly using the Terminal Sync Script (`pnpm sync:terminal`), so that configuration updates take effect across all active terminal sessions.

## Implementation Decisions

- **Lazy-load SDKMAN Initialization**: Instead of sourcing the SDKMAN initialization script unconditionally on shell startup, defer loading behind a wrapper function that triggers upon invoking `sdk`, `java`, `javac`, `mvn`, or `gradle`.
- **Static Java Path Configuration**: Provide default exports for `JAVA_HOME` pointing to the current candidate so existing tools resolve Java immediately without waiting for full initialization.
- **Ghostty Rendering Tweaks**: Update the Ghostty configuration to disable idle cursor blinking (`cursor-style-blink = false`) and ensure background opacity settings avoid unnecessary WindowServer alpha blend thrashing.
- **Clean Shell Initialization**: Ensure all profile hooks and completion scripts check for valid terminal capabilities before executing formatting commands to eliminate terminal capability lookup errors.
- **Terminal Sync Integration**: Utilize the standard repository sync workflow so modified configurations are properly stowed and linked to user home environments.

## Testing Decisions

- **Highest Testing Seam**: Measure end-to-end interactive shell startup execution time via non-interactive exit benchmarking (`time zsh -i -c exit`).
- **Success Criteria**: 
  - Interactive shell startup time drops from ~5.93s to < 0.40s.
  - SDKMAN commands (`sdk version`, `java -version`) execute correctly and initialize transparently when called.
  - Ghostty configuration loads without parse errors or warnings.
- **Prior Art**: Shell benchmark assertions and configuration tests located in the repository's shell test suite.

## Out of Scope

- Migrating from Oh My Zsh to an alternative shell framework (e.g., Prezto, Zim).
- Removing or restructuring project-specific Flutter, Dart, or FVM aliases.
- Native Ghostty application source code compilation or binary patching.

## Further Notes

- Once this specification is implemented, developer shell sessions across Ghostty and multiplexer panes will launch ~15x faster.
