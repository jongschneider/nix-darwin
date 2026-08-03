# open-computer-use: stdio MCP server + CLI driving macOS via Accessibility
# https://github.com/iFurySt/open-codex-computer-use
#
# Published to npm rather than nixpkgs. The tarball vendors prebuilt native
# runtimes for every platform it supports and declares no dependencies, so
# there is nothing to resolve at build time — this just unpacks it and points
# the launchers at a nix nodejs.
{pkgs}:
pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "open-computer-use";
  version = "0.3.1";

  src = pkgs.fetchurl {
    url = "https://registry.npmjs.org/open-computer-use/-/open-computer-use-${finalAttrs.version}.tgz";
    hash = "sha256-dXS3o1tkK8vimaY5zgFCjBlVX7Ke9zB5bbT4fysykbU=";
  };

  nativeBuildInputs = [pkgs.makeWrapper];

  # The vendored .app is signed with a Developer ID and a hardened runtime, and
  # macOS keys the Accessibility / Screen Recording grants to that signature.
  # Anything that rewrites the Mach-O — stripping included — invalidates it and
  # the grants stop applying.
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    install -d $out/lib/open-computer-use
    cp -R bin dist scripts plugins package.json LICENSE README.md \
      $out/lib/open-computer-use/

    # `#!/usr/bin/env bash` only resolves if bash is on PATH; these helpers are
    # spawned directly by the launcher, which passes no PATH of its own.
    patchShebangs $out/lib/open-computer-use/scripts

    # All four launchers are the same script under different names. Each
    # resolves its native runtime from `path.resolve(__dirname, "..")`, so they
    # have to stay inside the package tree — hence a wrapper rather than a
    # symlink into $out/bin.
    for cmd in open-computer-use ocu open-computer-use-mcp open-codex-computer-use-mcp; do
      makeWrapper ${pkgs.nodejs}/bin/node $out/bin/$cmd \
        --add-flags $out/lib/open-computer-use/bin/$cmd
    done

    runHook postInstall
  '';

  meta = {
    description = "Open-source computer use for macOS, exposed as an MCP server";
    homepage = "https://github.com/iFurySt/open-codex-computer-use";
    license = pkgs.lib.licenses.mit;
    platforms = pkgs.lib.platforms.darwin;
    mainProgram = "open-computer-use";
  };
})
