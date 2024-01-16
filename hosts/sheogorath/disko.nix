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
                pool = "vault";
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
                pool = "vault";
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
                pool = "vault";
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
                pool = "vault";
              };
            };
          };
        };
      };
    };
    zpool = {
      vault = {
        type = "zpool";
        mode = "raidz";
        rootFsOptions = {
          compression = "zstd";
          acltype = "posixacl";
          dnodesize = "auto";
          mountpoint = "none";
          canmount = "off";
          xattr = "sa";
          "com.sun:auto-snapshot" = "false";
        };
        options = {
          ashift = "12";
          autotrim = "on";
        };

        datasets = {

          # Small data frequently accessed data like config with snapshots
          data = {
            type = "zfs_fs";
            options = {
              compression = "zstd";
              mountpoint = "legacy";
              relatime = "off";
              "com.sun:auto-snapshot" = "true";
            };
          };

          # General use with snapshot
          storage = {
            type = "zfs_fs";
            mountpoint = "/storage";
            options = {
              compression = "zstd";
              mountpoint = "legacy";
              atime = "on";
              relatime = "on";
              "com.sun:auto-snapshot" = "true";
            };
          };

          # For media, no snapshot
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
