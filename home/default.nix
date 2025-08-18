
{ inputs, hostname, unstable, ... }:
{
  
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];
  
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs hostname unstable; };
  };

  home-manager.users.user =  import ./home.nix;

}