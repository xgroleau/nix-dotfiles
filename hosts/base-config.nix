{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  keys = import ../secrets/ssh-keys.nix;
  overlays = import ../overlays { inherit inputs; };
in
{
  config = {

    # Custom modules
    modules = {
      tailscale.enable = true;
    };

    nixpkgs = {
      config = {
        allowUnfree = true;
        permittedInsecurePackages = [
          "aspnetcore-runtime-6.0.36"
          "aspnetcore-runtime-wrapped-6.0.36"
          "dotnet-sdk-6.0.428"
          "dotnet-sdk-wrapped-6.0.428"
        ];
      };
      overlays = [
        overlays.unstable-packages
      ];
    };

    nix = {

      package = pkgs.nixVersions.latest;
      extraOptions = ''
        experimental-features = nix-command flakes
      '';

      # Avoid always redownloading the registry
      registry.nixpkgsu.flake = inputs.nixpkgs-unstable; # For flake commands
      nixPath = [ "nixpkgsu=${inputs.nixpkgs-unstable}" ]; # For legacy commands
      settings = {
        auto-optimise-store = true;
        trusted-users = [
          "root"
          "@wheel"
        ];
      };
    };

    time.timeZone = "America/Toronto";
    environment.systemPackages = with pkgs; [
      curl
      gitMinimal
      vim
      nano
      wget
    ];

    programs.nix-ld.enable = true;
    programs.zsh.enable = true;
    i18n.defaultLocale = "en_CA.UTF-8";

    # Adding all machines to known host
    programs.ssh.knownHosts = lib.mapAttrs (name: value: { publicKey = value; }) keys.machines;

    users = {
      users.xgroleau = {
        isNormalUser = true;
        shell = pkgs.zsh;
        initialPassword = "nixos";
        extraGroups = [
          "wheel"
          "builder"
          "audio"
          "networkmanager"

          # For embedded development
          "plugdev"
          "dialout"
        ];

        openssh.authorizedKeys.keys = [ keys.users.xgroleau ];
      };
    };

    #Increase number of file descriptor
    systemd.extraConfig = "DefaultLimitNOFILE=32768";
  };
}
