{ config, lib, inputs, profiles, ... }:

with lib;
with lib.my.option;
let cfg = config.modules.home;
in {

  options.modules.home = with types; {
    profile = mkOption {
      type = nullOr str;
      default = null;
      description = ''
        The profile used for the nix-dotfiles
      '';
    };
    username = mkOption {
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
        imports = [ ../home profile.${cfg.profile} ] ++ extraModules;
        config = extraConfig;
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
