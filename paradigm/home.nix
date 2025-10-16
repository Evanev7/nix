{
  lib,
  pkgs,
  rootPath,
  ...
}:
{
  home.packages = with pkgs; [
    nixfmt-rfc-style
    (discord.override {
      withOpenASAR = true;
      withVencord = true;
    })
    thunderbird
    gimp
    obsidian
    godot
    keymapp
    parsec-bin
    vlc
    bat
    youtube-music
    snapshot
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
  xdg.configFile."VSCodium/User/settings.json".source = lib.mkForce (
    rootPath + /config/codium/settings.json
  );

  home = {
    username = "maia";
    homeDirectory = "/home/maia";
    stateVersion = "25.05";
  };
}
