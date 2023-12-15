{ config, lib, pkgs, ... }:

{
  imports = [ ./base-config.nix ];
  services.udisks2.enable = true;

}
