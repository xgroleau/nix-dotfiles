{ config, lib, pkgs, profiles, ... }:

with lib;
with lib.my.option;
let cfg = config.modules.services.docker;
in {

  options.modules.services.docker = with types; {
    enable = mkEnableOption "Enables docker";
  };

  config = mkIf cfg.enable {
    virtualisation.docker.enable = true;
    users.groups.docker.members =
      [ users.users.${config.modules.home.username}.name ];
  };
}
