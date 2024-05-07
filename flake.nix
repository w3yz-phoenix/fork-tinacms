{
  description = "Nepjua Nix Config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = {...} @ inputs: let
    w3yz = import ./nix/default.nix {inherit inputs;};
  in
    with w3yz; {
      devShell = forAllSystems (system: let
        pkgs = inputs.nixpkgs.legacyPackages.${system};
      in
        with pkgs;
          mkShell {
            name = "w3yz";
            buildInputs = [
              fish
              rsync
              alejandra
              go-task
              nodejs_20
              bun
              tree
            ];
            shellHook = ''
              echo "Welcome in $name"
              export PATH=$HOME/.local/bin:$PATH
              export PATH=$HOME/.console-ninja/.bin:$PATH
            '';
          });

      w3yz.default = w3yz;
      formatter = forAllSystems (system: inputs.nixpkgs.legacyPackages.${system}.alejandra);
    };
}
