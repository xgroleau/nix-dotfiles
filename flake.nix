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
        #checks = {
        #  fmt = pkgs.runCommand "nixfmt" { } ''
        #    ${pkgs.nixfmt}/bin/nixfmt --check ${./.}/**/*.nix
        #  '';

        #  statix = pkgs.runCommand "statix" { } ''
        #    ${pkgs.statix}/bin/statix check ${./.} --format errfmt | tee output
        #    [[ "$(cat output)" == "" ]]
        #  '';
        #};

        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            git
            nixfmt
            home-manager.defaultPackage.${system}
          ];
        };
      }));
}
