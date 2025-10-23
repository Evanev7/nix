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
    nvidia.enable = true;
    # Firewall + port forwarding
    ports.enable = true;
    ports.both = [
      6567
      34197
      25565
      30000
    ];
    ssh.enable = true;
    #nextdns.enable = true;
    #tailscale.enable = true;
    # Desktop Environment
    desktop = "Plasma";
    autoUpdate = true;
  };

  environment.systemPackages = with pkgs; [
    wget
    git
    pijul
    bash
    home-manager
    lshw
    pciutils
    inxi
    gnumake
    bottom
    ripgrep
    lazygit
    bacon
    xdg-user-dirs
    just
    gparted
  ];

  services.fstrim.enable = true;

  services.foundryvtt = {
    enable = true;
    minifyStaticFiles = true;
    package = inputs.foundryvtt.packages.${pkgs.system}.foundryvtt_12.overrideAttrs {
      build = "331";
    };
  };
  # Enable steam and stuff
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  users.users.${profile.username} = {
    openssh.authorizedKeys.keyFiles = [
      (rootPath + /ssh/gtnh.key.pub)
      (rootPath + /ssh/muko.pub)
      (rootPath + /ssh/typhon.pub)
    ];
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Don't change it!!
  system.stateVersion = "24.05";
}
