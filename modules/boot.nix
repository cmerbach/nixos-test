{ config, pkgs, ... }: {

    #  boot loader config - https://nixos.wiki/wiki/Bootloader
    boot = {
        loader = {
            systemd-boot.enable = true;
            efi.canTouchEfiVariables = true;
        };

        kernelPackages = pkgs.linuxPackages_latest;
        # boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_5;
        # kernelModules = [ "v4l2loopback" ]; # -> not working on the 30.05.25
        # extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ]; # -> not working on the 30.05.25

        # binfmt.emulatedSystems = [ "aarch64-linux" ]; # https://github.com/plmercereau/nixos-pi-zero-2

        # enable dmesg logging
        kernelParams = [ 
            "loglevel=7" 
            "console=ttyS0,115200n8" # Serielle Console for debugging
            "console=tty0" # important! on the last position - VGA-Console as PRIMARY (letzte = primär)
        ];
    };

    # enable all firmware regardless of license
    hardware.enableAllFirmware = true;

}
