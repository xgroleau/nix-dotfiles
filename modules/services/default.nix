{ config, lib, pkgs, ... }:

{
  imports = [ ./docker ./media-server ./xserver ];
}
