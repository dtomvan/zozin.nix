#!/usr/bin/env bash

echo "Generating legacy treefmt.toml..."

config=`nix --extra-experimental-features "nix-command flakes" build .#treefmt-config --no-link --print-out-paths`
install -m644 "$config" treefmt.toml

sed -Ei 's|^command = "/nix/store/.*/bin/nixfmt"$|command = "nixfmt"|' treefmt.toml 
