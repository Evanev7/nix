{
  lib,
  pkgs,
  rootPath,
  ...
}:
let
  freecad-xwayland = pkgs.writeShellScriptBin "freecad" ''
    export QT_QPA_PLATFORM=xcb
    exec ${pkgs.freecad}/bin/freecad "$@"
  '';
in
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
    blender
    freecad-xwayland
    youtube-music
  ];

  cady = {
    firefox = {
      enable = true;
      userChromePath = rootPath + /config/firefox/userChrome.css;
    };
    console = {
      defaults = true;
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
      keymaps = [
      # remap hjkl to jkl;
      { key = "j"; action = "h"; mode = ["n" "v"]; }
      { key = "k"; action = "j"; mode = ["n" "v"]; }
      { key = "l"; action = "k"; mode = ["n" "v"]; }
      { key = ";"; action = "l"; mode = ["n" "v"]; }

      { key = "<C-w>j"; action = "<C-w>h"; mode = "n"; }
      { key = "<C-w>k"; action = "<C-w>j"; mode = "n"; }
      { key = "<C-w>l"; action = "<C-w>k"; mode = "n"; }
      { key = "<C-w>;"; action = "<C-w>l"; mode = "n"; }
                                
      { key = ","; action = ";"; mode = ["n" "v"]; }
      ];
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
