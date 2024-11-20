{
  stdenv,
  lib,
  fetchFromGitHub,
  dtc,
  gcc-arm-embedded,
  python3,
  # Options
  overrideDevice ? "msm8916",
  signBootimg ? false,
}:
let
  python = (
    python3.withPackages (p: [
      p.libfdt
      p.pyasn1
      p.pyasn1-modules
      p.pycryptodome
    ])
  );

in
stdenv.mkDerivation rec {
  pname = "lk2nd";
  version = "19.0";

  src = fetchFromGitHub {
    repo = "lk2nd";
    owner = "msm8916-mainline";
    rev = version;
    hash = "sha256-uSvifSRc5O6JtuwT4RkgcyKOiBUMLElqVN74xKNuvI4=";
  };

  nativeBuildInputs = [
    gcc-arm-embedded
    dtc
    python
  ];

  postPatch = ''
    patchShebangs --build lk2nd/scripts/
  '';

  LD_LIBRARY_PATH = "${python}/lib";

  installPhase = ''
    mkdir -p $out/
    cp ./build-lk2nd-${overrideDevice}/lk2nd.img $out
  '';

  makeFlags =
    [
      "lk2nd-${overrideDevice}"
      "LK2ND_VERSION=${version}"
      "LD=arm-none-eabi-ld"
      "TOOLCHAIN_PREFIX=arm-none-eabi-"
    ]
    ++ lib.optionals signBootimg [
      "SIGN_BOOTIMG=1"
    ];
}
