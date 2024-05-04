{inputs, ...}: let
  lib = inputs.nixpkgs.lib;
in rec {
  defaultSystems = {
    linux = "x86_64-linux";
    darwin = "aarch64-darwin";
  };

  systems = [
    "aarch64-linux"
    "x86_64-linux"
    "aarch64-darwin"
    "x86_64-darwin"
  ];
  # ================================================================ #
  # =                            My Lib                            = #
  # ================================================================ #

  # ======================= Package Helpers ======================== #

  pkgsFor = sys: inputs.nixpkgs.legacyPackages.${sys};

  # =========================== Helpers ============================ #
  isLinuxSystem = lib.strings.hasSuffix "-linux";
  isDarwinSystem = lib.strings.hasSuffix "-darwin";

  filesIn = dir: (map (fname: dir + "/${fname}")
    (builtins.attrNames (builtins.readDir dir)));

  dirsIn = dir:
    lib.filterAttrs (name: value: value == "directory")
    (builtins.readDir dir);

  fileNameOf = path: (builtins.head (builtins.split "\\." (baseNameOf path)));

  # ============================ Shell ============================= #
  forAllSystems = lib.genAttrs systems;
}
