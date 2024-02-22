{ rustPlatform
, glib
, gtk4
, gtk-layer-shell
, pkg-config
, rustToolchain
,
}:
let
  cargoToml = builtins.fromTOML (builtins.readFile ../Cargo.toml);
in
rustPlatform.buildRustPackage {
  pname = cargoToml.package.name;
  version = cargoToml.package.version;

  src = ../.;

  cargoLock = {
    lockFile = ../Cargo.lock;
  };

  buildInputs = [
    glib
    gtk4
    gtk-layer-shell
  ];

  nativeBuildInputs = [
    pkg-config
    rustToolchain
  ];

  doCheck = false;
}
