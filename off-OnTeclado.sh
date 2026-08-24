#!/bin/bash
# Redirigimos la salida a /dev/null para que no se vea nada en pantalla
# Note: It's necesary use "brightnessctl" to manage lights of devices. You may install them by: sudo pacman -S brightnessctl
#
# 1. Buscamos el dispositivo
DEVICE=$(brightnessctl -l | grep -oE '[^ ]+::scrolllock' | head -n 1)

# 2. Limpiamos cualquier comilla simple molestosa que devuelva el comando
DEVICE="${DEVICE//\'/}"

# Si no encuentra ningún dispositivo, salimos silenciosamente
if [ -z "$DEVICE" ]; then
	exit 1
fi

# 3. Obtenemos el estado actual
ESTADO=$(brightnessctl --device="$DEVICE" get 2>/dev/null)

# Si el estado queda vacío por algún motivo, asumimos que está apagado (0)
if [ -z "$ESTADO" ]; then
	ESTADO=0
fi

# 4. Alternamos el estado
if [ "$ESTADO" -eq 1 ]; then
	brightnessctl --device="$DEVICE" set 0 >/dev/null 2>&1
else
	brightnessctl --device="$DEVICE" set 1 >/dev/null 2>&1
fi
