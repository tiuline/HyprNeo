#!/bin/bash

echo "chamando $BASE_DIR/pacotes/01-utilitarios.sh"
source "$BASE_DIR/pacotes/01-utilitarios.sh"
progresso_instalacao_pacman "Instalando utilitarios essenciais para o sistema..." "${UTILITARIOS[@]}"