{
  system ? builtins.currentSystem,
  pkgs ? import <nixpkgs> { inherit system; },
  ...
}:
(pkgs.lib.filesystem.packagesFromDirectoryRecursive {
  inherit (pkgs) callPackage newScope;
  directory = ./packages;
})
