{
  pkgs,
  lib,
  config,
  ...
}:
{

  options.cady = {
    ports = {
      enable = lib.mkEnableOption "Cady's funny port stuff (firewall config module.)";
      both = lib.mkOption {
        default = [
        ];
        example = [
          25565
          25566
        ];
        type = lib.types.listOf lib.types.int;
        description = "Additional ports to open for both TCP and UDP";
      };
      tcp = lib.mkOption {
        default = [ ];
        example = [
          80
        ];
        type = lib.types.listOf lib.types.int;
        description = "Additional ports to open for TCP";
      };
      udp = lib.mkOption {
        default = [ ];
        example = [
          6969
        ];
        type = lib.types.listOf lib.types.int;
        description = "Additional ports to open for UDP";
      };
    };
    ssh.enable = lib.mkEnableOption "Enable SSH service";
    nextdns = {
      enable = lib.mkEnableOption "The NextDNS nameserver overrides.";
      servers = lib.mkOption {
        default = [
          "45.90.28.0#fbd51c.dns.nextdns.io"
          "2a07:a8c0::#fbd51c.dns.nextdns.io"
          "45.90.30.0#fbd51c.dns.nextdns.io"
          "2a07:a8c1::#fbd51c.dns.nextdns.io"
        ];
        example = [
          "idk some ip addresses"
          "maybe some more"
        ];
        type = lib.types.listOf lib.types.str;
        description = "A list of fallback domains preconfigured to align with NextDNS.";
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.cady.nextdns.enable {
      # NextDNS setup
      networking.nameservers = config.cady.nextdns.servers;
      services.resolved = {
        enable = true;
        dnssec = "true";
        domains = [ "~." ];
        fallbackDns = config.cady.nextdns.servers;
        dnsovertls = "true";
      };
    })
    (lib.mkIf (config.cady.ports.enable) (
      let
        both = config.cady.ports.both;
        tcp = config.cady.ports.tcp ++ lib.optionals config.cady.ssh.enable [ 9125 ];
        udp = config.cady.ports.udp;
      in
      {
        networking.firewall.enable = true;
        networking.firewall.allowedTCPPorts = both ++ tcp;
        networking.firewall.allowedUDPPorts = both ++ udp;
      }
    ))
    (lib.mkIf (config.cady.ssh.enable) ({
      # Enable the OpenSSH daemon.
      services.openssh = {
        enable = true;
        settings = {
          PermitRootLogin = "no";
          PasswordAuthentication = false;
        };
        ports = [ 9125 ];
      };
    }))
  ];
}
