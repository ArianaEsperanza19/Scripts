#!/bin/bash
# Script para la configuración de alacritty

if [ ! -d "$HOME/.config/alacritty" ] && [ ! $XDG_SESSION_TYPE = "wayland" ]; then
	mkdir -p "$HOME/.config/alacritty"
	echo '
[bell]
animation = "Ease"
duration = 1
color = "#ffffff"

[colors.cursor]
cursor = "#f5e0dc"
text = "#1e1e2e"

[colors.primary]
background = "#282a36"
foreground = "#f8f8f2"

[colors.normal]
black = "#000000"
red = "#ff5555"
green = "#50fa7b"
yellow = "#f1fa8c"
blue = "#bd93f9"
magenta = "#ff79c6"
cyan = "#8be9fd"
white = "#bfbfbf"

[colors.bright]
black = "#4d4d4d"
red = "#ff6e67"
green = "#5af78e"
yellow = "#f4f99d"
blue = "#caa9fa"
magenta = "#ff92d0"
cyan = "#9aedfe"
white = "#e6e6e6"

[cursor]
style = "Block"

[font]
size = 14.0
offset = { x = 0, y = 0 }
glyph_offset = { x = 0, y = 0 }
builtin_box_drawing = true

[font.normal]
family = "3270 Nerd Font"
style = "Regular"

[[keyboard.bindings]]
action = "Quit"
key = "Q"
mods = "Control|Shift"

[scrolling]
history = 10000
multiplier = 3

[selection]
save_to_clipboard = true

[window]
decorations = "full"
opacity = 0.9
startup_mode = "Windowed"  # Asegúrate de que Alacritty se inicie en modo ventana

[window.padding]
x = 10
y = 10

[shell]
program = "/bin/bash"  # O el shell que uses
args = ["--login"]
# Si tienes Tmux
# program = "/usr/bin/tmux"
# args = ["new-session", "-A", "-s", "default"]
	' >>"$HOME/.config/alacritty/alacritty.toml"

	if [ $? -eq 0 ]; then
		echo "✅ Alacritty configurado exitosamente."
	else
		echo "❌ ¡ERROR! No se pudo configurar Alacritty."
	fi
else
	echo "Alacritty ya estaba instalado"
fi
