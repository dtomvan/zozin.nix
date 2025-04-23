{
  lib,
  nix-update-script,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule {
  pname = "markut";
  version = "0-unstable-2025-04-09";

  src = fetchFromGitHub {
    owner = "tsoding";
    repo = "markut";
    rev = "19c472f784716c037bbfbff0b8cc870d5f23fe87";
    hash = "sha256-r5Xv5Ca9Zy4ElePX5j/DrumViqsDdQYFxJar5hN7bv8=";
  };

  vendorHash = null;

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Autocut the Twitch VODs based on a Marker file";
    homepage = "https://github.com/tsoding/markut";
    license = lib.licenses.mit;
  };
}
