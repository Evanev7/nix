{
  inputs,
  outputs,
  lib,
  pkgs,
  config,
  ...
}:
{
  options.cady.home = {
    defaults = lib.mkEnableOption "Cady Universal Home Defaults!!";
    userDirsOverride = lib.mkEnableOption "apparently i hate uppercase now";
  };

  config = lib.mkMerge [
    (lib.mkIf config.cady.home.defaults {
      nixpkgs.config.allowUnfree = true;
      # QEMU + KVM autostart, see nix/common.nix for extra setup.
      dconf.settings = {
        "org/virt-manager/virt-manager/connections" = {
          autoconnect = [ "qemu:///system" ];
          uris = [ "qemu:///system" ];
        };
      };

      # Enable home-manager
      programs.home-manager.enable = true;
      # Move .gtkrc-2.0 out of home and into .config, in line with gtk 3 and 4.
      gtk.gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
      # Disable news message
      news.display = "silent";
      # Reload systemd units when reloading home-manager
      systemd.user.startServices = "sd-switch";
    })
    (lib.mkIf config.cady.home.userDirsOverride {
      xdg.userDirs =
        let
          filesDir = "/mysc/files";
        in
        {
          enable = true;
          createDirectories = true;
          desktop = "${config.home.homeDirectory}/desktop";
          documents = "${config.home.homeDirectory}" + filesDir;
          download = "${config.home.homeDirectory}/downloads";
          music = "${config.home.homeDirectory}" + filesDir;
          pictures = "${config.home.homeDirectory}" + filesDir;
          publicShare = "${config.home.homeDirectory}/mysc/public";
          templates = "${config.home.homeDirectory}/mysc/templates";
          videos = "${config.home.homeDirectory}" + filesDir;
          extraConfig = {
            XDG_PROJECTS_DIR = "${config.home.homeDirectory}/projects";
          };
        };
      gtk.gtk3.bookmarks = builtins.map (file: "file://${config.home.homeDirectory}/${file}") [
        "projects"
        "desktop"
        "downloads"
        "nixos"
        "mysc/files"
      ];
    })
  ];
}
