# justfile for managing Nix configuration

# List available commands
default:
    @just --list

# Check flake inputs for updates
check-updates:
    nix flake update --dry-run

# Update flake inputs
update:
    nix flake update

# Update specific input
update-input input:
    nix flake lock --update-input {{input}}

# Build the system configuration
build:
    nix build .#darwinConfigurations.Jonathans-MacBook-Pro.system

# Build and switch to the new configuration
switch: build
    ./result/sw/bin/darwin-rebuild switch --flake .

# Clean up old generations
clean:
    nix-collect-garbage -d
    home-manager expire-generations "-30 days"

# Check configuration for errors
check:
    nix flake check
    darwin-rebuild check --flake .

# Format nix files
fmt:
    alejandra .

# Show the current system's flake info
show:
    nix flake show

# Debug build time dependencies
debug-deps:
    nix why-depends .#darwinConfigurations.Jonathans-MacBook-Pro.system {package}

# List all current system generations
generations:
    darwin-rebuild --list-generations

# Boot into a specific generation
boot-generation gen:
    darwin-rebuild switch --flake . --switch-generation {{gen}}

# Create a new backup of the current generation
backup:
    cp -r result result.backup.$(date +%Y%m%d_%H%M%S)
