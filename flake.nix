{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs = {nixpkgs.follows = "nixpkgs";};
    };
  };

  outputs = {
    nixpkgs,
    utils,
    rust-overlay,
    ...
  }:
    utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [(import rust-overlay)];
      };

      toolchain = pkgs.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml;
    in {
      devShells.default = pkgs.mkShell {
        nativeBuildInputs = [toolchain];
      };
    });
}
