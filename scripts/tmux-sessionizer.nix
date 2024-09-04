{pkgs}: let
  my-src = builtins.readFile ./bins/tmux-sessionizer.sh;
  my-name = "tmux-sessionizer";
in
  (pkgs.writeScriptBin my-name my-src).overrideAttrs (old: {
    buildCommand = "${old.buildCommand}\n patchShebangs $out";
  })
