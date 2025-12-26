#!/bin/bash
# Script para crear archivo .desktop para crear un ejecutable en el menu.

echo "Recuerda no introducir / al final"
read -p "Introduce la ruta a la carpeta contenedora: " dir
read -p "Introduce el nombre de la carpeta: " name

# Usamos $HOME en lugar de /home/$USER para mayor compatibilidad
route="$dir/$name"

if [ -d "$route" ]; then
	echo "La ruta es correcta. Copiando a /opt..."
	sudo cp -R "$route" "/opt/"
	sudo chown -R $USER:$USER "/opt/$name"
	echo "Copiado a: /opt/$name"
else
	echo "Error: Ruta de origen incorrecta"
	exit 1
fi

read -p "Introduce el nombre del ejecutable (ej: programa.bin): " file
executable="/opt/$name/$file"

read -p "Introduce nombre del icono con extensión (debe estar en ~/Imágenes): " img
icon_source="$HOME/Imágenes/$img"
icon_dest="$HOME/.local/share/applications/icons"

# Crear carpeta de iconos si no existe
mkdir -p "$icon_dest"

if [ -f "$icon_source" ]; then
	cp "$icon_source" "$icon_dest/"
	echo "Imagen copiada con éxito."
else
	echo "Aviso: No se encontró el icono en $icon_source"
fi

# Verificación y creación del lanzador
if [ -f "$executable" ]; then
	desktop_file="$HOME/.local/share/applications/$name.desktop"
	read -p "Introduce la categoría (ej: Game, Utility, AudioVideo): " category

	# Usamos cat <<EOF para que el formato sea perfecto y sin espacios al inicio
	cat <<EOF >"$desktop_file"
[Desktop Entry]
Type=Application
Version=1.0
Name=$name
Comment=Lanzador de $name
Exec="$executable"
Icon=$icon_dest/$img
Terminal=false
Categories=$category;
EOF

	chmod +x "$desktop_file"
	update-desktop-database "$HOME/.local/share/applications"
	echo "¡Listo! El acceso directo '$name' ya debería aparecer en tu menú."
else
	echo "Error: El ejecutable no se encuentra en $executable"
fi
