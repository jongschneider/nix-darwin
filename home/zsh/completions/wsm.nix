{
  xdg.configFile."zsh/completions/_wsm".source = ./wsm.zsh;

  programs.zsh = {
    enable = true;
    initContent = ''
      # Add the completion directory to fpath
      fpath=(~/.config/zsh/completions $fpath)

      # Initialize completions
      autoload -Uz compinit
      compinit
    '';
  };
}
