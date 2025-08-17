{ config, pkgs, lib, exec, hostname, unstable, ... }:

  let
    # list of possible modules
    allModules = [
      ../pkgs/additional.nix
      ../pkgs/base.nix
      ../pkgs/gnome-config.nix
      ../pkgs/hyprland-config.nix
      ../pkgs/python.nix
      ../pkgs/test.nix
      ../pkgs/vscode.nix
      ../pkgs/work.nix
      ../hosts/${hostname}/host.nix
    ];
  in {

    # default import options of the imports (only set if modules exist)
    imports = builtins.filter builtins.pathExists allModules;

    # set default import options of the imports - e.g.:
    # additional.enable = lib.mkDefault false;

    # home manager needs some information about you and the paths it should manage
    home.username = "user";
    home.homeDirectory = lib.mkForce "/home/user";

    # system packages for user environment
    home.packages = with pkgs; [
      # Add packages here - e.g.:
      # pkgs.hello
      #
      # create simple shell scripts directly:
      # add a command 'my-hello' to your environment - e.g.:
      # (pkgs.writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')  
    ];

    # bashrc
    programs.bash = {
      enable = true;
      enableCompletion = true;

      # set some aliases
      shellAliases = {
        # basis
        ll = "ls -al";
        # docker
        dca = "docker container ls -a";
        drm = "docker container rm -f";
        # kubectl
        kx = "kubectx";
        # nixos
        nr = "git -C /home/user/nixos/ add . && sudo nixos-rebuild --impure switch && source /home/user/.bashrc";
        nu = "git -C /home/user/nixos/ add . && rm -f rm /home/user/.config/mimeapps.list && sudo nix flake update --flake '/home/user/nixos' && sudo nixos-rebuild --impure switch && source /home/user/.bashrc";
        ng = "sudo nix-collect-garbage -d";
        # git
        ga = "git add .";
        gaa = "git add . && git commit --amend";
        gsm = "git switch main";
        gp = "git push --force-with-lease";
        gpp = "git pull --rebase";
        gr = "git rebase -i main";
        gs = "git status";
        # youtube-dl
        yt  = "yt-dlp";
        yt3 = "yt-dlp --extract-audio --audio-format mp3";
      };
    };

    # git
    programs.git = {
      enable = true;
    };

    # set default application
    xdg.mimeApps = {
      enable = true;
      # search/get info -  e.g.: xdg-mime query default video/mp4
      # cat /home/user/.config/mimeapps.list
      defaultApplications = {
        "default-web-browser" = "vivaldi-stable.desktop";
        "text/html" = "vivaldi-stable.desktop";
        "x-scheme-handler/http" = "vivaldi-stable.desktop";
        "x-scheme-handler/https" = "vivaldi-stable.desktop";
        "x-scheme-handler/about" = "vivaldi-stable.desktop";
        "x-scheme-handler/unknown" = "vivaldi-stable.desktop";
        "application/xhtml+xml" = "vivaldi-stable.desktop";
        "text/plain" = "org.gnome.TextEditor.desktop";
        "application/x-zerosize" = "org.gnome.TextEditor.desktop";
        "application/pdf" = "org.gnome.Evince.desktop";
        "image/jpeg" = "org.nomacs.ImageLounge.desktop";
        "image/jpg" = "org.nomacs.ImageLounge.desktop";
        "image/png" = "org.nomacs.ImageLounge.desktop";
        "video/avi" = "vlc.desktop";
        "video/mp4" = "vlc.desktop";
        "video/mkv" = "vlc.desktop";
        "video/x-matroska" = "vlc.desktop";
      };
    };

    # manage dotfiles and config files
    home.file = {
      # ".bashrc".source = ./dotfiles/bashrc;
      # ".config/waybar/config".source = ./configs/waybar-config;
      # ".Xresources".text = "Xft.dpi: 144";
      # ".tmux.conf".source = ./dotfiles/tmux.conf;
    };

    # environment variables (auto-sourced if shell managed by Home Manager)
    # otherwise manually source: ~/.nix-profile/etc/profile.d/hm-session-vars.sh
    home.sessionVariables = {
      GOPATH = "$HOME/.go";
      # EDITOR = "nvim";
      # BROWSER = "firefox";
    };

    # NOTE: required when working with binary-python-packages without poetry2nix
    home.sessionVariables.LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
    home.sessionVariables.PDM_VENV_BACKEND = "venv";

    # let home manager install and manage itself.
    programs.home-manager.enable = true;

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    #
    # home.stateVersion = "24.11";  # define in flake.nix

}
