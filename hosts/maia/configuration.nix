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

  programs.nix-ld.enable = true;

  # Enable steam and stuff
  programs.steam = {
    enable = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  users.users.${profile.username} = {
    openssh.authorizedKeys.keyFiles = [
      (rootPath + /ssh/gtnh.key.pub)
      (rootPath + /ssh/muko.pub)
      (rootPath + /ssh/typhon.pub)
      (rootPath + /ssh/maia.pub)
    ];
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable KWallet automatically
  security.pam.services.kwallet = {
    name = "kdewallet";
    enableKwallet = true;
  };

  system.stateVersion = "25.05"; # Don't change it!!!
}
