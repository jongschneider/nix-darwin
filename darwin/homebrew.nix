{
  onActivation.cleanup = "uninstall"; # uncomment when everything is migrated over
  enable = true;
  caskArgs.no_quarantine = true;
  global.brewfile = true;
  casks = [
    "font-monaspace"
    "powershell"
    "raycast"
    "shottr"
    "vlc"
    "wkhtmltopdf" # for work
  ];
  taps = [
    "homebrew/cask-fonts"
  ];
  brews = [
    "bitwarden-cli"
    "lazygit"
    "trash"
  ];
}
