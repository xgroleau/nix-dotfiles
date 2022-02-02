{ lib, home-manager, ... }:

{

  nixosConfigurationFromProfile = { user, extraModules ? [ ]
    , extraSpecialArgs ? { }, extraConfig ? { }, profile ? { ... }: { } }:
    home-manager.nixosModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = extraSpecialArgs;
      home-manager.users.${user} = { ... }: {
        imports = [ ../.home.nix profile ] ++ extraModules;
        config = extraConfig;
      };
    };

  homeConfigurationFromProfile = { system, username
    , homeDirectory ? "/home/${username}", extraModules ? [ ]
    , extraSpecialArgs ? { }, extraConfig ? { }, profile ? { ... }: { } }:
    home-manager.lib.homeManagerConfiguration {
      inherit system username homeDirectory extraModules extraConfig;
      configuration = {
        imports = [ ../.home.nix profile ] ++ extraSpecialArgs;
        config = extraConfig;
      };
    };
}
