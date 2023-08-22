{
  description = "Project starter";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    # flakeUtils.url = "github:numtide/flake-utils";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        # flake-utils.follows = "flakeUtils";
      };
    };
  };

  outputs = { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      flake = {
        # Put your original flake attributes here.
      };
      systems = [
        # systems for which you want to build the `perSystem` attributes
        "x86_64-linux"
        # ...
      ];
      perSystem = { config, ... }:
        let
          pkgs = import inputs.nixpkgs {
            # inherit overlays;
            config.allowUnfree = true;
          };

        in {

          devShells = {
            default = pkgs.mkShell {
              packages = with pkgs; [
                rust-bin.beta.latest.default
                pkg-config
                alsa-lib
              ];
            };
          };
        };
    };

  # flakeUtils.lib.eachSystem [ "x86_64-linux" ] (system:
  #   let
  #     pkgs = import nixpkgs {
  #       inherit system;
  #       overlays = [ (import rust-overlay) ];
  #       config.allowUnfree = true;
  #     };

  #     # porsmoPkg = pkgs.rustBuilder.makePackageSet {
  #     #   rustVersion = "1.61.0";
  #     #   packageFun = import ./Cargo.nix;
  #     # };

  #   in {
  #     # packages = rec {
  #     #   porsmo = (porsmoPkg.workspace.porsmo { }).bin;
  #     #   default = porsmo;
  #     # };
  #   });
}
