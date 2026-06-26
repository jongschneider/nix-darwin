# Workarounds

Temporary deviations from upstream applied to this config to work around bugs we don't control. Each entry stays here until upstream is fixed and the workaround can be removed.

## How to revisit

1. Pick an entry below.
2. Follow its **Retest** step (usually: undo the workaround and run `just c`).
3. If `just c` succeeds, upstream is fixed — remove the workaround and delete the entry.
4. If it still fails, restore the workaround and append today's date to **Last reproduced**.

---

## Open

_None._

---

## Closed

### Pin `llm-agents` to 93c592a — `agent-browser-0.27.1` pnpm-deps OOM on darwin

- **Opened**: 2026-06-02
- **Closed**: 2026-06-26
- **Resolution**: sidestepped, not upstream-fixed. `agent-browser` was dropped from `inputs.llm-agents.packages.*` on both darwin hosts (`hosts/mbp/home.nix`, `hosts/m4mini/home.nix`) and added to the shared Homebrew `brews` list in `darwin/homebrew.nix`. Homebrew core ships the same `agent-browser 0.30.1` as a bottled formula, so no local pnpm build runs. The `llm-agents` input is now unpinned and tracks upstream HEAD.

Was: `flake.nix` pinned `inputs.llm-agents.url` to `93c592a1bf2bfcb7e72b9a5344611efcf72917db` because every rev newer than `93c592a` (confirmed broken: `2f2a2d3`, `a418d27`, `02eaebc`, `05f2ea6`) SIGKILLed `agent-browser-dashboard-pnpm-deps` at finalization on darwin. The fixed-output `pnpm install` derivation got killed by the kernel right after `added 1136, done`. Subsequent upstream packaging changes through 0.30.1 did not fix it. If we ever want `agent-browser` back inside the nix closure, recheck this against a future `llm-agents` rev (and reintroduce the `inputs.llm-agents.packages.*.agent-browser` line on both hosts).

---

### `--force-cleanup` on `brew bundle` — homebrew requires non-interactive opt-in

- **Opened**: 2026-06-03
- **Closed**: 2026-06-18
- **Upstream fix**: [lnl7/nix-darwin@bb9c29c](https://github.com/lnl7/nix-darwin/commit/bb9c29c) ("homebrew: address bundle command new CLI flag requirements", 2026-06-17). The module now emits `--force-cleanup` (uninstall) or `--zap --force-cleanup` (zap) itself.

Was: workaround appended `extraFlags = ["--force-cleanup"]` under `onActivation`. Removed once locked nix-darwin advanced to `a1fa429` (which contains `bb9c29c`); `just c` then ran the Homebrew bundle step cleanly.

---

### Write `~/.homebrew/trust.json` from `homebrew.taps` — Homebrew 6.0 tap-trust opt-in

- **Opened**: 2026-06-12
- **Closed**: 2026-06-18
- **Upstream fix**: [lnl7/nix-darwin@cd7cf09](https://github.com/lnl7/nix-darwin/commit/cd7cf09) ("homebrew: set `trusted` flag in Brewfile directly", 2026-06-17). The module now exposes per-tap/brew/cask `trusted` options that emit `, trusted: true` in the Brewfile.

Was: workaround wrote `~/.homebrew/trust.json` from `config.homebrew.taps` via `system.activationScripts.extraActivation`. Replaced with per-tap `trusted = true;` in `homebrew.taps`; the old activationScript and `homebrewTrust` let-binding were removed. Imperative taps (e.g. `grafana/grafana`, `docker/tap`) are still trusted via the leftover `~/.homebrew/trust.json` from the prior workaround — if/when that file is removed, those taps must be re-trusted with `brew trust` per-machine.
