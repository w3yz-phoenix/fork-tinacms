{
  description = "A flake that outputs PHP with memcached and ds extension and hello pkg.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages = {
          t = pkgs.writeScriptBin "t" ''
            deno task -c "$DEVBOX_PROJECT_ROOT/tooling/deno.json" t "$@"
          '';

          td = pkgs.writeScriptBin "td" ''
            deno task -c "$DEVBOX_PROJECT_ROOT/tooling/deno.json" td "$@"
          '';
        };
      });
}
