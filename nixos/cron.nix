{pkgs, ...}: {
  services.cron = {
    enable = true;
    # messages.enable = true;
    systemCronJobs = [
      # Every Sunday at 2:10 AM, run chkrootkit as root, log output for review
      "10 2 * * 0 root ${pkgs.chkrootkit}/bin/chkrootkit | logger -t chkrootkit"
      # Every day at 2:00 AM, run clamscan as root and append output to a log file
      "0 2 * * * root ${pkgs.clamav}/bin/clamscan -r /home >> /var/log/clamscan.log"
      "0 11 * * * ${pkgs.aide}/bin/aide --check --config /var/lib/aide/aide.conf"
    ];
  };
}
