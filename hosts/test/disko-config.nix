{ lib, ... }:
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/change/this";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1G";
              type = "EF00";
              label = "boot";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            luks = {
              size = "100%";
              label = "cryptroot";
              content = {
                type = "luks";
                name = "cryptroot";
                settings = {
                  allowDiscards = true;
                };
                # -----
                # passwordFile = "/tmp/luks.key"; # if not set then you will ask by the cli automatically
                # -----
                # extraOpenArgs = [ ];
                # settings = {
                    # if you want to use the key for interactive login be sure there is no trailing newline
                    # for example use `echo -n "password" > /tmp/secret.key`
                    # keyFile = "/home/nixos/nixos/key.key";
                    # allowDiscards = true;
                # };
                # additionalKeyFiles = [ "/tmp/additionalSecret.key" ];
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  subvolumes = {
                    "/root" = {
                      mountpoint = "/";
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                    "/nix" = {
                      mountpoint = "/nix";
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                    "/home" = {
                      mountpoint = "/home";
                      mountOptions = [ "compress=zstd" ];
                    };
                    # Nested subvolumes unter /home/user
                    # These need explicit mountpoints because /home/user is not mounted as a subvolume
                    "/home/user/life" = {
                      mountpoint = "/home/user/life";
                      mountOptions = [ "compress=zstd" ];
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}