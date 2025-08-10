{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      nodejsVersion = 22; # Change this to update the whole stack
      overlays = [
        (final: prev: {
          nodejs = prev."nodejs_${toString nodejsVersion}";
          typescript-language-server = prev.nodePackages.typescript-language-server;
        })
      ];

      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSupportedSystem =
        f:
        nixpkgs.lib.genAttrs supportedSystems (
          system: f { pkgs = import nixpkgs { inherit overlays system; }; }
        );
    in
    {
      devShells = forEachSupportedSystem (
        { pkgs }:
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              node2nix

              nodejs
              nodePackages.rush

              pnpm
              typescript
              typescript-language-server
            ];
          };
        }
      );
    };
}
