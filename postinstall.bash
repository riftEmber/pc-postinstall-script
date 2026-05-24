#!/usr/bin/env bash

# Do basic post-install steps on a new Archlinux PC.

set -exuo pipefail

echo ">> Updating all installed packages"
sudo pacman -Syu --noconfirm
echo ">> Installing required packages for bootstrapping"
sudo pacman -S --noconfirm python ansible github-cli firefox git jq

echo ">> Generating SSH key"
ssh-keygen -t ed25519 -C "$USER@$(cat /etc/hostname)" -f ~/.ssh/id_ed25519 -N ""

echo ">> Adding GitHub SSH keys to known hosts"
curl --silent https://api.github.com/meta \
  | jq --raw-output '"github.com "+.ssh_keys[]' >> ~/.ssh/known_hosts

echo ">> Logging in to GitHub, make sure to upload SSH key"
gh auth login --hostname github.com --git-protocol ssh --insecure-storage
echo ">> Logging back out of Github to clear secrets"
gh auth logout

echo ">> Pulling and running Ansible playbook"
PYTHONUNBUFFERED=1 ansible-pull --url git@github.com:riftEmber/pc-config -i localhost, --ask-become-pass

echo ">> Done! Reboot for all changes to take effect."
