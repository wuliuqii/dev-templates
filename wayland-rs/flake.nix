{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, rust-overlay, pre-commit-hooks }:
    let
      overlays = [
        rust-overlay.overlays.default
        (final: prev: {
          rustToolchain =
            prev.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml;
        })
      ];
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      eachSystem = f:
        nixpkgs.lib.genAttrs supportedSystems (system: f {
          pkgs = import nixpkgs { inherit system overlays; };
        });
    in
    {
      packages = eachSystem ({ pkgs }: {
        hello-wayland = pkgs.callPackage ./nix { };
      });

      checks = eachSystem ({ pkgs }: {
        pre-commit-check = pre-commit-hooks.lib.${pkgs.system}.run {
          src = ./.;
          hooks = {
            rustfmt.enable = true;
            clippy.enable = true;
          };
        };
      });

      devShells = eachSystem ({ pkgs }: {
        default = pkgs.mkShell (with pkgs; rec {
          inherit (self.checks.${pkgs.system}.pre-commit-check) shellHook;

          packages = [
            rustToolchain
          ];

          nativeBuildInputs = [
            pkg-config
          ];

          buildInputs = [
            rustToolchain
            wayland
            systemd # For libudev
            seatd # For libseat
            libxkbcommon
            libinput
            mesa # For libgbm
            pango
            libglvnd # For libEGL
          ];

          LD_LIBRARY_PATH = "${lib.makeLibraryPath buildInputs}";
          RUST_SRC_PATH = "${rustToolchain}/lib/rustlib/src/rust/library";
        });
      });
    };
}
