{
  clangStdenv,
  lib,
  replaceVars,
  fetchFromGitHub,
  rustc,
  fasm,
  nob_h,
}:
clangStdenv.mkDerivation { # TODO: when Tsoding starts building with nob, use buildNobPackage
  pname = "b";
  version = "0-unstable-2025-04-23";

  src = fetchFromGitHub {
    owner = "tsoding";
    repo = "b";
    rev = "66c4c1af2db8143d10596de675edae09bba9e37c";
    hash = "sha256-DlPc/PDNQybefs+JQKBTIp45Tc3Bjg1DOeHNgPwe+S8=";
  };

  patches = [(replaceVars ./use-nix-nob.patch {
    NOB_H = "${nob_h}/include/nob.h";
  })];

  postPatch = "rm nob.h";

  nativeBuildInputs = [ rustc fasm ];

  installPhase = ''
  runHook preInstall
  
  mkdir -p $out/bin $out/examples
  cp b $out/bin
  cp hello.js hello index.html $out/examples

  runHook postInstall
  '';

  meta = {
    description = "Compiler for the B Programming Language implemented in Crust";
    homepage = "https://github.com/tsoding/b";
    license = lib.licenses.mit;
    mainProgram = "b";
  };
}
