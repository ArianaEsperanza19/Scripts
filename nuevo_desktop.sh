#!/bin/bash
# Crear ejecutable desde carpeta externa, sin moverla a /opt
# Mejoras posibles: Verificar si existe un archivo con el mismo nombre en la carpeta de aplicaciones.
# Dar la opcion de dejarlo o sustituirlo.
echo "Recuerda no introducir / al final"
cent_exe=0

finder() {
	local destino="$icon_dest/$img"
	# El operador -f comprueba si el archivo existe y es regular
	if [[ -f "$destino" ]]; then
		return 0 # Lo encontró
	else
		return 1 # No lo encontró
	fi
}

while [[ cent_exe != 1 ]]; do
	read -p "Ingresa el nombre de la aplicacion: " name
	read -p "Ingresa exacto el nombre del ejecutable: " exe
	read -p "Direccion de la carpeta del ejecutable: " dir
	route="$HOME/$dir/$exe"
	if [[ -f $route ]]; then
		echo "Ruta verificada"
		cent_exe=1
		break
	else
		echo "Error, ejecutable no encontrado"
		echo "Ruta ingresada: $route"
		exit 0
	fi
done

read -p "Introduce la categoría (ej: Game, Utility, AudioVideo): " category
icon_dest="$HOME/.local/share/applications/icons"
mkdir -p "$icon_dest" # Seguridad: crear la carpeta si no existe

cent_icon=0
while ((cent_icon != 1)); do
	read -p "Ingresa el nombre del icono en ~/Imágenes (ej: icono.png): " img
	icon="$HOME/Imágenes/$img"

	if [[ -f "$icon" ]]; then
		echo "Imagen origen encontrada..."

		# Llamamos a la función finder
		if finder; then
			echo "El icono ya existe en la carpeta de destino ($icon_dest)."
			cent_icon=1
		else
			echo "Copiando icono a la carpeta de aplicaciones..."
			cp "$icon" "$icon_dest/"

			if [[ $? -eq 0 ]]; then
				echo "¡Copiado con éxito!"
				cent_icon=1
			else
				echo "Error crítico al copiar el icono."
				exit 1 # Salimos con error
			fi
		fi
	else
		echo "Error: La imagen no existe en $icon"
	fi
done

if [[ $cent_exe && $cent_icon ]]; then
	desktop_file="$HOME/.local/share/applications/$name.desktop"
	icon="$icon_dest/$img"
	cat <<EOF >"$desktop_file"
[Desktop Entry]
Type=Application
Version=1.0
Name=$name
Comment=Lanzador de $name
Exec="$route"
Icon="$icon"
Terminal=false
Categories=$category;
EOF

	sudo chmod +x "$desktop_file"
	sudo chmod +x "$route"
	update-desktop-database "$HOME/.local/share/applications"
fi
