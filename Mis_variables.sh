#!/bin/bash
# Script para crear un archivo .Mis_variable en la carpeta actual y agregarlo al .bashrc
cd ~/

# Atento: Si el archivo ya existe, no se modificará
# Verifica que Mis_scripts este en la carpeta esperada
if [ -e ".Mis_variables" ]; then
	echo "El archivo $archivo ya existe. No se modificará."
	echo "Para continuar elimina el archivo."
	exit 1 # Salir del script con código de error
else
	if echo "# Editor de terminal por defecto
		export VISUAL=nvim
		# Mis scripts
		export PATH=$PATH:/home/ariana/Otros/Mis_scripts" >>.Mis_variable; then
		echo "El archivo Mis_variables se ha creado correctamente."
	fi
fi

archivo="$HOME/.bashrc" # Archivo a modificar
texto_a_buscar="if [ -f ~/.Mis_variables ]; then"
linea="
# Agregar de alias en archivo externo
if [ -f ~/.Mis_variables ]; then
	. ~/.Mis_variables
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
source ~/.bashrc
