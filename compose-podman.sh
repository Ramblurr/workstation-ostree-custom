#!/bin/sh
set -eu
CACHE=/var/cache/ostree
REPO=/repo/repo


dnf install -y git rpm-ostree selinux-policy selinux-policy-targeted policycoreutils

if [ -d  /repo/workstation ]; then
  rm -rf /repo/workstation
fi

git clone https://github.com/Ramblurr/workstation-ostree-custom.git /repo/workstation

cd /repo/workstation


mkdir -p $CACHE

if [ ! -d $REPO/objects ]; then
    ostree --repo=$REPO init --mode=archive-z2
fi

rpm-ostree compose tree --unified-core --cachedir=$CACHE --repo=$REPO sway-desktop.yaml

tar -czf /repo/repo.tar.gz -C $REPO .
