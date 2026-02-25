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
    ports.both = [ ];
    ssh.enable = true;
    # Desktop Environment
    autoUpdate = true;
  };

  environment.systemPackages = with pkgs; [
    git
    bash
    home-manager
    ripgrep
    lazygit
    just
  ];

  # cloudflare ddns
  services.cloudflare-ddns = {
    enable = true;
    credentialsFile = "/run/secrets/cloudflare_ddns_token";
    ip6Domains = [
      "www.caedy.net"
      "caedy.net"
    ];

  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "25.11"; # Don't change it!
}
