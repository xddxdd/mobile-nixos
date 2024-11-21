{
  config,
  lib,
  pkgs,
  ...
}:

let
  qcom-video-firmware = pkgs.runCommand "potter-firmware" { } ''
    dir=$out/lib/firmware/qcom
    mkdir -p $dir
    cp  ${pkgs.linux-firmware}/lib/firmware/qcom/a530* $dir
  '';
in
{
  options.mobile.outputs.lk2nd = lib.mkOption {
    type = lib.types.package;
    default = pkgs.lk2ndMsm8916.override {
      overrideDevice = "msm8953";
      signBootimg = true;
    };
  };

  config = {
    mobile.device.name = "lenovo-thinksmart-view";
    mobile.device.identity = {
      name = "Lenovo ThinkSmart View";
      manufacturer = "Lenovo";
    };

    mobile.hardware = {
      soc = "qualcomm-msm8953";
      ram = 1024 * 2;
      screen = {
        width = 800;
        height = 1280;
      };
    };

    mobile.boot.stage-1.firmware = [
      qcom-video-firmware
    ];

    mobile.boot.stage-1.kernel = {
      package = pkgs.callPackage ./kernel { };
      modular = true;
      allowMissingModules = false;
      modules = [
        "msm"
        "panel_lenovo_cd_18781y_ft8201"
        "panel_lenovo_cd_18781y_hx83100a"
        "panel_lenovo_cd_18781y_jd9365"
      ];
    };

    # in your configuration.nix hardware.firmware, in addition to this
    # package you will probably need pkgs.linux-firmware, pkgs.wireless-regdb
    mobile.device.firmware = pkgs.callPackage ./firmware { };

    mobile.system.android.device_name = "cd-18781y";
    mobile.system.android = {
      bootimg.flash = {
        offset_base = "0x80000000";
        offset_kernel = "0x00008000";
        offset_ramdisk = "0x01000000";
        offset_second = "0x00f00000";
        offset_tags = "0x00000100";
        pagesize = "2048";
      };
      appendDTB = [
        "dtbs/qcom/apq8053-lenovo-cd-18781y.dtb"
      ];
    };

    # The boot partition on this phone is 16MB, so use `xz` compression
    # as smaller than gzip
    mobile.boot.stage-1.compression = lib.mkDefault "xz";

    mobile.usb = {
      mode = "gadgetfs";
      idVendor = "18D1"; # Google
      idProduct = "4EE7"; # something not "D001", to distinguish nixos from fastboot/lk2nd

      gadgetfs.functions = {
        rndis = "rndis.usb0";
        adb = "ffs.adb";
      };
    };

    mobile.system.type = "android";
    mobile.system.android.flashingMethod = "lk2nd";
  };
}
