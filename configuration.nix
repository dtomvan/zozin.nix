# Be zozin
# packages == packages in this flake
{ packages, pkgs, ... }: {
  imports = [
    /etc/nixos/hardware-configuration.nix
  ];

  nixpkgs.flake.setFlakeRegistry = true;
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
    };
    gc.automatic = true;
    optimise.automatic = true;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;
  time.timeZone = "Russia/Moscow"; # or something
  networking.hostName = "markov";

  services.xserver.enable = true;
  services.xserver.windowManager.i3.enable = true;
  # I have no idea what DM zozin might be using but lets just KISS (also for
  # the config itself, in theory just .xinitrc with auto startx would be
  # simpler but not when it comes to lines of nix)
  services.xserver.displayManager.lightdm.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  }; 

  users.users.streamer = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    initialPassword = "canyourdebiandothatshit";
  };

  environment.systemPackages = builtins.attrValues packages ++ (with pkgs; [
    vim
    xst
    emacs-pgtk
    tmux
    git
    rxvt-unicode
    mpv
    firefox
    mypaint
    chromium
    chatterino7
  ]);

  system.copySystemConfiguration = true;
  system.stateVersion = "25.05";
}
