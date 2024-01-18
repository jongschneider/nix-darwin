{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "jschneider";
  home.homeDirectory = "/Users/jschneider";

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # Basics
    htop
    coreutils
    curl
    wget
    tree
    procs
    ripgrep
    ffmpeg

    # Dev
    gh
    fh
    lf
    jq
    jqp
    go
    golangci-lint
    gotestsum
    nodejs_21
    git-open
  ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.bat.enable = true;
  programs.bat.config.theme = "TwoDark";
  programs.direnv.enable = true;
  programs.direnv.enableZshIntegration = true;
  programs.direnv.nix-direnv.enable = true;
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
  # programs.fzf.enable = true;
  # programs.fzf.enableZshIntegration = true;
  programs.eza.enable = true;
  programs.eza.enableAliases = true;
  programs.git.enable = true;
  programs.git.aliases = {
    a = "add";
    c = "commit";
    ca = "commit --amend";
    can = "commit --amend --no-edit";
    cl = "clone";
    cm = "commit -m";
    co = "checkout";
    cp = "cherry-pick";
    cpx = "cherry-pick -x";
    d = "diff";
    f = "fetch";
    fo = "fetch origin";
    fu = "fetch upstream";
    lol = "log --graph --decorate --pretty=oneline --abbrev-commit";
    lola = "log --graph --decorate --pretty=oneline --abbrev-commit --all";
    pl = "pull";
    pr = "pull -r";
    ps = "push";
    psf = "push -f";
    rb = "rebase";
    rbi = "rebase -i";
    r = "remote";
    ra = "remote add";
    rr = "remote rm";
    rv = "remote -v";
    rs = "remote show";
    st = "status";
  };
  programs.git.extraConfig = {
    core = {
      excludesfile = "/Users/jschneider/.gitignore";
    };
    url = {
      "git@bitbucket.org:" = {
        insteadOf = "https://bitbucket.org/";
      };
    };
    pull = {
      rebase = true;
    };
  };
  programs.git.userName = "Jonathan Schneider";
  programs.git.userEmail = "jonathan.schneider@thetalake.com";
  programs.git.difftastic.enable = true;
  programs.git.difftastic.display = "side-by-side-show-both";
  programs.git.difftastic.color = "always";
  programs.z-lua.enable = true;
  programs.zsh.enable = true;
  programs.zsh.initExtra = ''
    PATH=$HOME/bin:$HOME/go/bin:$HOME/tools:$HOME/scripts:$PATH
  '';
  programs.zsh.initExtraBeforeCompInit = ''
    PATH=$HOME/bin:$HOME/go/bin:$HOME/tools:$HOME/scripts:$PATH
  '';
  programs.zsh.enableCompletion = true;
  programs.zsh.autocd = true;
  programs.zsh.enableAutosuggestions = true;
  programs.zsh.syntaxHighlighting.enable = true;
  programs.zsh.shellAliases = {
    # ls = "ls --color=auto -F";
    nixswitch = "darwin-rebuild switch --flake ~/.config/nix-darwin/";
    nixup = "pushd ~/.config/nix-darwin; nix flake update; nixswitch; popd";

    # Work
    localdev = "/Users/jschneider/code/localdev/localdev";
    runingester = "export INGESTER_ENV=.env && goi && ingester > tmp.txt";
    runintegrator = "export INTEGRATOR_ENV=.env && goi && integrator  > tmp.txt";
    runemailpreprocessor = "ENV_FILE=preprocessor.env.localdev go run ./cmd/email_preprocessor/...";
    telcon = "tsh login --proxy=thetalake.teleport.sh --auth=google";
    colcon = "echo 'creating an ssh tunnel to dev collector via teleport...\ntsh ssh -N -L 27777:localhost.thetalake.com:13579 ubuntu@ingester1.dev1.thetalake.com' && tsh ssh -N -L 27777:localhost.thetalake.com:13579 ubuntu@ingester1.dev1.thetalake.com";
    goi = "go install ./... && go vet ./...";
    c = "code .";

    nixconf = "code /Users/jschneider/.config/nix-darwin";

    # More git aliases
    g = "git";
    ga = "git add";
    gs = "git status";
    gd = "git diff";
    gdt = "git difftool";
    gdlist = "git diff --name-status";
    gcm = "git commit -m";
    gco = "git checkout";
    gcob = "git checkout -b";
    gcom = "git checkout master && git pull";
    gignore = "c .git/info/exclude";
    glog = "git log --simplify-by-decoration --oneline --graph";
    glast = "git branch --sort=-committerdate | fzf --header 'Checkout Recent Branch' --preview 'git diff {1} --color=always' --preview-window down --bind 'ctrl-/:change-preview-window(down|hidden|),shift-up:preview-page-up,shift-down:preview-page-down' | xargs git checkout";
  };
  programs.starship.enable = true;
  programs.starship.enableZshIntegration = true;

  programs.alacritty = {
    enable = true;
    settings.font.normal.family = "MesloLGS Nerd Font Mono";
    # settings.font.normal.family = "Monaspace Krypton Light";
    settings.font.size = 13;
    settings.cursor.style = {
      shape = "Beam";
      blinking = "On";
    };
  };

  # home.file.".zshrc".file = ./.zshrc
}
