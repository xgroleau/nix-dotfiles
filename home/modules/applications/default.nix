{ config, lib, pkgs, ... }:

{
  imports =
    [ ./discord ./element ./firefox ./mpv ./obs ./pulseview ./slack ./spotify ];
}
