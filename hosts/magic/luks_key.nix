_:
# let
#   PRIMARYUSBID = "MYUSB"; # From `blkid /dev/sda1`
#   BACKUPUSBID = "Ventoy"; # Optional secondary USB `blkid /dev/sdc1`
# in {
#   boot.initrd.kernelModules = [
#     "uas"
#     "usbcore"
#     "usb_storage"
#     "vfat"
#     "nls_cp437"
#     "nls_iso8859_1"
#   ];
#   boot.initrd.postDeviceCommands = lib.mkBefore ''
#     mkdir -p /key
#     sleep 3
#     mount -n -t vfat -o ro $(findfs UUID=${PRIMARYUSBID}) /key || \
#     mount -n -t vfat -o ro $(findfs UUID=${BACKUPUSBID}) /key || echo "No USB key found"
#   '';
#   boot.initrd.luks.devices.cryptroot = {
#     device = "/dev/disk/by-partlabel/luks";
#     keyFile = "/key/usb-luks.key";
#     fallbackToPassword = true;
#     allowDiscards = true;
#     preLVM = false; # Crucial!
#   };
{
  boot = {
    initrd.luks.devices = {
      cryptroot = {
        device = "/dev/disk/by-partlabel/luks";
        allowDiscards = true;
        # fallbackToPassword = true;
      };
    };
    # resumeDevice = "/dev/disk/by-uuid/0dbae39f-939d-42eb-916e-5372ba2c203f";
    # binfmt.emulatedSystems = ["aarch64-linux"];
  };
}
