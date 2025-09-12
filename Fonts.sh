#!/bin/bash
# Script para instalar devicons y fuentes

# Descargar devicons
# Reemplaza estos valores con la URL de tu repositorio y el directorio de destino
REPO_URL="https://github.com/vorillaz/devicons.git"
DESTINO="$HOME/.local/share/fonts/devicons"

# 1. Verificar si el directorio de destino existe, si no, lo crea.
if [ ! -d "$DESTINO" ]; then
	echo "El directorio de destino '$DESTINO' no existe. Creándolo..."
	sudo mkdir -p "$DESTINO"
fi

# 2. Clonar el repositorio en una carpeta temporal
echo "Clonando el repositorio en una carpeta temporal..."
sudo git clone --depth 1 "$REPO_URL" "$DESTINO"

# Verificar si la clonación fue exitosa
if [ $? -ne 0 ]; then
	echo "Error: No se pudo clonar el repositorio."
	exit 1
fi

echo "¡Hecho! Contenido del repositorio movido exitosamente."
sudo chown -R ariana $DESTINO

echo "¡Hecho! Contenido del repositorio clonado exitosamente."

FONTS="$HOME/.local/share/fonts/"
sudo wget -P $FONTS https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/3270.zip
ZIP="$HOME/.local/share/fonts/3270.zip"
NERD="$HOME/.local/share/fonts/nerd"
sudo unzip $ZIP -d $NERD
sudo rm -rd $ZIP
echo "Nerd fonts instaladas"
# Actualizar fuentes
fc-cache -fv
echo "Nota, para instalar manualmente las fuentes kaisei-harunoumi"
echo "Ir a: https://fontmeme.com/fuentes/fuente-kaisei-harunoumi/"
