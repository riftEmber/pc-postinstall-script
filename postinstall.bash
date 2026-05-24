#!/usr/bin/env bash

# Do basic post-install steps on a new Archlinux PC.

set -exuo pipefail

# Install basic requirements to run the Ansible playbook
echo ">> Updating all installed packages"
sudo pacman -Syu --noconfirm
echo ">> Installing required packages for bootstrapping"
sudo pacman -S --noconfirm python ansible github-cli firefox git libsecret

# Generate new SSH key
echo ">> Generating SSH key"
ssh-keygen -t ed25519 -C "$USER@$(cat /etc/hostname)" -f ~/.ssh/id_ed25519 -N ""

# Log in to GitHub
echo ">> Logging in to GitHub, make sure to upload SSH key"
gh auth login --hostname github.com --git-protocol ssh

# Run Ansible playbook
echo ">> Pulling and running Ansible playbook"
ansible-pull --url git@github.com:riftEmber/pc-config setup.yaml -i localhost, --ask-become-pass

echo ">> Done! Reboot for all changes to take effect."
