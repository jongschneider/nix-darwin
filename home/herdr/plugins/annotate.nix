# herdr-annotate: annotate terminal text and documents in herdr, send the
# feedback back to the agent. https://github.com/plannotator/herdr-annotate
#
# The plugin ships `[[build]]` steps that download pinned release binaries
# (herdr-annotate and plannotator-tui) into <plugin root>/bin. Two things make
# that unusable here:
#
#   1. `herdr plugin link` never runs build steps — only `plugin install` does.
#   2. herdr resolves plugin_root to the *realpath* of herdr-plugin.toml, so a
#      home-manager symlink tree still lands on the read-only store directory.
#
# So we do the staging ourselves: copy the upstream source and drop each release
# binary into bin/ at build time. Versions and hashes live in annotate-pins.json,
# and each version is asserted against upstream's own pin (<name>.version) so a
# source bump that moves a pin fails the build instead of silently shipping an
# old binary.
#
# When that assert fires, `just update-herdr-annotate` rewrites the pins file
# from whatever source flake.lock points at; `just update` runs it after every
# `nix flake update`.
{
  pkgs,
  src,
}: let
  inherit (pkgs) lib stdenvNoCC;

  pins = lib.importJSON ./annotate-pins.json;

  inherit (pkgs.stdenv.hostPlatform) system;
  rustTarget =
    pins.targets.${system}
    or (throw "herdr-annotate: no prebuilt binaries for ${system}");

  binaries =
    lib.mapAttrs (name: pin: {
      inherit (pin) version;
      file = pkgs.fetchurl {
        url = "${lib.replaceStrings ["{version}"] [pin.version] pin.release}/${name}-${rustTarget}";
        hash = pin.hashes.${system};
      };
    })
    pins.binaries;

  # What each upstream fetch script would have produced, including the version
  # stamp, so the build steps are no-ops if herdr ever does run them.
  stageBinary = name: bin: ''
    pinned="$(tr -d '[:space:]' < ${name}.version)"
    if [ "$pinned" != "${bin.version}" ]; then
      echo "herdr-annotate pins ${name} $pinned but annotate-pins.json fetches ${bin.version}." >&2
      echo "Run 'just update-herdr-annotate' to repin from the locked source." >&2
      exit 1
    fi
    install -Dm755 ${bin.file} $out/bin/${name}.exe
    printf '%s' "${bin.version}" > $out/bin/${name}.version
  '';
in
  stdenvNoCC.mkDerivation {
    pname = "herdr-annotate";
    inherit src;
    version = pins.plugin;

    dontConfigure = true;
    dontBuild = true;

    # Self-contained Rust binaries whose ad-hoc macOS signatures are load-bearing:
    # rewrite the Mach-O and the kernel refuses to exec it.
    dontStrip = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -R . $out/
      chmod -R u+w $out

      ${lib.concatStrings (lib.mapAttrsToList stageBinary binaries)}

      runHook postInstall
    '';

    meta = {
      description = "Annotate terminal text and documents in herdr and send the feedback back to the agent";
      homepage = "https://github.com/plannotator/herdr-annotate";
      license = lib.licenses.mit;
      platforms = lib.attrNames pins.targets;
      sourceProvenance = [lib.sourceTypes.binaryNativeCode];
    };
  }
