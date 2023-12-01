{ config, lib, pkgs, ... }:

{
  imports = [ ./cc.nix ./common.nix ./ocaml.nix ./python.nix ./rust.nix ];
}
