{ mobile-nixos
, fetchFromGitHub
, ...
}:

mobile-nixos.kernel-builder {
  version = "6.9.6";
  # https://gitlab.com/kaechele/pmaports/-/blob/lenovo-cd-18781y/device/testing/linux-lenovo-cd-18781y/config-lenovo-cd-18781y.aarch64
  configfile = ./config.aarch64;

  src = fetchFromGitHub {
    owner = "kaechele";
    repo = "msm8953-mainline-linux";
    rev = "cfadd1dbceb06d674c04023c66be7ca19e45cf27";
    sha256 = "sha256-2t5wD7o7MLMrbSlIWpVA8M9YKoZsSNLLXyUBJ5F5vso=";
  };

  isModular = true;
}
