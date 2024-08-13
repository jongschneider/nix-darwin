{
  onActivation.cleanup = "uninstall"; # uncomment when everything is migrated over
  enable = true;
  caskArgs.no_quarantine = true;
  global.brewfile = true;
  casks = [
    "wkhtmltopdf" # for work
    "vlc"
    "font-monaspace"
    "raycast"
    "shottr"
    "powershell"
  ];
  taps = [
    "homebrew/cask-fonts"
  ];
  brews = [
    "trash"
    "lazygit"
  ];
}
