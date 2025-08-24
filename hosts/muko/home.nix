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
          withOpenASAR = true;
          withVencord = true;
        }
      }/bin/discord --use-gl=desktop";
      desktopName = "Discord";
      icon = "${pkgs.tela-circle-icon-theme}/share/icons/Tela-circle/scalable/apps/discord.svg";
    })
    gimp
    obsidian
    godot
    keymapp
    parsec-bin
    vlc
    tree
    bat
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
