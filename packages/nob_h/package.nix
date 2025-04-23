{ stdenv, nix-update-script, lib, fetchFromGitHub }: stdenv.mkDerivation {
  pname = "nob.h";
  version = "0-unstable-2025-04-14";

  src = fetchFromGitHub {
    owner = "tsoding";
    repo = "nob.h";
    rev = "ceeb7bedd4df1f519d5991f8314cb567939a4b21";
    hash = "sha256-4XLf9MuO+0hiE1+PWBzyGuZklBGzN0lZGSEAY7Htwbo=";
  };

  doBuild = false;
  doCheck = true;

  checkPhase = ''
    cc -o nob nob.c
    ./nob
  '';

  installPhase = ''
    mkdir -p $out/include
    cp nob.h $out/include
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Header only library for writing build recipes in C.";
    homepage = "https://github.com/tsoding/nob.h";
    license = with lib.licenses; [mit unlicense];
  };
}
