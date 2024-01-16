{ ... }: {
  disko.devices = {
    disk = {
      boot = {
        type = "disk";
        device =
          "/dev/disk/by-id/ata-Samsung_SSD_850_EVO_500GB_S21HNXAG817146W";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "500M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              end = "-8G";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
            plainSwap = {
              size = "100%";
              content = { type = "swap"; };
            };
          };
        };
      };
      wdc1 = {
        type = "disk";
        device = "/dev/disk/by-id/ata-WDC_WD80EAZZ-00BKLB0_WD-CA227V3K";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "storage";
              };
            };
          };
        };
      };
      wdc2 = {
        type = "disk";
        device = "/dev/disk//by-id/ata-WDC_WD80EAZZ-00BKLB0_WD-CA23ZWHK";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "storage";
              };
            };
          };
        };
      };
      wdc3 = {
        type = "disk";
        device = "/dev/disk/by-id/ata-WDC_WD80EAZZ-00BKLB0_WD-CA24G8HK";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "storage";
              };
            };
          };
        };
      };
      wdc4 = {
        type = "disk";
        device = "/dev/disk/by-id/ata-WDC_WD80EAZZ-00BKLB0_WD-CA24GG5K";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "storage";
              };
            };
          };
        };
      };
    };
    zpool = {
      storage = {
        type = "zpool";
        mode = "raidz";
        rootFsOptions = {
          compression = "zstd";
          mountpoint = "none";
          canmount = "off";
          ashift = "12";
        };

        datasets = {

          # Small data frequently access
          data = {
            type = "zfs_fs";
            options = {
              compression = "zstd";
              mountpoint = "legacy";
              relatime = "off";
            };
          };

          # General use
          storage = {
            type = "zfs_fs";
            mountpoint = "/storage";
            options = {
              compression = "zstd";
              mountpoint = "legacy";
              atime = "on";
              relatime = "on";
            };
          };

          # Media for videos and stuff
          media = {
            type = "zfs_fs";
            mountpoint = "/media";
            options = {
              # media is already compressed generally anyway
              compression = "off";
              mountpoint = "legacy";
              recordsize = "1M"; # for better sequential reads
              atime = "off";
            };

          };
          # As per https://nixos.wiki/wiki/ZFS#Reservations
          reserved = {
            type = "zfs_fs";
            options = {
              canmount = "off";
              refreservation = "10G";
            };
          };
        };
      };
    };
  };
}
