#!/bin/bash

# ========================
# ======  FUNCOES  =======
# ========================

sair() {
  whiptail --title "Requisitos" --msgbox "\ 
    A instalação precisa do: $!" \
    10 60
  exit 1
}

# ===========================
# ======  instalacao  =======
# ===========================

# Precisa estar instalando no ARCH Linux
[[ -f /etc/arch-release ]] || sair "Vanilla Arch"

# não pode ser uma distro derivada doarch, tem que ser O ARCH LINUX
for marker in /etc/cachyos-release /etc/eos-release /etc/garuda-release /etc/manjaro-release; do
  [[ -f "$marker" ]] && sair "Vanilla Arch"
done

# não pode rodar como root
[ "$EUID" -eq 0 ] && sair "Running as user (not root)"

# recisa rodar num processador x86
[ "$(uname -m)" != "x86_64" ] && sair "x86_64 CPU"

# não pode ter o hnome shell ou plasma desktop instalados
pacman -Qe gnome-shell &>/dev/null && sair "Fresh + Vanilla Arch"
pacman -Qe plasma-desktop &>/dev/null && sair "Fresh + Vanilla Arch"

# Só instala o Chaotic AUR se o usuario tiver usando arquitetura ARM
if [[ "$(uname -m)" == "x86_64" ]] && ! command -v yay &>/dev/null; then
  # Tenta instalar as chaves de registro e os mirrors do Chaotic AUR
  if ! pacman-key --list-keys 3056513887B78AEB >/dev/null 2>&1 &&
    sudo pacman-key --recv-key 3056513887B78AEB &&
    sudo pacman-key --lsign-key 3056513887B78AEB &&
    sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' &&
    sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'; then

    # Adiciona o repositorio do Chaotic AUR
    if ! grep -q "chaotic-aur" /etc/pacman.conf; then
      echo -e '\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist' | sudo tee -a /etc/pacman.conf >/dev/null
    fi

    # Instala o yay direto pelo Chaotic-AUR
    sudo pacman -Sy --needed --noconfirm yay
  else
    whiptail --title "Falha" --msgbox "\ 
      Falha ao instalra o Chaotic-AUR, não vamos inclui-lo nas configuraçoes do pacman" \
      10 60
    exit 1
  fi
fi

# Caso não tenha um AUR instalado, vai atras do YAY
if ! command -v yay &>/dev/null; 
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