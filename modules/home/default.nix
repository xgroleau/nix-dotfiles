{ config, lib, pkgs, ... }:

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
      type = nullOr str;
      default = null;
      description = ''
        The username of the nix-dotfiles
      '';
    };
  };

  imports = [
    (lib.my.core.nixosConfigurationFromProfile {
      username = cfg.username;
      profile = cfg.profile;
    })
  ];

}
