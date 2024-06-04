{ config, pkgs, ... }:

{
  imports = [
    ../desktop.nix
    ./hardware-configuration.nix
  ];

  config = {
    # Custom modules
    modules = {
      home = {
        enable = true;
        username = "xgroleau";
        profile = "desktop";
      };

      ssh.enable = true;
      kdeconnect.enable = true;
      docker.enable = true;

      # Let home manager setup the session and the X11 windowing system.
      xserver.home-manager = true;
    };

    # Use the systemd-boot EFI boot loader.
    boot = {
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
    };

    networking = {
      hostName = "azura";
      networkmanager.enable = true;
      interfaces.enp12s0.useDHCP = true;
    };

    environment.systemPackages = with pkgs; [ pavucontrol ];
    programs.steam.enable = false;

    # Dualbooting, avoids time issues
    time.hardwareClockInLocalTime = true;

    hardware.bluetooth.enable = true;

    services = {
      blueman.enable = true;
      printing.enable = true;
      # Enable sound.
      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };
    };
    security.rtkit.enable = true;

    system.stateVersion = "23.11";
  };
}
