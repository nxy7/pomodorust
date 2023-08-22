{
  description = "Project starter";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    devshell.url = "github:numtide/devshell";
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
      imports = [ inputs.devshell.flakeModule ];
      systems = [ "x86_64-linux" ];
      perSystem = { config, system, ... }:
        let
          pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [ (import inputs.rust-overlay) ];
            config.allowUnfree = true;
          };
          porsmoPkg = pkgs.rustPlatform.buildRustPackage rec {
            pname = "porsmo";
            version = "0.2.2";

            cargo = pkgs.rust-bin.beta.latest.minimal;
            rustc = pkgs.rust-bin.beta.latest.minimal;
            RUST_SRC_PATH =
              "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";

            src = ./.;
            nativeBuildInputs = with pkgs; [ pkg-config ];
            buildInputs = with pkgs; [ alsa-lib ];

            cargoSha256 = "/crpLUk6Q88lGLQOGSK61NQC32ekxcORiEBxgoFhzX8=";

            meta = with pkgs.lib; {
              description = "Pomodoro app";
              homepage = "https://github.com/BurntSushi/ripgrep";
              license = licenses.unlicense;
              maintainers = [ maintainers.tailhook ];
            };
          };

        in {
          packages.default = porsmoPkg;
          # devshells.default = {
          #   env = [{
          #     name = "RUST_SRC_PATH";
          #     value = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
          #   }];

          #   packages = with pkgs; [

          #   ];
          # };
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              gcc
              rust-bin.beta.latest.default
              rust-analyzer
              pkg-config
              alsa-lib
            ];
          };
        };
    };
}
