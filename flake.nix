{
  description = "P1 nix configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # flake-utils.url = "github:numtide/flake-utils"; 
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }: {
  overlays = {
    docker-overlay = final: prev: {
      docker = prev.docker.overrideAttrs (oldAttrs: rec {
        version = "20.10.21";
	src = final.fetchFromGitHub {
	  owner = "moby";
	  repo = "moby";
	  rev = "3056208812eb5e792fa99736c9167d1e10f4ab49";
	  sha256 = "00000000000000000000000000";
	};
      });
    };
  };
      nixosConfigurations.kaiserP1 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
	  specialArgs = { inherit self; };
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
