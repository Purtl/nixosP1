{
  description = "P1 nix configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }: {
        nixosConfigurations.kaiserP1 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
	    ./p1.nix 
            home-manager.nixosModules.home-manager
            {
              home-manager = {
	        users.tom = import ./home.nix;
                useGlobalPkgs = true;
                useUserPackages = true;
              };
	    }
	  ];
	};		
  };		
}
