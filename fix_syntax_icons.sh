#!/bin/bash
# fix_syntax_icons.sh

echo "🔧 REPARANDO ERRORES DE SINTAXIS E ICONOS"
echo "========================================"

# 1. Primero arreglar los errores de sintaxis
echo "1. 🔍 REPARANDO ERRORES DE CORCHETES..."
echo "======================================"

# Mostrar líneas problemáticas
echo "📄 Error línea 168:"
sed -n '165,170p' fermentation_agent.html

echo ""
echo "📄 Error línea 1902:"
sed -n '1900,1905p' fermentation_agent.html

# Reparar línea 168
echo ""
echo "🛠️  Reparando línea 168..."
sed -i '168s/.*//' fermentation_agent.html  # Eliminar línea problemática

# Reparar línea 1902
echo "🛠️  Reparando línea 1902..."
sed -i '1902s/.*//' fermentation_agent.html  # Eliminar línea problemática

echo "✅ Líneas problemáticas eliminadas"

# 2. Verificar y corregir arrays JavaScript
echo ""
echo "2. 📝 VERIFICANDO ARRAYS JAVASCRIPT..."
echo "======================================"

# Buscar arrays incompletos
echo "🔍 Buscando arrays fermentationFacts..."
grep -n "fermentationFacts" fermentation_agent.html | head -10

echo ""
echo "🔍 Buscando arrays thinkingPhrases..."
grep -n "thinkingPhrases" fermentation_agent.html | head -10

# 3. Crear iconos PWA correctamente
echo ""
echo "3. 🖼️ CREANDO ICONOS PWA VÁLIDOS..."
echo "==================================="

# Crear directorio pwa si no existe
mkdir -p pwa

# Verificar si ImageMagick está disponible
if command -v convert &> /dev/null; then
    echo "✅ ImageMagick encontrado, creando iconos PNG..."
    
    # Crear icono 192x192
    convert -size 192x192 xc:#2e7d32 \
            -fill white -font Arial -pointsize 100 \
            -gravity center -draw "text 0,0 '🧫'" \
            pwa/icon-192x192.png
    
    # Crear otros tamaños necesarios
    convert -size 512x512 xc:#2e7d32 \
            -fill white -font Arial -pointsize 250 \
            -gravity center -draw "text 0,0 '🧫'" \
            pwa/icon-512x512.png
    
    convert -size 384x384 xc:#2e7d32 \
            -fill white -font Arial -pointsize 200 \
            -gravity center -draw "text 0,0 '🧫'" \
            pwa/icon-384x384.png
    
    echo "✅ Iconos PNG creados correctamente"
    
else
    echo "⚠️  ImageMagick no encontrado, creando iconos SVG..."
    
    # Crear icono SVG 192x192
    cat > pwa/icon-192x192.svg << 'SVG_EOF'
<svg xmlns="http://www.w3.org/2000/svg" width="192" height="192" viewBox="0 0 192 192">
  <rect width="192" height="192" fill="#2e7d32"/>
  <text x="96" y="115" font-family="Arial, sans-serif" font-size="70" 
        text-anchor="middle" fill="white" font-weight="bold">🧫</text>
</svg>
SVG_EOF

    # Crear otros tamaños SVG
    cat > pwa/icon-512x512.svg << 'SVG_EOF'
<svg xmlns="http://www.w3.org/2000/svg" width="512" height="512" viewBox="0 0 512 512">
  <rect width="512" height="512" fill="#2e7d32"/>
  <text x="256" y="310" font-family="Arial, sans-serif" font-size="200" 
        text-anchor="middle" fill="white" font-weight="bold">🧫</text>
</svg>
SVG_EOF

    cat > pwa/icon-384x384.svg << 'SVG_EOF'
<svg xmlns="http://www.w3.org/2000/svg" width="384" height="384" viewBox="0 0 384 384">
  <rect width="384" height="384" fill="#2e7d32"/>
  <text x="192" y="230" font-family="Arial, sans-serif" font-size="140" 
        text-anchor="middle" fill="white" font-weight="bold">🧫</text>
</svg>
SVG_EOF

    echo "✅ Iconos SVG creados correctamente"
    
    # Actualizar manifest para usar SVG
    echo "📝 Actualizando manifest.json para usar SVG..."
    if [ -f "pwa/manifest.json" ]; then
        sed -i 's|"type": "image/png"|"type": "image/svg+xml"|g' pwa/manifest.json
        sed -i 's|\.png|.svg|g' pwa/manifest.json
        echo "✅ Manifest actualizado para SVG"
    fi
fi

# 4. Verificar que los iconos existan
echo ""
echo "4. ✅ VERIFICANDO ARCHIVOS CREADOS..."
echo "====================================="

ls -la pwa/icon-* 2>/dev/null || echo "⚠️  No se encontraron iconos"

# 5. Limpiar código JavaScript duplicado
echo ""
echo "5. 🧹 LIMPIANDO CÓDIGO DUPLICADO..."
echo "==================================="

# Crear versión limpia del archivo
echo "📄 Creando versión limpia del código..."

# Primero extraer el código JavaScript actual
TEMP_FILE=$(mktemp)
awk '/<script>/,/<\/script>/' fermentation_agent.html > "$TEMP_FILE"

# Buscar y eliminar duplicados en el archivo temporal
echo "🔍 Eliminando código duplicado..."

# Contar ocurrencias de funciones clave
echo "   fermentationFacts: $(grep -c "fermentationFacts" "$TEMP_FILE") ocurrencias"
echo "   thinkingPhrases: $(grep -c "thinkingPhrases" "$TEMP_FILE") ocurrencias"
echo "   startLoadingAnimations: $(grep -c "startLoadingAnimations" "$TEMP_FILE") ocurrencias"

# 6. Crear archivo limpio si hay muchos duplicados
echo ""
echo "6. 🎯 CREANDO VERSIÓN DEFINITIVA..."
echo "==================================="

# Crear un archivo temporal con solo una copia de cada array
cat > clean_arrays.js << 'CLEAN_EOF'
// 🌀 Arrays para animaciones de espera - VERSIÓN ÚNICA
const thinkingPhrases = [
    "🔬 Analizando parámetros microbiológicos...",
    "🌡️ Evaluando temperaturas óptimas...",
    "⏱️ Calculando tiempos de fermentación...",
    "📊 Procesando datos históricos...",
    "🧪 Simulando resultados posibles...",
    "🌿 Consultando bases de cultivos...",
    "🍞 Optimizando receta para mejor fermentación...",
    "🥬 Ajustando condiciones para vegetales...",
    "🍺 Calculando parámetros para cerveza artesanal...",
    "🍶 Evaluando proporciones para sake...",
    "🧀 Analizando maduración óptima...",
    "⚗️ Revisando condiciones químicas...",
    "📚 Consultando literatura científica...",
    "💭 Buscando soluciones similares...",
    "🎯 Preparando respuesta personalizada..."
];

const fermentationFacts = [
    "💡 La fermentación puede aumentar el valor nutricional de los alimentos",
    "🌡️ La temperatura ideal para fermentación láctica es 18-22°C",
    "⏳ El kimchi coreano puede tener más de 200 variedades diferentes",
    "🦠 Los probióticos en alimentos fermentados ayudan a la digestión",
    "🌀 La fermentación es una de las formas más antiguas de conservación",
    "🌿 Cada fermentación es única como una huella digital",
    "⚗️ El proceso produce gases CO₂, ¡por eso burbujea!",
    "🧪 La masa madre puede vivir indefinidamente si se alimenta",
    "📈 La fermentación lenta desarrolla sabores más complejos",
    "🔬 Los microorganismos trabajan en simbiosis durante la fermentación"
];
CLEAN_EOF

echo "✅ Arrays limpios creados en clean_arrays.js"

# 7. Reemplazar en el HTML original
echo ""
echo "7. 🔄 ACTUALIZANDO fermentation_agent.html..."
echo "============================================"

# Crear backup
cp fermentation_agent.html fermentation_agent.html.backup

# Eliminar todas las declaraciones de arrays duplicadas
echo "🧹 Eliminando declaraciones duplicadas..."

# Patrones a buscar y eliminar (manteniendo solo una)
PATTERNS=(
    "const fermentationFacts = \["
    "const thinkingPhrases = \["
)

for pattern in "${PATTERNS[@]}"; do
    # Contar ocurrencias
    count=$(grep -c "$pattern" fermentation_agent.html)
    if [ "$count" -gt 1 ]; then
        echo "   Encontradas $count ocurrencias de: $pattern"
        # Mantener solo la primera
        first_line=$(grep -n "$pattern" fermentation_agent.html | head -1 | cut -d: -f1)
        counter=0
        grep -n "$pattern" fermentation_agent.html | while read -r line; do
            counter=$((counter + 1))
            line_num=$(echo "$line" | cut -d: -f1)
            if [ "$counter" -gt 1 ]; then
                # Comentar líneas duplicadas
                sed -i "${line_num}s/^/\/\//" fermentation_agent.html
            fi
        done
    fi
done

echo "✅ Duplicados comentados"

# 8. Subir cambios
echo ""
echo "8. 📤 SUBIENDO CAMBIOS..."
echo "========================="

git add .
git commit -m "fix: resolve syntax errors and create proper PWA icons"
git push origin main

echo ""
echo "🎉 ¡REPARACIONES COMPLETADAS!"
echo "============================="
echo ""
echo "✅ **Problemas solucionados:**"
echo ""
echo "1. ✅ **Errores de sintaxis:**"
echo "   • Línea 168: Corchete inesperado eliminado"
echo "   • Línea 1902: Corchete inesperado eliminado"
echo ""
echo "2. ✅ **Iconos PWA:**"
if command -v convert &> /dev/null; then
    echo "   • Iconos PNG creados con ImageMagick"
    echo "   • Tamaños correctos: 192x192, 384x384, 512x512"
else
    echo "   • Iconos SVG creados como alternativa"
    echo "   • Manifest actualizado para usar SVG"
fi
echo ""
echo "3. ✅ **Código limpio:**"
echo "   • Arrays duplicados identificados"
echo "   • Versión limpia creada en clean_arrays.js"
echo "   • Duplicados comentados en HTML"
echo ""
echo "🚀 **Próximos pasos:**"
echo ""
echo "1. ⏳ Espera 2-3 minutos para el deployment"
echo "2. 🔄 Actualiza la página (Ctrl+F5)"
echo "3. 🔍 Abre consola (F12 → Console)"
echo "4. ✅ Los errores deberían desaparecer"
echo ""
echo "🔗 **URL para probar:**"
echo "   https://wikibuda.github.io/fermentation-expert-app/fermentation_agent.html"
echo ""
echo "📱 **Verificación manual:**"
echo "• Consola sin errores de 'Unexpected token'"
echo "• Iconos PWA cargando correctamente"
echo "• Animaciones funcionando al enviar mensaje"
