{
  description = "My user configuration using home-manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, home-manager, flake-utils }:
    let
      system = flake-utils.lib.system.x86_64-linux;
      pkgs = nixpkgs;
      utils = import ./lib {
            inherit pkgs home-manager;
            lib = self;
          };

      profiles = import ./profiles;
    in {
      inherit profiles utils;

      homeConfigurations = {
        # eachDefaultSystem doesn't work for now.
        xgroleau = utils.core.homeConfigurationFromProfile {
          inherit system;
          username = "xgroleau";
          profile = profiles.desktop;
        };
      };
    }

    # Dev shell for all architectures
    // (flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
      in {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            git
            nixfmt
            home-manager.defaultPackage.${system}
          ];
        };
      }));
}
