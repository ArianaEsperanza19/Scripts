#!/bin/bash
# Script para instalar devicons y fuentes

# ----------------------------------------------------
# 1. CONFIGURACIÓN
# ----------------------------------------------------

# Definición de variables clave
REPO_URL="https://github.com/vorillaz/devicons.git"
DESTINO="$HOME/.local/share/fonts/devicons"
FONTS_DIR="$HOME/.local/share/fonts/"

CURRENT_USER=$(whoami)
# Si ejecutas el script con 'sudo ./script.sh', $HOME apunta a /root/.

# ----------------------------------------------------
# 2. INSTALACIÓN DE DEVICONS (Verificación de Configuración)
# ----------------------------------------------------

# Verificar si el directorio de destino de Devicons ya existe (Lógica de Salida Temprana)
if [ -d "$DESTINO" ]; then
	echo "El directorio de configuración '$DESTINO' ya existe."
	echo "Asumiendo que las devicons ya fueron instaladas. Terminando ejecución."
	# Salida con código de éxito 0 (el estado deseado ya se alcanzó)
	exit 0
fi

# El script continúa solo si el directorio NO existía
echo "El directorio de destino '$DESTINO' no existe. Creándolo..."
mkdir -p "$DESTINO"

echo "Clonando el repositorio en el destino..."
git clone --depth 1 "$REPO_URL" "$DESTINO"

# Verificar si la clonación fue exitosa
if [ $? -ne 0 ]; then
	echo "Error: No se pudo clonar el repositorio."
	# Si falla la clonación, salimos con error 1
	exit 1
fi

echo "✅ ¡Devicons instaladas exitosamente!"

# ----------------------------------------------------
# 3. INSTALACIÓN DE FUENTES ADICIONALES (Nerd Fonts y Kaisei)
# ----------------------------------------------------

# --- Nerd Fonts (3270) ---
echo -e "\n--- Iniciando instalación de Nerd Fonts (3270) ---"
ZIP_NERD="$FONTS_DIR/3270.zip"
NERD_DIR="$FONTS_DIR/3270-nerd" # Cambiado para evitar conflictos con carpetas genéricas

# 1. Descargar (usando -q para quiet, solo si es posible)
sudo wget -P "$FONTS_DIR" https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/3270.zip

# 2. Descomprimir
sudo unzip -o "$ZIP_NERD" -d "$NERD_DIR"

# 3. Limpiar zip y asignar propiedad al usuario
sudo rm -f "$ZIP_NERD"
# Usar $CURRENT_USER para el chown
sudo chown -R "$CURRENT_USER:$CURRENT_USER" "$NERD_DIR"
echo "✅ Nerd Fonts instaladas en $NERD_DIR"

# --- Kaisei Fonts ---
echo -e "\n--- Iniciando instalación de Kaisei Harunoumi ---"
ZIP_KAISEI="$FONTS_DIR/kaisei-harunoumi.zip"
KAISEI_DIR="$FONTS_DIR/kaisei_harunoumi"

# 1. Descargar
sudo wget -O "$ZIP_KAISEI" 'https://gwfh.mranftl.com/api/fonts/kaisei-harunoumi?download=zip&subsets=japanese,latin&variants=500,700,regular&formats=woff2'

# 2. Descomprimir
sudo unzip -o "$ZIP_KAISEI" -d "$KAISEI_DIR"

# 3. Limpiar zip y asignar propiedad al usuario
sudo rm -f "$ZIP_KAISEI"
# Usar $CURRENT_USER para el chown
sudo chown -R "$CURRENT_USER:$CURRENT_USER" "$KAISEI_DIR"
echo "✅ Kaisei Harunoumi instaladas en $KAISEI_DIR"

# ----------------------------------------------------
# 4. FINALIZACIÓN
# ----------------------------------------------------
echo -e "\n--- Finalizando instalación de fuentes ---"
# Actualizar caché de fuentes
fc-cache -fv
echo "🎉 Todas las fuentes instaladas y el caché actualizado."
