{ lib, pkgs, ... }:

let
  inherit (lib) makeExtensible attrValues foldr;
  inherit (modules) mapModules;

  modules = import ./modules.nix {
    inherit lib;
    self.attrs = import ./attrs.nix { inherit lib; self = {}; };
  };

  mylib = import ./option.nix;
in
mylib.extend
  (self: super:
    foldr (a: b: a // b) {} (attrValues super))