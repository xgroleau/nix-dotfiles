{ config, lib, pkgs, ... }:

{
  imports = [ ./cc.nix ./common.nix ./python.nix ./rust.nix ];
}
