{ pkgs, ... }:
{
  home.packages = with pkgs; [ nixfmt ];

  cady = {
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
    };
  };

  home = {
    username = "mnemosyne";
    homeDirectory = "/home/mnemosyne";
    stateVersion = "25.11";
  };
}
