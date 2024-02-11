{ config, lib, inputs, profiles, ... }:

let cfg = config.modules.home;
in {

  options.modules.home = with lib.types; {
    profile = lib.mkOption {
      type = nullOr str;
      default = null;
      description = ''
        The profile used for the nix-dotfiles
      '';
    };
    username = lib.mkOption {
      type = str;
      default = null;
      description = ''
        The username of the nix-dotfiles
      '';
    };
  };

  imports = [
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.users.${cfg.username} = _: {
        imports = [ ../home profiles.${cfg.profile} ];
      };
    }
  ];

  config = {

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users."${cfg.username}".home.stateVersion = config.system.stateVersion;
    };
  };

}
