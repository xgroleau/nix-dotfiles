{ config, lib, pkgs, ... }:

{
  config = {

    nixpkgs.config.allowUnfree = true;
    nix = {
      package = pkgs.nixUnstable;
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
    };

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
    };

    time.timeZone = "America/Toronto";

    environment.systemPackages = with pkgs; [ vim nano curl wget firefox ];

    programs.zsh.enable = true;
    i18n.defaultLocale = "en_CA.UTF-8";
    users = {
      users.xgroleau = {
        isNormalUser = true;
        shell = pkgs.zsh;
        initialPassword = "nixos";
        extraGroups = [
          "wheel"
          "audio"
          "networkmanager"

          # For embedded development
          "plugdev"
          "dialout"
        ];

        openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC/ZRV75mh7+1xiTR8+oNDabpUAmUrrEa6drrlhB4H2xqRoaBM5ZGlwuCgB+uTtsdcyM2sf0ZVep9vkjVFDbAAsoSeKM1sIySQXcPjaSFJX51aGUVWorPYfHIVljg6NHFKJtQFow/Kh3lzYs6F7ZbnrSGS25PWiR/ZfJx3RaGpCcyJcDUUjJ0Bt1+ORaayIL429IImEmW0/SqJL3PdzstkS8ukQ8rIki5MTU/Nk7RjbghkmzwONdMbu+8/fego7LbxJYhzdt97lwB0g0k5Z/cSE5Dic3pa2oLRinVyPjfgGyxZ8lugaTjmGB9HroqVfg/C+QWAxUwouX0SWHnCYhXvF xavgroleau@gmail.com"
        ];
      };
    };

    system.stateVersion = "22.11";
  };
}
