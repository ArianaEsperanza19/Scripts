#!/bin/bash
# Script para configurar Neovim/LazyVim mediante un repositorio GitHub.

if command -v nvim &>/dev/null; then
	echo "✅ Neovim instalado. Versión: $(nvim --version | head -n 1)"
	# Reemplaza estos valores con la URL de tu repositorio y el directorio de destino
	REPO_URL="https://github.com/ArianaEsperanza19/Lazyvim.git"
	DESTINO="$HOME/.config/nvim"

	# 1. Verificar si el directorio de destino existe, si no, lo crea.
	if [ ! -d "$DESTINO" ]; then
		echo "El directorio de destino '$DESTINO' no existe. Creándolo..."
		mkdir -p "$DESTINO"
	fi

	# 2. Clonar el repositorio en una carpeta temporal
	echo "Clonando el repositorio en una carpeta temporal..."
	git clone --depth 1 "$REPO_URL" "$DESTINO"

	# Verificar si la clonación fue exitosa
	if [ $? -ne 0 ]; then
		echo "Error: No se pudo clonar el repositorio."
		exit 1
	fi

	echo "✅¡Hecho! Contenido del repositorio clonado exitosamente."
else
	echo "❌ Neovim no se encontró."
fi
