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

  # Auto-rewrite personal GitHub URLs to use personal SSH key
  programs.git.includes = [
    {
      condition = "hasconfig:remote.*.url:git@github.com:jongschneider/**";
      contents = {
        url."git@github.com-personal:jongschneider/".insteadOf = "git@github.com:jongschneider/";
      };
    }
  ];

  home.packages = with pkgs; [
    # azure-cli # disabled due to azure-multiapi-storage build failure
    gh
    inetutils
    # mosh # wrapper for `ssh` that better and not dropping connections
    procs
    srt
    teleport
    unrar # extract RAR archives
    wget
    xz # extract XZ archives
    zlib

    # Dev
    inputs.ai-toolbox.packages.${pkgs.stdenv.hostPlatform.system}.appender
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.amp
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.claude-code
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.cursor-agent
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.opencode
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.pi
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.tuicr
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.handy
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.agent-browser
    cpulimit
    fh
    git-open
    glow
    gum
    jqp
    lazydocker
    mkcert
    # neofetch # disabled due to ueberzug dependency not building on macOS
    oapi-codegen
    # nodejs-slim
    # nodePackages_latest.jsonlint
    presenterm
    protobuf
    redis
    repomix
    rubocop
    ruby
    # rubyPackages.rubocop-performance
    # rubyPackages.solargraph
    # uv
    pipx
    yt-dlp

    # not sure I need... were migrated from brew
    pango
    rav1e
    snappy
    speex
    svt-av1
    utf8proc
    x264
    x265
  ];
}
