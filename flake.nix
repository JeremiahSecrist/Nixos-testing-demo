{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  outputs = inputs:
    with inputs; let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
    in {
      nixosConfigurations = {
        myNixos = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = with self.nixosModules; [
            myCaddy
            myNixos
          ];
        };
      };
      nixosModules = {
        myCaddy = ./modules/myCaddy.nix;
        myNixos = ./modules/myNixos.nix;
      };
      checks."${system}" = {
        systems = import ./tests {
          inherit pkgs;
          inherit (self) nixosModules;
        };
      };
    };
}
