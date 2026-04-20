{
  pkgs,
  ...
}: {
  xdg.configFile = {
    nvim = {
      source = ./config;
      recursive = true;
    };
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
    withRuby = true;
    vimdiffAlias = true;
  };
}
