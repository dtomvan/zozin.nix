# zozin.nix

Nix/NixOS module and packages for most major [@Tsoding](https://github.com/tsoding) (twitch.tv/tsoding) projects:
- [x] Boomer
- [x] Ded
- [x] Markut
- [x] Musializer
- [x] Sowon
- [x] Koil
- [x] Koil server (NixOS only)
- [x] Shed
- [x] Porth
- [x] Snitch
- [x] olive.c
- [x] olive.c NixOS module
- [ ] Zozin NixOS module
- [ ] Zozin home-manager module

Also some build helpers:
- [x] buildNobPackage

## Usage
There are 3 main modes of operation:
1. Separate packages
2. NixOS module / config
3. home-manager module / config

And of course all of the above may be combined, but if you don't want to drown
in complexity I wouldn't recommend that.

### Single packages
You can use flakes for that:

```ShellSession
# For example:
$ nix run github:dtomvan/zozin.nix#boomer
$ nix profile install github:dtomvan/zozin.nix#porth
```

#### In NixOS
Without flakes:

```nix
{ pkgs, lib, ... }: 
let
  zozin = import (pkgs.fetchFromGitHub {
    owner = "dtomvan";
    repo = "zozin.nix";
    rev = "db0f969f517ecdea1a20cad3bd41fa28e0dd6762";
    hash = "sha256-tFZIKO/mt4vdusr18Oi/dUDsZxdmspHYIgDnE445u30=";
  });
in {
  environment.systemPackages = with zozin; [porth musializer sowon boomer ded];
}
```

Or with flakes, in your `flake.nix`:
```nix
inputs.zozin.url = "github:dtomvan/zozin.nix";
```

You can then install `zozin.packages.x86_64-linux.shed` for example:

```nix
outputs = { nixpkgs, zozin, ... }: {
  nixosConfigurations.penger = nixpkgs.lib.nixosSystem {
    modules = [
      { environment.systemPackages = with zozin.packages.x86_64-linux; [ shed ]; }
    ];
  };
};
```

#### Copy-paste method
If you know what you are doing, you can of course install these without ever
pulling in this repo through the flakes system, which is what I would
personally do if I encountered such a repo. Just steal, no depend. :)

1. Copy one of the folders in `packages/` to your own config
2. Reference to it via `callPackage` e.g. `pkgs.callPackage ./boomer/package.nix {}`
3. Don't forget to also get `buildNobPackage` if needed

### Koil server
Add the input to the flake:
```nix
inputs.zozin.url = "github:dtomvan/zozin.nix";
```

You can then reference it in your NixOS config as `zozin.nixosModules.koil`:
```nix
outputs = { nixpkgs, zozin, ... }: {
  nixosConfigurations.penger = nixpkgs.lib.nixosSystem {
    modules = [
      zozin.nixosModules.koil
      { services.koil.enable = true; }
    ];
  };
};
```

### Olive.c server
Add the input to the flake:
```nix
inputs.zozin.url = "github:dtomvan/zozin.nix";
```

You can then reference it in your NixOS config as `zozin.nixosModules.olive_c`:
```nix
outputs = { nixpkgs, zozin, ... }: {
  nixosConfigurations.penger = nixpkgs.lib.nixosSystem {
    modules = [
      zozin.nixosModules.olive_c
      { services.olive_c.enable = true; }
    ];
  };
};
```

### NixOS Configuration
WIP

### Home-manager module

### Home-manager Configuration
