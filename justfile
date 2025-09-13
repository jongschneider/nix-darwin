# justfile for managing Nix configuration

# Get local hostname (cross-platform)
host := if os() == "macos" { `scutil --get LocalHostName` } else { `whoami` + "@" + `hostname -s` }

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
        nix build .#homeConfigurations.{{hostname}}.activationPackage
    fi

# Manual Homebrew update/upgrade (usually handled by switch)
brew:
    brew update && brew upgrade && brew cleanup

# Build and switch to the new configuration (optionally specify a different hostname)
switch hostname=host:
    #!/usr/bin/env bash
    if [[ "{{os()}}" == "macos" ]]; then
        sudo darwin-rebuild switch --flake .#{{hostname}}
        brew update && brew upgrade && brew cleanup
    else
        home-manager switch --flake .#{{hostname}}
    fi

# Clean up old generations
clean:
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
        nix why-depends .#homeConfigurations.{{hostname}}.activationPackage {{package}}
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
