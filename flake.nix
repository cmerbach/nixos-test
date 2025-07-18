{
    description = "A very basic flake";
    

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/release-25.05";
        nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
        disko.url = "github:nix-community/disko";
        home-manager = {
            url = "github:nix-community/home-manager/release-25.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };


    outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, disko, home-manager, ... }:
    let
        lib = nixpkgs.lib;
        system = "x86_64-linux";
        pkgs = import nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
        };
        unstable = import nixpkgs-unstable {
            system = "x86_64-linux";
            config.allowUnfree = true; 
        };
    in {


       
        nixosConfigurations.test = let 
            hostname = "test";
        in lib.nixosSystem {
            inherit system;
            specialArgs = { inherit inputs hostname; };
            modules = [
                {
                    networking.hostName = hostname;
                    environment.etc."nixos/flake.nix".source = "/home/user/nixos/flake.nix";
                    system.stateVersion = "25.05";
                }
                ./hosts/${hostname}/hardware-configuration.nix # created on the fly if necessary
                ./modules/disko.nix

                ./modules/boot.nix
                ./modules/desktop.nix
                
            ];
        };


        install = pkgs.writeShellApplication {
            name = "install-local";
            runtimeInputs = with pkgs; [ cowsay git pick ];
            text = ''

                    REPO=nixos-test

                    # nix-collect-garbage -d

                # ---( downlaod repo )--- #
                    cowsay -f tux I will start the preparation for the install
                    git clone https://"$ACCOUNT"@github.com/"$ACCOUNT"/$REPO.git 2> /dev/null || \
                    git clone https://"$ACCOUNT":"$PASSWORD"@github.com/"$ACCOUNT"/$REPO.git 2> /dev/null
                    cd $REPO
                    git checkout "$BRANCH"

                # ---( create hardware config )--- #
                    printf "\nChoose a system for install:\n"
                    HOSTNAME=$(grep -oP 'nixosConfigurations\.\K[\w-]+' flake.nix | pick -X)
                    export HOSTNAME
                    [ ! -f "hosts/$HOSTNAME/hardware-configuration.nix" ] && nixos-generate-config --no-filesystems --show-hardware-config > hosts/"$HOSTNAME"/hardware-configuration.nix
                    git add .

                # ---( choose disk )--- #
                    printf "\nChoose a disk/device for install the system:\n" && \
                    DISK=$(lsblk -o NAME,SIZE -n | tail -n +2 | pick -X | awk '{print $1}') && \
                    printf '%s\n\n' "$DISK"
                    sed -i 's|/dev/change/this|/dev/'"$DISK"'|g' hosts/"$HOSTNAME"/disko-config.nix
                    git add .

                # ---( formatting the hard drive )--- #
                    sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --yes-wipe-all-disks --mode destroy,format,mount hosts/"$HOSTNAME"/disko-config.nix
                            
                # ---( install nixos )--- #
                    cowsay -f dragon I will burn nixos to your computer
                    sudo nixos-install --no-root-passwd --impure --flake .#"$HOSTNAME"
                    git remote -v | head -n1 | sed 's/https:\/\/github.com\//git@github.com:/' | awk '{print $2}' | xargs -I {} git remote set-url origin {}
                    git remote -v
                    cd .. && sudo mv $REPO/ /mnt/home/user/
            '';
        };
    };
}
