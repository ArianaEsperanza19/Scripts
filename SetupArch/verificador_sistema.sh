#!/bin/bash

# Lista de paquetes esenciales (Nota: se maneja el generador de initramfs por separado)
PAQUETES=("linux" "linux-headers" "intel-ucode" "mesa" "libva-intel-driver")

echo "--- Iniciando verificación de componentes esenciales ---"

for pkg in "${PAQUETES[@]}"; do
	if pacman -Qs "^$pkg$" >/dev/null; then
		echo "✅ El paquete '$pkg' ya está instalado."
	else
		echo "⚠️ El paquete '$pkg' no se encontró. Instalando..."
		sudo pacman -S --noconfirm "$pkg"
	fi
done

echo "--- Detectando generador de initramfs ---"

# Verificamos si el sistema usa dracut o mkinitcpio para no crear conflictos de dependencias
if pacman -Qs "^dracut$" >/dev/null || pacman -Qs "^kernel-install-for-dracut$" >/dev/null; then
	echo "📦 Se detectó 'dracut' como el generador activo. Regenerando imágenes de arranque..."
	sudo dracut --regenerate-all --force
elif pacman -Qs "^mkinitcpio$" >/dev/null; then
	echo "📦 Se detectó 'mkinitcpio' como el generador activo. Regenerando imágenes de arranque..."
	sudo mkinitcpio -P
else
	echo "❌ Advertencia: No se detectó ni mkinitcpio ni dracut de forma explícita."
fi

echo "¡Sistema verificado y actualizado!"

#INFO: Desglose de los componentes del sistema
#
#linux: Es el Kernel de Linux, el núcleo fundamental que comunica tu hardware (procesador, RAM, puertos) con el software. Sin él, el sistema literalmente no puede iniciarse.
#
#linux-headers: Son los archivos de cabecera necesarios para compilar módulos externos del kernel. Aunque parezca que no los usas directamente, son vitales si, por ejemplo, instalas drivers o herramientas que necesitan "conectarse" al núcleo del sistema para funcionar correctamente.
#
#dracut / mkinitcpio: Son los motores encargados de crear la imagen de inicio (initramfs). Esta imagen es un pequeño sistema temporal que se carga en la RAM al encender el PC; su trabajo es cargar los drivers mínimos necesarios para que el disco duro pueda ser "montado". (Helios utiliza 'dracut' de forma nativa).
#
#intel-ucode: Son los microcódigos de Intel. Los procesadores pueden tener errores de diseño de fábrica; este paquete aplica parches de software a nivel de hardware cada vez que enciendes la PC para corregir fallos de seguridad o inestabilidad en tu CPU Intel.
#
#mesa: Es la implementación de código abierto de OpenGL y Vulkan. Es la librería que traduce los cálculos matemáticos de tus juegos y programas a imágenes que tu procesador Intel puede mostrar en pantalla. Sin mesa, no tendrías aceleración gráfica por hardware.
#
#libva-intel-driver: Es una librería especializada en la decodificación de video por hardware (VA-API). Permite que tu procesador Intel maneje la reproducción de video (como en YouTube o VLC) sin sobrecargar al CPU, haciendo que la reproducción sea fluida y consuma menos energía.
