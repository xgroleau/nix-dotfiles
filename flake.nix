{
  description = "My user configuration using home-manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    agenix.url = "github:ryantm/agenix";
  };

  outputs = { self, nixpkgs, home-manager, flake-utils, agenix }:
    let
      system = flake-utils.lib.system.x86_64-linux;
      pkgs = nixpkgs;
      utils = import ./lib {
        inherit pkgs home-manager;
        inherit (nixpkgs) lib;
      };

      hosts = import ./hosts;
      profiles = import ./home/profiles;
      hmModule = {
        home = rec {
          username = "xgroleau";
          homeDirectory = "/home/${username}";
        };
      };

      inherit (utils) core;
      lib = nixpkgs.lib.extend (self: super: { my = utils; });
    in {
      inherit profiles;
      inherit utils;

      # Generate a home configuration for each profiles
      homeConfigurations = nixpkgs.lib.mapAttrs (profileName: profileConfig:
        core.homeConfigurationFromProfile {
          pkgs = pkgs.legacyPackages.${system};
          profile = profileConfig;
          modules = [ hmModule ];
        }) profiles;

      # Generate a nixos configuration for each hosts
      nixosConfigurations = nixpkgs.lib.mapAttrs (hostName: hostConfig:
        nixpkgs.lib.nixosSystem {
          inherit (hostConfig) system;
          specialArgs = {
            inherit lib; # Provide my lib to modules
            inherit profiles;
          };

          modules = [ ./modules hostConfig.cfg ];
        }) hosts;
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

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            git
            nixfmt
            statix
            home-manager.defaultPackage.${system}
          ];
        };
      }));
}
