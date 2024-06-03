# Nix Dotfiles

My declarative dotfiles configuration using [nix](https://nixos.org/) and [home-manager](https://github.com/nix-community/home-manager) to manage my systems.

This configuration **should** work in all distribution in theory, but because nixpkgs has some issue with opengl, some features may not work. Namely `alacritty` and `picom` won't be able to launch if you are not using NixOS.

## Installation

### Home manager

Make sure [flakes are enabled on your system](https://nixos.wiki/wiki/Flakes#Installing_flakes). 

```sh
nix develop
home-manager switch --flake .#<profile>
```

where `<profile>` is your desired profile.

### NixOS

Simply run the command with flakes enabled to get my full NixOS configuration

 ```sh
 sudo nixos-rebuild switch --flake .#<host>
 ```

#### Hosts

Diffrent hosts are available.

##### Namira

My old Ideapad Y580 from 2012. A thick boy but still fully functionning. NixOS gave it a breath of fresh air. 

##### Azura

My main tower for development, work and games.

##### Sheogorath

Server for hosting a couple services for the family and myself.

##### Jyggalag

The free tier oracle A1 vm. For doing random projects and monitors `Sheogorath`.

### Nix-Darwin

Only one configuration is available for MacOS for now.

```sh
nix develop
darwin-rebuild switch --flake .#
```

## Profiles

Different profiles are available in the `profiles` directory. Namely `minimal` for TUI headless server, `dev` for headless development, `graphical` for GUI and `desktop` for GUI and DE. Each profile is a superset of the other.

## Usage as module

You can use this flake as a module to your home-manager configuration or your NixOS configuration.

### NixOS module

  * [ ] To use as a nixos module

``` nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    nix-dotfiles.url = "github:xgroleau/nix-dotfiles";
  };

  outputs = { nixpkgs, home-manager, nix-dotfiles, ... }: {
    nixosConfigurations = {
      example = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nix-dotfiles.nixosModules
          # Enable some modules
          {
            modules.kdeconnect.enable = true;
          }
        ];
      };
    };
  };
}
```

### Home-Manager module

To use for your home-manager configuration.

``` nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    nix-dotfiles.url = "github:xgroleau/nix-dotfiles";
  };

  outputs = { nixpkgs, home-manager, nix-dotfiles, ... }: {
    homeConfigurations = {
      example = nix-dotfiles.utils.homeConfigurationFromProfile {
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${flake-utils.lib.system.x86_64-linux};
          modules = [ 
            nix-dotfiles.homeManagerModules
            # Enable some modules
            {
              # Minimum HM requirements
              home = {
                username = "xgroleau";
                homeDirectory = "/home/xgroleau";
                stateVersion = "23.11";
              };
              modules.shell.zsh.enable = true;
            }
          ];
      };
    };
  };
}
```

## Checks

To check formatting with [nixfmt](https://github.com/NixOS/nixfmt) and analyze with [statix](https://github.com/nerdypepper/statix) you can run

```sh
nix flake check
```

Or to apply the changes directly, you can run.

``` sh
nix run .#fmt
```
