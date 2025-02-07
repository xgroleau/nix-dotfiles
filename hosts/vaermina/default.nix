{ config, pkgs, ... }:
{

  imports = [
    ../desktop.nix
    ./disko.nix
    ./hardware-configuration.nix
  ];

  config = {

    # Custom modules
    modules = {
      ssh.enable = true;
      secrets.enable = true;
      kdeconnect.enable = true;
      home = {
        enable = true;
        username = "xgroleau";
        profile = "minimal";
      };
    };

    hardware.xone.enable = true; # support for the xbox controller USB dongle

    # Other services
    services = {
      libinput.enable = true;

      udev.extraRules = ''
        SUBSYSTEM=="vchiq",GROUP="video",MODE="0660"
        KERNEL=="event*", ATTRS{id/product}=="9400", ATTRS{id/vendor}=="18d1", MODE="0660", GROUP="plugdev", SYMLINK+="input/by-id/stadia-controller-$kernel"
      '';

      displayManager = {
        autoLogin = {
          enable = true;
          user = "console";
        };
      };
      xserver = {
        enable = true;
        displayManager.lightdm.enable = true;

      };
    };

    environment = {
      # Couple of packages
      systemPackages = with pkgs; [
        wine
        winetricks
        glxinfo
        vulkan-tools
        mangohud
      ];
      # loginShellInit = ''
      #   [[ "$(tty)" = "/dev/tty1" ]] && ${./gs.sh}
      # '';
    };

    programs = {
      steam = {
        enable = true;
        gamescopeSession.enable = true;
      };
      gamescope = {
        enable = true;
        capSysNice = true;
      };
    };

    users.users.console = {
      isNormalUser = true;
      extraGroups = [
        "video"
        "input"
        "plugdev"
      ];
      initialPassword = "nixos";
    };

    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    networking = {
      hostName = "vaermina";
      networkmanager.enable = true;
      interfaces.enp1s0.useDHCP = true;
      interfaces.wlp2s0.useDHCP = true;
    };

    system.stateVersion = "24.11";
  };
}
