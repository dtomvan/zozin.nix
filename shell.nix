{pkgs ? import <nixpkgs> {}, ...}:
pkgs.mkShell {
  packages = builtins.filter (p: builtins.isAttrs p && builtins.hasAttr "type" p && p.type == "derivation") (builtins.attrValues (import ./default.nix {inherit pkgs;}));
}
