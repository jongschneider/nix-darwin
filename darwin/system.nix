# darwin/system.nix
{pkgs, ...}: {
  # Base system configuration
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  programs.zsh.enable = true;
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = 4;

  # Basic system packages all machines should have
  environment.systemPackages = with pkgs; [
    curl
    git
    vim
  ];
}
