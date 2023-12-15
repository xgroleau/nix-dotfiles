{ config, pkgs, ... }:

{
  imports = [ ../desktop.nix ./hardware-configuration.nix ];

  config = {
    modules = {
      home.username = "xgroleau";
      home.profile = "desktop";
      networking.kdeconnect.enable = true;
      services.docker.enable = true;

      # Let home manager setup the session and the X11 windowing system.
      services.xserver.home-manager = true;
    };

    # Use the systemd-boot EFI boot loader.
    boot = {
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
    };

    networking = {
      hostName = "azura"; # Define your hostname.
      networkmanager.enable = true;
      interfaces.enp0s25.useDHCP = true;
    };

    environment.systemPackages = with pkgs; [ pavucontrol ];
    programs.steam.enable = false;

    # Dualbooting, avoids time issues
    time.hardwareClockInLocalTime = true;

    hardware.bluetooth.enable = true;
    services.blueman.enable = true;

    services.printing.enable = true;

    # Enable sound.
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
