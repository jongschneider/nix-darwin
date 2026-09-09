# herdr-annotate: annotate terminal text and documents in herdr, send the
# feedback back to the agent. https://github.com/plannotator/herdr-annotate
#
# The plugin ships a `[[build]]` step that downloads a pinned plannotator-tui
# release into <plugin root>/bin. Two things make that unusable here:
#
#   1. `herdr plugin link` never runs build steps — only `plugin install` does.
#   2. herdr resolves plugin_root to the *realpath* of herdr-plugin.toml, so a
#      home-manager symlink tree still lands on the read-only store directory.
#
# So we do the staging ourselves: copy the upstream source and drop the release
# binary into bin/ at build time. The version comes from upstream's own pin
# (plannotator-tui.version), which is asserted below so a source bump that
# moves the pin fails the build instead of silently shipping the old binary.
{
  pkgs,
  src,
}: let
  inherit (pkgs) lib stdenvNoCC;

  version = "0.7.0";

  # Rust target triples as named in the plannotator-tui release assets; hashes
  # come from that release's SHA256SUMS.
  targets = {
    aarch64-darwin = {
      rustTarget = "aarch64-apple-darwin";
      hash = "sha256-tSA4uqJko3INV8mg5Wc9uG1eB7mNY5cz+WIb6IuPFSg=";
    };
    x86_64-darwin = {
      rustTarget = "x86_64-apple-darwin";
      hash = "sha256-UVWvh0Qv0STJ7fEFxIZ0z6VjOiW+cDllKvUruNxhZ00=";
    };
    aarch64-linux = {
      rustTarget = "aarch64-unknown-linux-gnu";
      hash = "sha256-GUgIcAHloC6Hn9oVhmjLVZ5ARTREageGEN55mwtTBRQ=";
    };
    x86_64-linux = {
      rustTarget = "x86_64-unknown-linux-gnu";
      hash = "sha256-j4FK/WPGMQDf0Vx+TC1ciSTnSUPoF4gMOciAwvicmUQ=";
    };
  };

  inherit (pkgs.stdenv.hostPlatform) system;
  target =
    targets.${system}
    or (throw "herdr-annotate: no plannotator-tui build for ${system}");

  plannotatorTui = pkgs.fetchurl {
    url = "https://github.com/plannotator/plannotator-tui/releases/download/v${version}/plannotator-tui-${target.rustTarget}";
    inherit (target) hash;
  };
in
  stdenvNoCC.mkDerivation {
    pname = "herdr-annotate";
    inherit src;
    # Tracks the plugin's own version, not plannotator-tui's.
    version = "0.3.0";

    dontConfigure = true;
    dontBuild = true;

    # A self-contained Rust binary whose ad-hoc macOS signature is load-bearing:
    # rewrite the Mach-O and the kernel refuses to exec it.
    dontStrip = true;

    installPhase = ''
      runHook preInstall

      pinned="$(tr -d '[:space:]' < plannotator-tui.version)"
      if [ "$pinned" != "${version}" ]; then
        echo "herdr-annotate pins plannotator-tui $pinned but this derivation fetches ${version}." >&2
        echo "Update version and the hashes in home/herdr/plugins/annotate.nix from" >&2
        echo "https://github.com/plannotator/plannotator-tui/releases/download/v$pinned/SHA256SUMS" >&2
        exit 1
      fi

      mkdir -p $out
      cp -R . $out/
      chmod -R u+w $out

      # What scripts/fetch-plannotator-tui.sh would have produced, including the
      # stamp, so the build step is a no-op if herdr ever does run it.
      install -Dm755 ${plannotatorTui} $out/bin/plannotator-tui.exe
      printf '%s' "${version}" > $out/bin/plannotator-tui.version

      runHook postInstall
    '';

    meta = {
      description = "Annotate terminal text and documents in herdr and send the feedback back to the agent";
      homepage = "https://github.com/plannotator/herdr-annotate";
      license = lib.licenses.mit;
      platforms = lib.attrNames targets;
      sourceProvenance = [lib.sourceTypes.binaryNativeCode];
    };
  }
