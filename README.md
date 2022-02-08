# nix-dotfiles
My declarative dotfiles configuration using [nix](https://nixos.org/) and [home-manager](https://github.com/nix-community/home-manager) to manage my systems.

This configuration **should** work in all distribution in theory, but because nixpkgs has some issue with opengl, some features may not work. Namely `alacritty` and `picom` won't be able to launch if you are not using NixOS.

## Installation

Make sure [flakes are enabled on your system](https://nixos.wiki/wiki/Flakes#Installing_flakes). 

```sh
nix develop
home-manager switch --flake .#<profile>
```

where `<profile>` is your desired profile.

## Profiles

Different profiles are available in the `profiles` directory. Namely `minimal` for TUI, `graphical` for GUI and `desktop` for GUI and DE. Each profile is a superset of the other. 

## Usage as module

You can use this flake as a module to your home-manager configuration or your NixOS configuration.

### NixOS module

To use as a nixos module
``` nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    nix-config.url = "github:xgroleau/nix-config";
  };

  outputs = { nixpkgs, home-manager, dotfiles, ... }: {
    nixosConfigurations = {
      example = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nix-config.utils.nixosConfigurationFromProfile {
            username = "xgroleau";
            profile = nix-config.profile.desktop; # Replace with desired config
            # You can use extraSpecialArgs, extraConfig and extraModules to customize
          }
        ];
      };
    };
  };
}
```

### Home-Manager module

To use for your home-manager configuration
``` nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    nix-config.url = "github:xgroleau/nix-config";
  };

  outputs = { nixpkgs, home-manager, dotfiles, ... }: {
    homeConfigurations = {
      example = nix-config.utils.homeConfigurationFromProfile {
        system = "x86_64-linux";
        username = "xgroleau";
        profile = nix-config.profiles.desktop;
        # You can use extraSpecialArgs, extraConfig and extraModules to customize
      };
    };
  };
}
```

## Checks

To check formatting with [nixfmt](https://github.com/serokell/nixfmt) and analyze with [statix](https://github.com/nerdypepper/statix) you can run

```sh
nix flake check
```

Or to apply the changes directly, you can run.
``` sh
nix run .#fmt
```

