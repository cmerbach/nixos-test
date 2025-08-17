{ config, lib, pkgs, unstable, ... }:
{

  # enable gnome
  services.xserver = {
    # enable = true; enable the X11 windowing system
    # xkb = { # configure keymap in X11
    #   layout = "de";
    #   variant = "";
    # };
    displayManager = {
      gdm = {
        enable = true;
        wayland = true;
      };
    };
    desktopManager = {
      gnome = {
        enable = true;
      };
    };
  };

  # disable pre-installed gnome packages
  environment.gnome.excludePackages = with pkgs; [
    baobab
    epiphany    # web browser
    geary       # email client
    gnome-calculator
    gnome-calendar
    gnome-characters
    gnome-clocks
    # gnome-console
    gnome-contacts
    gnome-font-viewer
    gnome-logs
    gnome-maps
    gnome-music
    gnome-system-monitor
    gnome-terminal
    gnome-tour
    gnome-weather
    simple-scan
    totem
    yelp
  ];

}
