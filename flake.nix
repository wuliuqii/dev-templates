{
  description = "My personal nix flake dev templates";

  outputs = { self }:
    {
      templates = {
        go = {
          path = ./go;
          description = "Go (Golang) development environment";
        };

        rust = {
          path = ./rust;
          description = "Rust development environment";
        };

        typescript = {
          path = ./typescript;
          description = "TypeScript development environment";
        };
      };
    };
}
