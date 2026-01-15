{ lib, ... }: {
  programs.git = {
    enable = true;

    # New unified settings attribute replaces userName/userEmail/aliases/extraConfig.
    settings = {
      user = {
        name = lib.mkDefault "jongschneider";
        email = lib.mkDefault "jongschneider@gmail.com";
      };

      alias = {
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

      url."git@bitbucket.org:".insteadOf = "https://bitbucket.org/";
      url."ssh://git@bitbucket.org/".insteadOf = "https://bitbucket.org/";
      color.ui = true;
      diff.colorMoved = "zebra";
      fetch.prune = true;
      init.defaultBranch = "main";
      merge.conflictstyle = "zdiff3";
      push.autoSetupRemote = true;
      rebase.autoStash = true;
    };

    ignores = [
      ".direnv"
      ".envrc"
      "tmp.txt"
      "tmp*.json"
      "*.log"
      "testout.txt"
      "permitted_addresses.txt"
      "postscreen_access.txt"
      ".DS_Store"
      ".vscode"
      "*/vcr_responses.localdev.*.yaml"
      "result"
      "permitted_addresses.txt"
      "postscreen_access.txt"
      "cover.cov"
      ".cursor"
      "codecompanion-workspace.json"
      ".aider*"
      "bt_private_key"
      ".opencode"
    ];
  };

  programs.delta = {
    enable = true; # renamed from programs.git.delta.enable
    enableGitIntegration = true; # must now be explicit
    options = { side-by-side = true; }; # renamed from programs.git.delta.options
  };
}
