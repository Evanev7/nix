{
  description = "caedesyth system flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nvf.url = "github:notashelf/nvf";
    nvf.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
    foundryvtt.url = "github:reckenrode/nix-foundryvtt";
    foundryvtt.inputs.nixpkgs.follows = "nixpkgs";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
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
      pkgs = nixpkgs.legacyPackages.${system};

      treefmtEval = inputs.treefmt-nix.lib.evalModule pkgs {
        projectRootFile = "flake.nix";
        programs = {
          nixfmt.enable = true;
          nixfmt.strict = true;
          stylua.enable = true;
        };
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
          ]
          ++ profile.extraModules;
        };

      mkHomeConfiguration =
        profile:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit
              inputs
              outputs
              profile
              rootPath
              ;
          };
          modules = [
            ./modules/home
            (./hosts + "/${profile.hostname}" + /home.nix)
            stylix.homeModules.stylix
            nvf.homeManagerModules.default
            ./stylix
            ./stylix/home.nix
          ]
          ++ profile.extraHomeModules;
        };

      muko = {
        hostname = "muko";
        username = "muko";
        isNixos = true;
        extraModules = [ ];
        extraHomeModules = [ ];
      };

      typhon = {
        hostname = "typhon";
        username = "typhon";
        isNixos = true;
        extraModules = [ inputs.foundryvtt.nixosModules.foundryvtt ];
        extraHomeModules = [ ];
      };

      mnemosyne = {
        hostname = "mnemosyne";
        username = "mnemosyne";
        isNixos = true;
        extraModules = [ ];
        extraHomeModules = [ ];
      };

      maia = {
        hostname = "maia";
        username = "maia";
        isNixos = true;
        extraModules = [ inputs.nixos-hardware.nixosModules.framework-amd-ai-300-series ];
        extraHomeModules = [ ];
      };
    in
    {
      nixosConfigurations = {
        muko = mkNixosConfiguration muko;
        typhon = mkNixosConfiguration typhon;
        mnemosyne = mkNixosConfiguration mnemosyne;
        maia = mkNixosConfiguration maia;
      };
      homeConfigurations = {
        muko = mkHomeConfiguration muko;
        typhon = mkHomeConfiguration typhon;
        mnemosyne = mkHomeConfiguration mnemosyne;
        maia = mkHomeConfiguration maia;
      };
      formatter.${system} = treefmtEval.config.build.wrapper;
      checks.${system}.formatting = treefmtEval.config.build.check inputs.self;
    };
}
