{
  description = "Biological Foundation Models packaged with Nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      imports = [ inputs.treefmt-nix.flakeModule ];

      flake.overlays.default = import ./overlays;

      perSystem =
        { pkgs, system, ... }:
        {
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            config.allowUnfree = true;
            overlays = [ inputs.self.overlays.default ];
          };

          packages = {
            inherit (pkgs.python3Packages) fair-esm;
          };

          devShells.default = pkgs.mkShellNoCC {
            packages = [
              pkgs.nix-update
              pkgs.nix-prefetch-scripts
              pkgs.jq
              pkgs.gh
            ];
            shellHook = "export PRJ_ROOT=$PWD";
          };

          treefmt = {
            projectRootFile = "flake.nix";
            programs = {
              nixfmt.enable = true;
              deadnix.enable = true;
              statix.enable = true;
              keep-sorted.enable = true;
              ruff-check.enable = true;
              ruff-format.enable = true;
            };
          };
        };
    };
}
