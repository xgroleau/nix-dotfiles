{
  config,
  lib,
  pkgs,
  ...
}:

let
  keys = import ../secrets/ssh-keys.nix;
in
{

  config = {
    nix = {
      settings.trusted-users = [ "@builder" ];
    };

    users = {
      root = {
        openssh.authorizedkeys.keys = [ keys.deployer.ghAction ];
      };

      builder = {
        isSystemUser = true;
        createHome = false;
        uid = 500;
        openssh.authorizedKeys.keys = [ keys.users.builder ];
        useDefaultShell = true;
      };

      groups.builder = {
        name = "builder";
      };
    };
  };
}
