{
  xdg.configFile."zsh/completions/_wsm".source = ./wsm.zsh;

  programs.zsh = {
    enable = true;
    initExtraFirst = ''
      # Add custom completions to fpath (before compinit runs)
      fpath=(~/.config/zsh/completions $fpath)
    '';
  };
}
