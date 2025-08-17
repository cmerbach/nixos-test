{ config, pkgs, lib, ... }:
{
  options = {
    python.enable = lib.mkEnableOption "enable python packages global";
  };

  config = lib.mkIf config.python.enable {
    home.packages = with pkgs; [
      (python3.withPackages (python-pkgs: [
        python-pkgs.pandas
        python-pkgs.pip
        python-pkgs.virtualenv
        python-pkgs.identify
        python-pkgs.cfgv
        python-pkgs.pre-commit-hooks
        python-pkgs.ruamel-yaml
      ]))
    ];
  };
}