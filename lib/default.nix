{ lib, pkgs, home-manager, ... }:

{
  core = import ./core.nix { inherit lib pkgs home-manager; };
  option = import ./option.nix { inherit lib pkgs home-manager; };
}
