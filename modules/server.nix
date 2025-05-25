{ config, lib, pkgs, ... }:
{

    # enable flakes command
    nix.settings.experimental-features = [ "nix-command flakes" ];
    # enable unfree software
    nixpkgs.config.allowUnfree = true;

boot.loader.grub.device = "nodev";

    # network settings
    networking.networkmanager.enable = true;
    services.openssh.enable = true;
    console.keyMap = "de";

    users.users.user = {
        isNormalUser = true;
        home = "/home/user";
        description = "user";
        hashedPassword = "$6$U3SyXldxX47qXKo9$7IUNCifC7iZp7O6ldKA6gbMtsIuTG0XG0EBKErBD.uURbZ4fbqUgni0SbzlgXXP4phTJuDlh5VEki0HmHwxYs/";
        extraGroups = [ "networkmanager" "wheel" ];
        # packages = with pkgs; [
        #     git
        # ];
    };

    environment.systemPackages = with pkgs; [
        git
    ];

    environment.interactiveShellInit = ''
        alias nr="git -C /home/user/nixos/ add . && sudo nixos-rebuild --impure switch";
    '';

}
