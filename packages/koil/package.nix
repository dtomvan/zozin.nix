{
  fetchFromGitHub,
  llvmPackages_19,
  glibc_multi,
  c3c,
  buildNpmPackage,
  replaceVars,
  lib,
  nix-update-script,
}: let
  llvmPackages = llvmPackages_19;
  cc = llvmPackages.clang;
  ourc3c = c3c.overrideAttrs {
    version = "0.7.1"; # or versionCheckHook will complain
    src = fetchFromGitHub {
      owner = "c3lang";
      repo = "c3c";
      rev = "eade5fa57a28e3611f8b7b8830d6dc6390f136fe";
      hash = "sha256-JpNSCG6+yC0YLSM5xlyJ0ehRzCAk1I+3Q7QueuiyhfA=";
    };

    doCheck = false; # oh such a bummer
  };
in
  buildNpmPackage {
    pname = "koil";
    version = "0-unstable-2025-04-06";

    src = fetchFromGitHub {
      owner = "lerno";
      repo = "koil";
      rev = "698697d5511f68966bf86e5d9c3c68f8b1d2779c";
      hash = "sha256-wUx94eZC/g8pIyF7t/KBuuh66hbXeW04Vo6+wepJa+o=";
    };

    # patches = [
    #   (replaceVars ./use-different-wasm32-compiler.patch {
    #     GLIBC = glibc_multi.dev;
    #     CLANG = cc.passthru.cc.lib;
    #   })
    # ];

    npmDepsHash = "sha256-d+LGpFoThvA7KnFqEhnJSPhj+jQcvc399Iv7YJ5ZtVw=";

    nativeBuildInputs = [
    cc 
    # ourc3c
    c3c
    ];

    # Needs to be fixed upstream. Neither tsoding or lerno compiles on either c3c
    # from nixpkgs or the one tsoding suggested
    meta.broken = true;
  }
