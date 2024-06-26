{
  config,
  lib,
  pkgs,
  profiles,
  ...
}:

let
  cfg = config.modules.docker;
in
{

  options.modules.docker = {
    enable = lib.mkEnableOption "Enables docker";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.docker.enable = true;
    users.groups.docker.members = [ config.users.users.${config.modules.home.username}.name ];
  };
}
