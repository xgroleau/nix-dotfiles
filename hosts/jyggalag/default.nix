{ config, pkgs, lib, ... }:

let
  hostname = "jyggalag";
  runners = map (idx: "${hostname}-${toString idx}") (lib.lists.range 0 2);
  ghTokenPath = /run/secrets/github-runner/HOP-Tech-Canada.token;
  duckdnsTokenPath = /run/secrets/duckdns + "/${hostname}.token";
in {
  imports = [ ../base-config.nix ./hardware-configuration.nix ];

  config = lib.mkMerge ([{
    modules = {
      home = {
        username = "xgroleau";
        profile = "dev";
      };
      networking = {
        ssh.enable = true;
        duckdns = {
          enable = true;
          domain = hostname;
          tokenFile = config.age.secrets.duckdnsToken.path;
        };
      };
      secrets.enable = true;
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
  }] ++
    # Config for each runners
    map (name: {
      services.github-runners."${name}" = {
        enable = true;
        replace = true;
        url = "https://github.com/HOP-Tech-Canada";
        tokenFile = config.age.secrets.ghRunner.path;
        workDir = "$S/github-runner-work/${name}";

        extraPackages = with pkgs; [ config.virtualisation.docker.package ];
        extraLabels = [ "nixos" ];
      };
      systemd.services."github-runner-${name}".serviceConfig.SupplementaryGroups =
        [ "docker" ];
    }) runners);
}
