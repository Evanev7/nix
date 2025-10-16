{
  pkgs,
  profile,
  rootPath,
  inputs,
  ...
}:
{
  cady = {
    defaults = true;
    # My modules!!
    ssh.enable = true;
    tailscale.enable = true;
    #nextdns.enable = true;
    # Desktop Environment
    desktop = "Plasma";
    autoUpdate = true;
  };

  environment.systemPackages = with pkgs; [
    wget
    git
    bash
    home-manager
    bottom
    ripgrep
    lazygit
    bacon
    xdg-user-dirs
    just
    unzip

    vimix-cursors
  ];
  # microphone fix
  services.pipewire.wireplumber.extraConfig.no-ucm = {
    "monitor.alsa.properties" = {
      "alsa.use-ucm" = false;
    };
  };
  # Hibernation fix
  boot.kernelPackages = pkgs.linuxPackages_latest;

  programs.nix-ld.enable = true;

  # Enable steam and stuff
  programs.steam = {
    enable = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "25.05"; # Don't change it!!!
}
