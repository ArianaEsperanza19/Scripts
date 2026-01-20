#!/bin/bash

archivo="$HOME/.bashrc"
# Usamos una marca única para que el script no falle al buscar
marca="# [PROMPT_COLORES_RUST]"
colores="export PS1='\[\e[32m\]\u@\h\[\e[m\]:\[\e[34m\]\w\[\e[m\]\$' $marca"

if [ -f "$archivo" ]; then
	# Buscamos solo la marca única, no toda la cadena compleja
	if grep -qF "$marca" "$archivo"; then
		echo "La configuración de colores ya existe en $archivo."
	else
		echo -e "\n$colores" >>"$archivo"
		if [ $? -eq 0 ]; then
			echo "Configuración agregada correctamente."
		else
			echo "Error al modificar el archivo."
		fi
	fi
else
	echo "El archivo $archivo no existe."
fi
