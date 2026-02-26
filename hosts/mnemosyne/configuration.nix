{
  pkgs,
  profile,
  rootPath,
  ...
}:
{
  services = {
    radarr.enable = true;
    lidarr.enable = true;
    prowlarr.enable = true;
    sonarr.enable = true;
    bazarr.enable = true;
    jellyfin.enable = true;
    fail2ban.enable = true;
    caddy.enable = true;
    caddy.virtualHosts."http://www.caedy.net".extraConfig = ''
      respond "omg hiiiiiiiiiiii"
    '';
    caddy.virtualHosts."jellyfin.caedy.net".extraConfig = ''
      reverse_proxy 127.0.0.1:8096
    '';
    caddy.email = "evanev7@gmail.com";
  };

  cady = {
    defaults = true;
    # My modules!!
    # Firewall + port forwarding
    ports.enable = true;
    ports.both = [ ];
    ports.tcp = [ 80 443 ];
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
    credentialsFile = "/secrets/cloudflare_ddns_token";
    ip6Domains = [
      "www.caedy.net"
      "caedy.net"
      "jellyfin.caedy.net"
    ];

  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "25.11"; # Don't change it!
}
