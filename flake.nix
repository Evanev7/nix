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
    foundryvtt.url = "github:reckenrode/nix-foundryvtt";
    foundryvtt.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      stylix,
      nvf,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      system = "x86_64-linux";
      rootPath = ./.;

      mkProfile =
        {
          hostname,
          username,
          isNixos,
          extraPkgs ? [ ],
          extraHomePkgs ? [ ],
        }:
        {
          inherit
            hostname
            username
            isNixos
            extraPkgs
            extraHomePkgs
            ;
        };

      mkNixosConfiguration =
        profile:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit
              inputs
              outputs
              profile
              rootPath
              ;
          };
          modules = [
            (./hosts + "/${profile.hostname}" + /configuration.nix)
            (./hosts + "/${profile.hostname}" + /hardware-configuration.nix)
            ./modules/nix
            stylix.nixosModules.stylix
            ./stylix
          ] ++ profile.extraPkgs;
        };

      mkHomeConfiguration =
        profile:
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
          modules = [
            ./modules/home
            (./hosts + "/${profile.hostname}" + /home.nix)
            stylix.homeModules.stylix
            nvf.homeManagerModules.default
            ./stylix
            ./stylix/home.nix
          ] ++ profile.extraHomePkgs;
        };

      muko = mkProfile {
        hostname = "muko";
        username = "muko";
        isNixos = true;
        extraPkgs = [
        ];
        extraHomePkgs = [ ];
      };

      typhon = mkProfile {
        hostname = "typhon";
        username = "typhon";
        isNixos = true;
        extraPkgs = [
          inputs.foundryvtt.nixosModules.foundryvtt
        ];
        extraHomePkgs = [ ];
      };

      mnemosyne = mkProfile {
        hostname = "mnemosyne";
        username = "mnemosyne";
        isNixos = true;
        extraPkgs = [
        ];
        extraHomePkgs = [ ];
      };
    in
    {
      nixosConfigurations = {
        muko = mkNixosConfiguration muko;
        typhon = mkNixosConfiguration typhon;
        mnemosyne = mkNixosConfiguration mnemosyne;
      };
      homeConfigurations = {
        muko = mkHomeConfiguration muko;
        typhon = mkHomeConfiguration typhon;
        mnemosyne = mkHomeConfiguration mnemosyne;
      };
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-rfc-style;

      nixConfig = {
        extra-substituters = [
          "https://niri.cachix.org"
        ];
        extra-trusted-public-keys = [
          "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
        ];
      };

      packages.${system}.configurate =
        nixpkgs.legacyPackages.${system}.writeShellScriptBin "configurate"
          ''
            #!/usr/bin/env bash
            set -e
            set -o pipefail


            # Shows your changes
            git diff -U0 *.nix

            # To the configuration!
            echo "Rebuild time"
            nix flake update
            sudo just nix &> nixos-switch.log || (cat nixos-switch.log | grep --color error && exit 1)
            just home &> home-switch.log || (cat home-switch.log | grep --color error && exit 1)
            current=$(nixos-rebuild list-generations | grep True | cut -c -31)
            git commit -am "$current"
          '';
    };
}
