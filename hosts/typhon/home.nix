{
  lib,
  pkgs,
  rootPath,
  ...
}:
{
  home.packages = with pkgs; [
    nixfmt-rfc-style
    (pkgs.makeDesktopItem {
      name = "discord";
      exec = "env -u NIXOS_OZONE_WL ${
        pkgs.discord.override {
          withVencord = true;
          withOpenASAR = true;
        }
      }/bin/discord --use-gl=desktop";
      desktopName = "Discord";
      icon = "${pkgs.tela-circle-icon-theme}/share/icons/Tela-circle/scalable/apps/discord.svg";
    })
    google-chrome
    gimp
    obsidian
    godot_4
    tiled
    keymapp
    thunderbird
    vlc
    rawtherapee
    parsec-bin
    libreoffice
    wineWowPackages.waylandFull
    prismlauncher
  ];

  cady = {
    firefox = {
      enable = true;
      userChromePath = rootPath + /config/firefox/userChrome.css;
    };
    console = {
      defaults = true;
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
      lsp = {
        enable = true;
      };
      spellcheck.enable = true;
      visuals = {
        nvim-scrollbar.enable = true;
        nvim-web-devicons.enable = true;
        nvim-cursorline.enable = true;
        highlight-undo.enable = true;
      };
      statusline.lualine.enable = true;
      telescope.enable = true;
      languages = {
        enableTreesitter = true;
        enableFormat = true;
        enableExtraDiagnostics = true;

        rust = {
          enable = true;
          crates.enable = true;
        };
        nix.enable = true;
        clang.enable = true;
        python.enable = true;
        zig.enable = true;
        markdown.enable = true;
        lua.enable = true;
        bash.enable = true;
        css.enable = true;
      };
    };
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium.fhs;
  };

  home = {
    username = "typhon";
    homeDirectory = "/home/typhon";
    stateVersion = "24.05";
  };
}
