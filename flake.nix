{
  description = "My personal nix flake dev templates";

  outputs =
    { self }:
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

        bevy = {
          path = ./bevy;
          description = "Bevy development environment";
        };

        wasm = {
          path = ./wasm;
          description = "Rust wasm development environment";
        };

        rust-project = {
          path = ./rust-project;
          description = "Rust project development environment";
        };

        gtk-rs = {
          path = ./gtk-rs;
          description = "Gtk development evironment";
        };

        wayland-rs = {
          path = ./wayland-rs;
          description = "Wayland development evironment";
        };

        gpui = {
          path = ./gpui;
          description = "Gpui development evironment";
        };

        node = {
          path = ./node;
          description = "Node.js development environment";
        };
      };
    };
}
