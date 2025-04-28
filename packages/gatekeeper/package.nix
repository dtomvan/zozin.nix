{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule {
  pname = "gatekeeper";
  version = "0-unstable-2025-03-04";

  src = fetchFromGitHub {
    owner = "tsoding";
    repo = "Gatekeeper";
    rev = "005e813a6d8e90d7e3fe4f2aaac28661d0e55f15";
    hash = "sha256-3bHsYZgErsoaZF1+RlUz64C40jr9QsWfsqL0X2+iguE=";
  };

  vendorHash = "sha256-IEvrGVaYcnR+PxaIc00sw0+TJgoJIi14vihgCkUu8zc=";

  subPackages = [
    "cmd/gatekeeper"
    "cmd/gaslighter"
  ];

  doCheck = false; # no tests

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "The chat bot Zozin does not want you to know about";
    homepage = "https://github.com/tsoding/Gatekeeper";
    license = lib.licenses.mit;
    mainProgram = "gatekeeper";
  };
}
