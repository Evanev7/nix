{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.cady.nvidia.enable = lib.mkEnableOption "Nvidia Graphics Settings";

  config = lib.mkIf config.cady.nvidia.enable {
    # Accept nvidia licenses
    nixpkgs.config.nvidia.acceptLicense = true;
    
    # Enable OpenGL
    hardware.graphics = {
      enable = true;
      # driSupport = true;
      # driSupport32Bit = true;
    };

    # Load Nvidia driver for Xorg and Wayland
    services.xserver.videoDrivers = [ "nvidia" ];

    # Seems like a good idea.
    hardware.enableAllFirmware = true;
    hardware.nvidia = {
      # Modesetting is maybe required
      modesetting.enable = lib.mkDefault true;
      nvidiaPersistenced = true;

      # These options are all experimental and buggy.
      # See https://nixos.wiki/wiki/Nvidia for more info
      powerManagement = {
        enable = false;
      };
      open = false;

      # Enable the Nvidia settings menu through nvidia-settings
      nvidiaSettings = true;

      # May need to switch to appropriate driver
      package = lib.mkDefault config.boot.kernelPackages.nvidiaPackages.stable;
    };

    # Taken from https://github.com/tolgaerok/nixos-kde/blob/0a3541eb07c183a8c1979e024abe3bebcbfd8fe2/core%2Fgpu%2Fnvidia%2Fnvidia-stable-opengl%2Fdefault.nix
    boot.extraModprobeConfig =
      "options nvidia "
      + lib.concatStringsSep " " [
        # nvidia assume that by default your CPU does not support PAT,
        # but this is effectively never the case in 2023
        "NVreg_UsePageAttributeTable=1"
        # This may be a noop, but it's somewhat uncertain
        "NVreg_EnablePCIeGen3=1"
        # This is sometimes needed for ddc/ci support, see
        # https://www.ddcutil.com/nvidia/
        #
        # Current monitor does not support it, but this is useful for
        # the future
        "NVreg_RegistryDwords=RMUseSwI2c=0x01;RMI2cSpeed=100"
        # When (if!) I get another nvidia GPU, check for resizeable bar
        # settings
      ];

    # Set environment variables related to NVIDIA graphics
    environment.variables = {
      # Required to run the correct GBM backend for nvidia GPUs on wayland
      GBM_BACKEND = "nvidia-drm";
      # Apparently, without this nouveau may attempt to be used instead
      # (despite it being blacklisted)
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      # Hardware cursors are currently broken on nvidia
      LIBVA_DRIVER_NAME = "nvidia";
      WLR_NO_HARDWARE_CURSORS = "1";
      __GL_THREADED_OPTIMIZATION = "1";
      __GL_SHADER_CACHE = "1";
      # Hardware acceleration in firefox
      NVD_BACKEND = "direct";
      MOZ_DISABLE_RDD_SANDBOX = "1";
    };

    # Packages related to NVIDIA graphics
    environment.systemPackages = with pkgs; [
      clinfo
      gwe
      nvtopPackages.nvidia
      virtualglLib
      vulkan-loader
      vulkan-tools
    ];
  };
}
