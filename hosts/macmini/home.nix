{pkgs, ...}: {
  imports = [
    ../../home
  ];

  home.packages = with pkgs; [
    unrar # extract RAR archives
    wget
  ];
}
