#!/bin/bash
# Script para la configuración de tmux

# Verificar si el archivo .tmux.conf ya existe
if [ ! -f ~/.tmux.conf ]; then
	echo '
# Habilitar el uso del mouse
set -g mouse on

# Mejorar la compatibilidad de colores en terminales modernas
set -g default-terminal "tmux-256color"
set -ga terminal-overrides ",alacritty:Tc"

# Recargar configuración sin reiniciar tmux
bind-key R source-file ~/.tmux.conf \; display-message "Configuración recargada!"

# Configurar el fondo y el texto
set -g status-style fg=#f8f8f2,bg=#282a36

# Colores del borde de los paneles
set -g pane-border-style fg=#bfbfbf
set -g pane-active-border-style fg=#8be9fd

# Colores de las ventanas
set -g window-status-style fg=#50fa7b,bg=#282a36
set -g window-status-current-style fg=#bd93f9,bg=#282a36

# Colores para mensajes en tmux
set -g message-style fg=#ff5555,bg=#282a36

# Sincronizacion de terminales
setw -g synchronize-panes off

# Colores de resaltado en la barra de estado
setw -g mode-style fg=#282a36,bg=#f1fa8c

# Colores de los indicadores de ventana
setw -g window-status-bell-style fg=#ff5555,bg=#282a36

# Configurar True Color en tmux
set -g default-terminal "tmux-256color"
set -ga terminal-overrides ",alacritty:Tc"

# Recargar configuración automáticamente
bind r source-file ~/.tmux.conf \; display-message "Tmux recargado!"
	' >>"$HOME/.tmux.conf"

	if [ $? -eq 0 ]; then
		echo "✅ Tmux configurado exitosamente."
	else
		echo "❌ ¡ERROR! No se pudo configurar Tmux."
	fi
else
	echo "Tmux ya estaba instalado"
fi
