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
    nextdns.enable = true;
    tailscale.enable = true;
    # Desktop Environment
    desktop = "Gnome";
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
    cachix
  ];

  services.fstrim.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

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

  nix.settings = {

    substituters = [
      "https://niri.cachix.org"
    ];
    trusted-public-keys = [
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
    ];
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Don't change it!!
  system.stateVersion = "24.05";
}
