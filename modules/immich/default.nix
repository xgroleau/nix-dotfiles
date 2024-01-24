{ config, lib, pkgs, ... }:

let
  photosLocation = "/mnt/immich";
  modelCacheLocation = "/mnt/immich/cache";
  environment = { };

  serverImage = "ghcr.io/immich-app/immich-server";
  serverVersion = "v1.92.1";
  serverHash =
    "sha256:f659948d22515f31704a726e0ea8fd36372d3110d8331a1454e59d2f9a134c6c";

  machineLearningImage = "ghcr.io/immich-app/immich-machine-learning";
  machineLearningVersion = "v1.92.1";
  machineLearningHash =
    "sha256:d150a0de5d30861aa309c2b23f487781bf9dc9502bf9e2587d098acd074aae2e";
in {

  virtualisation.oci-containers.containers = {
    immich_server = {
      autoStart = true;
      image = "${serverImage}:${serverVersion}@${serverHash}";
      cmd = [ "start.sh" "immich" ];
      volumes = [
        "/etc/localtime:/etc/localtime:ro"
        "${photosLocation}:/usr/src/app/upload"
      ];
      environment = environment; # TODO:
      ports = [ "3001:3001" ];
      dependsOn = [ "redis" "database" ];
    };

    immich_micro_service = {
      autoStart = true;
      image = "${serverImage}:${serverVersion}@${serverHash}";
      cmd = [ "start.sh" "immich" ];
      volumes = [
        "/etc/localtime:/etc/localtime:ro"
        "${photosLocation}:/usr/src/app/upload"
      ];
      environment = environment; # TODO:
      dependsOn = [ "redis" "database" ];
    };

    immich_machine_learning = {
      autoStart = true;
      image =
        "${machineLearningImage}:${machineLearningVersion}@${machineLearningHash}";
      volumes = [ "${modelCacheLocation}:/cache" ];
      environment = environment; # TODO:
      dependsOn = [ "redis" "database" ];
    };

  };

  networking.firewall = {
    allowedTCPPorts = [ 3001 ];
    allowedUDPPorts = [ 3001 ];
  };

}
