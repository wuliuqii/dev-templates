{ rustPlatform
, wayland
, systemd
, seatd # For libseat
, libxkbcommon
, libinput
, mesa # For libgbm
, pango
, libglvnd
, pkg-config
, rustToolchain
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

  nativeBuildInputs = [
    pkg-config
    rustToolchain
  ];

  doCheck = false;
}
