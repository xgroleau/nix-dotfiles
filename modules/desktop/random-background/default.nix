{ config, lib, pkgs, ... }:

{
  services.random-background = {
    enable = true;
    imageDirectory = "${./wallpapers}";
    interval = "2h";
  };
  
}
