{ config, pkgs, ... }:

{
  imports = [ ../desktop.nix ./hardware-configuration.nix ];

  config = {
    modules = {
      home = {
        enable = true;
        username = "xgroleau";
        profile = "desktop";
      };

      docker.enable = true;
      kdeconnect.enable = true;

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
      hostName = "namira";
      networkmanager.enable = true;
    };

    environment.systemPackages = with pkgs; [ pavucontrol ];

    # Dualbooting, avoids time issues
    time.hardwareClockInLocalTime = true;

    services = {
      # Enable CUPS to print documents. Add driver if needed
      printing.enable = true;

      # Enable touchpad
      libinput.enable = true;
    };

    hardware.bluetooth.enable = true;
    services.blueman.enable = true;
    # For broadcom ble chip
    hardware.enableAllFirmware = true;

    # Enable sound.
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    system.stateVersion = "22.11";

  };
}
