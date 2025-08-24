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
      useNvf = true;
    };
    home = {
      defaults = true;
      userDirsOverride = true;
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
