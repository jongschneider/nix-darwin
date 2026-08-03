# yaak-cli: the Yaak API client from the command line
# https://github.com/mountain-loop/yaak
#
# Not in nixpkgs — nixpkgs' `yaak` is the desktop app, which ships no CLI (the
# app itself comes from the homebrew cask in darwin/homebrew.nix). GitHub
# releases carry only desktop artifacts, so npm is the sole channel.
#
# The `@yaakapp/cli` entry point is just a downloader: it resolves one of six
# `@yaakapp/cli-<os>-<arch>` packages, each holding a single prebuilt binary,
# and shells out to npm at install time if the right one is missing. Fetching
# the platform package directly skips that and keeps the build hermetic.
{pkgs}: let
  inherit (pkgs) lib stdenvNoCC;

  # scripts/update-npm.sh rewrites the three attrs below, so keep them one per
  # line: it reads npmPackage to find the registry entry, version from
  # dist-tags.latest, and refreshes the hash under each npmArch in turn.
  npmPackage = "@yaakapp/cli";
  version = "0.7.1";

  # Only the systems this flake actually builds for. Upstream also ships
  # darwin-x64 (nixpkgs 26.11 dropped x86_64-darwin) and linux-arm64 (no host
  # here uses it); adding either back means a new entry plus its hash, since
  # every pin listed costs a ~55 MB refetch on `just update`.
  #
  # npmArch holds the `${process.platform}-${process.arch}` names npm resolves
  # on, so this table lines up with upstream's install.js.
  targets = {
    aarch64-darwin = {
      npmArch = "darwin-arm64";
      hash = "sha256-R8IwUcb8ke0BbW8DFxdNRO8QOwthU0+1TixTTi6qiz8=";
    };
    x86_64-linux = {
      npmArch = "linux-x64";
      hash = "sha256-hiwakbcKSH/oJZx5ADcBGQV70McI3IF/DtjjMTaqzc4=";
    };
  };

  inherit (pkgs.stdenv.hostPlatform) system;
  target =
    targets.${system}
    or (throw "yaak-cli: no upstream binary for ${system}");
in
  stdenvNoCC.mkDerivation {
    pname = "yaak-cli";
    inherit version;

    src = pkgs.fetchurl {
      # Scoped tarball paths drop the scope from the filename:
      # @yaakapp/cli-darwin-arm64 -> .../@yaakapp/cli-darwin-arm64/-/cli-darwin-arm64-<v>.tgz
      url = "https://registry.npmjs.org/${npmPackage}-${target.npmArch}/-/${baseNameOf npmPackage}-${target.npmArch}-${version}.tgz";
      inherit (target) hash;
    };

    # A self-contained Rust binary linking nothing but system libraries, and on
    # arm64 macOS its ad-hoc (linker-signed) signature is load-bearing: rewrite
    # the Mach-O and the kernel refuses to exec it.
    dontStrip = true;

    installPhase = ''
      runHook preInstall
      install -Dm755 bin/yaak $out/bin/yaak
      # Upstream installs the same binary under both names.
      ln -s yaak $out/bin/yaakcli
      runHook postInstall
    '';

    meta = {
      description = "Send requests and manage Yaak workspaces from the command line";
      homepage = "https://yaak.app/";
      license = lib.licenses.mit;
      platforms = lib.attrNames targets;
      sourceProvenance = [lib.sourceTypes.binaryNativeCode];
      mainProgram = "yaak";
    };
  }
