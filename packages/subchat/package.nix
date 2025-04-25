{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  wayland-scanner,
  wayland,
  wayland-protocols,
  libxkbcommon,
  libGL,
  glfw,
  glew,
  gtk3,
  guiSupport ? true,
}:
stdenv.mkDerivation {
  pname = "subchat";
  version = "0-unstable-2025-04-08";

  src = fetchFromGitHub {
    owner = "Kam1k4dze";
    repo = "SubChat";
    rev = "8b04fe4df3c8b0d50054f50fd313ecbbfcab07d5";
    hash = "sha256-WEiTkCgCO4u8C3r3Y8xtba3tzyyYFCggyDT3A1NdT6M=";
    fetchSubmodules = true;
  };

  patches = [
    ./use-nix-glfw.patch # they are vendoring glfw, but nix needs some patches so just use nixpkgs version
    ./dont-fucking-static-link.patch # this is nixpkgs dammit, -static will not work with stdenv
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ] ++ lib.optional guiSupport wayland-scanner;

  buildInputs = lib.optionals guiSupport [
    gtk3
    glfw
    glew
    libGL
    wayland
    wayland-protocols
    libxkbcommon
  ];

  installPhase = ''
  runHook preInstall
  mkdir -p $out/bin
  cp subtitles_generator $out/bin
  ${lib.optionalString guiSupport "cp config_generator_gui $out/bin"}
  runHook postInstall
  '';

  meta = {
    description = "SubChat is a command-line and GUI toolset for generating YouTube subtitles from chat logs";
    homepage = "https://github.com/Kam1k4dze/SubChat";
    license = lib.licenses.mit;
    mainProgram = "subchat";
    platforms = lib.platforms.all;
  };
}
