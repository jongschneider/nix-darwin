{pkgs, ...}: {
  home.packages = [pkgs.trash-cli];

  xdg.configFile = {
    "yazi/yazi.toml" = {
      source = ./yazi.toml;
    };
    "yazi/keymap.toml" = {
      text = ''
        # Override delete to use trash-cli instead of rm
        [[manager.prepend_keymap]]
        on   = ["d"]
        run  = "shell '${pkgs.trash-cli}/bin/trash -- \"$@\"' --confirm"
        desc = "Move to trash"
      '';
    };
  };
}
