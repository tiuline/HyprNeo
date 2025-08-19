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

source ./pacotes/dependencias.sh
source ./pacotes/principais.sh
source ./pacotes/extras.sh

# ================================
# =========  VARIAVEIS  ==========  
# ================================
hyprland=("hyprland")

# ================================
# ==========  FUNCOES  ===========  
# ================================
progresso_instalacao() {
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
        pacman -S --noconfirm --needed "$pkg" &>/dev/null
        progresso=$((progresso + passo))
    done
    echo 100
  } | whiptail --title "Instalando" --gauge "$mensagem" 10 80 0
}

# ================================
# ========= INSTALAÇÃO ===========
# ================================

# Vamos iniciar com o pacote newt que contem o WhipTail, essencial para a nossa instalação
sudo pacman -S newt

# Verificar se o usuário é root
if [[ $EUID -ne 0 ]]; 
    then whiptail --title "Permissão negada" --msgbox"\ 
        Este script precisa ser executado como root!" \
        10 60
  exit 1
fi
whiptail --title "Bem-vindo ao HyprNeo" --msgbox" teste " 20 80

whiptail --title "Bem-vindo ao HyprNeo" --msgbox"\
 _   _                  _   _            
| | | |_   _ _ __  _ __| \ | | ___  ___  
| |_| | | | | '_ \| '__|  \| |/ _ \/ _ \ 
|  _  | |_| | |_) | |  | |\  |  __/ (_) |  2025
|_| |_|\__, | .__/|_|  |_| \_|\___|\___/   Arch Linux
       |___/|_|                            
" 20 80

# Confirmação para continuar
if (whiptail --title "Continuar?" --yesno "Deseja iniciar a instalação do Hyprland?" 10 60); then
  echo "Instalação iniciada..."
else
  whiptail --title "Cancelado" --msgbox "Instalação cancelada pelo usuário." 10 60
  exit 0
fi

progresso_instalacao "Instalando dependencias..." "${DEPENDENCIAS[@]}"

progresso_instalacao "Instalando pacotes principais..." "${PACOTES_PRINCIPAIS[@]}"

progresso_instalacao "Instalando o Hyprland..." "${hyprland[@]}"

# Mensagem final
whiptail --title "Finalizado" --msgbox "Hyprland instalado com sucesso!" 10 60

exit 0
