{
  description = "Become zozin with Nix(OS)";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pkgs-by-name-for-flake-parts.url = "github:drupol/pkgs-by-name-for-flake-parts";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs @ {
    self,
    nixpkgs,
    flake-parts,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} (top @ {
      config,
      withSystem,
      moduleWithSystem,
      ...
    }: {
      imports = [
        inputs.pkgs-by-name-for-flake-parts.flakeModule
        inputs.home-manager.flakeModules.home-manager
      ];

      flake = {
        nixosConfigurations.zozin = withSystem "x86_64-linux" ({config}:
          nixpkgs.lib.nixosSystem {
            specialArgs = {
              inherit (config) packages;
            };
            modules = [./configuration.nix];
          });

        nixosModules.zozin = ./nixos-modules/zozin.nix;
        nixosModules.olive_c = {pkgs, ...}: {
          imports = [./nixos-modules/olive_c.nix];
          services.olive-c.package = withSystem pkgs.stdenv.hostPlatform.system ({config, ...}: config.packages.olive_c);
        };

        nixosModules.koil = {pkgs, ...}: {
          imports = [./nixos-modules/koil.nix];
          services.koil.package = withSystem pkgs.stdenv.hostPlatform.system ({config, ...}: config.packages.koil);
        };

        homeConfigurations.zozin = nixpkgs.lib.nixosSystem {
          modules = [./home.nix];
        };

        homeModules.zozin = ./hm-module.nix;
      };

      systems = ["x86_64-linux" "aarch64-linux"];

      perSystem = {pkgs, ...}: {
        pkgsDirectory = ./packages;
      };
    });
}
