# wta - Git Worktree Add Script
# This script creates a new worktree for an existing remote branch.
# It checks if the current directory is a git repository and not already a worktree,
# then sets up a new worktree that tracks the specified remote branch.
{pkgs}:
pkgs.writeShellScriptBin "wta" ''
  # Check if we're in a git repository
  if ! ${pkgs.git}/bin/git rev-parse --is-inside-work-tree &>/dev/null; then
    echo "Not in a git repository. Exiting."
    exit 1
  fi

  # Get the toplevel git directory
  GIT_DIR=$(${pkgs.git}/bin/git rev-parse --git-dir)

  # Check if we're already in a worktree
  if [[ "$(${pkgs.git}/bin/git rev-parse --is-inside-work-tree)" == "true" && "$GIT_DIR" != ".git" ]]; then
    echo "Already in a worktree. This command should be run from the main repository. Exiting."
    exit 1
  fi

  # Check if branch name is provided
  if [ -z "$1" ]; then
    echo "No branch name provided. Usage: wta <branch-name>"
    exit 1
  fi

  BRANCH_NAME="$1"
  REMOTE_BRANCH="origin/$BRANCH_NAME"

  # Check if remote branch exists
  if ${pkgs.git}/bin/git ls-remote --heads origin "$BRANCH_NAME" | ${pkgs.gnugrep}/bin/grep -q "$BRANCH_NAME"; then
    echo "Creating worktree for branch $BRANCH_NAME tracking $REMOTE_BRANCH..."
    ${pkgs.git}/bin/git worktree add -B "$BRANCH_NAME" "$BRANCH_NAME" --track "$REMOTE_BRANCH"
    echo "Worktree created successfully at ./$BRANCH_NAME"
  else
    echo "Remote branch '$REMOTE_BRANCH' does not exist."
    echo "If you want to create a new branch, use the standard git command:"
    echo "  git worktree add -b $BRANCH_NAME $BRANCH_NAME"
  fi
''
