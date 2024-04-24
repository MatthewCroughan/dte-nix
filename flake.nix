{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko-utils.url = "github:matthewcroughan/disko-utils";
  };
  outputs = { nixpkgs, nixos-hardware, disko, disko-utils, self, ... }@inputs: {
    packages.x86_64-linux.gugusar-autoinstaller = disko-utils.mkAutoInstaller {
      nixosConfiguration = self.nixosConfigurations.gugusar;
      flakeToInstall = self;
    };
    nixosConfigurations.gugusar = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        disko.nixosModules.disko
        ./configuration.nix
      ];
    };
  };
}
