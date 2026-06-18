#!/bin/bash
# Script para configurar Japonés
sudo pacman -S fcitx5-configtool fcitx5-anthy fcitx5-qt fcitx5-gtk

# Verificar si el archivo ~/.xprofile
if [ ! -f ~/.xprofile ]; then
	echo '
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
' >>"$HOME/.xprofile"

	if [ $? -eq 0 ]; then
		echo "✅ Fcitx configurado exitosamente."
	else
		echo "❌ ¡ERROR! No se pudo configurar fcitx."
	fi
else
	echo "Fcitx ya estaba instalado"
fi
