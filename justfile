# justfile for managing Nix configuration

# Get local hostname
host := `scutil --get LocalHostName`

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
    nix build .#darwinConfigurations.{{hostname}}.system

# Build and switch to the new configuration (optionally specify a different hostname)
switch hostname=host: (build hostname)
    ./result/sw/bin/darwin-rebuild switch --flake .

# Clean up old generations
clean:
    nix-collect-garbage -d

# Check configuration for errors (optionally specify a different hostname)
check hostname=host:
    nix flake check
    darwin-rebuild check --flake .

# Format nix files
fmt:
    alejandra .

# Show the current system's flake info
show:
    nix flake show

# Debug build time dependencies (optionally specify a different hostname)
debug-deps package hostname=host:
    nix why-depends .#darwinConfigurations.{{hostname}}.system {{package}}

# List all current system generations
generations:
    darwin-rebuild --list-generations

# Boot into a specific generation (optionally specify a different hostname)
boot-generation gen hostname=host:
    darwin-rebuild switch --flake . --switch-generation {{gen}}

# Create a new backup of the current generation
backup:
    cp -r result result.backup.$(date +%Y%m%d_%H%M%S)

# Print current hostname
print-host:
    @echo "Current hostname: {{host}}"
