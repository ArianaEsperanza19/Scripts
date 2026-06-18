#!/bin/bash
# Obtenemos el estado actual del led de scrolllock
# Note: It's necesary use "brightnessctl" to manage lights of devices. You may install them by: sudo pacman -S brightnessctl
ESTADO=$(brightnessctl --device='input5::scrolllock' get)

if [ "$ESTADO" -eq 1 ]; then
	brightnessctl --device='input5::scrolllock' set 0
else
	brightnessctl --device='input5::scrolllock' set 1
fi
