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

      # Enable home-manager and git
      programs.home-manager.enable = true;
      programs.git = {
        enable = true;
        lfs.enable = true;
        delta.enable = true;
        userEmail = lib.mkDefault "evanev7@gmail.com";
        userName = lib.mkDefault "Evan";
        extraConfig = {
          push = { autoSetupRemote = true; };
          pull.rebase = true;
          rebase.autoStash = true;
          color.ui = "auto";
          init.defaultBranch = "main";
          commit.verbose = true;
          rerere.enabled = true;
          merge.conflictstyle = "zdiff3";
          diff.algorithm = "histogram";
          delta.navigate = true;
          "url \"git@github.com:\"".insteadOf = "https://github.com/";
          "url \"git@github.com:exo-explore/\"".insteadOf = "exo:";
          "url \"git@github.com:evanev7/\"".insteadOf = "ev:";
          core.compression = 9;
          core.whitespace = "error";
        };
      };

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
