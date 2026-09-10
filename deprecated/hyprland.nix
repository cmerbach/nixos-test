{ config, lib, pkgs, unstable, ... }:
{

  # enable hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # display manager
  services.xserver = {
    enable = true;
    displayManager = {
      gdm = {
        enable = true;
        wayland = true;
      };
    };
  };

  # xdg portal for wayland - automatic in gnome
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # hardware acceleration - automatic in gnome
  hardware.graphics = {
    enable = true;
  };

  # fonts for JaKooLit waybar 
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fantasque-sans-mono
  ];

  # list packages installed in system profile
  # nix search wget
  environment.systemPackages = with pkgs; [
    #
  ];

}
