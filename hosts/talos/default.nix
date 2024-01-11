{ config, pkgs, ... }:

{
  imports = [ ../base-config.nix ./disko.nix ./hardware-configuration.nix  ];

  config = {
    # Custom modules
    modules = {
      home.username = "xgroleau";
      home.profile = "minimal";
      services.docker.enable = true;
    };

    # Use the systemd-boot EFI boot loader.
    boot = {
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
    };

    networking = {
      hostId = "819a6cd7";
      hostName = "talos"; 
      interfaces.enp0s25.useDHCP = true;
    };

    system.stateVersion = "24.05"; 
  };
}
