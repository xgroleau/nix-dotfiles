{ config, lib, pkgs, nixpkgs, ... }:

{
  # User config
  home.keyboard = {
    layout = "ca";
    options = [ "caps:swapescape" ];
  };
  home.language.base = "en_CA.UTF-8";

  targets.genericLinux.enable = true;
  systemd.user.startServices = "sd-switch";
  nixpkgs.config.allowUnfree = true;
  home.enableNixpkgsReleaseCheck = true;

  imports = [ ./modules/desktop ./modules/dev ./modules/shell ./modules/editors];
}
