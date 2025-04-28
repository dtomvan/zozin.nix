{
  clangStdenv,
  lib,
  replaceVars,
  fetchFromGitHub,
  rustc,
  fasm,
  nob_h,
  nix-update-script,
}:
clangStdenv.mkDerivation {
  # TODO: when Tsoding starts building with nob, use buildNobPackage
  pname = "b";
  version = "0-unstable-2025-04-24";

  src = fetchFromGitHub {
    owner = "tsoding";
    repo = "b";
    rev = "513cd864a2546c6bf61f2681d8e928fa1d2a26d7";
    hash = "sha256-OaxB33466bs3dzccPCizgBZbFtdCXIjucEuEWvxjkto=";
  };

  patches = [
    (replaceVars ./use-nix-nob.patch {
      NOB_H = "${nob_h}/include/nob.h";
    })
  ];

  postPatch = "rm thirdparty/nob.h";

  nativeBuildInputs = [
    rustc
    fasm
  ];

  makeFlags = [
    "build/b"
    "examples"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/opt/b/examples
    cp build/b $out/bin
    cp build/{hello.js,hello} index.html $out/opt/b/examples

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Compiler for the B Programming Language implemented in Crust";
    homepage = "https://github.com/tsoding/b";
    license = lib.licenses.mit;
    mainProgram = "b";
  };
}
