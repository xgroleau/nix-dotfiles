{
  description = "My user configuration using home-manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        utils.follows = "flake-utils";
      };
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    authentik-nix = {
      url = "github:nix-community/authentik-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, nixos-hardware
    , home-manager, agenix, deploy-rs, disko, flake-utils, authentik-nix, ... }:
    let
      hosts = import ./hosts;
      profiles = import ./home/profiles;
      hmModule = {
        home = rec {
          username = "xgroleau";
          homeDirectory = "/home/${username}";
        };
      };
    in {

      deploy = {
        remoteBuild = true;
        nodes = nixpkgs.lib.mapAttrs (hostName: hostConfig: {
          inherit (hostConfig.deploy) hostname;
          profiles.system = {
            inherit (hostConfig.deploy) user sshUser;
            path = deploy-rs.lib.${hostConfig.system}.activate.nixos
              self.nixosConfigurations.${hostName};
          };
        }) (nixpkgs.lib.filterAttrs (hostName: hostConfig: hostConfig ? deploy)
          hosts);
      };

      overlays = import ./overlays { inherit inputs; };

      # Generate a home configuration for each profiles
      homeConfigurations = nixpkgs.lib.mapAttrs (profileName: profileConfig:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${flake-utils.lib.system.x86_64-linux};
          modules =
            [ hmModule ./home profileConfig { home.stateVersion = "23.11"; } ];
          extraSpecialArgs = { inherit inputs; };
        }) profiles;

      # Generate a nixos configuration for each hosts
      nixosConfigurations = nixpkgs.lib.mapAttrs (hostName: hostConfig:
        nixpkgs.lib.nixosSystem {
          inherit (hostConfig) system;
          specialArgs = {
            inherit profiles;
            inherit inputs;
          };

          modules = [
            ./modules
            ./secrets
            agenix.nixosModules.default
            disko.nixosModules.disko
            # authentik-nix.nixosModules.default
            hostConfig.cfg
          ];
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
              '';
            };
          in {
            type = "app";
            program = "${app}/bin/${app.name}";
          };
        };

        checks = {
          fmt = pkgs.runCommand "fmt" {
            buildInputs = with pkgs; [ nixfmt statix ];
          } ''
            ${pkgs.nixfmt}/bin/nixfmt --check ${./.}/**/*.nix && \
            touch $out
          '';
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            agenix.packages.${system}.default
            deploy-rs.packages.${system}.default
            disko.packages.${system}.default
            git
            nixfmt
            statix
            home-manager.defaultPackage.${system}
          ];
        };
      }));
}
