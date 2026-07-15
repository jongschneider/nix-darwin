{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../../home
  ];

  programs.git.settings.user = {
    name = "jonathan-schneider-tl";
    email = "jonathan.schneider@thetalake.com";
  };

  # Auto-rewrite personal GitHub URLs to use personal SSH key and identity
  programs.git.includes = [
    {
      # Matches repos cloned with the canonical github.com URL
      condition = "hasconfig:remote.*.url:git@github.com:jongschneider/**";
      contents = {
        user.name = "jongschneider";
        user.email = "jongschneider@gmail.com";
        url."git@github.com-personal:jongschneider/".insteadOf = "git@github.com:jongschneider/";
      };
    }
    {
      # Matches repos cloned directly with the github.com-personal SSH alias
      condition = "hasconfig:remote.*.url:git@github.com-personal:jongschneider/**";
      contents = {
        user.name = "jongschneider";
        user.email = "jongschneider@gmail.com";
      };
    }
  ];

  home.packages = with pkgs; [
    # azure-cli # disabled due to azure-multiapi-storage build failure
    asciinema
    asciinema-agg
    inetutils
    # mosh # wrapper for `ssh` that better and not dropping connections
    teleport
    xz # extract XZ archives
    zlib

    # Dev
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.claude-code
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.pi
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.handy
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.sandbox-runtime
    llama-cpp
    fh
    glow
    herdr
    gum
    # nodejs-slim
    # nodePackages_latest.jsonlint
    repomix
    terraform
    # uv
    # yt-dlp # disabled: jeepney checkPhase fails on macOS (nixpkgs-unstable)
  ];
}
