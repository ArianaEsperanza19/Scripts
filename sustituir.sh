#!/bin/bash

dir="/opt/"
read -p "Ingresa el nombre de la aplicacion: " name

if [ -d "$dir/$name" ]; then
	echo "La carpeta existe perfectamente."
fi

# if rg --files | rg -P "${name}$"; then
# 	echo "Texto encontrado"
# fi
