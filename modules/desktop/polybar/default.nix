{ config, lib, pkgs, ... }:

{
  services.polybar = {
    enable = true;
    package = pkgs.polybar.override {
        i3GapsSupport = true;
        alsaSupport = true;
        iwSupport = true;
        githubSupport = true;
    };
    config = ./polybar/config.ini
    interval = "2h";
  };
  
}
