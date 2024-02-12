{ config, lib, pkgs, ... }:

{
  imports = [ ./base-config.nix ];

  programs.ssh.startAgent = true;

  services = {

    udev = {
      enable = true;
      packages = with pkgs; [
        # For embedded
        stlink
        qmk-udev-rules
        openocd
        libsigrok
      ];

      extraRules = ''
        # Udev rules for nrfconnect
        # https://github.com/NordicSemiconductor/nrf-udev/blob/dcd4097b4c4c00f1103f94cb8d2faba6437d8101/nrf-udev_1.0.1-all/lib/udev/rules.d/71-nrf.rules
        ACTION!="add", SUBSYSTEM!="usb_device", GOTO="nrf_rules_end"
        SUBSYSTEM=="usb", ATTRS{idVendor}=="1915", MODE="0666"
        KERNEL=="ttyACM[0-9]*", SUBSYSTEM=="tty", SUBSYSTEMS=="usb", ATTRS{idVendor}=="1915", MODE="0666", ENV{NRF_CDC_ACM}="1"
        LABEL="nrf_rules_end"
      '';
    };
    udisks2.enable = true;
  };

}
