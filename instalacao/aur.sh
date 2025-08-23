#!/bin/bash

# Caso não tenha um AUR instalado, vai atras do YAY
if ! command -v yay; 
  then
  # Install build tools
  sudo pacman -Sy --needed --noconfirm base-devel
  cd /tmp
  rm -rf yay-bin
  git clone https://aur.archlinux.org/yay-bin.git
  cd yay-bin
  makepkg -si --noconfirm
  cd -
  rm -rf yay-bin
  cd ~
fi

# Adiciona o easter egg do pacman kkkkk
if ! grep -q "ILoveCandy" /etc/pacman.conf; then
  sudo sed -i '/^\[options\]/a Color\nILoveCandy' /etc/pacman.conf
fi