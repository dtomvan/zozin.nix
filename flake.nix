{
  description = "Become zozin with Nix(OS)";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    pkgs-by-name-for-flake-parts.url = "github:drupol/pkgs-by-name-for-flake-parts";
  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-parts,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      top@{
        config,
        withSystem,
        moduleWithSystem,
        ...
      }:
      {
        imports = [
          inputs.pkgs-by-name-for-flake-parts.flakeModule
        ];

        flake = {
          nixosModules.olive_c =
            { pkgs, ... }:
            {
              imports = [ ./nixos-modules/olive_c.nix ];
              services.olive-c.package = withSystem pkgs.stdenv.hostPlatform.system (
                { config, ... }: config.packages.olive_c
              );
            };

          nixosModules.koil =
            { pkgs, ... }:
            {
              imports = [ ./nixos-modules/koil.nix ];
              services.koil.package = withSystem pkgs.stdenv.hostPlatform.system (
                { config, ... }: config.packages.koil
              );
            };
        };

        systems = [
          "x86_64-linux"
          "aarch64-linux"
        ];

        perSystem =
          { pkgs, system, ... }:
          {
            pkgsDirectory = ./packages;

            checks.koil = pkgs.testers.runNixOSTest {
              imports = [ ./tests/koil.nix ];
              defaults.services.koil.package = self.packages.${system}.koil;
            };
          };
      }
    );
}
