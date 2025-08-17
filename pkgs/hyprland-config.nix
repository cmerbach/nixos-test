{ config, pkgs, lib, unstable, ... }:
{
  options = {
    hyprland.enable = lib.mkEnableOption "enable hyprland settings";
  };

  config = lib.mkIf config.hyprland.enable {

    home.packages = with pkgs; [
      gnome-console 
      waybar 
      krabby          # Pokémon ASCII art
      rofi-wayland    # App launcher (rofi gefunden)
      swww            # Wallpaper daemon (swww gefunden)
      nwg-look        # GTK Theme manager (nwg-look gefunden)
      # Weitere JaKooLit Dependencies
      imagemagick     # Für Wallpaper-Effekte
      cava            # Audio visualizer
      playerctl       # Media control
      brightnessctl   # Brightness control
      networkmanager  # Network management
      blueman         # Bluetooth manager
      pavucontrol     # Audio control
      # Weather und Scripts Dependencies  
      python3         # Für Weather.py
      curl            # Für API calls
      jq              # JSON processing
      # System monitoring
      htop
      fastfetch    # System info (modern neofetch)
    ];

    # Automatically download and install Waybar configs
    home.activation.waybar-setup = lib.hm.dag.entryAfter ["writeBoundary"] ''
      echo "Setting up JaKooLit Waybar configs..."
      
      # Create waybar config directory
      mkdir -p $HOME/.config/waybar/{configs,styles}
      
      # Download only necessary files
      ${pkgs.curl}/bin/curl -L https://raw.githubusercontent.com/JaKooLit/Hyprland-Dots/Ubuntu-24.04-Dots/config/waybar/Modules -o $HOME/.config/waybar/Modules
      ${pkgs.curl}/bin/curl -L https://raw.githubusercontent.com/JaKooLit/Hyprland-Dots/Ubuntu-24.04-Dots/config/waybar/ModulesWorkspaces -o $HOME/.config/waybar/ModulesWorkspaces
      ${pkgs.curl}/bin/curl -L https://raw.githubusercontent.com/JaKooLit/Hyprland-Dots/Ubuntu-24.04-Dots/config/waybar/ModulesCustom -o $HOME/.config/waybar/ModulesCustom
      ${pkgs.curl}/bin/curl -L https://raw.githubusercontent.com/JaKooLit/Hyprland-Dots/Ubuntu-24.04-Dots/config/waybar/ModulesGroups -o $HOME/.config/waybar/ModulesGroups
      ${pkgs.curl}/bin/curl -L https://raw.githubusercontent.com/JaKooLit/Hyprland-Dots/Ubuntu-24.04-Dots/config/waybar/UserModules -o $HOME/.config/waybar/UserModules
      
      # Download config and style
      ${pkgs.curl}/bin/curl -L "https://raw.githubusercontent.com/JaKooLit/Hyprland-Dots/Ubuntu-24.04-Dots/config/waybar/configs/%5BTOP%5D%20Default%20Laptop" -o "$HOME/.config/waybar/configs/[TOP] Default Laptop"
      ${pkgs.curl}/bin/curl -L "https://raw.githubusercontent.com/JaKooLit/Hyprland-Dots/Ubuntu-24.04-Dots/config/waybar/style/%5BExtra%5D%20Modern-Combined%20-%20Transparent.css" -o "$HOME/.config/waybar/styles/[Extra] Modern-Combined - Transparent.css"
      
      # Create symlinks
      ln -sf "$HOME/.config/waybar/configs/[TOP] Default Laptop" $HOME/.config/waybar/config
      ln -sf "$HOME/.config/waybar/styles/[Extra] Modern-Combined - Transparent.css" $HOME/.config/waybar/style.css
      
      echo "JaKooLit Waybar configs installed!"
    '';

    # Hyprland config - the clean way!
    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        # Autostart
        exec-once = [
          "waybar"
        ];
        
        # Keybinds
        bind = [
          "SUPER, Return, exec, kitty"
          "SUPER, Q, killactive"
          "SUPER SHIFT, E, exit"
        ];
      };
    };

    # Pokemon terminal in bashrc
    programs.bash.initExtra = ''
      ${pkgs.krabby}/bin/krabby random
      ${pkgs.fastfetch}/bin/fastfetch
    '';

  };

}