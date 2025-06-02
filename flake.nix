{
  description = "caedesyth system flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # nixvim.url = "github:nix-community/nixvim";
    # nixvim.inputs.nixpkgs.follows = "nixpkgs";
    # nixvim.inputs.home-manager.follows = "home-manager";
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Potentially, nvf asks you to include
    # obsidian-nvim.url = "github:epwalsh/obsidian.nvim";
    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
    stylix.inputs.home-manager.follows = "home-manager";
    foundryvtt.url = "github:reckenrode/nix-foundryvtt";
    foundryvtt.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    stylix,
    nvf,
    ...
  } @ inputs: let
    inherit (self) outputs;
    system = "x86_64-linux";
    rootPath = ./.;

    mkProfile = {
      hostname,
      username,
      isNixos,
      extraPkgs ? [],
      extraHomePkgs ? [],
    }: {
      inherit
        hostname
        username
        isNixos
        extraPkgs
        extraHomePkgs
        ;
    };

    mkNixosConfiguration = profile:
      nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit
            inputs
            outputs
            profile
            rootPath
            ;
        };
        modules =
          [
            (./hosts + "/${profile.hostname}" + /configuration.nix)
            (./hosts + "/${profile.hostname}" + /hardware-configuration.nix)
            ./modules/nix
            stylix.nixosModules.stylix
            ./stylix
          ]
          ++ profile.extraPkgs;
      };

    mkHomeConfiguration = profile:
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = {
          inherit
            inputs
            outputs
            profile
            rootPath
            ;
          unstablePkgs = inputs.nixpkgs-unstable.legacyPackages.${system};
        };
        modules =
          [
            ./modules/home
            (./hosts + "/${profile.hostname}" + /home.nix)
            stylix.homeModules.stylix
            nvf.homeManagerModules.default
            ./stylix
            ./stylix/home.nix
          ]
          ++ profile.extraHomePkgs;
      };

    muko = mkProfile {
      hostname = "muko";
      username = "muko";
      isNixos = true;
      extraPkgs = [
      ];
      extraHomePkgs = [];
    };

    typhon = mkProfile {
      hostname = "typhon";
      username = "typhon";
      isNixos = true;
      extraPkgs = [
        inputs.foundryvtt.nixosModules.foundryvtt
      ];
      extraHomePkgs = [];
    };
  in {
    nixosConfigurations = {
      muko = mkNixosConfiguration muko;
      typhon = mkNixosConfiguration typhon;
    };
    homeConfigurations = {
      muko = mkHomeConfiguration muko;
      typhon = mkHomeConfiguration typhon;
    };
    formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-rfc-style;

    # Broken rn. We fixing it slowly
    packages.${system}.configurate =
      nixpkgs.legacyPackages.${system}.writeShellScriptBin "configurate"
      ''
        # If we error, crash out
        set -e
        set -o pipefail

        # To the configuration!
        echo "Rebuild time"
        nix flake update
        sudo just nix &> nixos-switch.log || (cat nixos-switch.log | grep --color error && exit 1)
        just home &> home-switch.log || (cat home-switch.log | grep --color error && exit 1)
      '';
  };
}
