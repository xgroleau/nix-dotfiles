{ config, lib, pkgs, profiles, ... }:

with lib;
with lib.my.option;
let cfg = config.modules.services.docker;
in {

  options.modules.services.docker = with types; { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    virtualisation.docker.enable = true;
    users.users.${config.modules.home.username}.extraGroups = [ "docker" ];
  };
}
