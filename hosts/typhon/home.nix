{
  lib,
  pkgs,
  rootPath,
  ...
}:
{
  home.packages = with pkgs; [
    nixfmt-rfc-style
    pkgs.discord
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
    prismlauncher
    blender
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

  services.easyeffects.enable = true;

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
