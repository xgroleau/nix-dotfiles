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

      inherit (nixpkgs.lib) listToAttrs mapAttrs;
      inherit (utils.core) homeConfigurationFromProfile;
    in {
      inherit profiles utils;

      # Generate a configuration for each profiles
      homeConfigurations = nixpkgs.lib.mapAttrs (profileName: profileConfig:
        homeConfigurationFromProfile {
          inherit system;
          username = "xgroleau";
          profile = profileConfig;
        }) profiles;
    }

    # Utils of each system
    // (flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
      in {
        apps = {
          checks = pkgs.writeShellApplication {
            name = "checks";
            runtimeInputs = with pkgs; [ nixfmt statix ];
            text = ''
              nixfmt --check ${./.}/**/*.nix && \
              statix check ${./.}
            '';

          };

          fmt = pkgs.writeShellApplication {
            name = "fmt";
            runtimeInputs = with pkgs; [ nixfmt ];
            text = ''
              nixfmt ./**/*.nix
              statix fix ${./.}
            '';
          };
        };

        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            git
            nixfmt
            statix
            home-manager.defaultPackage.${system}
          ];
        };
      }));
}
