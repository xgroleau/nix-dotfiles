{ config, lib, pkgs, ... }:

{
  services.redshift = {
    enable = true;
    provider = "manual";
    latitude = 40.74;
    longitude = -74.0;
    temperature = {
      day = 5000;
      night = 3800;
    };
    settings = {
      redshift = {
        fade = true;
        adjustment-method = "randr";
        gamma-day = "0.95:0.95:0.95";
        gamma-night = "0.95:0.95:0.95";
      };
    };
  };
}
