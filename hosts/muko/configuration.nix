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
    ssh.enable = true;
    nextdns.enable = true;
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
    fd
    lazygit
    bacon
    xdg-user-dirs
    just
    thunderbird
    vimix-cursors
  ];

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

  # Enable nvidia prime
  hardware.nvidia.prime = {
    # Very system specific! See https://nixos.wiki/wiki/Nvidia for more info
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  # Enable KWallet automatically
  security.pam.services.kwallet = {
    name = "kdewallet";
    enableKwallet = true;
  };

  # Don't change it!!
  system.stateVersion = "23.11";
}
