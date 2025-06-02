{
  config,
  lib,
  pkgs,
  profile,
  ...
}: {
  options.cady.emulator = {
    enable = lib.mkEnableOption "Enables QEMU+KVM+virt-manager Emulator";
  };

  config = lib.mkMerge [
    (lib.mkIf config.cady.emulator.enable {
      # QEMU+KVM. We'll see how it goes from here. There are also dconf settings written to home.nix.
      virtualisation.libvirtd = {
        enable = true;
        onBoot = "start";
        qemu.vhostUserPackages = with pkgs; [virtiofsd];
      };
      programs.virt-manager.enable = true;
      users.users.${profile.username}.extraGroups = ["libvirtd"];
    })
  ];
}
