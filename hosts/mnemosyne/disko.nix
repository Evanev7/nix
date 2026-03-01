{
  disko.devices.disk.media = {
    type = "disk";
    device = "/dev/disk/by-id/ata-WDC_WD10JUCT-63CYNY0_WD-WXP1EA52U942";
    content.type = "gpt";
    content.partitions = {
      storage = {
        size = "100%";
        content = {
          type = "btrfs";
          extraArgs = [ "-f" ];
          mountpoint = "/storage";
          mountOptions = [
            "compress=zstd"
            "noatime"
          ];
        };
      };
    };
  };
}
