{
  description = "My user configuration using home-manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    flake-utils.url = "github:numtide/flake-utils";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix/release-24.05";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
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
    attic.url = "github:zhaofengli/attic";
    authentik-nix.url = "github:nix-community/authentik-nix";

    roam = {
      url = "github:xgroleau/roam-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-unstable,
      nixos-hardware,
      nix-darwin,
      flake-utils,
      home-manager,
      agenix,
      deploy-rs,
      disko,
      attic,
      authentik-nix,
      roam,
      ...
    }:
    let
      hosts = import ./hosts;
      profiles = import ./home/profiles;
      hmBaseConfig = {
        home = rec {
          username = "xgroleau";
          homeDirectory = "/home/${username}";
          stateVersion = "23.11";
        };
      };

      hmModule = import ./home;

      nixosModule = _: {
        imports = [
          ./modules
          agenix.nixosModules.default
          disko.nixosModules.disko
          attic.nixosModules.atticd
          authentik-nix.nixosModules.default
        ];
      };
    in
    {

      deploy = {
        remoteBuild = true;
        nodes = nixpkgs.lib.mapAttrs (hostName: hostConfig: {
          inherit (hostConfig.deploy) hostname;
          profiles.system = {
            inherit (hostConfig.deploy) user sshUser;
            path = deploy-rs.lib.${hostConfig.system}.activate.nixos self.nixosConfigurations.${hostName};
          };
        }) (nixpkgs.lib.filterAttrs (hostName: hostConfig: hostConfig ? deploy) hosts);
      };

      homeManagerModules.default = hmModule;

      nixosModules.default = nixosModule;

      overlays = import ./overlays { inherit inputs; };

      darwinConfigurations."Xaviers-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        modules = [ ./darwin ];
        specialArgs = {
          inherit inputs;
        };
      };

      # Generate a home configuration for each profiles
      homeConfigurations = nixpkgs.lib.mapAttrs (
        profileName: profileConfig:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${flake-utils.lib.system.x86_64-linux};
          modules = [
            hmBaseConfig
            hmModule
            profileConfig
          ];
          extraSpecialArgs = {
            inherit inputs;
          };
        }
      ) profiles;

      # Generate a nixos configuration for each hosts
      nixosConfigurations = nixpkgs.lib.mapAttrs (
        hostName: hostConfig:
        nixpkgs.lib.nixosSystem {
          inherit (hostConfig) system;
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./secrets
            hostConfig.cfg
            nixosModule
          ];
        }
      ) hosts;
    }

    # Utils of each system
    // (flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        apps = {
          fmt =
            let
              app = pkgs.writeShellApplication {
                name = "fmt";
                runtimeInputs = with pkgs; [
                  nixfmt-rfc-style
                  statix
                ];
                text = ''
                  nixfmt ./**/*.nix && \
                  statix fix --config ${./statix.toml}
                '';
              };
            in
            {
              type = "app";
              program = "${app}/bin/${app.name}";
            };

          deploy =
            let
              app = pkgs.writeShellApplication {
                name = "deploy";
                runtimeInputs = with pkgs; [ deploy-rs.packages.${system}.default ];
                text = ''
                  deploy .# --remote-build "$@"
                '';
              };
            in
            {
              type = "app";
              program = "${app}/bin/${app.name}";
            };
        };

        formatter = pkgs.nixfmt-rfc-style;

        checks = {
          fmt =
            pkgs.runCommand "fmt"
              {
                buildInputs = with pkgs; [
                  nixfmt-rfc-style
                  statix
                ];
              }
              ''
                ${pkgs.nixfmt-rfc-style}/bin/nixfmt --check ${./.}/**/*.nix && \
                ${pkgs.statix}/bin/statix check --config ${./statix.toml} && \
                touch $out
              '';
        };

        devShells.default = pkgs.mkShell {
          buildInputs =
            with pkgs;
            [
              agenix.packages.${system}.default
              deploy-rs.packages.${system}.default
              git
              nixfmt-rfc-style
              statix
              home-manager.defaultPackage.${system}
            ]
            ++ (lib.optionals stdenv.isDarwin [ nix-darwin.packages.${system}.default ]);
        };
      }
    ));
}
