{ lib, pkgs, home-manager, ... }:

let

  myHmLib = pkgs.lib.extend (self: super:
    {
      my = import ./. {
        inherit pkgs home-manager;
        lib = self;
      };
    } // home-manager.lib);
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
            config = extraConfig;
          };
        }
      ];
    };

  # Calls homeManagerConfiguration with the profile
  homeConfigurationFromProfile = { pkgs, modules ? [ ], extraSpecialArgs ? { }
    , profile ? { _ }: { }, check ? true, ... }:

    home-manager.lib.homeManagerConfiguration {
      inherit pkgs extraSpecialArgs check;
      lib = myHmLib;
      modules = [ ../home.nix profile ] ++ modules;
    };
}
