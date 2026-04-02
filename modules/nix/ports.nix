{
  lib,
  config,
  profile,
  inputs,
  ...
}:
{

  options.cady = {
    ports = {
      enable = lib.mkEnableOption "Cady's funny port stuff (firewall config module.)";
      both = lib.mkOption {
        default = [ ];
        example = [
          25565
          25566
        ];
        type = lib.types.listOf lib.types.int;
        description = "Additional ports to open for both TCP and UDP";
      };
      tcp = lib.mkOption {
        default = [ ];
        example = [ 80 ];
        type = lib.types.listOf lib.types.int;
        description = "Additional ports to open for TCP";
      };
      udp = lib.mkOption {
        default = [ ];
        example = [ 6969 ];
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
      services.resolved.enable = true;
      services.resolved.settings.Resolve = {
        DNSSEC = "true";
        Domains = [ "~." ];
        FallbackDns = config.cady.nextdns.servers;
        DNSOverTLS = "true";
      };
    })
    (lib.mkIf config.cady.ports.enable (
      let
        inherit (config.cady.ports) both tcp udp;
      in
      {
        networking.firewall = {
          enable = true;
          allowedTCPPorts = both ++ tcp;
          allowedUDPPorts = both ++ udp;
        };
      }
    ))
    (lib.mkIf config.cady.ssh.enable {
      # Enable the OpenSSH daemon.
      services.openssh = {
        enable = true;
        settings = {
          PermitRootLogin = "no";
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
        };
        ports = [ 9125 ];
        openFirewall = true;

      };
      users.users.${profile.username} = {
        openssh.authorizedKeys.keyFiles = [
          (inputs.self + /ssh/gtnh.key.pub)
          (inputs.self + /ssh/muko.pub)
          (inputs.self + /ssh/typhon.pub)
          (inputs.self + /ssh/maia.pub)
          (inputs.self + /ssh/mnemosyne.pub)
        ];
      };
    })
  ];
}
