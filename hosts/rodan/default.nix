{ config, pkgs, lib, ... }:

let
  runners = map (idx: "rodan-${toString idx}") (lib.lists.range 0 2);
  tokenPath = /run/secrets/github-runner/HOP-Tech-Canada.token;
in {
  imports = [ ../base-config.nix ./hardware-configuration.nix ];

  config = lib.mkMerge ([{
    modules = {
      home.username = "xgroleau";
      home.profile = "dev";
      networking.ssh.enable = true;
    };

    boot = {
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
    };

    # Enable docker
    virtualisation.docker.enable = true;

    networking.hostName = "rodan";
  }] ++
    # Config for each runners
    map (name: {
      services.github-runners."${name}" = {
        enable = true;
        replace = true;
        url = "https://github.com/HOP-Tech-Canada";
        tokenFile = tokenPath;
        extraPackages = with pkgs; [ config.virtualisation.docker.package ];
      };
      systemd.services."github-runner-${name}".serviceConfig.SupplementaryGroups =
        [ "docker" ];
    }) runners);
}
