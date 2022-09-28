{ config, lib, pkgs, ... }:

{
  imports = [
    ./discord
    ./element
    ./firefox
    ./gitkraken
    ./mpv
    ./obs
    ./pulseview
    ./slack
    ./spotify
  ];
}
