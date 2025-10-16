{ lib, config, pkgs, flakeRoot, ... }:
{
  # My mixed modules
  cady = {

  };

  # Nix only settings
  nix = {
    imports = [ /etc/nixos/hardware-configuration.nix ];
  };

  # Home only settings
  home = {
    home = {
      username = "maia";
      homeDirectory = "/home/maia";
      stateVersion = "25.05";
      packages = with pkgs; [
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
    };

    programs.vscode = {
      enable = true;
      package = pkgs.vscodium.fhs;
    };
    xdg.configFile."VSCodium/User/settings.json".source = lib.mkForce (
      flakeRoot + /config/codium/settings.json
    );

    cady = {
      firefox = {
        enable = true;
        userChromePath = flakeRoot + /config/firefox/userChrome.css;
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
  };
};
