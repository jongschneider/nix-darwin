{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../../home
  ];

  home.packages = with pkgs; [
    gh
    inetutils
    unrar # extract RAR archives
    wget
    xz # extract XZ archives
    zlib

    # Dev
    inputs.ai-toolbox.packages.${pkgs.stdenv.hostPlatform.system}.appender
    git-open
    glow
    gum
    jqp
    lazydocker
    mkcert
    neofetch
    # nodejs-slim
    # nodePackages_latest.jsonlint
    redis
    repomix
    yt-dlp
  ];
}
