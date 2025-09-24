{
  pkgs,
  profile,
  rootPath,
  inputs,
  config,
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
    desktop = "Plasma";
    autoUpdate = true;
  };

  environment.systemPackages = with pkgs; [
    wget
    git
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

  # Use old kernel, for GT730 support.
  boot.kernelPackages = pkgs.linuxPackages_6_1;
  hardware.nvidia = {
    modesetting.enable = false;
    package = config.boot.kernelPackages.nvidiaPackages.legacy_390;
  };
  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "mnemosyne";

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
