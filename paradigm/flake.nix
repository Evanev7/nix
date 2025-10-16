{

  description = "caedesyth system flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.inputs.home-manager.follows = "home-manager";
    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
    stylix.inputs.home-manager.follows = "home-manager";
    foundryvtt.url = "github:reckenrode/nix-foundryvtt";
    foundryvtt.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      stylix,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      system = "x86_64-linux";
      flakeRoot = ./.;

      mkNixosConfiguration =
        profile:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit
              inputs
              outputs
              profile
              flakeRoot
              ;
          };
          modules = [
            "./${profile.hostname}.nix"
            /etc/nixos/hardware-configuration.nix
          ]);
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
          };
          modules = [
            import "./${profile.username}.nix"
            ./home
            (./hosts + "/${profile.hostname}" + /home.nix)
            stylix.homeManagerModules.stylix
            ./stylix
            ./stylix/home.nix
          ] ++ (profile.extraHomePkgs ? [ ]);

        };

      muko = mkProfile {
        hostname = "muko";
        username = "muko";
        isNixos = true;
        extraPkgs = [
          ./nix/nvidia.nix
          ./nix/plasma.nix
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

    in
    {
      nixosConfigurations = {
        muko = mkNixosConfiguration muko;
        typhon = mkNixosConfiguration typhon;
      };
      homeConfigurations = {
        muko = mkHomeConfiguration muko;
        typhon = mkHomeConfiguration typhon;
      };
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-rfc-style;
}
