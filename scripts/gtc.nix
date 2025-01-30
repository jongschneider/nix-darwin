# gtc tests only the changed go packages.
{pkgs}:
pkgs.writeShellScriptBin "gtc" ''
  set -e
  (
    ${pkgs.git}/bin/git status --porcelain | ${pkgs.gawk}/bin/awk '{print $2}'
    ${pkgs.git}/bin/git diff --name-only HEAD..origin/main
  ) |
    ${pkgs.gnugrep}/bin/grep -E '.*\.go$' |
    ${pkgs.gnugrep}/bin/grep -v dagger |
    while read -r file; do
      echo "./$(dirname "$file")/..."
    done |
    sort |
    uniq |
    tr '\n' ' ' |
    xargs go test --failfast -cover $*
''
