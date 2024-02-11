{ inputs, ... }: {
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
  lib = final: prev: { my = import ../lib { inherit (prev) lib; }; };
}