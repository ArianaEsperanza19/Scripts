#!/bin/bash
# Script para instalar devicons y fuentes

kaisei() {
	# 1. Descargar
	sudo wget -O "$ZIP_KAISEI" 'https://gwfh.mranftl.com/api/fonts/kaisei-harunoumi?download=zip&subsets=japanese,latin&variants=500,700,regular&formats=woff2'

	# 2. Descomprimir
	sudo unzip -o "$ZIP_KAISEI" -d "$KAISEI_DIR"

	# 3. Limpiar zip y asignar propiedad al usuario
	sudo rm -f "$ZIP_KAISEI"
	# Usar $CURRENT_USER para el chown
	sudo chown -R "$CURRENT_USER:$CURRENT_USER" "$KAISEI_DIR"
	echo "✅ Kaisei Harunoumi instaladas en $KAISEI_DIR"
}

nerd() {
	# 1. Descargar (usando -q para quiet, solo si es posible)
	sudo wget -P "$FONTS_DIR" https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/3270.zip

	# 2. Descomprimir
	sudo unzip -o "$ZIP_NERD" -d "$NERD_DIR"

	# 3. Limpiar zip y asignar propiedad al usuario
	sudo rm -f "$ZIP_NERD"
	# Usar $CURRENT_USER para el chown
	sudo chown -R "$CURRENT_USER:$CURRENT_USER" "$NERD_DIR"
	echo "✅ Nerd Fonts instaladas en $NERD_DIR"
}

# ----------------------------------------------------
# 1. CONFIGURACIÓN
# ----------------------------------------------------

# Definición de variables clave
REPO_URL="https://github.com/vorillaz/devicons.git"
FONTS_DIR="$HOME/.local/share/fonts"
DESTINO="$FONTS_DIR/devicons"

CURRENT_USER=$(whoami)
# Si ejecutas el script con 'sudo ./script.sh', $HOME apunta a /root/.

# ----------------------------------------------------
# 2. INSTALACIÓN DE DEVICONS (Verificación de Configuración)
# ----------------------------------------------------

# Verificar si el directorio de destino de Devicons ya existe (Lógica de Salida Temprana)
if [ -d "$DESTINO" ]; then
	echo "El directorio de configuración '$DESTINO' ya existe."
	echo "Asumiendo que las devicons ya fueron instaladas. Continua con otras instalaciones."
	# Salida con código de éxito 0 (el estado deseado ya se alcanzó)
else

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
fi

# ----------------------------------------------------
# 3. INSTALACIÓN DE FUENTES ADICIONALES (Nerd Fonts y Kaisei)
# ----------------------------------------------------

# --- Nerd Fonts (3270) ---
echo -e "\n--- Iniciando instalación de Nerd Fonts (3270) ---"
ZIP_NERD="$FONTS_DIR/3270.zip"
NERD_DIR="$FONTS_DIR/nerd" # Cambiado para evitar conflictos con carpetas genéricas
if [ ! -d "$NERD_DIR" ]; then
	nerd
else
	echo "Ya hay Nerd fonts instaladas."
	echo "1. Reinstalar"
	echo "2. Dejar y continuar"
	read -p "Seleccione su opción: " op
	case $op in
	1)
		echo "Reinstalando..."
		rm -Rd "$NERD_DIR"
		nerd
		;;
	2)
		echo "No hacer nada y continuar..."
		;;
	*)
		exit 0
		;;
	esac
fi

# --- Kaisei Fonts ---
echo -e "\n--- Iniciando instalación de Kaisei Harunoumi ---"
ZIP_KAISEI="$FONTS_DIR/kaisei-harunoumi.zip"
KAISEI_DIR="$FONTS_DIR/kaisei_harunoumi"
if [ ! -d "$KAISEI_DIR" ]; then
	kaisei
else
	echo "Kaisei Harunoumi ya existe en el directorio."
	echo "1. Reinstalar"
	echo "2. Dejar y continuar"
	read -p "Seleccione su opción: " op
	case $op in
	1)
		rm -Rd "kaisei_harunoumi"
		kaisei
		;;
	2)
		echo "No hacer nada y continuar..."
		;;
	*)
		exit 0
		;;
	esac

fi

# ----------------------------------------------------
# 4. FINALIZACIÓN
# ----------------------------------------------------
echo -e "\n--- Finalizando instalación de fuentes ---"
# Actualizar caché de fuentes
fc-cache -fv
echo "🎉 Todas las fuentes instaladas y el caché actualizado."
