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
          prometheusScrapeUrls = [ "sheogorath:13150" ];
          alerting = {
            enable = true;
            envFile = config.age.secrets.alertmanagerEnv.path;
            emailTo = "xavgroleau@gmail.com";
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
