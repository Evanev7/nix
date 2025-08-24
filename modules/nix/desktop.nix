{
  pkgs,
  lib,
  config,
  ...
}:
{

  options.cady = {
    desktop = lib.mkOption {
      type = lib.types.enum [
        "Gnome"
        "Plasma"
        "Hyprland"
      ];
      default = "Gnome";
      description = "Cady style preconfigured DE (Only Gnome or Plasma for now)";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (config.cady.desktop == "Gnome") {
      # Enable the X11 windowing system and disable xterm.
      services.xserver = {
        enable = true;
        excludePackages = with pkgs; [ xterm ];
      };

      # Enable the GNOME Desktop Environment.
      services.displayManager.gdm.enable = true;
      services.desktopManager.gnome.enable = true;

      # Exclude GNOME default applications
      environment.gnome.excludePackages = with pkgs; [
        gnome-disk-utility
        gnome-backgrounds
        gnome-user-docs
        gnome-tour
        # gnome-text-editor
        gnome-calculator
        gnome-calendar
        gnome-contacts
        gnome-font-viewer
        gnome-maps
        gnome-music
        gnome-weather
        gnome-connections
        gnome-software
        orca
        simple-scan
        # snapshot
        # totem
        yelp
        epiphany
        geary
        evince
      ];

      # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
      systemd.services."getty@tty1".enable = false;
      systemd.services."autovt@tty1".enable = false;

      # Pop!_OS shell is really nice actually.
      environment.systemPackages =
        with pkgs;
        with pkgs.gnomeExtensions;
        [
          pop-shell
          blur-my-shell
          undecorate
          gsnap
          gparted
        ];
    })

    (lib.mkIf (config.cady.desktop == "Plasma") {

      # Enable KDE Plasma
      services.displayManager.sddm = { enable = true; wayland.enable = true; };
      services.desktopManager.plasma6.enable = true;

      # Plasma Packages
      environment.systemPackages =
        with pkgs;
        with kdePackages;
        [
          plasma-browser-integration
          kolourpaint
          sddm-kcm
        ];

      environment.plasma6.excludePackages = with pkgs.kdePackages; [
        elisa
        kate
      ];

    })
  ];
}
