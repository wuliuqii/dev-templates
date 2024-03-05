# Nix flake templates for my projects

Initialize certain projects with nix flakes in current directory.

## Usage

```shell
nix flake init --template github:wuliuqii/dev-templates#${ENV}
```

example:

```shell
nix flake init --template github:wuliuqii/dev-templates#rust
```

## Available templates

| Language   | Template                   |
| ---------- | -------------------------- |
| rust       | [rust](./rust)             |
| gtk-rs     | [gtk-rs](./gtk-rs)         |
| wayland-rs     | [wayland-rs](./wayland-rs)         |
| go         | [go](./go)                 |
| typescript | [typescript](./typescript) |
