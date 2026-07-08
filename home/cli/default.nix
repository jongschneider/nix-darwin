{pkgs, ...}: {
  programs = {
    jq.enable = true;
    bat = {
      enable = true;
    };

    eza = {
      enable = true;
      git = true;
      icons = "auto";
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
      package = pkgs.direnv.overrideAttrs (old: {
        env = (old.env or {}) // {
          CGO_ENABLED = 1;
        };
        doCheck = false;
      });
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
      # Let Atuin own Ctrl-R; fzf keeps Ctrl-T and Alt-C.
      historyWidget.command = "";
    };

    atuin = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        auto_sync = true;
        sync_frequency = "5m";
        sync_address = "https://api.atuin.sh";
        ctrl_n_shortcuts = true;
        enter_accept = true;
      };
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = ["--hook pwd"];
    };
  };
}
