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
    caddy = {
      enable = true;
      virtualHosts = {
        "www.caedy.net".extraConfig = ''
          respond "omg hiiiiiiiiiiii"
        '';
        "caedy.net".extraConfig = ''
          respond "omg hiiiiiiiiiiii"
        '';
        "jellyfin.caedy.net".extraConfig = ''
          reverse_proxy 127.0.0.1:8096
        '';
        "radarr.caedy.net".extraConfig = ''
          reverse_proxy 127.0.0.1:7878
          tls internal
        '';
        "sonarr.caedy.net".extraConfig = ''
          reverse_proxy 127.0.0.1:8989
        '';
        "lidarr.caedy.net".extraConfig = ''
          reverse_proxy 127.0.0.1:8686
        '';
        "prowlarr.caedy.net".extraConfig = ''
          reverse_proxy 127.0.0.1:9696
        '';
      };
      email = "evanev7@gmail.com";
    };
  };
  networking = {
    wireguard = {
      enable = true;
      interfaces.wg0 = {
        privateKeyFile = "/secrets/wireguard";
        listenPort = 51820;
        ips = [ "10.91.25.1/24" ];
      };
    };
    nat = {
      enable = true;
      enableIPv6 = true;
      externalInterface = "enp2s0";
      internalInterfaces = [ "wg0" ];
    };
    nftables.enable = true;
  };

  cady = {
    defaults = true;
    # My modules!!
    # Firewall + port forwarding
    ports.enable = true;
    ports.both = [
      80
      443
    ];
    ports.tcp = [ ];
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
      "radarr.caedy.net"
    ];

  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "25.11"; # Don't change it!
}
