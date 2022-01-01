{ config, lib, pkgs, ... }:

{
  programs.firefox = {
      enable = true;
      package = pkgs.firefox.override {
          enableTridactylNative = true;
      }
  };
}
