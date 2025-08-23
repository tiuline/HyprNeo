#!/bin/bash
# HyprNeo - Instalador do HyprLand
#
# Bem-vindo ao HyprNeo, meu instalador do hyprland para facilitar
# o processo para desenvolvedores e entusiastas do linux.
# 
# Acesse:
# https://github.com/tiuline
#
# Siga e compartilhe

# ================================
# =========  VARIAVEIS  ==========  
# ================================
hyprland=("hyprland")
BASE_DIR="$(dirname "$(realpath "$0")")"


ASCII_ART=$(cat <<'EOF'
 _   _                  _   _            
| | | |_   _ _ __  _ __| \ | | ___  ___  
| |_| | | | | '_ \| '__|  \| |/ _ \/ _ \ 
|  _  | |_| | |_) | |  | |\  |  __/ (_) |  2025
|_| |_|\__, | .__/|_|  |_| \_|\___|\___/   Arch Linux
       |___/|_|                            
EOF
)

# ================================
# ==========  FUNCOES  ===========  
# ================================
progresso_instalacao_pacman() {
  local mensagem="$1"              
  shift                            
  local pcts=("$@")                
  local total=${#pcts[@]}
  local passo=$((100 / total))
  local progresso=0

    for pkg in "${pcts[@]}"; 
      do
        echo $progresso
        echo "Instalando: $pkg" >&2
        sudo pacman -S --noconfirm --needed "$pkg"
        progresso=$((progresso + passo))
    done
}

progresso_instalacao_yay() {
  local mensagem="$1"              
  shift                            
  local pcts=("$@")                
  local total=${#pcts[@]}
  local passo=$((100 / total))
  local progresso=0

    for pkg in "${pcts[@]}"; 
      do
        echo $progresso
        echo "Instalando: $pkg" >&2
        yay -S --noconfirm --needed "$pkg" 
        progresso=$((progresso + passo))
    done
}

# ================================
# ========= INSTALAÇÃO ===========
# ================================


sudo pacman -Syu # atualizar o sistema
 
sudo pacman -S libnewt

# Instancia as variaveis de dependencia

"$BASE_DIR/instalacao/aur.sh"
"$BASE_DIR/instalacao/nvidia.sh"
"$BASE_DIR/instalacao/hyprland.sh"
"$BASE_DIR/instalacao/utilitarios.sh"

echo "instalando sddm"
sudo pacman -S sddm
sudo systemctl enable sddm.service
# TODO
# Instalar um SDDM depois pra testar

sudo pacman -Rns $(pacman -Qdtq)

echo "Digite Hyprland para continuar"
exit 0
