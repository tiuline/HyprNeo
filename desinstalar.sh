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

progresso_desinstalacao_yay() {
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

progresso_desinstalacao_pacman "Desinstalando dependencias via YAY..." "${DEPENDENCIAS_YAY[@]}"
progresso_instalacao_yay "Desinstalando dependencias via Pacman..." "${DEPENDENCIAS_PACMAN[@]}"

progresso_desinstalacao_pacman "Desinstalando pacotes principais..." "${PACOTES_PRINCIPAIS[@]}"

progresso_desinstalacao_pacman "Desinstalando o Hyprland..." "${hyprland[@]}"

if lspci | grep -i 'nvidia' &>/dev/null; then
  echo "Desinstalando Drivers Nvidia"

  # Determina quais pacotes foram instalados
  PACKAGES_TO_REMOVE=(
    "nvidia-open-dkms"
    "nvidia-dkms"
    "nvidia-utils"
    "lib32-nvidia-utils"
    "egl-wayland"
    "libva-nvidia-driver"
    "qt5-wayland"
    "qt6-wayland"
  )

  # Remove pacotes (ignora os que não estão instalados)
  yay -Rns --noconfirm "${PACKAGES_TO_REMOVE[@]}" 2>/dev/null

  # Remove configuração do modprobe
  if [ -f /etc/modprobe.d/nvidia.conf ]; then
    sudo rm /etc/modprobe.d/nvidia.conf
    echo "Removido: /etc/modprobe.d/nvidia.conf"
  fi

  # Restaura mkinitcpio.conf
  MKINITCPIO_CONF="/etc/mkinitcpio.conf"
  BACKUP_CONF="${MKINITCPIO_CONF}.backup"
  if [ -f "$BACKUP_CONF" ]; then
    sudo cp "$BACKUP_CONF" "$MKINITCPIO_CONF"
    echo "Restaurado backup do mkinitcpio.conf"
  else
    # Se não houver backup, apenas tenta remover os módulos manualmente
    sudo sed -i -E 's/ nvidia_drm//g; s/ nvidia_uvm//g; s/ nvidia_modeset//g; s/ nvidia//g;' "$MKINITCPIO_CONF"
    sudo sed -i -E 's/  +/ /g' "$MKINITCPIO_CONF"
    echo "Removidos módulos NVIDIA manualmente do mkinitcpio.conf"
  fi

  sudo mkinitcpio -P

  # Remove variáveis de ambiente do Hyprland
  HYPRLAND_CONF="$HOME/.config/hypr/hyprland.conf"
  if [ -f "$HYPRLAND_CONF" ]; then
    sed -i '/# NVIDIA environment variables/,+3d' "$HYPRLAND_CONF"
    echo "Removidas variáveis NVIDIA do hyprland.conf"
  fi

  echo "Drivers NVIDIA desinstalados com sucesso."
else
  echo "Nenhuma GPU NVIDIA detectada."
fi


sudo pacman -Rns libnewt

sudo pacman -Syu # atualizar o sistema
 
exit 0
