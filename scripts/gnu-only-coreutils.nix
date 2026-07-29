# macOS ships no equivalent for these GNU coreutils tools, so they lose their
# bare names when we install coreutils-prefixed rather than coreutils. Linking
# them back is unambiguous — unlike date/ls/stat, there is no BSD tool here to
# shadow. Everything else stays g-prefixed on purpose.
#
# Omits the tools that are meaningless on darwin: chcon, runcon (SELinux),
# hostid, pinky, ptx, and dir/vdir/dircolors (GNU ls variants).
{pkgs}: let
  tools = [
    "b2sum"
    "base32"
    "basenc"
    "factor"
    "nproc"
    "numfmt"
    "shred"
    "shuf"
    "tac"
    "timeout"
  ];
in
  pkgs.runCommand "gnu-only-coreutils" {} ''
    mkdir -p "$out/bin"
    for tool in ${pkgs.lib.escapeShellArgs tools}; do
      ln -s "${pkgs.coreutils-prefixed}/bin/g$tool" "$out/bin/$tool"
    done
  ''
