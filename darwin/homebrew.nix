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
    "rectangle"
    "shottr"
    # "karabiner-elements" # using the cask bc couldn't get  services.karabiner-elements to work correctly
  ];
  taps = [
    "homebrew/cask-fonts"
  ];
  brews = [
    "trash"
  ];
}
