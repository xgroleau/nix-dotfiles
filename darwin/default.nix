{ config, pkgs, inputs, ... }:

let
  profiles = import ../home/profiles;
  overlays = import ../overlays { inherit inputs; };
in {

  imports = [ inputs.home-manager.darwinModules.home-manager ];

  config = {

    nixpkgs = {
      config.allowUnfree = true;
      hostPlatform = "aarch64-darwin";
      overlays = [ overlays.unstable-packages overlays.roam ];
    };

    nix = {
      package = pkgs.nixUnstable;
      extraOptions = ''
        experimental-features = nix-command flakes
      '';

      # Avoid always redownloading the registry
      registry.nixpkgs.flake = inputs.nixpkgs; # For flake commands
      nixPath = [ "nixpkgs=${inputs.nixpkgs}" ]; # For legacy commands
    };

    services = {
      nix-daemon.enable = true;
      tailscale.enable = true;
    };

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
