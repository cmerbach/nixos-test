{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-unstable,
      disko,
      home-manager,
      ...
    }:

  let
    system = "x86_64-linux";
    lib = nixpkgs.lib;
    pkgs = nixpkgs.legacyPackages.${system};
    unstable = import nixpkgs-unstable { inherit system; config.allowUnfree = true; };
    mkHost =
      args@{
        hostname,
        stateVersion,
        extraModules ? [ ],
        homeManagerConfig ? { },
        ...
      }:
      lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs hostname unstable; };
        modules = [
          {
            nixpkgs.config.allowUnfree = true;
            networking.hostName = hostname;
            environment.etc."nixos/flake.nix".source = "/home/user/nixos/flake.nix";
            system.stateVersion = stateVersion;
          }
          ./hosts/${hostname}/hardware-configuration.nix
          ./modules/disko.nix
          ./modules/boot.nix
          ./modules/config.nix
          ./home
          {
            home-manager.users.user = {
              home.stateVersion = args.homeStateVersion or stateVersion;
            } // homeManagerConfig;
          }
        ] ++ extraModules;
      };
    hosts = [
      {
        hostname = "core";
        stateVersion = "26.05";
        homeManagerConfig = {};
      }
      {
        hostname = "test";
        stateVersion = "26.05";
        extraModules = [
          ./modules/gnome.ni
        ];
        homeManagerConfig.gnome.enable = true;
      }
    ];
  in
    {
      nixosConfigurations = lib.listToAttrs (
        map (h: {
          name = h.hostname;
          value = mkHost h;
        }) hosts
      );

      packages.${system} = {
        default = self.packages.${system}.install;

        install = pkgs.writeShellApplication {
          name = "install-local";
          runtimeInputs = with pkgs; [
            cowsay
            git
            pick
          ];
          text = ''
            cowsay -f tux "Starting installation preparation..."

            # ---( download repo )--- #
            if [ ! -d "$REPO" ]; then
              git clone "https://$ACCOUNT@github.com/$ACCOUNT/$REPO.git" 2>/dev/null || \
              git clone "https://$ACCOUNT:$PASSWORD@github.com/$ACCOUNT/$REPO.git"
            fi
            cd "$REPO"
            git checkout "$BRANCH"

            # ---( create hardware config )--- #
            printf "\nChoose a system for install:\n"
            HOSTNAME=$(grep -oP 'hostname\s*=\s*"\K[\w-]+' flake.nix | pick -X)
            printf '%s\n\n' "$HOSTNAME"

            if [ ! -f "hosts/$HOSTNAME/hardware-configuration.nix" ]; then
              nixos-generate-config --no-filesystems --show-hardware-config > "hosts/$HOSTNAME/hardware-configuration.nix"
            fi
            git add .

            # ---( choose disk )--- #
            printf "\nChoose a disk/device for install:\n"
            DISK=$(lsblk -o NAME,SIZE -n | tail -n +2 | pick -X | awk '{print $1}')
            printf '%s\n\n' "$DISK"

            sed -i "s|/dev/change/this|/dev/$DISK|g" "hosts/$HOSTNAME/disko-config.nix"
            git add .

            # ---( formatting the hard drive )--- #
            sudo nix --experimental-features 'nix-command flakes' run "${disko}#disko" -- --yes-wipe-all-disks --mode destroy,format,mount "hosts/$HOSTNAME/disko-config.nix"

            # ---( install nixos )--- #
            cowsay -f dragon "I will burn nixos to your computer"
            sudo nixos-install --no-root-passwd --impure --flake ".#$HOSTNAME"

            git remote set-url origin "$(git remote get-url origin | sed 's|https://github.com/|git@github.com:|')"
            git remote -v

            cd .. && sudo mv "$REPO/" /mnt/home/user/
          '';
        };
      };
    };
}
