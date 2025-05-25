## disko:
#
# https://github.com/nix-community/disko/blob/master/docs/quickstart.md
# https://github.com/nix-community/disko/tree/master/example
# - https://github.com/nix-community/disko/blob/master/example/luks-lvm.nix
# - https://github.com/nix-community/disko/blob/master/example/btrfs-subvolumes.nix


## nixos-anywhere:
#
# https://github.com/nix-community/nixos-anywhere/blob/main/docs/quickstart.md
# 
# using with nixos-anywhere:
#   sudo nix --extra-experimental-features "nix-command flakes" run github:nix-community/disko#disko-install -- --flake .#test --disk disk1 /dev/sda 


{ inputs, lib, hostname, ... }:
{
    imports = [ 
        inputs.disko.nixosModules.disko
        ../hosts/${hostname}/disko-config.nix
    ];
}
