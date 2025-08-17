{ config, pkgs, lib, unstable, ... }:
{
  options = {
    gnome.enable = lib.mkEnableOption "enable gnome settings";
  };

  config = lib.mkIf config.gnome.enable {
    # https://heywoodlh.io/nixos-gnome-settings-and-keyboard-shortcuts
    dconf.settings = {
      "org/gnome/desktop/session" = {
        idle-delay = (lib.hm.gvariant.mkUint32 0);
      };
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
      "org/gnome/desktop/interface" = {
        gtk-theme = "Adwaita-dark";
        show-battery-percentage = true;
      };
      "org/gnome/settings-daemon/plugins/power" = {
        idle-dim = false;
        sleep-inactive-ac-timeout = 0;
        sleep-inactive-battery-timeout = 0;
      };
      "org/gnome/shell" = {
        disable-user-extensions = false;
        disabled-extensions = "disabled";
        enabled-extensions = [
          "executor@raujonas.github.io"
          "ddterm@amezin.github.com"
          "smart-auto-move@khimaros.com"
          "trayIconsReloaded@selfmade.pl"
          "tiling-assistant@leleat-on-github"
          "docker@stickman_0x00.com"
          "clipboard-indicator@tudmotu.com"
          "window-thumbnails@G-dH.github.com"
        ];
        favorite-apps = [ "nautilus.desktop" "foot.desktop" "vivaldi-stable.desktop" "code.desktop" "lorien.desktop" "OrcaSlicer.desktop" ];
      };
      # settings for the individual gnome extensions
      # info: https://github.com/nix-community/home-manager/blob/master/modules/lib/gvariant.nix
      "org/gnome/shell/extensions/executor" = {
        click-on-output-active = false;
        left-active = false;
        left-index = 0;
        center-active = false;
        center-index = 0;
        right-active = true;
        right-index = 0;
        right-commands-json = ''{"commands":[{"isActive":true,"command":"kubectx --current","interval":2,"uuid":"571f4628-36a3-4dd2-835e-6e9d54c16a70"},{"isActive":true,"command":"echo '     '","interval":60,"uuid":"22ef901b-249d-454a-b213-b5af919c1a36"},{"isActive":true,"command":"df -h / | awk 'NR==2 {print $4 \" / \" $2}'","interval":10,"uuid":"44022451-123c-4803-b605-e7c6926f3793"}]}'';
      };
      "org/gnome/shell/extensions/docker" = {
        quicksettings-columns = 1;
        terminal = ''foot -e /run/current-system/sw/bin/bash -c'';
      };
      "com/github/amezin/ddterm" = {
        window-position = "top";
        audible-bell = false;
        shortcuts-enabled = true;
        panel-icon-type = "toggle-and-menu-button";
        window-size = (lib.hm.gvariant.mkDouble "0.6");
        ddterm-toggle-hotkey = (lib.hm.gvariant.mkArray lib.hm.gvariant.type.string ["<SHIFT><Control><Alt>a"]);
        shortcut-terminal-copy = (lib.hm.gvariant.mkArray lib.hm.gvariant.type.string ["<Control>c"]);
        shortcut-terminal-paste = (lib.hm.gvariant.mkArray lib.hm.gvariant.type.string ["<Control>v"]);
        shortcut-background-opacity-inc = (lib.hm.gvariant.mkArray lib.hm.gvariant.type.string ["<Control><SHIFT>plus"]);
        shortcut-background-opacity-dec = (lib.hm.gvariant.mkArray lib.hm.gvariant.type.string ["<Control><SHIFT>-"]);
      };
      # custom window keybindings shortcuts
      "org/gnome/desktop/wm/keybindings" = {
        switch-to-workspace-up = [];
        switch-to-workspace-down = [];
        maximize = ["<Control><Alt>UP"];
        unmaximize = ["<Control><Alt>DOWN"];
      };
      # custom keybindings shortcuts
      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5/"
        ];
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        name = "terminal";
        command = "foot";
        binding = "<Ctrl><ALT>T";
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
        name = "flameshot";
        command = "flameshot gui";
        binding = "<SHIFT><Ctrl><ALT>F";
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
        name = "jdownloader";
        command = "java -jar /home/user/.jdownloader2/JDownloader.jar";
        binding = "<SHIFT><Ctrl><ALT>J";
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
        name = "open nixos package webside";
        command = "foot nvim";
        binding = "<SHIFT><Ctrl><ALT>N";
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4" = {
        name = "call function to bind storage";
        command = "/run/current-system/sw/bin/bash -c 'bash -i -c \"bindstorage\"'";
        binding = "<SHIFT><Ctrl><ALT>P";
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5" = {
        name = "vivaldi";
        command = "vivaldi";
        binding = "<SHIFT><Ctrl><ALT>V";
      };
    };
  };

}