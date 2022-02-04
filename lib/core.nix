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
  nixosConfigurationFromProfile = { user, extraModules ? [ ]
    , extraSpecialArgs ? { }, extraConfig ? { }, profile ? { _ }: { } }:
    home-manager.nixosModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = { lib = myHmLib; } // extraSpecialArgs;
      home-manager.users.${user} = { _ }: {
        imports = [ ../home.nix profile ] ++ extraModules;
        config = extraConfig;
      };
    };

  homeConfigurationFromProfile = { system, username
    , homeDirectory ? "/home/${username}", extraModules ? [ ]
    , extraSpecialArgs ? { }, extraConfig ? { }, profile ? { _ }: { } }:
    home-manager.lib.homeManagerConfiguration {
      inherit system username homeDirectory extraModules;
      extraSpecialArgs = { lib = myHmLib; } // extraSpecialArgs;
      configuration = {
        imports = [ ../home.nix profile ] ++ extraModules;
        config = extraConfig;
      };
    };
}
