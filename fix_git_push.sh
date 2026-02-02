#!/bin/bash
echo "🔧 SOLUCIONANDO PUSH A GITHUB"
echo "=============================="

# Opción 1: Configurar SSH
echo ""
echo "1. Configurando SSH..."
git remote set-url origin git@github.com:wikibuda/fermentation-expert-app.git
echo "✅ Remote cambiado a SSH"

# Opción 2: Verificar y generar SSH key si no existe
if [ ! -f ~/.ssh/id_ed25519.pub ]; then
    echo ""
    echo "2. Generando nueva clave SSH..."
    ssh-keygen -t ed25519 -C "wikibuda@github.com" -f ~/.ssh/id_ed25519 -N ""
    echo "✅ Clave SSH generada"
    echo ""
    echo "📋 COPIA ESTA CLAVE PÚBLICA Y PÉGALA EN GITHUB:"
    echo "=============================================="
    cat ~/.ssh/id_ed25519.pub
    echo "=============================================="
    echo ""
    echo "📝 Ve a: https://github.com/settings/keys"
    echo "Haz clic en 'New SSH key' y pega la clave de arriba"
    read -p "Presiona Enter después de agregar la clave a GitHub..."
fi

# Opción 3: Probar conexión
echo ""
echo "3. Probando conexión SSH..."
ssh -T git@github.com

# Opción 4: Intentar push
echo ""
echo "4. Intentando push..."
git push -u origin main

# Si falla, mostrar opción HTTPS
if [ $? -ne 0 ]; then
    echo ""
    echo "⚠️  SSH falló. Intentando con HTTPS..."
    echo ""
    echo "📝 Crea un token en: https://github.com/settings/tokens"
    echo "Con permisos: repo (full control)"
    echo ""
    read -p "Pega tu token aquí: " TOKEN
    if [ -n "$TOKEN" ]; then
        git remote set-url origin https://wikibuda:$TOKEN@github.com/wikibuda/fermentation-expert-app.git
        git push -u origin main
    fi
fi
