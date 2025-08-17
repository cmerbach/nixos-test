{ config, pkgs, lib, ... }:
{

  options = {
    test.enable = lib.mkEnableOption "enable test module";
  };

  config = lib.mkIf config.test.enable {
    home.packages = with pkgs; [
      solvespace # parametric 3d cad program
      waveterm # open source, cross-platform terminal for seamless workflows
      mouseless # replacement for the mouse in Linux
      warpd
    ];

    programs.neovim = {
      enable = true;
      defaultEditor = true;
    };

    home.sessionVariables = {
      VISUAL = "nvim";
      EDITOR = "nvim";
      SUDO_EDITOR = "nvim";
    };
  };

}
