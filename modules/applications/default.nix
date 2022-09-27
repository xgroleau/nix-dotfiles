{ config, lib, pkgs, ... }:

{
  imports =
    [ ./discord ./element ./firefox ./gitkraken ./obs ./slack ./spotify ];
}
