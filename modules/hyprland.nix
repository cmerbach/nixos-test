{ config, lib, pkgs, unstable, ... }:
{

    # ---( Enable Hyprland Desktop Environment )---#
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

    # xdg portal for Wayland - automatic in GNOME, manual in Hyprland
    # enables file dialogs, screenshots, etc. in modern apps
    xdg.portal = {
        enable = true;
        wlr.enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };

    # hardware acceleration - automatic in GNOME
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
        # ----- #
        gnome-console 
        waybar 
        krabby           # Pokémon ASCII art
        rofi-wayland     # App launcher (rofi gefunden)
        swww             # Wallpaper daemon (swww gefunden)
        nwg-look         # GTK Theme manager (nwg-look gefunden)
        # Weitere JaKooLit Dependencies
        imagemagick      # Für Wallpaper-Effekte
        cava             # Audio visualizer
        playerctl        # Media control
        brightnessctl    # Brightness control
        networkmanager   # Network management
        blueman          # Bluetooth manager
        pavucontrol      # Audio control
        # Weather und Scripts Dependencies  
        python3          # Für Weather.py
        curl             # Für API calls
        jq               # JSON processing
        # System monitoring
        htop
        fastfetch        # System info (modern neofetch)
   ];

}
