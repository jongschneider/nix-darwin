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
- **Last reproduced**: 2026-06-03 (twice — also after `just u`)
- **Upstream**: [numtide/llm-agents.nix](https://github.com/numtide/llm-agents.nix)

**Symptom**: `just c` fails building `agent-browser-dashboard-pnpm-deps` with exit code 137 (SIGKILL). The kill happens right after pnpm logs `added 1122, done`, during the final store-write phase. Reproducible even with 16 GB of free memory.

**Cause**: Any `llm-agents` rev newer than `93c592a` (confirmed broken: `2f2a2d3`, `a418d27`) ships `agent-browser` 0.27.1, which pulls Next.js 16.1.1 plus all five `@next/swc` platform binaries (~180 MB of native code). The fixed-output `pnpm install` derivation gets killed by the kernel at finalization on darwin. Not a memory-pressure issue — it's a hard upstream regression in the 0.27.1 dashboard packaging.

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

_(none yet)_
