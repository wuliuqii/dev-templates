{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      eachSystem = f:
        nixpkgs.lib.genAttrs supportedSystems (system: f {
          pkgs = import nixpkgs { inherit system; };
        });
    in
    {
      devShells = eachSystem ({ pkgs }: {
        default = pkgs.mkShell (with pkgs; rec {
          nativeBuildInputs = [
            pkg-config
            mold
            clang
          ];

          buildInputs = [
            udev
            alsa-lib
            vulkan-loader
            libxkbcommon
            wayland # To use the wayland feature
          ];

          LD_LIBRARY_PATH = "${lib.makeLibraryPath buildInputs}";
        });
      });
    };
}
