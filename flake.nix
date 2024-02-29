{
  description = "P1 nix configuration";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs, ... }: {
        nixosConfigurations.kaiserP1 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./p1.nix ];
	};		
  };		
}
