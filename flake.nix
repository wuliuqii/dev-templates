{
  description = "My personal nix flake dev templates";

  outputs = { self }:
    {
      templates = {
        rust = {
          path = ./rust;
          description = "Rust development environment";
        };
      };
    };
}
