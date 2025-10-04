{pkgs}: let
  script = builtins.readFile ./mike.sh;
in
  pkgs.writeShellScriptBin "mike" ''
    #!${pkgs.bash}/bin/bash
    ${script}
  ''
