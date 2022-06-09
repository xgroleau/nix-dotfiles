{ config, lib, pkgs, ... }:

{
  imports = [ ./discord ./element ./firefox ./gitkraken ./slack ./spotify ];
}
