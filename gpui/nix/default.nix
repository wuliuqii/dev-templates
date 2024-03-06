{ rustPlatform
, wayland
, libxkbcommon
, pkg-config
, fontconfig
, xorg
, openssl
, vulkan-loader
, freetype
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
    outputHashes = {
      "blade-graphics-0.3.0" = "sha256-sDq1EmXnXfMQ3SQQ+yvwpFo4fN0VGavTCE4JMjKGkcQ=";
      "collections-0.1.0" = "sha256-4kSXDjT40PNJmGm5HB+hOws8BZNlhdCn3qB8aX3lvwY=";
      "font-kit-0.11.0" = "sha256-+4zMzjFyMS60HfLMEXGfXqKn6P+pOngLA45udV09DM8=";
      "taffy-0.3.11" = "sha256-0hXOEj6IjSW8e1t+rvxBFX6V9XRum3QO2Des1XlHJEw=";
    };
  };

  buildInputs = [
    wayland
    libxkbcommon
    fontconfig
    xorg.libxcb
    openssl
    freetype
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  postFixup = ''
    patchelf --add-rpath ${vulkan-loader}/lib $out/bin/* 
  '';

  doCheck = false;
}
