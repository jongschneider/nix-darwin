# Workarounds

Temporary deviations from upstream applied to this config to work around bugs we don't control. Each entry stays here until upstream is fixed and the workaround can be removed.

## How to revisit

1. Pick an entry below.
2. Follow its **Retest** step (usually: undo the workaround and run `just c`).
3. If `just c` succeeds, upstream is fixed — remove the workaround and delete the entry.
4. If it still fails, restore the workaround and append today's date to **Last reproduced**.

---

## Open

### Pin `llm-agents` to 93c592a — `agent-browser-0.27.1` pnpm-deps OOM on darwin

- **Opened**: 2026-06-02
- **Last reproduced**: 2026-06-14 (retested against `02eaebc` / agent-browser 0.27.3 — still SIGKILLs)
- **Upstream**: [numtide/llm-agents.nix](https://github.com/numtide/llm-agents.nix)

**Symptom**: `just c` / `just build` fails building `agent-browser-dashboard-pnpm-deps` with exit code 137 (SIGKILL). The kill happens right after pnpm logs `added 1122, done`, during the final store-write phase. Reproducible even with 16 GB of free memory.

**Cause**: Any `llm-agents` rev newer than `93c592a` (confirmed broken: `2f2a2d3`, `a418d27`, `02eaebc`) ships `agent-browser` ≥ 0.27.1, which pulls Next.js 16.1.1 plus all five `@next/swc` platform binaries (~180 MB of native code). The fixed-output `pnpm install` derivation gets killed by the kernel at finalization on darwin. The 0.27.3 packaging refactor (`fetcherVersion = 3`, vendored Geist font) did not fix it. Not a memory-pressure issue — it's a hard upstream regression in the dashboard packaging.

**Workaround**: Pinned the rev directly in `flake.nix` so `just u` / `nix flake update` can't stomp it:

```nix
llm-agents = {
  url = "github:numtide/llm-agents.nix/93c592a1bf2bfcb7e72b9a5344611efcf72917db";
  ...
};
```

(Earlier we used `nix flake lock --override-input`, but that pin lived only in `flake.lock` and got blown away by `just u`. The URL pin in `flake.nix` is the durable form.)

**Retest**:

1. In `flake.nix`, drop the rev from `inputs.llm-agents.url` (back to `github:numtide/llm-agents.nix`).
2. `nix flake update llm-agents && just c`.

If it succeeds, remove this entry and leave `flake.nix` unpinned. If it OOMs again, restore the rev in `flake.nix` and append today's date to **Last reproduced**.

---

## Closed

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
