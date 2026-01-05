{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [ nixfmt-rfc-style ];

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
      userDirsOverride = true;
    };
  };

  home = {
    username = "mnemosyne";
    homeDirectory = "/home/mnemosyne";
    stateVersion = "25.05";
  };
}
