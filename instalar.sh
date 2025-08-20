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

  {
    for pkg in "${pcts[@]}"; 
      do
        echo $progresso
        echo "Instalando: $pkg" >&2
        sudo pacman -S --noconfirm --needed "$pkg" &>/dev/null
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
        yay -S --noconfirm --needed "$pkg" &>/dev/null
        progresso=$((progresso + passo))
    done
    echo 100
  } | whiptail --title "Instalando" --gauge "$mensagem" 10 80 0
}

# ================================
# ========= INSTALAÇÃO ===========
# ================================

# Vamos iniciar com o pacote newt que contem o WhipTail, essencial para a nossa instalação
sudo pacman -S libnewt &>/dev/null

# Confirmação para continuar
if (whiptail --title "Continuar?" --yesno "\
    $ASCII_ART 
    
    Bem-vindo ao HyprNeo!
    Para comecar, vamos instalar o Hyprland, deseja continuar?" 15 65
    ); 
    then
  echo "Instalação iniciada..."
else
  whiptail --title "Cancelado" --msgbox "Instalação cancelada pelo usuário." 10 60
  exit 0
fi

# Instancia as variaveis de dependencia
source "$BASE_DIR/pacotes/dependencias.sh"
source "$BASE_DIR/pacotes/principais.sh"
source "$BASE_DIR/pacotes/extras.sh"

source $BASE_DIR/instalacao/prerequisitos.sh

# TODO
# Instalar um SDDM depois pra testar

progresso_instalacao_pacman "Instalando dependencias via YAY..." "${DEPENDENCIAS_YAY[@]}"
progresso_instalacao_yay "Instalando dependencias via Pacman..." "${DEPENDENCIAS_PACMAN[@]}"

progresso_instalacao_pacman "Instalando pacotes principais..." "${PACOTES_PRINCIPAIS[@]}"

progresso_instalacao_pacman "Instalando o Hyprland..." "${hyprland[@]}"

# Mensagem final
whiptail --title "Instalando" --msgbox "Hyprland instalado com sucesso!" 10 60

if (whiptail --title "Continuar?" --yesno "\
    Agora vamos instalar o HyprNeo, deseja continuar?" 15 65
    ); 
    then
  echo "Instalação iniciada..."
else
  whiptail --title "Cancelado" --msgbox "Instalação cancelada pelo usuário." 10 60
  exit 0
fi

clear
echo "Digite Hyprland para continuar"
exit 0
