{ config, pkgs, lib, unstable, ... }:
{
  options = {
    additional.enable = lib.mkEnableOption "enable additional module";
  };

  config = lib.mkIf config.additional.enable {
    home.packages = with pkgs; [
      android-studio # official ide for android
        # https://nixos.org/manual/nixpkgs/unstable/#using-androidenv-with-android-studio
        (pkgs.androidenv.composeAndroidPackages { 
          cmdLineToolsVersion = "8.0";
          toolsVersion = "26.1.1";
          platformToolsVersion = "36.0.0";
          buildToolsVersions = [ "36.0.0" ];
        }).androidsdk
      ansible # open source it automation engine (automates provisioning, configuration, deployment, orchestration ...)
      arduino-ide # open source electronics prototyping platform
      blender # 3d creation and animation system
      brave # privacy-oriented browser
      exercism # g based command line tool for exercism.io
      flutter # googles sdk for building mobile, web and desktop with dart
      go # golang programming language
        gopls # official language server for the Go language
        tinygo # go compiler for small places - mbedded systems and microcontroller
      libsForQt5.kdenlive # free and open source cross-platform video editing program
      kicad # open source electronics design automation suite
      libreoffice # free and open-source office productivity software suite
      parted # create, destroy, resize, check, and copy partitions
      simplescreenrecorder # screen recorder for linux like obs
      sshpass # non-interactive ssh password auth
      openscad # 3D parametric model compiler
      orca-slicer # G-code generator for 3D printers (Bambu, Prusa, Voron, VzBot, RatRig, Creality, etc.) - alternative bambu-studio # software and slicer for bambuLab 3d printers
      simple-scan # simple scanning utility
      telegram-desktop # telegram desktop messaging app
      zenity # tool to display gui dialogs from the commandline and shell scripts
      megatools # command line client for mega.nz
      pv # tool for monitoring the progress of data through a pipeline
      yt-dlp # cli tool to download videos from youtube
      xbindkeys-config # graphical interface for configuring xbindkeys
      xorg.xhost # used to add and delete host names or user names to the list allowed to make connections to the X server
    ] ++ (with unstable; [
      #
    ]);
  };

}
