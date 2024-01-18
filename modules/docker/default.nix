{ config, lib, pkgs, profiles, ... }:

with lib;
with lib.my.option;
let cfg = config.modules.docker;
in {

  options.modules.docker = with types; {
    enable = mkEnableOption "Enables docker";
  };

  config = mkIf cfg.enable {
    virtualisation.docker.enable = true;
    users.groups.docker.members =
      [ config.users.users.${config.modules.home.username}.name ];
  };
}
