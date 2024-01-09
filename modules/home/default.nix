{ config, lib, pkgs, profiles, ... }:

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
    (lib.my.core.nixosConfigurationFromProfile {
      inherit (cfg) username;
      profile = profiles."${cfg.profile}";
    })
  ];

  config = {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users."${cfg.username}".home.stateVersion = config.system.stateVersion;
    };
  };

}
