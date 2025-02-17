{ config, pkgs, ... }:
{

  imports = [
    ../desktop.nix
    ./disko.nix
    ./hardware-configuration.nix
  ];

  config = {

    # Custom modules
    # modules = {
    #   ssh.enable = true;
    #   secrets.enable = true;
    #   kdeconnect.enable = true;
    #   home = {
    #     enable = true;
    #     username = "xgroleau";
    #     profile = "minimal";
    #   };
    # };

    hardware = {
      xone.enable = true; # support for the xbox controller USB dongle
      xpadneo.enable = true;
      uinput.enable = true;
      steam-hardware.enable = true;
    };

    # Other services
    services = {
      libinput.enable = true;
      joycond.enable = true;

      udev.extraRules = ''
        SUBSYSTEM=="vchiq",GROUP="video",MODE="0660"
        KERNEL=="event*", ATTRS{id/product}=="9400", ATTRS{id/vendor}=="18d1", MODE="0660", GROUP="plugdev", SYMLINK+="input/by-id/stadia-controller-$kernel"
      '';

      displayManager = {
        autoLogin = {
          enable = true;
          user = "console";
        };
        defaultSession = "steam";
      };
      xserver = {
        enable = true;
        # displayManager.lightdm.enable = true;
        desktopManager = {
          retroarch = {
            enable = true;
            package = pkgs.retroarchFull;
          };
          xfce.enable = true;
        };
      };
    };
    programs.steam.enable = true;
    programs.steam.gamescopeSession.enable = true;
    programs.gamescope.enable = true;
    programs.gamemode.enable = true;
    programs.gamescope.capSysNice = true;

    environment = {
      # Couple of packages
      systemPackages = with pkgs; [
        wine
        winetricks
        glxinfo
        vulkan-tools
        mangohud
      ];
    };

    users.users.console = {
      isNormalUser = true;
      extraGroups = [
        "adm"
        "audio"
        "dialout"
        "input"
        "kvm"
        "networkmanager"
        "plugdev"
        "systemd-journal"
        "users"
        "video"
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
