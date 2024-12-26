# gsquash is a script that squashes the last n commits
{pkgs}:
pkgs.writeShellScriptBin "gsquash" ''
  ${pkgs.git}/bin/git reset --soft HEAD~$1
''
