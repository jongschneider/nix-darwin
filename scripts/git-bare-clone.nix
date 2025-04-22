# gsquash is a script that squashes the last n commits
{pkgs}:
pkgs.writeShellScriptBin "git-bare-clone" ''
  # Make directory for your git repository
  repo=$(basename $1 .git)
  mkdir "$repo"
  pushd "$repo"
  echo "Cloning bare repository to .git..."
  ${pkgs.git}/bin/git clone --bare $1 .git
  pushd '.git' > /dev/null
  echo "Adjusting origin fetch locations..."
  # Explicitly sets the remote origin fetch so we can fetch remote branches
  ${pkgs.git}/bin/git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
  # Fetch all branches from remote
  echo "Fetching all branches from remote..."
  ${pkgs.git}/bin/git fetch origin
  popd > /dev/null
  echo "Success."
''
