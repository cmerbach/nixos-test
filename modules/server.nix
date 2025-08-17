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
      "dialout" # arduino permission for /dev/ttyUSB0
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

  # enable displaylink and the usage of monitors via displayport
  # ---(pre install steps)---
  # nix-prefetch-url --name displaylink-580.zip https://www.synaptics.com/sites/default/files/exe_files/2023-08/DisplayLink%20USB%20Graphics%20Software%20for%20Ubuntu5.8-EXE.zip
  # sudo systemctl start dlm.service
  # -----
  # services.xserver.videoDrivers = [ "displaylink" "modesetting" ];
  # ---

  # Pick only one of the below networking options.
  # or use unmanaged for both
  # networking.networkmanager.unmanaged = [ "wlp3s0" ];
  # Enables wireless support via wpa_supplicant
  # networking.wireless.enable = true;
  # networking.wireless.interface = [ "wlp3s0" ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release (first version of NixOS you have
  # installed on this particular machine) from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  
  # system.stateVersion = "24.11"; # define in flake.nix

}
