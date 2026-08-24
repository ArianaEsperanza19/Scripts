#!/bin/bash
archivo_vars="$HOME/.Mis_variables"

# Función para configurar el contenido
escribir_configuracion() {
	cat <<'EOF' >"$archivo_vars"
# Editor de terminal
export VISUAL=nvim

# Rutas de herramientas
export PATH="$HOME/Otros/Mis_scripts:$PATH"
export PATH="$HOME/.deno/bin:$PATH"
export PATH="/opt/lampp/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/share/nvim/mason/packages/:$PATH"

# Zoxide
eval "$(zoxide init bash)"
# Thefuck
eval $(thefuck --alias)
eval $(thefuck --alias FUCK)

# Fcitx
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Colores de Alacritty
export PS1='\[\e[32m\][\u@\h \W]\$ \[\e[0m\]'
EOF
	echo "Archivo $archivo_vars configurado correctamente."
}

# Lógica de verificación
if [ -e "$archivo_vars" ]; then
	echo "¡Atención! El archivo $archivo_vars ya existe."
	read -p "¿Deseas borrarlo y crear uno nuevo? (s/n): " confirmacion

	if [[ "$confirmacion" == "s" || "$confirmacion" == "S" ]]; then
		rm "$archivo_vars"
		escribir_configuracion
	else
		echo "Operación cancelada. El archivo original se mantiene intacto."
		exit 0
	fi
else
	escribir_configuracion
fi

source "$archivo_vars"
echo "Entorno actualizado."
