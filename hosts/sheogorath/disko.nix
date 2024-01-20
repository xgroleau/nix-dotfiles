_: {
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
                pool = "zpwdblue0";
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
                pool = "zpwdblue0";
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
                pool = "zpwdblue0";
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
                pool = "zpwdblue0";
              };
            };
          };
        };
      };
    };
    zpool = {
      zpwdblue0 = {
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
          # Small data frequently accessed data like configs. With snapshots and no atime
          vault = {
            type = "zfs_fs";
            mountpoint = "/vault";
            options = {
              mountpoint = "legacy";
              atime = "off";
              "com.sun:auto-snapshot" = "true";
            };
          };

          # Data frequently accessed data that doesn't require snapshots or atime
          # e.g. databases with a solid backup solution
          data = {
            type = "zfs_fs";
            mountpoint = "/data";
            options = {
              mountpoint = "legacy";
              atime = "off";
            };
          };

          # General use with snapshot and atime support
          documents = {
            type = "zfs_fs";
            mountpoint = "/documents";
            options = {
              mountpoint = "legacy";
              atime = "on";
              relatime = "on";
              "com.sun:auto-snapshot" = "true";
            };
          };

          # For media, no snapshot and optimzed for sequential read
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
              refreservation = "20G";
            };
          };
        };
      };
    };
  };
}
