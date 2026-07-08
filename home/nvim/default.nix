{
  pkgs,
  ...
}: {
  xdg.configFile = {
    "nvim/init.lua".source = ./config/init.lua;
    "nvim/lua" = {
      source = ./config/lua;
      force = true;
    };
    "nvim/after/plugin/herdr_nav.lua".source = ./config/after/plugin/herdr_nav.lua;
  };

  programs.neovim = {
    enable = true;
    initLua = ''
      require('user')
    '';
    extraPackages = with pkgs; [
      # Included for nil_ls
      cargo
      # Included to build telescope-fzf-native.nvim
      cmake
      luajitPackages.tiktoken_core # copilot (optional)
      tree-sitter # Required for nvim-treesitter parser compilation
    ];
    withNodeJs = true;
    withPython3 = true;
    vimdiffAlias = true;
  };
}
