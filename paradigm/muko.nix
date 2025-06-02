{ lib, config, pkgs, ... }:
{
  # My mixed modules
  cady = {

  };

  # Nix only settings
  nix = {
    # IF isNixos - why store these in git, yknow? They should be static.
    # In that case - put it in the flake.
    imports = [ /etc/nixos/hardware-configuration.nix ];
  };

  # Home only settings
  home = {

  };
};
