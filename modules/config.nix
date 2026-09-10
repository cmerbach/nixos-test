{ config, lib, pkgs, unstable, ... }:
{

  # enable flakes command
  nix.settings.experimental-features = [ "nix-command flakes" ];
  # enable unfree software
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;
  nixpkgs.config.android_sdk.accept_license = true; 
  # allow insecure software
  nixpkgs.config.permittedInsecurePackages = [
    # "electron-25.9.0"
  ];

  # enable syslog-ng for traditional syslog files (optional)
  services.syslog-ng.enable = true;

  # set your time zone.
  time.timeZone = "Europe/Berlin";

  # enable networking
  networking.networkmanager.enable = true;  
  
  # select internationalisation properties.
  i18n.defaultLocale = "de_DE.UTF-8";  
  
  # configure console keymap
  console.keyMap = "de";

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable CUPS to print documents
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager)
  services.libinput.enable = true;

  # define a user account. Don't forget to set a password with passwd
  users.users.user = {
    isNormalUser = true;
    description = "user"; # managed by home-manager
    hashedPassword = "$6$U3SyXldxX47qXKo9$7IUNCifC7iZp7O6ldKA6gbMtsIuTG0XG0EBKErBD.uURbZ4fbqUgni0SbzlgXXP4phTJuDlh5VEki0HmHwxYs/"; # mkpasswd --method=SHA-512 --stdin
    extraGroups = [
      "adbusers"
      "docker"
      "kvm"
      "libvirtd"
      "networkmanager"
      "wheel" # enables 'sudo' for the user
    ]; 
    # packages = with pkgs; [
    #  firefox
    # ];
  };

  # list packages installed in system profile
  # nix search wget
  environment.systemPackages = with pkgs; [
    git
    openssl
  ];

  environment.interactiveShellInit = ''
    alias nr="git -C /home/user/nixos/ add . && sudo nixos-rebuild --impure switch";
  '';
}
