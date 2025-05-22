{
  description = "Become zozin with Nix(OS)";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nur-packages.url = "github:dtomvan/nur-packages";
    treefmt-nix.url = "github:numtide/treefmt-nix";
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
          let
            treefmt = inputs.treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
          in
          {
            packages = inputs.nur-packages.legacyPackages.${system}.tsodingPackages;

            formatter = treefmt.config.build.wrapper;
            checks.formatting = treefmt.config.build.check self;

            checks.koil = pkgs.testers.runNixOSTest {
              imports = [ ./tests/koil.nix ];
              defaults.services.koil.package = self.packages.${system}.koil;
            };
          };
      }
    );
}
