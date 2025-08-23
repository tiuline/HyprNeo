#!/bin/bash

BASE_DIR="$(dirname "$(realpath "$0")")"

yay -Rns hyprland-git

source "$BASE_DIR/pacotes/01-utilitarios.sh"
sudo pacman -Rns "${UTILITARIOS[@]}"

source "$BASE_DIR/pacotes/00-hyprland.sh"
yay -Rns "${HYPRLAND[@]}"