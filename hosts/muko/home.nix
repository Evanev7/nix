{
  lib,
  pkgs,
  rootPath,
  unstablePkgs,
  ...
}:
{
  home.packages = with pkgs; [
    nixfmt-rfc-style
    (pkgs.makeDesktopItem {
      name = "discord";
      exec = "env -u NIXOS_OZONE_WL ${
        pkgs.discord.override {
          withOpenASAR = true;
          withVencord = true;
        }
      }/bin/discord --use-gl=desktop";
      desktopName = "Discord";
      icon = "${pkgs.tela-circle-icon-theme}/share/icons/Tela-circle/scalable/apps/discord.svg";
    })
    gimp
    obsidian
    unstablePkgs.godot
    keymapp
    pijul
    nix-plugin-pijul
    parsec-bin
    vlc
  ];

  cady = {
    firefox = {
      enable = true;
      userChromePath = rootPath + /config/firefox/userChrome.css;
    };
    console = {
      defaults = true;
      # TODO: make a decision
      shellAliases = {
        "n" = "nvim";
      };
      starship = {
        enable = true;
        direnv = true;
      };
    };
    home = {
      defaults = true;
      userDirsOverride = true;
    };
  };

  imports = [
  ];

  # Check here https://github.com/NotAShelf/nvf/blob/main/configuration.nix
  programs.nvf = {
    enable = true;
    settings.vim = {
      #      keymaps = [
      # Check https://github.com/NotAShelf/nvf/blob/main/modules/neovim/mappings/config.nix
      # for how this converts into LUA and what options are available.
      #  {
      #key = "<leader>m";
      #mode = "n";
      #silent = true;
      #action = ":make<CR>";
      #  }
      #];
      viAlias = true;
      vimAlias = true;
      lsp = {
        enable = true;
        formatOnSave = true;
        lspkind.enable = true;
        lightbulb.enable = true;
      };
      spellcheck.enable = true;
      theme = {
        enable = true;
        name = "rose-pine";
        style = "moon";
        transparent = true;
      };
      visuals = {
        nvim-scrollbar.enable = true;
        nvim-web-devicons.enable = true;
        nvim-cursorline.enable = true;
        fidget-nvim.enable = true;
        highlight-undo.enable = true;
        cellular-automaton.enable = true;
      };
      autocomplete.nvim-cmp = {
        enable = true;
        sourcePlugins = [
          "rustaceanvim"
          "obsidian-nvim"
          "nvim-web-devicons"
        ];
      };
      autopairs.nvim-autopairs.enable = true;

      statusline.lualine.enable = true;
      telescope.enable = true;
      languages = {
        enableLSP = true;
        enableTreesitter = true;
        enableFormat = true;
        enableExtraDiagnostics = true;

        rust = {
          enable = true;
          crates.enable = true;
        };
        nix.enable = true;
        sql.enable = true;
        clang.enable = true;
        ts.enable = true;
        python.enable = true;
        #zig.enable = true;
        markdown.enable = true;
        #dart.enable = true;
        lua.enable = true;
        bash.enable = true;
        css.enable = true;
        kotlin.enable = true;
        haskell.enable = true;
      };
    };
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium.fhs;
    extensions = with pkgs.vscode-extensions; [
    ];
    #    userSettings = import ./config/codium/settings.nix;
  };
  xdg.configFile."VSCodium/User/settings.json".source = lib.mkForce (
    rootPath + /config/codium/settings.json
  );

  home = {
    username = "muko";
    homeDirectory = "/home/muko";
    stateVersion = "24.05";
  };
}
