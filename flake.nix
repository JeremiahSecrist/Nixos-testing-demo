{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs:
    with inputs; let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
    in
    {
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
        pre-commit-check = pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            nixpkgs-fmt.enable = true;
            deadnix.enable = true;
            nil.enable = true;
            statix.enable = true;
            # trailing_whitespace_fixer.enable = true;
            convco.enable = true;
          };
        };
      };
    };
}
