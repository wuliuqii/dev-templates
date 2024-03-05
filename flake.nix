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

        gtk-rs = {
          path = ./gtk-rs;
          description = "Gtk development evironment";
        };

        wayland-rs = {
          path = ./wayland-rs;
          description = "Wayland development evironment";
        };

        typescript = {
          path = ./typescript;
          description = "TypeScript development environment";
        };
      };
    };
}
