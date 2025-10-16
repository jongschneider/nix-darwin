{
  pkgs,
  lib,
  config,
  ...
}: {
  home.file.".grc/conf.runintegrator".source = ./conf.runintegrator;

  home.file.".grc/grc.conf".text = ''
    # Add custom command configuration
    runintegrator
  '';
}
