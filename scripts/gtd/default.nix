{pkgs}: let
  script = builtins.readFile ./gtd.sh;
in
  pkgs.writeShellScriptBin "gtd" ''
    #!${pkgs.bash}/bin/bash
    ${script}
  ''
