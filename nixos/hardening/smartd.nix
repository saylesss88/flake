_: {
  services.smartd = {
    enable = true;
    notifications.mail.enable = true;
    notifications.mail.recipient = "saylesss87@proton.me";
    devices = [
      {
        device = "/dev/nvme0n1p1";
      }
    ];
  };
}
