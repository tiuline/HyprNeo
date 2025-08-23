#!/bin/bash

source "$BASE_DIR/pacotes/00-hyprland.sh"
progresso_instalacao_yay "Instalando dependencias do hyprland..." "${HYPRLAND[@]}"

echo "instalando Hyprland"
yay -S hyprland-git