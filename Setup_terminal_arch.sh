#!/bin/bash
# Script para la instalación de mis paquetes con pacman y flatpak
# Recuerda instalar primero flatpak, reiniciar la terminal y luego ejecuta este script para una instalación sin inconvenientes.
# --- Función para instalar y verificar un paquete pacman ---
exito=()
fracasos=()
function install_and_verify_pacman {
	local package_name=$1
	echo "Instalando: $package_name..."
	sudo pacman -S --noconfirm "$package_name"

	if [ $? -eq 0 ]; then
		echo "✅ '$package_name' instalado exitosamente."
		exito+=("$package_name")
	else
		echo "❌ ¡ERROR! No se pudo instalar '$package_name'."
		fracasos+=("$package_name")
	fi
}
function install_and_verify_flatpak {
	local package_name=$1
	echo "Instalando: $package_name..."
	sudo flatpak install "$package_name"

	if [ $? -eq 0 ]; then
		echo "✅ '$package_name' instalado exitosamente."
		exito+=("$package_name")
	else
		echo "❌ ¡ERROR! No se pudo instalar '$package_name'."
		fracasos+=("$package_name")
	fi
}
# Actualizar paquetes
sudo pacman -Syu

echo "------------------------------------------------------------------------------------------------------"
echo "✅ Iniciando la instalación de programas esenciales de la terminal..."
echo "------------------------------------------------------------------------------------------------------"
exito+=("#------------------------Programas esenciales de la terminal------------------------#")
install_and_verify_pacman eza
install_and_verify_pacman tldr
install_and_verify_pacman zoxide
install_and_verify_pacman fzf
install_and_verify_pacman ranger
install_and_verify_pacman duf
install_and_verify_pacman ncdu
install_and_verify_pacman ripgrep
install_and_verify_pacman bat
install_and_verify_pacman btop
install_and_verify_pacman git
install_and_verify_pacman tmux
if [ $? -eq 0 ]; then
	bash tmux_config.sh
fi
install_and_verify_pacman curl
install_and_verify_pacman cmus
if [ $? -eq 0 ]; then
	sudo pacman -Syu libvorbis flac wavpack libmad
fi
install_and_verify_pacman pandoc
install_and_verify_pacman pavucontrol
install_and_verify_pacman obs-studio
install_and_verify_pacman nvim
bash Neovim_setup.sh
install_and_verify_pacman typst
echo "#------------------------------------------------------------------------------------------------------#"
echo "✅ Todos los programas esenciales de la terminal han sido procesados."
echo "------------------------------------------------------------------------------------------------------"
echo "------------------------------------------------------------------------------------------------------"
echo "✅ Iniciando la instalación de otras aplicaciones..."
echo "------------------------------------------------------------------------------------------------------"
exito+=("#------------------------Otros Programas------------------------#")
install_and_verify_pacman zathura
install_and_verify_pacman keepassxc
install_and_verify_pacman syncthing
install_and_verify_pacman qbittorrent
install_and_verify_pacman flameshot
install_and_verify_pacman lutris
install_and_verify_pacman steam # selecciona el vulkan-driver y las librerias
install_and_verify_pacman mpv   # Sustituto a vlc, el cual da problemas de compatibilidad
install_and_verify_pacman alacritty
if [ $? -eq 0 ]; then
	bash alacritty_config.sh
fi
# Instalar wget si no está instalado
if ! command wget --version &>/dev/null; then
	install_and_verify_pacman wget
fi
install_and_verify_pacman ibus-anthy
install_and_verify_pacman obsidian
install_and_verify_pacman xournalpp
install_and_verify_pacman cpu-x
install_and_verify_pacman handbrake
install_and_verify_pacman kdeconnect
if [ $? -eq 0 ]; then
	sudo firewall-cmd --permanent --zone=public --add-service=kdeconnect
	sudo firewall-cmd --reload
fi

# Configuración de flathub
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
install_and_verify_flatpak flatseal
install_and_verify_flatpak drawio
install_and_verify_flatpak peazip
install_and_verify_flatpak joplin
install_and_verify_flatpak luna
install_and_verify_flatpak Ankiweb
echo "------------------------------------------------------------------------------------------------------"
echo "✅ ¡Script completado! Se han procesado todas las instalaciones de aplicaciones GUI."
echo "------------------------------------------------------------------------------------------------------"

echo "------------------------------------------------------------------------------------------------------"
echo "✅ Iniciando la instalación de las herramientas de desarrollo..."
echo "------------------------------------------------------------------------------------------------------"

exito+=("#------------------------Herramientas de desarrollo------------------------#")
# Buscando paquetes

echo "------------------------------------------------------------------------------------------------------"
install_and_verify_pacman nodejs
install_and_verify_pacman npm

echo "Verificando Node.js y NPM..."
if command -v node &>/dev/null; then
	echo "✅ Node.js instalado. Versión: $(node -v)"
else
	echo "❌ Node.js no se encontró."
fi

if command -v npm &>/dev/null; then
	echo "✅ NPM instalado. Versión: $(npm -v)"
else
	echo "❌ NPM no se encontró."
fi

echo "------------------------------------------------------------------------------------------------------"
# Instalar Python y PIP
install_and_verify_pacman python3
install_and_verify_pacman python-pip

echo "Verificando Python y PIP..."
if command -v python3 &>/dev/null; then
	echo "✅ Python 3 instalado. Versión: $(python3 -V)"
else
	echo "❌ Python 3 no se encontró."
fi

if command -v pip3 &>/dev/null; then
	echo "✅ PIP 3 instalado. Versión: $(pip3 -V)"
else
	echo "❌ PIP 3 no se encontró."
fi

echo "------------------------------------------------------------------------------------------------------"
# Instalar Rust y Cargo
install_and_verify_pacman rustup

echo "Verificando Rust, Cargo y Rustup..."
if command -v rustc &>/dev/null; then
	echo "✅ Rustc instalado. Versión: $(rustc --version)"
else
	echo "❌ Rustc no se encontró."
fi

if command -v cargo &>/dev/null; then
	echo "✅ Cargo instalado. Versión: $(cargo --version)"
else
	echo "❌ Cargo no se encontró."
fi

if command -v rustup &>/dev/null; then
	echo "✅ Rustup instalado. Versión: $(rustup --version)"
else
	echo "❌ Rustup no se encontró."
fi

echo "------------------------------------------------------------------------------------------------------"
# Instalar Deno
echo "Instalando Deno..."
curl -fsSL https://deno.land/x/install/install.sh

echo "Verificando Deno..."
if command -v deno &>/dev/null; then
	echo "✅ Deno instalado. Versión: $(deno -V)"
else
	echo "❌ Deno no se encontró. Asegúrate de que $HOME/.deno/bin esté en tu variable PATH."
fi

echo "------------------------------------------------------------------------------------------------------"
echo "✅ ¡Script completado! Se han procesado todas las instalaciones."
echo "------------------------------------------------------------------------------------------------------"

# Mensaje final
echo "✅ Procesos completados exitosamente: "
for package_name in "${exito[@]}"; do
	echo "+ $package_name"
done
echo "#------------------------------------------------------------------------------------------------------#"
if [ ${#fracasos[@]} -eq 0 ]; then
	echo "✅ No hubo paquetes fallidos."
else
	# Este bloque solo se ejecuta si el array no está vacío
	echo "❌ Se encontraron los siguientes paquetes fallidos:"
	for paquete in "${fracasos[@]}"; do
		echo "- $paquete"
	done
fi
echo "#------------------------------------------------------------------------------------------------------#"
echo "Tareas pendientes post-instalación:"
echo "1. Recuerda configurar zoxide, ranger, eza, ibus y tmux."
echo "2. Para el uso interactivo en una nueva terminal, las rutas de zoxide y Deno deberían estar en tu PATH."
echo "   source \$HOME/.deno/bin" # Esta línea puede no ser necesaria si el script de Deno ya modifica ~/.bashrc
echo "   eval \"\$(zoxide init bash)\""
echo "3. Instala mediante la tienda de software (o Flatpak/Snap si no están disponibles en apt) las aplicaciones gráficas como Xournal++."
echo "#------------------------------------------------------------------------------------------------------#"
