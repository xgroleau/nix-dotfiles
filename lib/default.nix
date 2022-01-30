{ lib, pkgs, ... }:

let
  inherit (lib) makeExtensible attrValues foldr;

  mylib = makeExtensible (self: import ./option.nix);
in
mylib.extend
  (self: super:
    foldr (a: b: a // b) {} (attrValues super))