# justfile for managing Nix configuration

# Get local hostname (cross-platform)
host := if os() == "macos" { `scutil --get LocalHostName` } else { `hostname -s` }

alias u := update
alias c := check
alias s := switch

# List available commands
default:
    @just --list

# Update flake inputs
update:
    nix flake update

# Update specific input
update-input input:
    nix flake lock --update-input {{input}}

# Build the system configuration (optionally specify a different hostname)
build hostname=host:
    #!/usr/bin/env bash
    if [[ "{{os()}}" == "macos" ]]; then
        nix build .#darwinConfigurations.{{hostname}}.system
    else
        nix build .#homeConfigurations.{{hostname}}
    fi

# Manual Homebrew update/upgrade (usually handled by switch)
brew:
    brew update && brew upgrade && brew cleanup

# Build and switch to the new configuration (optionally specify a different hostname)
switch hostname=host:
    #!/usr/bin/env bash
    if [[ "{{os()}}" == "macos" ]]; then
        sudo darwin-rebuild switch --flake .#{{hostname}}
        brew update && brew upgrade --yes && brew cleanup
    else
        home-manager switch --flake .#{{hostname}}
    fi

# Clean up old generations (retention: 14d; use `clean-all` for full wipe)
clean:
    sudo nix-collect-garbage --delete-older-than 14d

# Nuke every generation but the current one (no rollback runway)
clean-all:
    sudo nix-collect-garbage -d

# Check configuration for errors (optionally specify a different hostname)
check hostname=host:
    #!/usr/bin/env bash
    nix flake check
    if [[ "{{os()}}" == "macos" ]]; then
        sudo darwin-rebuild check --flake .#{{hostname}}
    else
        home-manager build --flake .#{{hostname}}
    fi

# Format nix files
fmt:
    alejandra .

# Show the current system's flake info
show:
    nix flake show

# Debug build time dependencies (optionally specify a different hostname)
debug-deps package hostname=host:
    #!/usr/bin/env bash
    if [[ "{{os()}}" == "macos" ]]; then
        nix why-depends .#darwinConfigurations.{{hostname}}.system {{package}}
    else
        nix why-depends .#homeConfigurations.{{hostname}} {{package}}
    fi

# List all current system generations
generations:
    #!/usr/bin/env bash
    if [[ "{{os()}}" == "macos" ]]; then
        darwin-rebuild --list-generations
    else
        home-manager generations
    fi

# Boot into a specific generation (optionally specify a different hostname)
boot-generation gen hostname=host:
    #!/usr/bin/env bash
    if [[ "{{os()}}" == "macos" ]]; then
        sudo darwin-rebuild switch --flake . --switch-generation {{gen}}
    else
        echo "Generation switching on Linux should be done with: home-manager switch --flake .#{{hostname}} --generation {{gen}}"
    fi

# Create a new backup of the current generation
backup:
    cp -r result result.backup.$(date +%Y%m%d_%H%M%S)

# Print current hostname
print-host:
    @echo "Current hostname: {{host}}"

# Upgrade Determinate Nix to the latest version
upgrade-nix:
    sudo determinate-nixd upgrade

# Capture a perf snapshot to tmp/perf/<label>-<timestamp>.txt for before/after comparison
perf-snapshot label:
    #!/usr/bin/env bash
    set -uo pipefail
    mkdir -p tmp/perf
    out="tmp/perf/{{label}}-$(date +%Y%m%d-%H%M%S).txt"
    {
        echo "=== perf snapshot: {{label}} ==="
        echo "host:  {{host}}"
        echo "date:  $(date)"
        echo
        echo "=== /nix/store size ==="
        du -sh /nix/store
        echo
        echo "=== retained system generations ==="
        ls /nix/var/nix/profiles/ 2>/dev/null | grep -c '^system-[0-9]*-link$' || echo 0
        echo
        echo "=== flake.lock stats ==="
        echo "total nodes:             $(jq '.nodes | length' flake.lock)"
        echo "distinct nixpkgs revs:   $(jq '[.nodes | to_entries[] | select(.key | test("^nixpkgs(_[0-9]+)?$"))] | length' flake.lock)"
        echo "distinct flake-parts:    $(jq '[.nodes | to_entries[] | select(.key | test("^flake-parts(_[0-9]+)?$"))] | length' flake.lock)"
        echo "distinct nixpkgs-lib:    $(jq '[.nodes | to_entries[] | select(.key | test("^nixpkgs-lib(_[0-9]+)?$"))] | length' flake.lock)"
        echo
        echo "=== effective nix config (selected) ==="
        nix config show 2>/dev/null | grep -E '^(substituters|extra-substituters|trusted-substituters|max-jobs|cores|eval-cores|lazy-trees|auto-optimise-store)' || true
    } | tee "$out"
    echo
    echo "wrote $out"

# List existing perf snapshots
perf-list:
    @ls -lhrt tmp/perf/ 2>/dev/null || echo "no snapshots yet"

# Diff two perf snapshots by label prefix (latest match wins for each)
perf-diff before after:
    #!/usr/bin/env bash
    set -uo pipefail
    b=$(ls -1t tmp/perf/{{before}}-*.txt 2>/dev/null | head -1)
    a=$(ls -1t tmp/perf/{{after}}-*.txt 2>/dev/null | head -1)
    if [[ -z "$b" || -z "$a" ]]; then
        echo "snapshot(s) not found: before='$b' after='$a'"
        exit 1
    fi
    echo "diff $b -> $a"
    diff -u "$b" "$a" || true

# Show what nix store gc would reclaim (read-only)
perf-gc-dry:
    nix store gc --dry-run 2>&1 | tail -10

# Time evaluation of the system derivation (no build); slower than perf-snapshot
perf-eval-time hostname=host:
    #!/usr/bin/env bash
    if [[ "{{os()}}" == "macos" ]]; then
        time nix eval .#darwinConfigurations.{{hostname}}.system.drvPath
    else
        time nix eval .#homeConfigurations.{{hostname}}.activationPackage.drvPath
    fi

# Time darwin-rebuild switch (no brew), log output, then snapshot as built-<label>
perf-switch label hostname=host:
    #!/usr/bin/env bash
    set -uo pipefail
    mkdir -p tmp/perf
    log="tmp/perf/switch-{{label}}-$(date +%Y%m%d-%H%M%S).log"
    echo "logging switch to $log"
    if [[ "{{os()}}" == "macos" ]]; then
        { time sudo darwin-rebuild switch --flake .#{{hostname}} ; } 2>&1 | tee "$log"
    else
        { time home-manager switch --flake .#{{hostname}} ; } 2>&1 | tee "$log"
    fi
    echo
    just perf-snapshot built-{{label}}

# nix-collect-garbage -d, then snapshot as clean-<label>
perf-clean label:
    #!/usr/bin/env bash
    set -uo pipefail
    sudo nix-collect-garbage -d
    echo
    just perf-snapshot clean-{{label}}
