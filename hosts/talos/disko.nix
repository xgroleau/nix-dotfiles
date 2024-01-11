{ ... }:
{
  disko.devices = {
    disk = {
        boot = {
            type = "disk";
            device = "/dev/disk/by-id/ata-Samsung_SSD_850_EVO_500GB_S21HNXAG817146W";
            content = {
                type = "gpt";
                partitions = {
                    ESP = {
                        size = "64M";
                        type = "EF00";
                        content = {
                            type = "filesystem";
                            format = "vfat";
                            mountpoint = "/boot";
                        };
                    };
                    root = {
                        size = "100%";
                        content = {
                            type = "filesystem";
                            format = "ext4";
                            mountpoint = "/";
                        };
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
            device = "/dev/disk//by-id/ata-WDC_WD80EAZZ-00BKLB0_WD-CA24G8HK";
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
            device = "/dev/disk//by-id/ata-WDC_WD80EAZZ-00BKLB0_WD-CA24GG5K";
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
        };
        mountpoint = "/storage";

        datasets = {
          vault = {
            type = "zfs_fs";
            mountpoint = "/storage/vault";
          };
        };
      };
    };
  };
}