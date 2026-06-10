{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  home.packages = with pkgs; [
    nixfmt
    discord
    thunderbird
    gimp
    obsidian
    godot
    keymapp
    parsec-bin
    vlc
    bat
    snapshot
    qbittorrent
    zed-editor
    (inputs.nix-jetbrains-plugins.lib.buildIdeWithPlugins pkgs jetbrains.idea-oss ["IdeaVIM" "al.aoli.intellijdirenv"])
    file
    aseprite
  ];

  cady = {
    firefox.enable = true;
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

  programs.vscodium.enable = true;
  xdg.configFile."VSCodium/User/settings.json".source = lib.mkForce (
    inputs.self + /config/codium/settings.json
  );

  home = {
    username = "maia";
    homeDirectory = "/home/maia";
    stateVersion = "25.05";
  };
}
