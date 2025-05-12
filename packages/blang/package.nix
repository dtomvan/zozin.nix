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
  version = "0-unstable-2025-05-11";

  src = fetchFromGitHub {
    owner = "tsoding";
    repo = "b";
    rev = "6f3d5eb446c799fc0a71bac01a7293443dc57e33";
    hash = "sha256-vawrRg1i5F3yMyFAukN9EWPhWudyEMCQZkwz1Q/STF8=";
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

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/opt/b/examples
    cp build/b $out/bin
    # removed (temporarily?)
    # cp build/{hello.js,hello} index.html $out/opt/b/examples

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
