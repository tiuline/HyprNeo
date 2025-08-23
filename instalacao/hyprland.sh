#!/bin/bash

echo "chamando $BASE_DIR/pacotes/00-utilitarios.sh"

source "$BASE_DIR/pacotes/00-hyprland.sh"
yay -S "${HYPRLAND[@]}"

echo "instalando Hyprland"
yay -S hyprland-git