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
progresso_desinstalacao_pacman() {
  local mensagem="$1"              
  shift                            
  local pcts=("$@")                
  local total=${#pcts[@]}
  local passo=$((100 / total))
  local progresso=0

  {
    for pkg in "${pcts[@]}"; 
      do
        echo $progresso
        echo "Instalando: $pkg" >&2
        sudo pacman -Rns --noconfirm --needed "$pkg"
        progresso=$((progresso + passo))
    done
    echo 100
  } | whiptail --title "Instalando" --gauge "$mensagem" 10 80 0
}

progresso_instalacao_yay() {
  local mensagem="$1"              
  shift                            
  local pcts=("$@")                
  local total=${#pcts[@]}
  local passo=$((100 / total))
  local progresso=0

  {
    for pkg in "${pcts[@]}"; 
      do
        echo $progresso
        echo "Instalando: $pkg" >&2
        yay -Rns --noconfirm --needed "$pkg" 
        progresso=$((progresso + passo))
    done
    echo 100
  } | whiptail --title "Instalando" --gauge "$mensagem" 10 80 0
}

# ================================
# ========= INSTALAÇÃO ===========
# ================================

source "$BASE_DIR/instalacao/pacotes/dependencias.sh"
source "$BASE_DIR/instalacao/pacotes/extra.sh"
source "$BASE_DIR/instalacao/pacotes/hyprneo_dependencias.sh"
source "$BASE_DIR/instalacao/pacotes/principais.sh"

sudo pacman -Syu # atualizar o sistema
 
sudo pacman -S libnewt

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

# Instancia as variaveis de dependencia

# TODO
# Instalar um SDDM depois pra testar

progresso_desinstalacao_pacman "Instalando dependencias via YAY..." "${DEPENDENCIAS_YAY[@]}"
progresso_instalacao_yay "Instalando dependencias via Pacman..." "${DEPENDENCIAS_PACMAN[@]}"

progresso_desinstalacao_pacman "Instalando pacotes principais..." "${PACOTES_PRINCIPAIS[@]}"

progresso_desinstalacao_pacman "Instalando o Hyprland..." "${hyprland[@]}"

echo "Digite Hyprland para continuar"
exit 0
