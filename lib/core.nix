{ lib, ... }:

let inherit (lib) mkOption types;
in rec {
    homeConfigurationFromProfile = profile:
        { system, username, homeDirectory ? "/home/${username}", extraConfig ? {}}:
        home-manager.lib.homeManagerConfiguration {
            inherit homeDirectory system username;
            configuration = {
                nixosModuleFromProfile profile;
            };

        };
}
