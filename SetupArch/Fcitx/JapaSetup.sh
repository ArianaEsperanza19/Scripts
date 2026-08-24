#!/bin/bash
# Script para configurar Fcitx5 e instalar idioma Japonés

# 1. Instalación de paquetes
echo "Instalando paquetes de Fcitx5..."
sudo pacman -S --needed fcitx5-configtool fcitx5-anthy fcitx5-qt fcitx5-gtk

# 2. Configuración de variables en .xprofile
if ! grep -q "GTK_IM_MODULE=fcitx" "$HOME/.xprofile" 2>/dev/null; then
	cat <<'EOF' >>"$HOME/.xprofile"

# Fcitx5
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
EOF
	echo "✅ Variables de Fcitx agregadas a .xprofile."
else
	echo "ℹ️  Configuración de Fcitx ya presente en .xprofile."
fi

# 3. Copia de carpetas de configuración
# Asumimos que el script está en la misma carpeta padre que 'Fcitx/'
DIR_ORIGEN="./Fcitx"
DIR_DESTINO="$HOME/.config"

if [ -d "$DIR_ORIGEN" ]; then
	echo "Detectada carpeta de configuración en $DIR_ORIGEN."

	for carpeta in "fcitx" "fcitx5"; do
		if [ -d "$DIR_ORIGEN/$carpeta" ]; then
			if [ -d "$DIR_DESTINO/$carpeta" ]; then
				echo "⚠️  La carpeta $carpeta ya existe en .config."
				read -p "¿Deseas sobrescribirla con tu respaldo? (s/n): " confirm
				if [[ "$confirm" == "s" ]]; then
					rm -rf "$DIR_DESTINO/$carpeta"
					cp -r "$DIR_ORIGEN/$carpeta" "$DIR_DESTINO/"
					echo "✅ Carpeta $carpeta sobrescrita."
				fi
			else
				cp -r "$DIR_ORIGEN/$carpeta" "$DIR_DESTINO/"
				echo "✅ Carpeta $carpeta copiada correctamente."
			fi
		fi
	done
else
	echo "❌ ERROR: No se encontró la carpeta 'Fcitx' en el directorio actual."
fi

echo "Proceso finalizado. Reinicia la sesión para aplicar los cambios."
