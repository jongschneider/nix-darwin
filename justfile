set positional-arguments

sops_dir := if os() == "macos" { "$HOME/Library/Application Support/sops" } else { "$HOME/.config/sops" }

[macos]
rebuild profile='work':
  darwin-rebuild switch --flake ".#{{ profile }}"

update:
  nix flake update

lint path=".":
  nix develop -c nixpkgs-fmt --check {{path}}

format path=".":
  nix develop -c nixpkgs-fmt {{path}}

