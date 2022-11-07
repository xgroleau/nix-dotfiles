{ config, pkgs, ... }:

{
  imports = [ ../base-config.nix ./hardware-configuration.nix ];

  config = {
    modules = {
      home.username = "xgroleau";
      home.profile = "desktop";
      networking.kdeconnect.enable = true;
    };

    # Use the systemd-boot EFI boot loader.
    boot = {
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
    };

    networking = {
      hostName = "mothra"; # Define your hostname.
      networkmanager.enable = true;
      interfaces.enp0s25.useDHCP = true;
    };

    environment.systemPackages = with pkgs; [ pavucontrol ];
    programs.steam.enable = true;

    # Dualbooting, avoids time issues
    time.hardwareClockInLocalTime = true;

    # Enable the X11 windowing system.
    services = {
      xserver = {
        enable = true;
        # Enable the Plasma 5 Desktop Environment.
        displayManager.sddm.enable = true;
        desktopManager.plasma5.enable = true;
      };
    };

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
