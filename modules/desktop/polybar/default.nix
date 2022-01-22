{ config, lib, pkgs, ... }:

{
  services.polybar = {
    enable = true;
    package = pkgs.polybarFull;

    config = ./polybar/config.ini;

    script = "polybar main &";
  };
  
}
