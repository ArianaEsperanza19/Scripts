#!/bin/bash

# Nombre del archivo (sin el signo $ al definirlo)
archivo=".alias_bash"
destino="$HOME/$archivo"
origen="$HOME/Otros/Mis_scripts/Alias"

# Verificamos si el archivo existe (usamos -f para archivos)
if [ -f "$destino" ]; then
	echo "⚠️  El archivo $archivo ya existe."
	read -p "¿Deseas sobrescribirlo con tu configuración de aliases? (s/n): " confirm

	if [[ "$confirm" =~ ^[Ss]$ ]]; then
		cp "$origen" "$destino"
		echo "✅ Archivo $archivo actualizado."
	else
		echo "❌ Operación cancelada. El archivo NO se modificó."
	fi
else
	echo "Copiando archivo de alias..."
	cp "$origen" "$destino"
	echo "✅ Archivo de configuración creado con éxito."
fi
