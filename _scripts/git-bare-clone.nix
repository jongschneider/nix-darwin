# gsquash is a script that squashes the last n commits
{pkgs}:
pkgs.writeShellScriptBin "git-bare-clone" ''
  echo "Cloning bare repository to .bare..."
  ${pkgs.git}/bin/git clone --bare $1 .bare
  pushd '.bare' > /dev/null
  echo "Adjusting origin fetch locations..."
  ${pkgs.git}/bin/git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
  popd > /dev/null
  echo "Setting .git file contents..."
  echo "gitdir: ./.bare" > .git
  echo "Success."
''
