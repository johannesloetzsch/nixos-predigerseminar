{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    extra-container.url = "github:erikarvstedt/extra-container";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, extra-container, sops-nix, ... }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    lib = pkgs.lib;

    stateVersion = "23.11";

    nixosConfigurationsFromContainerConfigs = containerName: containerConfig:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit sops-nix; };
        modules = [
          {
            boot.isContainer = true;
            system = { inherit stateVersion; };
          }
          containerConfig.config
        ];
      };

    buildContainerFromContainerConfigs = containerName: containerConfig:
      lib.attrsets.nameValuePair
        ("buildContainer_" + containerName)
        (extra-container.lib.buildContainers {
          inherit system;
          inherit nixpkgs;
          config.containers."${containerName}" = containerConfig //
          {
            specialArgs = {inherit sops-nix;};
          };
        });

    containerConfigsWithSpecialArgs = containerName: containerConfig:
      containerConfig //
      {
        specialArgs = {inherit sops-nix;};
      };

    containerConfigs = lib.attrsets.mergeAttrsList (map (x: x.containers) [ (import ./nix/nextcloud-simple-insecure/containers.nix)
                                                                            (import ./nix/nextcloud-sops/containers.nix) ]);

    buildContainer_ = lib.attrsets.mapAttrs' buildContainerFromContainerConfigs containerConfigs;

  in {
  
    nixosConfigurations = builtins.mapAttrs nixosConfigurationsFromContainerConfigs containerConfigs;

    packages."${system}" = buildContainer_ // rec {

      buildContainers = extra-container.lib.buildContainers {
        inherit system;
        inherit nixpkgs;
        config.containers = builtins.mapAttrs containerConfigsWithSpecialArgs containerConfigs;
      };

      default = buildContainers;

    };
  };
}
