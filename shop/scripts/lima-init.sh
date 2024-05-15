#!/usr/bin/env bash

curl -fsSL https://get.jetify.com/devbox -o /tmp/devbox-installer.sh
chmod +x /tmp/devbox-installer.sh
/tmp/devbox-installer.sh -f

echo 'eval "$(devbox global shellenv --init-hook)"' >> ~/.bashrc
echo 'eval "$(devbox global shellenv --init-hook)"' >> ~/.zshrc
mkdir -p ~/.config/fish/
echo 'eval "$(devbox global shellenv --init-hook)"' >> ~/.config/fish/config.fish

curl -sfL https://get.rke2.io -o /tmp/rke2-installer.sh
chmod +x /tmp/rke2-installer.sh

sudo /tmp/rke2-installer.sh
sudo systemctl enable rke2-server.service
sudo systemctl start rke2-server.service
