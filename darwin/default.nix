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
      sharedModules = [ ../home ];
      extraSpecialArgs = { inherit inputs; };

      users.xgroleau = {
        imports = [ profiles."macos" ];
        config = {
          home = {
            stateVersion = "23.11";
            homeDirectory = "/Users/xgroleau";

            activation = {
              # This should be removed once
              # https://github.com/nix-community/home-manager/issues/1341 is closed.
              aliasHomeManagerApplications =
                inputs.home-manager.lib.hm.dag.entryAfter [ "writeBoundary" ] ''
                  app_folder="/Users/xgroleau/Applications/Home Manager Trampolines"
                  rm -rf "$app_folder"
                  mkdir -p "$app_folder"
                  find "$genProfilePath/home-path/Applications" -type l -print | while read -r app; do
                      app_target="$app_folder/$(basename "$app")"
                      real_app="$(readlink "$app")"
                      echo "mkalias \"$real_app\" \"$app_target\"" >&2
                      $DRY_RUN_CMD ${pkgs.mkalias}/bin/mkalias "$real_app" "$app_target"
                  done
                '';
            };
          };
        };
      };
    };
  };
}
