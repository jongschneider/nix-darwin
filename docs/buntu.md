# TODO: Add Ubuntu Machine to Nix Config

## Overview
Add the Ubuntu machine "buntu" (Late 2014 Mac mini running Ubuntu 24.04.3 LTS) to the existing Nix configuration for package management via home-manager.

## Machine Details
- **Hostname**: `jschneider-Macmini7-1` (Tailscale name: `buntu`)
- **IP**: `100.64.238.26` (Tailscale)
- **User**: `jschneider`
- **OS**: Ubuntu 24.04.3 LTS
- **Arch**: `x86_64-linux`
- **Use case**: Remote development server for Go development and container-based Android emulation

## Tasks

### 0. Change Hostname (Prerequisite)
- [ ] Change Ubuntu hostname from `jschneider-Macmini7-1` to `buntu`
  ```bash
  sudo hostnamectl set-hostname buntu
  sudo sed -i 's/jschneider-Macmini7-1/buntu/g' /etc/hosts
  ```
- [ ] Verify hostname change: `hostname` should return `buntu`
- [ ] Reboot system: `sudo reboot`
- [ ] Update Tailscale hostname: `sudo tailscale up --hostname=buntu`

### 1. Create Ubuntu Home Configuration
- [ ] Create `hosts/buntu/` directory
- [ ] Create `hosts/buntu/home.nix` with minimal server packages:
  - Go development tools (go_1_24, gofumpt, golangci-lint, gotools, delve)
  - Essential CLI tools (curl, wget, git, tree, htop, bottom, fd, ripgrep)
  - Container tools (lazydocker)
  - Development utilities (tmux, neofetch, just)
- [ ] Import existing home modules: cli, git, nvim, zsh
- [ ] Configure server-focused shell aliases
- [ ] Enable direnv for project environments

### 2. Update Flake Configuration
- [ ] Add `homeConfigurations` section to `flake.nix`
- [ ] Add `"jschneider@buntu"` configuration for `x86_64-linux`
- [ ] Include catppuccin home manager modules
- [ ] Ensure proper `extraSpecialArgs` (username, system, inputs)

### 3. Remove Old Mac Mini Configuration
- [ ] Remove `hosts/macmini/` directory and all contents:
  - `hosts/macmini/configuration.nix`
  - `hosts/macmini/home.nix` 
  - `hosts/macmini/homebrewoverrides.nix`
  - `hosts/macmini/systemoverrides.nix`
- [ ] Remove `"Jonathans-Mac-mini"` from `darwinConfigurations` in `flake.nix`
- [ ] Update `justfile` to remove references to old macmini hostname

### 4. Personal Git Configuration
- [ ] Remove work git credentials from buntu home config
- [ ] Either:
  - [ ] Option A: Add personal git credentials to home config
  - [ ] Option B: Remove git config entirely and configure manually on machine

### 5. Documentation Updates
- [ ] Update `README.md` to reflect the new Ubuntu machine setup
- [ ] Add instructions for home-manager deployment on Ubuntu
- [ ] Update machine list in documentation

### 6. Testing & Deployment
- [ ] Test flake configuration locally with `nix flake check`
- [ ] Deploy to Ubuntu machine with: `nix run home-manager/master -- switch --flake .#jschneider@buntu`
- [ ] Verify packages are installed correctly
- [ ] Test Go development environment
- [ ] Verify shell configuration and aliases

## Implementation Notes

### Deployment Command
```bash
# On the Ubuntu machine
nix run home-manager/master -- switch --flake .#jschneider@buntu
```

### Package Strategy
- **Keep via apt**: docker.io, openssh-server, tailscale (system services)
- **Replace with Nix**: development tools, CLI utilities
- **Gradual migration**: Can remove apt packages after confirming Nix versions work

### File Structure After Changes
```
hosts/
├── m4mini/           # M4 Mac mini
├── mbp/              # MacBook Pro  
├── buntu/            # Ubuntu machine (new)
└── macmini/          # Remove this (old Intel Mac mini)
```

## Success Criteria
- [ ] Ubuntu machine has working Nix package management
- [ ] Go development environment functional
- [ ] Shell configuration matches other machines
- [ ] Old Mac mini configuration completely removed
- [ ] Documentation updated and accurate
