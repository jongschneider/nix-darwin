{
  inputs,
  work,
}: {...}: {
  _module.args = {inherit inputs work;};

  imports = [
    # mine
    ./modules/dev.nix
    ./modules/git.nix
    ./modules/nix.nix
    # ./modules/sops.nix
    # ./modules/ssh.nix
    ./modules/zsh.nix
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    PATH = "$PATH:$GOPATH/bin";
  };

  # home.file.".background-img".source = ../img/lain.jpg;

  # home.stateVersion = "23.05";
  home.stateVersion = "23.11";
}
