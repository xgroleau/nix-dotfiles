{ lib, home-manager, ... }:

let hmLibArg = { lib = (lib // home-manager.lib); };
in {
  nixosConfigurationFromProfile = { user, extraModules ? [ ]
    , extraSpecialArgs ? { }, extraConfig ? { }, profile ? { ... }: { } }:
    home-manager.nixosModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = (hmLibArg // extraSpecialArgs);
      home-manager.users.${user} = { ... }: {
        imports = [ ../home.nix profile ] ++ extraModules;
        config = extraConfig;
      };
    };

  homeConfigurationFromProfile = { system, username
    , homeDirectory ? "/home/${username}", extraModules ? [ ]
    , extraSpecialArgs ? { }, extraConfig ? { }, profile ? { ... }: { } }:
    home-manager.lib.homeManagerConfiguration {
      inherit system username homeDirectory extraModules;
      extraSpecialArgs = (hmLibArg // extraSpecialArgs);
      configuration = {
        imports = [ ../home.nix profile ] ++ extraModules;
        config = extraConfig;
      };
    };
}
