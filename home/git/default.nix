{...}: {
  programs.git = {
    enable = true;
    userName = "jonathan-schneider-tl";
    userEmail = "jonathan.schneider@thetalake.com";

    delta = {
      enable = true;
      options = {
        side-by-side = true;
      };
    };

    aliases = {
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
    ];

    extraConfig = {
      url."git@bitbucket.org:".insteadOf = "https://bitbucket.org/";
      color.ui = true;
      diff.colorMoved = "zebra";
      fetch.prune = true;
      init.defaultBranch = "main";
      merge.conflictstyle = "zdiff3";
      push.autoSetupRemote = true;
      rebase.autoStash = true;
    };
  };
}
