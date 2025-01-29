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
    };

    # Other services
    services = {
      libinput.enable = true;

      udev.extraRules = ''
        SUBSYSTEM=="vchiq",GROUP="video",MODE="0660"
        KERNEL=="event*", ATTRS{id/product}=="9400", ATTRS{id/vendor}=="18d1", MODE="0660", GROUP="plugdev", SYMLINK+="input/by-id/stadia-controller-$kernel"
      '';

      xserver = {
        enable = true;
        displayManager.autoLogin = {
          enable = true;
          user = "console";
        };
        desktopManager.retroarch = {
          enable = true;
          package = pkgs.retroarchFull;
        };
      };
    };

    users.users.console = {
      isNormalUser = true;
      extraGroups = [ "video" ];
    };

    # Couple of packages
    environment.systemPackages = with pkgs; [
      wine
      winetricks
      glxinfo
      vulkan-tools
    ];

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
