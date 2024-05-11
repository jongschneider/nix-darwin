{ pkgs, config, ... }:
let
  # oxocarbon = (import ../oxocarbon.nix).dark;
in
{
  programs.neovim = {
        enable = true;
        # defaultEditor = true;
        extraLuaConfig = ''
          require('user')
        '';
        extraPackages = [
          # Included for nil_ls
          pkgs.cargo
          # Included to build telescope-fzf-native.nvim
          pkgs.cmake
        ];
        withNodeJs = true;
        withPython3 = true;
        withRuby = true;
        vimdiffAlias = true;
      };

  xdg.configFile.nvim = {
      source = config.lib.file.mkOutOfStoreSymlink ../../config/nvim;
      recursive = true;
    };
}
