{
  profile,
  lib,
  config,
  inputs,
  ...
}:
{
  imports = [
    ./nvidia.nix
    ./ports.nix
    ./desktop.nix
    ./virt.nix
  ];

  options.cady = {
    defaults = lib.mkEnableOption "Cady Universal Defaults!!";
    autoUpdate = lib.mkEnableOption "Auto update my flake!";
  };

  config = lib.mkMerge [
    (lib.mkIf config.cady.autoUpdate {
      # Automatic updates?? Actually enabled?
      system.autoUpgrade = {
        enable = true;
        flake = inputs.self.outPath;
        flags = [
          "--update-input"
          "nixpkgs"
          "-L"
        ];
        dates = "16:00";
        randomizedDelaySec = "45min";
      };
    })
    (lib.mkIf config.cady.defaults {
      # A user profile is nice to have
      users.users.${profile.username} = {
        isNormalUser = true;
        description = "Woah!! epic user account!!";
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
      };

      # Host name
      networking.hostName = profile.hostname;

      # Enable automatic login for the user
      services.displayManager.autoLogin.enable = true;
      services.displayManager.autoLogin.user = profile.username;

      # Sudoers change for wheel
      security.sudo.wheelNeedsPassword = false;
      security.sudo.configFile = "${profile.username} ALL=(ALL) NOPASSWD:ALL";
      security.polkit.adminIdentities = [ ];

      # Allow unfree packages
      nixpkgs.config.allowUnfree = true;

      # Always should have a browser.
      programs.firefox.enable = true;

      # Enable networking
      networking.networkmanager.enable = true;

      # Set your time zone.
      time.timeZone = "Europe/London";

      # Select internationalisation properties.
      i18n.defaultLocale = "en_GB.UTF-8";

      i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_GB.UTF-8";
        LC_IDENTIFICATION = "en_GB.UTF-8";
        LC_MEASUREMENT = "en_GB.UTF-8";
        LC_MONETARY = "en_GB.UTF-8";
        LC_NAME = "en_GB.UTF-8";
        LC_NUMERIC = "en_GB.UTF-8";
        LC_PAPER = "en_GB.UTF-8";
        LC_TELEPHONE = "en_GB.UTF-8";
        LC_TIME = "en_GB.UTF-8";
      };

      # Configure keymap in X11
      services.xserver.xkb = {
        layout = "gb";
        variant = "";
      };

      # Configure console keymap
      console.keyMap = "uk";

      # Enable CUPS to print documents.
      services.printing.enable = true;

      # Enable sound with pipewire.
      services.pulseaudio.enable = false;
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        wireplumber.extraConfig."51-disable-suspension.conf" = {
          session.suspend-timeout-seconds = 0;
        };
      };

      # Enable touchpad support (enabled default in most desktopManager).
      services.libinput.enable = true;

      # Enable ZSA keyboard support
      hardware.keyboard.zsa.enable = true;

      # Enable flakes
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
    })
  ];
}
