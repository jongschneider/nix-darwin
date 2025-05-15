{pkgs}: let
  script = builtins.readFile ./caider.sh;
in
  pkgs.writeShellScriptBin "caider" ''
    #!${pkgs.bash}/bin/bash
    ${script}
  ''
