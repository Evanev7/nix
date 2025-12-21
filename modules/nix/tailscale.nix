{ config, lib, ... }:
{
  options.cady.tailscale.enable = lib.mkEnableOption "Start Tailscale, but only after init";
  config = lib.mkIf config.cady.tailscale.enable {
    services.tailscale.enable = true;
    systemd.services.tailscaled = {
      after = [ "graphical.target" ];
      serviceConfig = {
        Type = "notify";
      };
    };
  };
}
