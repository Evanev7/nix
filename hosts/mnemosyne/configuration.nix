{
  pkgs,
  profile,
  rootPath,
  ...
}:
{
  cady = {
    defaults = true;
    # My modules!!
    # Firewall + port forwarding
    ports.enable = true;
    ports.both = [
    ];
    ssh.enable = true;
    # Desktop Environment
    desktop = "Plasma";
    autoUpdate = true;
  };

  environment.systemPackages = with pkgs; [
    git
    bash
    home-manager
    bottom
    ripgrep
    lazygit
    xdg-user-dirs
    just
  ];

  users.users.${profile.username} = {
    openssh.authorizedKeys.keyFiles = [
      (rootPath + /ssh/gtnh.key.pub)
      (rootPath + /ssh/muko.pub)
      (rootPath + /ssh/typhon.pub)
    ];
  };

  # cloudflare ddns
  services.cloudflare-ddns = {
    enable = true;
    credentialsFile="/run/secrets/cloudflare_ddns_token";
    ip6Domains = [ "www.caedy.net" "caedy.net" ];

  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use old kernel, for GT730 support.
  # nah, graphics are cringe
  # boot.kernelPackages = pkgs.linuxPackages_6_1;
  # hardware.nvidia = {
  #   modesetting.enable = false;
  #   package = config.boot.kernelPackages.nvidiaPackages.legacy_390;
  # };

  # Enable automatic login for the user.
  services.displayManager.autoLogin = {
    enable = true;
    user = "mnemosyne"; 
  };

  system.stateVersion = "25.05"; # Don't change it!
}
