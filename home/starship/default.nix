{...}: {
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      format = "$os$username$directory$git_branch$git_status$c$rust$golang$nodejs$php$java$kotlin$haskell$python$line_break$character ";
      os = {
        disabled = false;
        style = "fg:text";
      };

      os.symbols = {
        NixOS = "";
        Raspbian = "󰐿";
        Mint = "󰣭";
        Fedora = "󰣛";
        Macos = "󰀵";
        Windows = "󰍲";
        Ubuntu = "󰕈";
        SUSE = "";
        Manjaro = "";
        Linux = "󰌽";
        Gentoo = "󰣨";
        Alpine = "";
        Amazon = "";
        Android = "";
        Arch = "󰣇";
        Artix = "󰣇";
        CentOS = "";
        Debian = "󰣚";
        Redhat = "󱄛";
        RedHatEnterprise = "󱄛";
      };

      username = {
        show_always = true;
        style_user = "fg:text";
        style_root = "fg:text";
        format = "[ $user ]($style)";
      };

      directory = {
        truncation_length = 100;
        truncate_to_repo = false;
        style = "fg:peach";
        format = "[](fg:text)[ $path ]($style)";
        truncation_symbol = "…/";
      };

      directory.substitutions = {
        "Documents" = "󰈙 ";
        "Downloads" = " ";
        "Music" = "󰝚 ";
        "Pictures" = " ";
        "Developer" = "󰲋 ";
      };

      git_branch = {
        symbol = "";
        style = "fg:green";
        format = "[](fg:text)[ $symbol $branch ]($style)";
      };

      git_status = {
        style = "fg:green";
        format = "[($all_status$ahead_behind )]($style)";
      };

      time = {
        disabled = false;
        time_format = "%R";
        style = "bg:peach";
        format = "[[  $time ](fg:mantle bg:purple)]($style)";
      };

      nodejs = {
        symbol = "";
        style = "fg:teal";
        format = "[](fg:text)[ $symbol( $version) ]($style)";
      };

      rust = {
        style = "red bold";
        format = "[](fg:text) [$symbol( $version)]($style)";
      };

      golang = {
        symbol = "󰟓";
        style = "fg:teal";
        format = "[](fg:text)[ $symbol( $version) ]($style)";
      };

      python = {
        symbol = "";
        style = "fg:teal";
        format = "[](fg:text)[ $symbol( $version) ]($style)";
      };

      docker_context = {
        symbol = "";
        style = "bg:mantle";
        format = "[[ $symbol( $context) ](fg:base bg:blue)]($style)";
      };
      character = {
        success_symbol = "[](maroon)";
        error_symbol = "[](red)";
        vimcmd_symbol = "[](green)";
      };
      line_break = {
        disabled = false;
      };
      add_newline = false;
    };
  };
}
