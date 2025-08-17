{ config, pkgs, lib, ... }:
{

  options = {
    base.enable = lib.mkEnableOption "enable base module";
  };

  config = lib.mkIf config.base.enable {
    home.packages = with pkgs; [
      audacity # audio editing and recording software
      btop # monitor of resources
      curl # cli tool for transferring data using various network protocols
      ffmpeg # free and open-source software consisting of a suite of libraries for video, audio, and other multimedia files
      flameshot # free and open-source tool to take screenshots with many built-in features 
      foot # fast, lightweight and minimalistic Wayland terminal emulator
      gh # github cli tool
      gimp # cross-platform image editor
      dconf-editor # gsettings editor for gnome
      gnome-extension-manager # desktop app for managing GNOME shell extensions - command: extension-manager
      gnupg # openpgp implementation
      gzip # gnu zip compression program
      htop # cross-platform interactive process viewe
      iftop # cli system monitor toolfor network traffic
      jdk23 # java currently-supported LTS version of OpenJDK
      libvirt # toolkit to interact with the virtualization capabilities of linux
      lorien # infinite canvas drawing/note-taking app
      usbutils # tools for working with usb devices, such as lsusb
      lvm2 # support logical volume management (lvm) on linux
      mdadm # managing raid arrays under linux
      mkvtoolnix # set of tools used for creating, modifying, and inspecting mkv files
      mpv # free media player for the command line
      nnn # full-featured terminal file manager
      nomacs # free and open source image viewer
      p7zip # command line tool fork of the free 7-zip archive program for posix platforms
      pdfarranger # python-gtk application to merge or split PDF documents
      qemu # generic and open source machine emulator and virtualizer
      solaar #  linux manager for many Logitech devices
      tig # text-mode interface for Git
      tmux # terminal multiplexer
      tree # view directory hierarchy recursively as a tree structure
      unrar # Utility for RAR archives
      vivaldi # powerful, personal and private browser
      vivaldi-ffmpeg-codecs # additional support for proprietary codecs for vivaldi
      vlc # free and open source cross-platform multimedia player
      wget # free software package for retrieving files using HTTP, HTTPS, FTP and FTPS
      xbindkeys # launch shell commands with your keyboard or your mouse under X window
        xdotool # fake keyboard/mouse input, window management, and more
      xournalpp # software for pdf annotation support
      yt-dlp # cli tool to download videos from YouTube (youtube-dl fork)
      zip # Compressor/archiver for creating and modifying zipfiles
    ] ++ (with unstable; [
      # 
    ]);
  };

}