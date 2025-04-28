{
  lib,
  nob_h,
  buildNobPackage,
  fetchFromGitHub,
  nix-update-script,
  copyDesktopItems,
  makeDesktopItem,
  replaceVars,
  makeWrapper,
  ffmpeg,
  zenity,
  raylib,
  dialogProgram ? zenity,
}:
(buildNobPackage rec {
  pname = "musializer";
  version = "alpha2-unstable-2025-04-14";

  src = fetchFromGitHub {
    owner = "tsoding";
    repo = "musializer";
    rev = "b7578cc76b9ecb573d239acc9ccf5a04d3aba2c9";
    hash = "sha256-NbumChMDzh3kVi8q2Bhk91D6L9ckfqFncrwN0D5GA6w=";
  };

  desktopItems = [
    (makeDesktopItem {
      name = "musializer";
      exec = "musializer";
      comment = meta.description;
      desktopName = "Musializer";
      genericName = "Musializer";
      icon = "musializer";
    })
  ];

  # 2nd patch depends on the first one, hence sharing vars, idk what to do about that
  patches = [
    (replaceVars ./use-nix-raylib.patch {
      RAYLIB = raylib;
      RAYLIB_SRC = raylib.src;
    })
    (replaceVars ./use-nix-nob.patch {
      RAYLIB = raylib;
      RAYLIB_SRC = raylib.src;
      NOB_H = nob_h;
    })
  ];

  buildInputs = [
    raylib
  ];

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  postInstall = ''
    wrapProgram $out/bin/musializer \
      --prefix PATH : ${
        lib.makeBinPath [
          dialogProgram
          ffmpeg
        ]
      }

    install -Dm644 resources/logo/logo-256.png $out/share/pixmaps/musializer.png
  '';

  outPaths = [ "build/musializer" ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Music Visualizer";
    homepage = "https://github.com/tsoding/musializer";
    license = lib.licenses.mit;
  };
})
