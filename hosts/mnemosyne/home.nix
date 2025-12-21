{
  lib,
  pkgs,
  rootPath,
  ...
}:
{
  home.packages = with pkgs; [ nixfmt-rfc-style ];

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
    username = "mnemosyne";
    homeDirectory = "/home/mnemosyne";
    stateVersion = "25.05";
  };
}
