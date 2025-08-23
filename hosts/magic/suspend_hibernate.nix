{pkgs, ...}: let
  hibernateEnvironment = {
    HIBERNATE_SECONDS = "300";
    HIBERNATE_LOCK = "/var/run/autohibernate.lock";
  };
in {
  systemd.services.awake-after-suspend-for-a-time = {
    description = "Set RTC wake timer before suspend";
    wantedBy = ["suspend.target"];
    before = ["systemd-suspend.service"];
    environment = hibernateEnvironment;
    script = ''
      curtime=$(date +%s)
      echo "$curtime $1" >> /tmp/autohibernate.log
      echo "$curtime" > "$HIBERNATE_LOCK"
      ${pkgs.util-linux}/bin/rtcwake -m no -s "$HIBERNATE_SECONDS"
    '';
    serviceConfig.Type = "simple";
  };
  systemd.services.hibernate-after-recovery = {
    description = "Hibernate after suspend timeout";
    wantedBy = ["suspend.target"];
    after = ["systemd-suspend.service"];
    environment = hibernateEnvironment;
    script = ''
      if [ -f "$HIBERNATE_LOCK" ]; then
        curtime=$(date +%s)
        sustime=$(cat "$HIBERNATE_LOCK")
        rm "$HIBERNATE_LOCK"
        if [ $((curtime - sustime)) -ge "$HIBERNATE_SECONDS" ]; then
          echo "Hibernating after suspend timeout" >> /tmp/autohibernate.log
          systemctl hibernate
        else
          ${pkgs.util-linux}/bin/rtcwake -m no -s 1
        fi
      else
        echo "No hibernate lock file found, skipping..." >> /tmp/autohibernate.log
      fi
    '';
    serviceConfig.Type = "simple";
  };
}
