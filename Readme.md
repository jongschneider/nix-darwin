# Nix Configuration

This repository contains my personal Nix configuration for managing macOS systems using nix-darwin and home-manager. It uses a modular approach to maintain both shared and machine-specific configurations.

## Prerequisites

1. Install Nix by following the guide at [Zero to Nix](https://zero-to-nix.com/start/install/)

2. Install Homebrew from [brew.sh](https://brew.sh/)

3. Enable Nix flakes and prepare for nix-darwin installation:
```bash
# Enable experimental features (flakes)
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf

# Back up existing /etc config files that nix-darwin will manage
sudo mv /etc/zshenv /etc/zshenv.before-nix-darwin
```

4. Install nix-darwin:
```bash
# Navigate to your nix-darwin config directory
cd ~/.config/nix-darwin  # or wherever you cloned this repo

# Run the initial installation (requires sudo)
sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#"js-m4-mini"
```
Note: Replace `js-m4-mini` with your machine's hostname. The first installation will take several minutes.

5. Install Just command runner:
```bash
nix-shell -p just
```

## Repository Structure

```
.
├── flake.nix                       # Main flake configuration
├── darwin/                         # Base darwin configuration
│   ├── default.nix       
│   ├── system.nix                  # System-wide settings
│   ├── preferences.nix             # macOS preferences
│   └── homebrew.nix                # Base Homebrew config
├── home/                           # Base home-manager configuration
│   ├── default.nix
│   └── packages.nix                # Base home-manager packages
└── hosts/                          # Machine-specific configurations
    └── mbp/                        # Example MacBook Pro config
        ├── configuration.nix       # System configuration
        ├── home.nix                # Home-manager configuration
        ├── homebrewoverrides.nix   # Homebrew overrides 
        └── systemoverrides.nix     # Darwin system overrides
```

## Usage

Common commands (using just):

```bash
# Build and switch to new configuration
just switch

# Update flake inputs
just update

# Check configuration
just check

# Format nix files
just fmt

# Clean up old generations
just clean
```

## Adding a New Machine

1. Get your machine's hostname:
```bash
scutil --get LocalHostName
```
- If your hostname has a conflict with a current hostname (or you just want to change it) use the following commands to change it.
```sh
sudo scutil --set ComputerName "new-hostname-no-spaces"
sudo scutil --set HostName "new-hostname-no-spaces"
sudo scutil --set LocalHostName "new-hostname-no-spaces"  # Must not contain spaces or special characters
```
2. Create a new directory under `hosts/` with your machine's configuration:
```bash
mkdir -p hosts/new-machine
```

3. Create the machine-specific system configuration:
```nix
# hosts/new-machine/configuration.nix
{
  pkgs,
  username,
  ...
}: {
  imports = [
    ../../darwin
    ./systemoverrides.nix # Import the overrides
    ./homebrewoverrides.nix # Import the overrides
  ];

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };
}
```
- 💡 Note: if using the Determinate Systems nix installer you might need to set `nix.enable = false;` in `hosts/new-machine/systemoverrides.nix`

4. Create the machine-specific home configuration:
```nix
# hosts/new-machine/home.nix
{ pkgs, ... }: {
  imports = [
    ../../home
  ];

  # Add machine-specific home packages
  home.packages = with pkgs; [
    # your packages here
  ];
}
```

5. Add your machine to the flake:
```nix
# flake.nix
darwinConfigurations = {
  "Your-Hostname" = inputs.darwin.lib.darwinSystem {
    system = "aarch64-darwin";  # or "x86_64-darwin" for Intel Macs
    specialArgs = {
      username = "yourusername";
    };
    modules = [
      ./hosts/new-machine/configuration.nix
      inputs.home-manager.darwinModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = {
            username = "yourusername";
          };
          users.yourusername = {
              imports = [
                ./hosts/new-machine/home.nix
                inputs.catppuccin.homeManagerModules.catppuccin
              ];
            };

          users.yourusername = import ./home;
        };
      }
    ];
  };
};
```

6. Build and switch to your new configuration:
```bash
just switch
```

## Notes

- When installing nix-darwin the first time, you will want to specifically target the new flake of the new hostname:
```sh
nix run nix-darwin/master#darwin-rebuild -- switch --flake .#"js-m4-mini"
```
- The configuration uses `specialArgs` to pass username to all modules
- Base configurations in `darwin/` and `home/` are shared across all machines
- Machine-specific overrides and additions go in `hosts/<machine>/`
- Homebrew packages are managed through nix-darwin
- The justfile automatically uses your local hostname for commands

## Maintenance

- Keep your system updated with `just update`
- Clean old generations with `just clean`
- Check for errors before switching with `just check`
- Use `just generations` to list available generations
- Back up your current generation with `just backup`

## Troubleshooting

### First-time installation: "Unexpected files in /etc"

If you get an error about unexpected files in `/etc` during the initial nix-darwin installation, back up the conflicting files:

```bash
# Common files that may need backing up:
sudo mv /etc/zshenv /etc/zshenv.before-nix-darwin
sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin
sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin
```

Then retry the installation command.

### Flakes not working

If you get errors about flakes not being enabled, ensure your nix configuration includes:

```bash
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf
```
