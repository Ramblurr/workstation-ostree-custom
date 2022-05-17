#!/usr/bin/env bash
set -xeuo pipefail

# Enable SysRQ
echo 'kernel.sysrq = 1' > /usr/lib/sysctl.d/90-sysrq.conf

# power saving
echo 'blacklist e1000e' > /usr/lib/modprobe.d/blacklist-local.conf

# enable other units
mkdir -p /usr/lib/systemd/system/getty.target.wants
ln -s ../systemd-timesyncd.service /usr/lib/systemd/system/sysinit.target.wants/systemd-timesyncd.service
ln -s ../systemd-resolved.service /usr/lib/systemd/system/multi-user.target.wants/systemd-resolved.service
ln -s ../cockpit.socket /usr/lib/systemd/system/sockets.target.wants/cockpit.socket
ln -s ../sshd.socket /usr/lib/systemd/system/sockets.target.wants/sshd.socket

# avoid LVM spew in /etc
sed -i 's/backup = 1/backup = 0/; s/archive = 1/archive = 0/' /etc/lvm/lvm.conf

# update for Red Hat certificate
ln -s /etc/pki/ca-trust/source/anchors/2015-RH-IT-Root-CA.pem /etc/pki/tls/certs/2015-RH-IT-Root-CA.pem
update-ca-trust
