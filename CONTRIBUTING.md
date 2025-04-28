NOTE: This document is unfinished

## Formatting
To make sure your changes are properly formatted, a pre-commit hook is used.

To activate the hook, use [direnv](https://direnv.net/docs/installation.html)
and run `direnv allow`.

The formatter is preferrably run with [Nix](https://nixos.org/download/), so
install that. But since this is a nix flake, you probably already have it.

If you don't want to or cannot install Nix, you can just install
[nixfmt](https://github.com/NixOS/nixfmt) along with
[treefmt](https://treefmt.com/latest/).

If you want to format your code, you can either run `nix fmt` (if you have
flakes enabled) or `treefmt`.
