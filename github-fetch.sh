#!/bin/sh
# Download built GitHub OSTree repository artifact and unpack it into a plain directory
set -eux

# download latest repo build
REPO_FINAL="/srv/repo/sway-desktop"
REPO="${REPO_FINAL}.new"

CURL="curl -u token:$(cat ~/.config/github-token) --show-error --fail "
RESPONSE=$($CURL --silent https://api.github.com/repos/Ramblurr/workstation-ostree-custom/actions/artifacts)
ZIP=$(echo "$RESPONSE" | jq --raw-output '.artifacts | map(select(.name == "repository-fc35"))[0].archive_download_url')
echo "INFO: Downloading $ZIP ..."
[ -e /tmp/repository.zip ] || $CURL --continue-at - -L -o /tmp/repository.zip "$ZIP"
rm -rf "$REPO"
mkdir -p "$REPO"
unzip -p /tmp/repository.zip | tar -xzC "$REPO"
rm /tmp/repository.zip
[ ! -e "$REPO_FINAL" ] || mv "${REPO_FINAL}" "${REPO_FINAL}.old"
mv "$REPO" "$REPO_FINAL"
rm -rf "${REPO_FINAL}.old"
