{
  description = "My user configuration using home-manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";

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
        lib = nixpkgs.lib;
      };

      profiles = import ./profiles;
      hmModule = {
        home = rec {
          username = "xgroleau";
          homeDirectory = "/home/${username}";
        };
      };

      inherit (utils.core) homeConfigurationFromProfile;
    in {
      inherit profiles;
      inherit utils;

      # Generate a configuration for each profiles
      homeConfigurations = nixpkgs.lib.mapAttrs (profileName: profileConfig:
        homeConfigurationFromProfile {
          pkgs = pkgs.legacyPackages.${system};
          profile = profileConfig;
          modules = [ hmModule ];
        }) profiles;
    }

    # Utils of each system
    // (flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
      in {
        apps = {
          fmt = let
            app = pkgs.writeShellApplication {
              name = "fmt";
              runtimeInputs = with pkgs; [ nixfmt statix ];
              text = ''
                nixfmt ./**/*.nix
                statix fix ./.
              '';
            };
          in {
            type = "app";
            program = "${app}/bin/${app.name}";
          };
        };

        checks = {
          # TODO: Fix check
          fmt = pkgs.runCommand "fmt" {
            buildInputs = with pkgs; [ nixfmt statix ];
          } ''
            ${pkgs.nixfmt}/bin/nixfmt --check ${./.}/**/*.nix && \
            ${pkgs.statix}/bin/statix check ${./.} && \
            touch $out
          '';

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
