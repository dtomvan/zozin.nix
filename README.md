# zozin.nix

Nix/NixOS module and packages for most major [@Tsoding](https://github.com/tsoding) (twitch.tv/tsoding) projects:
- [x] 4at (`fourat`)
- [x] B
- [x] Boomer
- [x] Crust (does nothing yet but who knows)
- [x] Ded
- [x] Gatekeeper
- [x] Koil
- [x] Koil NixOS module
- [x] Markut
- [x] Musializer
- [x] Panim
- [x] Porth
- [x] Seroost
- [x] Shed
- [x] Snitch
- [x] Sowon
- [x] SubChat (not by zozin but relevant to the streams)
- [x] Todo.asm
- [x] Tula
- [x] good_training_language
- [x] olive.c
- [x] olive.c NixOS module

Also some build helpers:
- [x] buildNobPackage

## Usage
There are 2 main modes of operation:
1. Separate packages
2. NixOS module / config

### Single packages
You can use flakes for that:

```ShellSession
# For example:
$ nix run github:dtomvan/zozin.nix#boomer
$ nix profile install github:dtomvan/zozin.nix#porth
```

#### In NixOS
With flakes, in your `flake.nix`:
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
