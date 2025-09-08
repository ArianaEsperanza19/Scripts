#!/bin/bash
# Script para crear un archivo .alias_bash en la carpeta actual y agregarlo al .bashrc
cd ~/

if [ -e ".alias_bash" ]; then
	echo "El archivo $archivo ya existe. No se modificará."
	echo "Para continuar elimina el archivo."
	exit 1 # Salir del script con código de error
else
	if echo "# Mis Alias
# Cambiando "ls" a "eza"
alias ls='eza --icons -a --group-directories-first' # Nuevo ls con opciones preferidas
alias ld='eza --icons -D --group-directories-first'  # Solo Folder
alias ll='eza --icons -l --header --group-directories-first' # Formato Largo
alias lo='eza --icons -lo --header --group-directories-first' # Formato Largo Listado con permisos octales
alias lt='eza --icons -aT --group-directories-first' # Mostar Dentro Folder
alias l.='eza --icons -a | egrep "^\."' # Solo ocultos
alias li='eza --icons -a --git-ignore --group-directories-first' # ignorar archivos de .gitignore
alias lg='eza --icons -al --header --git --group-directories-first' # Formato Largo mas Git data
alias lp='eza --icons -al --header --octal-permissions --group-directories-first' # Formato Largo mas Permisos en octal y archivos ocultos" >>.alias_bash; then
		echo "El archivo $archivo se ha creado correctamente."
	fi
fi

archivo="$HOME/.bashrc" # Archivo a modificar
texto_a_buscar="if [ -f ~/.alias_bash ]; then"
linea="
# Agregar de alias en archivo externo
if [ -f ~/.alias_bash ]; then
	. ~/.alias_bash
fi
"

# Verificar si el archivo existe
if [ -e "$archivo" ]; then
	if grep -Fq "$texto_a_buscar" "$archivo"; then
		echo "El texto ya está presente en $archivo."
	else
		echo "$linea" >>"$archivo"
		if [ $? -eq 0 ]; then
			echo "Se ha agregado el texto a $archivo correctamente."
		else
			echo "Hubo un error al modificar el archivo."
		fi
	fi
else
	echo "El archivo $archivo no existe."
fi
