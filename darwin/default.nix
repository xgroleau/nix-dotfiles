{ config, pkgs, inputs, ... }:

let profiles = import ../home/profiles;
in {

  imports = [ inputs.home-manager.darwinModules.home-manager ];

  config = {
    nixpkgs.hostPlatform = "aarch64-darwin";
    services.nix-daemon.enable = true;

    users.users.xgroleau.home = "/Users/xgroleau";
    home-manager = {
      useUserPackages = true;
      sharedModules = [ ../home ];
      extraSpecialArgs = { inherit inputs; };

      users.xgroleau = {
        imports = [ profiles."macos" ];
        config = {
          home = {
            stateVersion = "23.11";
            homeDirectory = "/Users/xgroleau";
          };
        };
      };

    };
  };
}
