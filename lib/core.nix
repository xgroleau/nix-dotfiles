{ lib, pkgs, home-manager, ... }:

let

  myHmLib = pkgs.lib.extend (self: super:
    {
      my = import ./. {
        inherit pkgs home-manager;
        lib = self;
      };
    } // home-manager.lib);

  stateVersion = "22.11";

in {
  # Returns a module with the home-manager configuration and the profile
  nixosConfigurationFromProfile = { username, extraModules ? [ ]
    , extraSpecialArgs ? { }, extraConfig ? { }, profile ? { _ }: { }, ... }:

    _: {
      imports = [
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {
            lib = myHmLib;
          } // extraSpecialArgs;

          home-manager.users.${username} = _: {
            imports = [ ../home.nix profile ] ++ extraModules;
            config = { home.stateVersion = stateVersion; } // extraConfig;
          };
        }
      ];
    };

  # Calls homeManagerConfiguration with the profile
  homeConfigurationFromProfile = { system, username
    , homeDirectory ? "/home/${username}", extraModules ? [ ]
    , extraSpecialArgs ? { }, extraConfig ? { }, profile ? { _ }: { }, ... }:

    home-manager.lib.homeManagerConfiguration {
      inherit system username homeDirectory extraModules stateVersion;
      extraSpecialArgs = { lib = myHmLib; } // extraSpecialArgs;
      configuration = {
        imports = [ ../home.nix profile ] ++ extraModules;
        config = extraConfig;
      };
    };
}
