{ config, pkgs, lib, inputs, ... }:

let
  cfg = config.modules.home;
  profiles = import ../../home/profiles;
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
    { home-manager = { extraSpecialArgs = { inherit inputs; }; }; }
  ];

  config = {

    home-manager = {
      useUserPackages = true;
      sharedModules = [ ../../home ];

      users.${cfg.username} = {
        imports = [ profiles.${cfg.profile} ];
        config = { home.stateVersion = config.system.stateVersion; };
      };

    };
  };

}
