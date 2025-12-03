#!/bin/bash
# Script para la instalación de mis paquetes con apt y flatpak
# Recuerda instalar primero snapd y flatpak, reiniciar la terminal y luego ejecuta este script para una instalación sin inconvenientes.
# --- Función para instalar y verificar un paquete apt ---
exito=()
fracasos=()
function install_and_verify_apt {
	local package_name=$1
	echo "Instalando: $package_name..."
	sudo apt install -y "$package_name"

	if [ $? -eq 0 ]; then
		echo "✅ '$package_name' instalado exitosamente."
		exito+=("$package_name")
	else
		echo "❌ ¡ERROR! No se pudo instalar '$package_name'."
		fracasos+=("$package_name")
	fi
}
# --- Función para instalar y verificar un paquete flatpak ---
function install_and_verify_flatpak {
	local package_name=$1
	echo "Instalando: $package_name..."
	sudo flatpak install -y "$package_name"

	if [ $? -eq 0 ]; then
		echo "✅ '$package_name' instalado exitosamente."
		exito+=("$package_name")
	else
		echo "❌ ¡ERROR! No se pudo instalar '$package_name'."
		fracasos+=("$package_name")
	fi
}
function install_and_verify_snap {
	local package_name=$1
	echo "Instalando: $package_name..."
	sudo snap install "$package_name" --classic

	if [ $? -eq 0 ]; then
		echo "✅ '$package_name' instalado exitosamente."
		exito+=("$package_name")
	else
		echo "❌ ¡ERROR! No se pudo instalar '$package_name'."
		fracasos+=("$package_name")
	fi
}

# Actualizar paquetes
sudo apt update && sudo apt upgrade -y

echo "------------------------------------------------------------------------------------------------------"
echo "✅ Iniciando la instalación de programas esenciales de la terminal..."
echo "------------------------------------------------------------------------------------------------------"
exito+=("#------------------------Programas esenciales de la terminal------------------------#")
install_and_verify_apt eza
install_and_verify_apt tldr
install_and_verify_apt zoxide
install_and_verify_apt ranger
install_and_verify_apt duf
install_and_verify_apt ncdu
install_and_verify_apt ripgrep
install_and_verify_apt btop
install_and_verify_apt git
install_and_verify_apt tmux
if [ $? -eq 0 ]; then
	bash tmux_config.sh
fi
install_and_verify_apt curl
install_and_verify_apt cmus
install_and_verify_apt pandoc
install_and_verify_apt pavucontrol
install_and_verify_apt obs-studio
install_and_verify_snap nvim
echo "#------------------------------------------------------------------------------------------------------#"
echo "✅ Todos los programas esenciales de la terminal han sido procesados."
echo "------------------------------------------------------------------------------------------------------"
echo "------------------------------------------------------------------------------------------------------"
echo "✅ Iniciando la instalación de otras aplicaciones..."
echo "------------------------------------------------------------------------------------------------------"
exito+=("#------------------------Otros Programas------------------------#")
install_and_verify_apt zathura
install_and_verify_apt anki
install_and_verify_apt keepassxc
install_and_verify_apt stacer
install_and_verify_apt syncthing
install_and_verify_apt flameshot
install_and_verify_apt lutris
install_and_verify_apt steam
install_and_verify_apt vlc
# Instalar alacritty para X11
install_and_verify_apt gnome-log
if [ ! $XDG_SESSION_TYPE = "wayland" ]; then
	install_and_verify_apt alacritty
	bash alacritty_config.sh
fi
# Instalar wget si no está instalado
if ! command wget --version &>/dev/null; then
	install_and_verify_apt wget
fi
# Instalar ibus-anthy
wget -P $HOME/Descargas/ http://ftp.de.debian.org/debian/pool/main/i/ibus-anthy/ibus-anthy_1.5.17-1_amd64.deb
sudo dpkg -i $HOME/Descargas/ibus-anthy_1.5.17-1_amd64.deb
if [ $? -eq 0 ]; then
	echo "✅ 'ibus-anthy' instalado exitosamente."
	exito+=("ibus-anthy")
	sudo rm -drf $HOME/Descargas/ibus-anthy_1.5.17-1_amd64.deb
else
	if [ $? -eq 0 ]; then
		sudo apt-get install -f
		sudo dpkg -i $HOME/Descargas/ibus-anthy_1.5.17-1_amd64.deb
	else
		echo "❌ ¡ERROR! No se pudo instalar 'ibus-anthy'."
		fracasos+=("ibus-anthy")
	fi
fi

# Configuración de flathub
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

install_and_verify_flatpak flatseal
install_and_verify_flatpak cpu-x
install_and_verify_flatpak drawio
install_and_verify_flatpak obsidian
install_and_verify_flatpak peazip
install_and_verify_flatpak handbrake
echo "------------------------------------------------------------------------------------------------------"
echo "✅ ¡Script completado! Se han procesado todas las instalaciones de aplicaciones GUI."
echo "------------------------------------------------------------------------------------------------------"

echo "------------------------------------------------------------------------------------------------------"
echo "✅ Iniciando la instalación de las herramientas de desarrollo..."
echo "------------------------------------------------------------------------------------------------------"

exito+=("#------------------------Herramientas de desarrollo------------------------#")
# Instalar LaTeX
install_and_verify_apt texlive-latex-base
install_and_verify_apt texlive-latex-extra
install_and_verify_apt latexmk
install_and_verify_apt texlive-lang-spanish
install_and_verify_apt texlive-xetex
install_and_verify_apt typst

echo "------------------------------------------------------------------------------------------------------"

# Instalar Node.js y NPM
install_and_verify_apt nodejs
install_and_verify_apt npm

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
install_and_verify_apt python3
install_and_verify_apt python3-pip
install_and_verify_apt python3.12-venv

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
install_and_verify_apt rustup

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
