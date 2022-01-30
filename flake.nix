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

  outputs ={ self, nixpkgs, home-manager, flake-utils }: 
  let 
    system = flake-utils.lib.system.x86_64-linux;
    pkgs = nixpkgs;
    lib = nixpkgs.lib.extend
        (self: super: { my = import ./lib/option.nix { inherit pkgs; lib = self; }; } // home-manager.lib);
  in{

    homeConfigurations = {
      # eachDefaultSystem doesn't work for now.
      xgroleau = home-manager.lib.homeManagerConfiguration {
          inherit system;
          homeDirectory = "/home/xgroleau";
          username = "xgroleau";
          stateVersion = "22.05";
          extraSpecialArgs = {
            inherit lib;
          };
          configuration = {
            imports = [ ./home.nix ./profiles/minimal.nix ];
          };
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
