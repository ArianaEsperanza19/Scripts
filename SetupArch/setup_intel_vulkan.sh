#!/bin/bash
# Script para instalar librerias necesarias para Vulkan e Intel.
echo "--- Iniciando configuración de librerías Vulkan y Gráficos Intel ---"

# Asegurar que los comandos de pacman corran como root (pide sudo si no se ejecutó con él)
if [ "$EUID" -ne 0 ]; then
    echo "Se necesitan permisos de administrador para instalar los paquetes."
    exec sudo "$0" "$@"
fi

# 2. Instalación de librerías base de 32 bits y Vulkan
echo "Instalando loaders y herramientas de diagnóstico..."
pacman -S --needed --noconfirm lib32-vulkan-icd-loader vulkan-icd-loader vulkan-tools

# 3. Instalación de drivers Intel (ANV) y soporte Mesa
echo "Instalando drivers de Intel y librerías Mesa..."
pacman -S --needed --noconfirm vulkan-intel lib32-vulkan-intel mesa lib32-mesa

echo "--- Configuración finalizada ---"

# Verificación rápida
echo "Verificando instalación de Vulkan..."
if command -v vulkaninfo &>/dev/null; then
    echo "Vulkan detectado correctamente. Resumen:"

    # El truco: Si estamos usando sudo, ejecuta vulkaninfo con el usuario real que lanzó el script
    if [ -n "$SUDO_USER" ]; then
        sudo -u "$SUDO_USER" XDG_RUNTIME_DIR="/run/user/$(id -u $SUDO_USER)" vulkaninfo --summary | grep "device name"
    else
        vulkaninfo --summary | grep "device name"
    fi
else
    echo "Error: vulkaninfo no se pudo ejecutar."
fi
