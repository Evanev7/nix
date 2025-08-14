{
  config,
  lib,
  pkgs,
  profile,
  ...
}:
let
  cfg = config.cady.tailscale;
in
{
  options.cady.tailscale.enable = lib.mkEnableOption "Start Tailscale, but only after init";
  config = lib.mkIf cfg.enable {
    services.tailscale.enable = true;
    systemd.services.tailscaled.wantedBy = lib.mkForce [ ];

    systemd.user.services."start-tailscaled-graphical" = {
      description = "Start Tailscale daemon after graphical session is ready";
      after = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.sudo}/bin/sudo ${pkgs.systemd}/bin/systemctl start tailscaled.service";
        RemainAfterExit = true;
      };
    };

    security.sudo.extraRules = [
      {
        users = [ profile.username ];
        commands = [
          {
            command = "${pkgs.systemd}/bin/systemctl start tailscaled.service";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];

  };
}
