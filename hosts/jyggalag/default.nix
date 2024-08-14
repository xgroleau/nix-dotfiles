{
  config,
  pkgs,
  lib,
  ...
}:

let
  hostname = "jyggalag";
in
{
  imports = [
    ../base-config.nix
    ./hardware-configuration.nix
  ];

  config = {
    modules = {
      home = {
        enable = true;
        username = "xgroleau";
        profile = "minimal";
      };

      ssh.enable = true;

      secrets.enable = true;

      monitoring = {
        server = {
          enable = true;
          alerting = {
            enable = true;
            envFile = config.age.secrets.alertmanagerEnv.path;
            emailTo = "xavgroleau@gmail.com";
            prometheusScrapeUrls = [ "sheogorath:13150" ];
          };
        };
      };
    };

    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    boot = {
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
    };

    # Enable docker
    virtualisation.docker.enable = true;

    networking.hostName = hostname;

    system.stateVersion = "22.11";
  };
}
