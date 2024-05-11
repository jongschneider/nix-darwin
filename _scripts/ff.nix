# ff is a script that allows for fuzzy searching files and then opening the file
# in the default application on the system. all of the depndencies are baked in.
{pkgs}:
pkgs.writeShellScriptBin "ff" ''
  ${pkgs.fzf}/bin/fzf --preview '${pkgs.bat}/bin/bat -n --color=always {}' --bind 'ctrl-/:change-preview-window(down|hidden|),shift-up:preview-page-up,shift-down:preview-page-down' | xargs ${pkgs.xdg-utils}/bin/xdg-open
''
