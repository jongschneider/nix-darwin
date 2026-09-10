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
#
# When that assert fires, `just update-herdr-annotate` rewrites both versions
# and all four hashes here from whatever source flake.lock points at; `just
# update` runs it after every `nix flake update`.
{
  pkgs,
  src,
}: let
  inherit (pkgs) lib stdenvNoCC;

  version = "0.8.0";

  # Rust target triples as named in the plannotator-tui release assets; hashes
  # come from that release's SHA256SUMS.
  targets = {
    aarch64-darwin = {
      rustTarget = "aarch64-apple-darwin";
      hash = "sha256-fQV/Oho6ojywpEhD/tPwTUmKHaUhl83sAhLG+OFhjLI=";
    };
    x86_64-darwin = {
      rustTarget = "x86_64-apple-darwin";
      hash = "sha256-a2CE0W7YqgmRWJL5B+WBhqbsacVgdSz/nQQr3Ltigg8=";
    };
    aarch64-linux = {
      rustTarget = "aarch64-unknown-linux-gnu";
      hash = "sha256-I/keWx5dBKGsQfHY9Q6/TCDwRhFBlShilypjDvaQ4Y4=";
    };
    x86_64-linux = {
      rustTarget = "x86_64-unknown-linux-gnu";
      hash = "sha256-+qZROtGkdXooYelVcBaPLIEY8hm36NalF1oAj+I0/gs=";
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
    version = "0.4.0";

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
        echo "Run 'just update-herdr-annotate' to repin this file from the locked source," >&2
        echo "or edit it by hand from https://github.com/plannotator/plannotator-tui/releases/download/v$pinned/SHA256SUMS" >&2
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
