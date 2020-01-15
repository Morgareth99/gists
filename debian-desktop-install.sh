#!/bin/bash

# Custom Debian post installation setup script for Laptop use

# Username of the desktop user
username="armin"

# Throw an error message and exit
bailout () {
  tput setaf 9
  echo "$0: $@"
  tput sgr0
  exit 255
}

msg () {
  tput setaf 10
  echo "$@"
  tput sgr0
}

# Check for UID 0
if [[ "$UID" -gt 0 ]]; then
  tput setaf 9
  bailout "ERROR: $0 needs to run as root. Exiting."
  tput sgr0
fi

# Install additional packages
apt-get -y install screen tmux irssi weechat hexchat thunderbird libreoffice-l10n-de htop mc vim-nox rsync mtr-tiny nginx ferm etckeeper git mpg123 mpv lame gcc make libssl-dev powertop acpi ipython youtube-dl audacious audacious-plugins libnotify-bin tig gajim gimp whois ncdu chromium pidgin pidgin-otr rxvt-unicode-256color

msg "Removing nano ..."
apt-get -y remove nano
msg "done."
echo

msg "Removing light-locker ..."
apt-get -y remove light-locker
msg "done."
echo

# Make vimrc modifications
msg "Making modifications to vimrc ..."
if ! grep '^set mouse=$' /etc/vim/vimrc >/dev/null 2>&1; then
  echo "set mouse=" >> /etc/vim/vimrc
fi
if ! grep '^syntax on$' /etc/vim/vimrc >/dev/null 2>&1; then
  echo "syntax on" >> /etc/vim/vimrc
fi
msg "done."
echo

# fill /etc/rc.local
if [[ -f /etc/rc.local ]]; then
  msg "Renaming rc.local to rc.local.bak ..."
  mv /etc/rc.local /etc/rc.local.bak
fi
cat <<EOF >/etc/rc.local
#!/bin/sh

(sleep 5; echo 255 > /sys/devices/platform/i8042/serio2/sensitivity) &
powertop --auto-tune >/dev/null 2>&1

EOF
chmod +x /etc/rc.local

cat <<EOF >/etc/systemd/system/rc-local.service
[Unit]
Description=/etc/rc.local Compatibility
ConditionPathExists=/etc/rc.local

[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=20
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99

[Install]
WantedBy=multi-user.target
EOF
systemctl enable rc-local
systemctl start rc-local.service

# Copy vimrc to user home directory
if [[ ! -f /home/${username}/.vimrc ]]; then
  cp /etc/vim/vimrc /home/$username/.vimrc
fi

msg "Operation completed."
echo


