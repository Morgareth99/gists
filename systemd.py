#!/usr/bin/python

# systemd-components guessing game. Will output either an existing or fake name of
# some systemd component. The person you play this with has to drink if they guess
# wrong whether or not that component in systemd actually does exist or not.

import random
names = ['systemd','systemd-initctl','systemd-rfkill','systemd-analyze','systemd-initctl.service','systemd-rfkill.service','systemd-ask-password','systemd-initctl.socket','systemd-rfkill.socket','systemd-ask-password-console.path','systemd-journald','systemd-run','systemd-ask-password-console.service','systemd-journald-audit.socket','systemd.scope','systemd-ask-password-wall.path','systemd-journald-dev-log.socket','systemd.service','systemd-ask-password-wall.service','systemd-journald.service','systemd-shutdown','systemd.automount','systemd-journald.socket','systemd-sleep','systemd-backlight','systemd.journal-fields','systemd-sleep.conf','systemd-backlight@.service','systemd-journal-upload','systemd.slice','systemd-binfmt','systemd-kexec.service','systemd.socket','systemd-binfmt.service','systemd.kill','systemd-socket-activate','systemd-cat','systemd.link','systemd-socket-proxyd','systemd-cgls','systemd-localed','systemd.special','systemd-cgtop','systemd-localed.service','systemd-suspend.service','systemd-cryptsetup','systemd-logind','systemd.swap','systemd-cryptsetup-generator','systemd-logind.service','systemd-sysctl','systemd-cryptsetup@.service','systemd-machine-id-commit.service','systemd-sysctl.service','systemd-debug-generator','systemd-machine-id-setup','systemd-system.conf','systemd-delta','systemd-modules-load','systemd-system-update-generator','systemd-detect-virt','systemd-modules-load.service','systemd-sysusers','systemd.device','systemd-mount','systemd-sysusers.service','systemd.directives','systemd.mount','systemd-sysv-generator','systemd-escape','systemd.negative','systemd.target','systemd.exec','systemd.netdev','systemd.time','systemd-fsck','systemd.network','systemd-timedated','systemd-fsckd','systemd-networkd','systemd-timedated.service','systemd-fsckd.service','systemd-networkd.service','systemd.timer','systemd-fsckd.socket','systemd-networkd-wait-online','systemd-timesyncd','systemd-fsck-root.service','systemd-networkd-wait-online.service','systemd-timesyncd.service','systemd-fsck@.service','systemd-notify','systemd-tmpfiles','systemd-fstab-generator','systemd.offline-updates','systemd-tmpfiles-clean.service','systemd.generator','systemd-path','systemd-tmpfiles-clean.timer']
fakes = ['systemd-named','systemd-lookup','systemd-peer','systemd-load','systemd-execute','systemd-resolve','systemd-boot','systemd-sndctl', 'systemd-sockd', 'systemd-networkctl','systemd-utilize','systemctl-run','systemd-hostname','systemd-sysv','systemd-continue','systemd-fail','systemd-powerd','systemd-systemd','systemctl-machinectl']
allofthem = fakes[:] + names[:]
choice = random.choice(allofthem)

print choice

if choice in names:
  print "It actually does exist"
  if choice in fakes:
    print "but it also exists in fakes."
else:
  print "it only exists in fakes."

