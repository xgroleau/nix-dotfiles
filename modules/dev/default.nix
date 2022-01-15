{ config, lib, pkgs, ... }:

{
#  imports = [ ./cc.nix ./common.nix ./nix.nix ./python.nix ];
   imports = [ ./common.nix ];
}
