{
  config,
  pkgs,
  system,
  lib,
  ...
}: let
  gtd = pkgs.callPackage ../scripts/gtd {};
  mike = pkgs.callPackage ../scripts/mike {};
  scalyr = pkgs.callPackage ../scripts/scalyr.nix {};
in {
  # Latent config for hosts using nix-darwin's Nix management. Currently dormant
  # on every host because Determinate Nix sets `nix.enable = false` in each
  # host's systemoverrides.nix — leaving /etc/nix/nix.conf to Determinate.
  nix = lib.mkIf config.nix.enable {
    package = pkgs.nix;

    nixPath = [
      # Support legacy workflows that use `<nixpkgs>` etc.
      "nixpkgs=${pkgs.path}"
    ];

    settings = {
      auto-optimise-store = false;
      builders-use-substitutes = true;
      experimental-features = ["flakes" "nix-command"];
      trusted-users = [
        "@wheel"
        "@admin" # This line is a prerequisite for linux-builder
      ];
      warn-dirty = false;
    };

    optimise.automatic = false;

    gc = {
      automatic = lib.mkDefault true;
      options = "--delete-older-than 14d";
    };

    extraOptions = ''
      extra-platforms = x86_64-darwin aarch64-darwin
    '';
  };

  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = system;
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh = {
    enable = true; # default shell on catalina
    enableCompletion = false; # Disable system-level compinit (oh-my-zsh handles it)
  };
  programs.nix-index.enable = true;

  # Raise default macOS file descriptor limits (default soft limit is 256)
  launchd.daemons.maxfiles = {
    command = "/bin/launchctl limit maxfiles 524288 524288";
    serviceConfig = {
      Label = "limit.maxfiles";
      RunAtLoad = true;
    };
  };

  # Executor.app's MCP stdio sidecars inherit PATH from LaunchServices:
  #   /usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin
  # On macOS 26, both `launchctl setenv` (via LaunchAgent) and `launchctl config
  # user path` are silently ignored by LaunchServices — verified empirically
  # 2026-05-15 via /tmp/slack-mcp-trace.log after rebuild + logout/login.
  # Workaround: symlink node + npx into /usr/local/bin (already on Executor's
  # PATH) so bare `npx ...` MCP source commands resolve.
  system.activationScripts.extraActivation.text = ''
    mkdir -p /usr/local/bin
    for cmd in node npx; do
      src="/opt/homebrew/bin/$cmd"
      dst="/usr/local/bin/$cmd"
      if [ -e "$src" ]; then
        ln -sfn "$src" "$dst"
      fi
    done
  '';

  system.stateVersion = 4;

  # Add ability to used TouchID for sudo authentication
  security.pam.services.sudo_local.touchIdAuth = true;

  # Currently not working as a system service - using homebrew instead
  services.karabiner-elements.enable = false;

  # Basic system packages all machines should have
  environment.systemPackages = with pkgs;
    [
      (import ../scripts/git-bare-clone.nix {inherit pkgs;})
      (import ../scripts/wta.nix {inherit pkgs;})
      (import ../scripts/gsquash.nix {inherit pkgs;})
      bun
      alejandra
      ast-grep
      coreutils
      curl
      delve
      git
      gnumake
      go_1_25
      gofumpt
      golangci-lint
      golines
      gomodifytags
      gotests
      gotestsum
      gotools
      grc
      gtd
      ice-bar
      impl
      just
      manix
      mike
      nil # nix LSP
      scalyr
      nurl
      sqlc
      sqlite
      vhs
      vim
      yazi
    ];
}
