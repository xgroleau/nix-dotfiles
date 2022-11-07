{ config, pkgs, ... }:

{
  imports = [ ../base-config.nix ./hardware-configuration.nix ];

  config = {
    modules = {
      home.username = "xgroleau";
      home.profile = "dev";
    };

    # Use the systemd-boot EFI boot loader.
    boot = {
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
    };
  };
}
