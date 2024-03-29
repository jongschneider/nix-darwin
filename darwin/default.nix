{
  pkgs,
  config,
  ...
}: {
  environment = {
    shells = with pkgs; [bash zsh];
    loginShell = pkgs.zsh;
    systemPackages = with pkgs; [
      # nixpkgs-fmt # nix code formatter
      nil # nix LSP... testing this out.
      alejandra
      coreutils
      gnumake
      (import ../scripts/ff.nix {inherit pkgs;})
      (import ../scripts/gsquash.nix {inherit pkgs;})
      discord
      presenterm
      nurl
      manix
      delve
      go
      gofumpt
      gomodifytags
      impl
      golangci-lint
      gotools
      gotests
      gotestsum
      golines
      # ruby
      # ruby_3_3
      # rubyPackages.solargraph
      # rubyPackages.rubocop-performance
      # rubocop
    ];
    systemPath = ["/opt/homebrew/bin" "/Users/jschneider/go/bin"];
    pathsToLink = ["/Applications"];
  };

  # fonts.fontDir.enable = true; # DANGER
  # fonts.fonts = [
  #   (pkgs.nerdfonts.override {fonts = ["Hack" "Monaspace" "Meslo"];})
  # ];

  homebrew = import ./homebrew.nix // {enable = true;};

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # services.karabiner-elements.enable = true;

  # Necessary for using flakes on this system.
  nix = {
    settings = {
      auto-optimise-store = true;
      builders-use-substitutes = true;
      experimental-features = ["flakes" "nix-command"];
      substituters = ["https://nix-community.cachix.org"];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      trusted-users = [
        "@wheel"
        "@admin" # This line is a prerequisite for linux-builder
      ];
      warn-dirty = false;
    };
    extraOptions = ''
      extra-platforms = x86_64-darwin aarch64-darwin
    '';

    #  https://nixcademy.com/2024/02/12/macos-linux-builder/
    linux-builder.enable = true;
  };

  nix.nixPath = [
    # Support legacy workflows that use `<nixpkgs>` etc.
    "nixpkgs=${pkgs.path}"
  ];

  nixpkgs.config.allowUnfree = true;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  programs.bash.enable = true;
  programs.nix-index.enable = true;

  # programs.nixvim = {
  #   enable = true;
  #   enableMan = true;

  #   keymaps = [
  #     {
  #       mode = "n";
  #       key = "<leader>lg";
  #       action = ":FloatermNew --autoclose=2 --height=0.9 --width=0.9 lazygit<CR>";
  #       # options.desc = "[U]ndo tree";
  #     }
  #     # map('n', '<leader>ld', '<CMD>FloatermNew --autoclose=2 --height=0.9 --width=0.9 lazydocker<CR>', options)
  #     {
  #       mode = "n";
  #       key = "<leader>ld";
  #       action = ":FloatermNew --autoclose=2 --height=0.9 --width=0.9 lazydocker<CR>";
  #       # options.desc = "[U]ndo tree";
  #     }
  #     {
  #       mode = "n";
  #       key = "<leader>ll";
  #       action = ":FloatermNew --autoclose=2 --height=0.75 --width=0.75 nnn -Hde<CR>";
  #     }
  #     {
  #       key = "<leader>fm";
  #       action = ":Autoformat<CR>";
  #       options = {
  #         silent = true;
  #       };
  #     }
  #     {
  #       key = ".";
  #       action = ":";
  #     }
  #     {
  #       key = "<leader>bb";
  #       action = "<CMD>Telescope file_browser<NL>";
  #     }
  #     {
  #       key = "<leader>t";
  #       action = "<CMD>Neotree<NL>";
  #     }
  #     {
  #       key = "<Tab>";
  #       action = "<CMD>:bnext<NL>";
  #     }
  #     {
  #       key = "<leader>x";
  #       action = "<CMD>:bp | bd #<NL>";
  #     }
  #     {
  #       mode = "n";
  #       key = "<leader>u";
  #       action = "<cmd>UndotreeToggle<CR>";
  #       options = {
  #         silent = true;
  #         desc = "Undotree";
  #       };
  #     }
  #     # {
  #     #   key = "<leader>u";
  #     #   action = "vim.cmd.UndotreeToggle";
  #     #   lua = true;
  #     #   mode = "n";
  #     #   options.silent = true;
  #     # }
  #   ];

  #   colorschemes.nord = {
  #     enable = true;
  #     settings.contrast = true;
  #     settings.italic = false;
  #   };

  #   plugins.neo-tree = {
  #     enable = true;
  #     autoCleanAfterSessionRestore = true;
  #     closeIfLastWindow = true;

  #     window = {
  #       position = "float";
  #     };

  #     filesystem = {
  #       followCurrentFile.enabled = true;
  #       filteredItems = {
  #         hideHidden = false;
  #         hideDotfiles = false;
  #         forceVisibleInEmptyFolder = true;
  #         hideGitignored = false;
  #       };
  #     };

  #     window.mappings = {
  #       "<bs>" = "navigate_up";
  #       "." = "set_root";
  #       "f" = "fuzzy_finder";
  #       "/" = "filter_on_submit";
  #       "h" = "show_help";
  #     };

  #     eventHandlers = {
  #       neo_tree_buffer_enter = ''
  #         function()
  #           vim.cmd 'highlight! Cursor blend=100'
  #         end
  #       '';
  #       neo_tree_buffer_leave = ''
  #         function()
  #           vim.cmd 'highlight! Cursor guibg=#5f87af blend=0'
  #         end
  #       '';
  #     };
  #   };

  #   plugins.undotree = {
  #     enable = true;
  #     settings = {
  #       autoOpenDiff = true;
  #       focusOnToggle = true;
  #       # CursorLine = true;
  #       # DiffAutoOpen = true;
  #       # DiffCommand = "diff";
  #       # DiffpanelHeight = 10;
  #       # HelpLine = true;
  #       # HighlightChangedText = true;
  #       # HighlightChangedWithSign = true;
  #       # HighlightSyntaxAdd = "DiffAdd";
  #       # HighlightSyntaxChange = "DiffChange";
  #       # HighlightSyntaxDel = "DiffDelete";
  #       # RelativeTimestamp = true;
  #       # SetFocusWhenToggle = true;
  #       # ShortIndicators = false;
  #       # SplitWidth = 40;
  #       # TreeNodeShape = "*";
  #       # TreeReturnShape = "\\";
  #       # TreeSplitShape = "/";
  #       # TreeVertShape = "|";
  #       # WindowLayout = 4;
  #     };
  #   };

  #   # colorschemes.catppuccin = {
  #   #   enable = true;
  #   # };

  #   # Use system clipboard
  #   clipboard.register = "unnamedplus";
  #   globals.mapleader = " ";
  #   # Plugins
  #   # plugins.airline = {
  #   #   enable = true;
  #   #   theme = "deus";
  #   # };

  #   # LSP
  #   plugins.lsp = {
  #     enable = true;
  #     servers = {
  #       bashls = {
  #         enable = true;
  #       };
  #       clangd = {
  #         enable = true;
  #       };

  #       eslint = {
  #         enable = true;
  #       };

  #       gopls = {
  #         enable = true;
  #       };

  #       html = {
  #         enable = true;
  #       };
  #       pyright = {
  #         enable = true;
  #       };
  #       rnix-lsp = {
  #         enable = true;
  #       };

  #       rust-analyzer = {
  #         enable = true;
  #         installCargo = true;
  #         installRustc = true;
  #       };

  #       terraformls = {
  #         enable = true;
  #       };
  #     };

  #     keymaps.lspBuf = {
  #       K = "hover";
  #       gr = "references";
  #       gD = "declaration";
  #       gd = "definition";
  #       gi = "implementation";
  #       gt = "type_definition";
  #       gs = "signature_help";
  #       rn = "rename";
  #       ca = "code_action";
  #     };
  #   };

  #   plugins.luasnip.enable = true;
  #   plugins.lsp-format.enable = true;
  #   plugins.lsp-lines.enable = true;
  #   plugins.treesitter.enable = true;
  #   plugins.treesitter.nixGrammars = true;
  #   plugins.treesitter-context.enable = true;
  #   plugins.cmp-treesitter.enable = true;
  #   plugins.treesitter-refactor = {
  #     enable = true;
  #     highlightCurrentScope.enable = true;
  #     highlightCurrentScope.disable = [
  #       "nix"
  #     ];
  #     highlightDefinitions.enable = true;
  #     navigation.enable = true;
  #     smartRename.enable = true;
  #   };
  #   plugins.nvim-colorizer.enable = true;
  #   plugins.rainbow-delimiters.enable = true;
  #   plugins.which-key = {
  #     enable = true;
  #   };
  #   plugins.comment-nvim.enable = true;
  #   plugins.trouble.enable = true;
  #   plugins.multicursors.enable = true;

  #   # plugins.cmp.enable = true;

  #   plugins.cmp = {
  #     enable = true;
  #     settings.sources = [
  #       {name = "nvim_lsp";}
  #       {name = "path";}
  #       {name = "buffer";}
  #       {name = "luasnip";}
  #     ];

  #     settings.mapping = {
  #       "<CR>" = "cmp.mapping.confirm({ select = true })";
  #       "<C-Space>" = "cmp.mapping.complete()";
  #       "<C-d>" = "cmp.mapping.scroll_docs(-4)";
  #       "<C-e>" = "cmp.mapping.close()";
  #       "<C-f>" = "cmp.mapping.scroll_docs(4)";
  #       "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
  #       "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
  #     };
  #     settings.snippet.expand = ''
  #       function(args)
  #       require('luasnip').lsp_expand(args.body)
  #       end
  #     '';
  #   };

  #   plugins.bufferline = {
  #     enable = true;
  #   };

  #   plugins.telescope = {
  #     enable = true;

  #     enabledExtensions = ["ui-select"];
  #     extensionConfig.ui-select = {};
  #     extensions.frecency.enable = true;
  #     extensions.fzf-native.enable = true;

  #     extensions.file_browser = {
  #       enable = true;
  #       hidden = true;
  #       depth = 9999999999;
  #       autoDepth = true;
  #     };
  #     keymaps = {
  #       "<leader>ff" = "find_files";
  #       "<leader>fs" = "grep_string";
  #       "<leader>fg" = "live_grep";
  #     };
  #   };

  #   plugins.gitsigns.enable = true;
  #   plugins.lualine.enable = true;

  #   plugins.floaterm = {
  #     enable = true;
  #     keymaps.toggle = "<leader>j";
  #     width = 0.9;
  #     height = 0.9;
  #   };

  #   options = {
  #     number = true;
  #     relativenumber = true;
  #     fileencoding = "utf-8";
  #     hlsearch = true;
  #     ignorecase = true;
  #     mouse = "a";
  #     showtabline = 4;
  #     smartcase = true;
  #     smartindent = true;
  #     undofile = true;
  #     expandtab = true;
  #     shiftwidth = 4;
  #     tabstop = 4;
  #   };

  #   extraPlugins = with pkgs.vimPlugins; [
  #     telescope-ui-select-nvim
  #     vim-autoformat
  #     vim-jsbeautify
  #     vim-go
  #     fzf-vim
  #     ultisnips
  #   ];
  # };

  # MacOS Configuration
  system = {
    defaults = {
      finder.AppleShowAllExtensions = true;
      finder._FXShowPosixPathInTitle = true;
      finder.ShowPathbar = true;
      NSGlobalDomain.InitialKeyRepeat = 14;
      NSGlobalDomain.KeyRepeat = 1;
      dock.autohide = true;
    };

    # Used for backwards compatibility, please read the changelog before changing.
    stateVersion = 4;

    keyboard.enableKeyMapping = true;
    keyboard.remapCapsLockToEscape = true;
  };

  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;

  nixpkgs.hostPlatform = "aarch64-darwin";
}
