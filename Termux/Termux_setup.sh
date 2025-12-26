#!/data/data/com.termux/files/usr/bin/bash

echo "🔄 1. Sincronizando repositorios y actualizando TODAS las librerías..."
# Esto evita el error de libbfd y versiones desactualizadas
pkg update -y && pkg upgrade -y

echo "🛠️ 2. Instalando base para compilación (Tree-sitter)..."
pkg install -y clang make binutils gold libcrypt

echo "📦 3. Instalando utilidades de descompresión y red (Mason/Lazy)..."
pkg install -y git unzip tar wget curl gettext

echo "💻 4. Instalando Runtimes y LSPs Nativos (Evita errores de plataforma)..."
# Instalamos lua-language-server aquí para que Mason no falle
pkg install -y nodejs-lts python lua-language-server stylua

echo "💻 5. Instalando fzf para buscar"
pkg install -y fzf

echo "💻 6. Instalando ranger para buscar"
pkg install -y ranger

echo "💻 7. Instalando ripgrep para buscar"
pkg install -y ripgrep

echo "📂 8. Instalando duf y ncdu"
pkg install -y duf ncdu

echo "✨ 9. Instalando bat"
pkg install -y bat

echo "📂 10. Configurando acceso a archivos..."
# Si ya lo tenías, no pasa nada por ejecutarlo de nuevo
termux-setup-storage

echo "✨ 0. Limpieza de caché..."
pkg clean

echo "----------------------------------------------------"
echo "✅ ¡ENTORNO LISTO!"
echo "----------------------------------------------------"
echo "Para que LazyVim NO intente reinstalar lua_ls, recuerda"
echo "configurar 'mason = false' en tu archivo de plugins."
echo "----------------------------------------------------"
echo "Reinicia Termux (escribe 'exit') y vuelve a entrar."
EOF
