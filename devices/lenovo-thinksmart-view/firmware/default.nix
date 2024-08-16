{ lib
, stdenvNoCC
, fetchFromGitLab
}:

stdenvNoCC.mkDerivation {
  name = "lenovo-thinksmart-view-firmware";
  src = fetchFromGitLab {
    owner = "kaechele";
    repo = "postmarketos-vendor-lenovo-cd-18781y";
    rev = "27b666cc5e64e8b882e07ea2607b093ab04681a2";
    sha256 = "sha256-Ze47qHKoDN0nZw2Cst3s9s/Tb93zljyJZSAGWjBqqoU=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 bt/nvm_00150100.bin -t "$out/lib/firmware/qca"
    install -Dm644 bt/rampatch_00150100.bin -t "$out/lib/firmware/qca"
    install -Dm644 gpu/a506_zap.b02 -t "$out/lib/firmware/postmarketos"
    install -Dm644 gpu/a506_zap.mdt -t "$out/lib/firmware/postmarketos"
    install -Dm644 sound/tas5728m_dsp_lenovo_cd-18781y.bin -t "$out/lib/firmware"
    install -Dm644 wifi/board.bin -t "$out/lib/firmware/ath10k/QCA9379/hw1.0"
    install -Dm644 wifi/firmware-sdio-6.bin -t "$out/lib/firmware/ath10k/QCA9379/hw1.0"

    runHook postInstall
  '';

  meta = {
    license = lib.licenses.unfree;
  };
}
