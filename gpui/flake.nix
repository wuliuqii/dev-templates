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
            let
              rust = prev.rust-bin;
            in
            if builtins.pathExists ./rust-toolchain.toml then
              rust.fromRustupToolchainFile ./rust-toolchain.toml
            else if builtins.pathExists ./rust-toolchain then
              rust.fromRustupToolchainFile ./rust-toolchain
            else
              rust.selectLatestNightlyWith (toolchain: toolchain.default.override {
                extensions = [ "rust-src" ];
              });
        })
      ];
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      eachSystem = f:
        nixpkgs.lib.genAttrs supportedSystems (system: f {
          pkgs = import nixpkgs { inherit overlays system; };
        });
    in
    {
      packages = eachSystem ({ pkgs }: {
        hello-gpui = pkgs.callPackage ./nix { };
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
            clang
            # Use mold when we are runnning in Linux
            (lib.optionals stdenv.isLinux mold)

            pkg-config
          ];

          buildInputs = [
            openssl
            fontconfig
            libxkbcommon
            xorg.libxcb
            wayland
            vulkan-loader
            freetype
          ];

          LD_LIBRARY_PATH = "${lib.makeLibraryPath buildInputs}";
          RUST_SRC_PATH = "${rustToolchain}/lib/rustlib/src/rust/library";
        });
      });
    };
}
