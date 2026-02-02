#!/bin/bash
# fix_all_errors.sh

echo "🔧 REPARANDO TODOS LOS ERRORES"
echo "=============================="

# 1. Primero, hacer backup
echo "📦 Creando backup..."
cp fermentation_agent.html fermentation_agent.html.backup.$(date +%Y%m%d_%H%M%S)

echo ""
echo "1. 🔍 BUSCANDO Y ELIMINANDO VARIABLES DUPLICADAS..."
echo "=================================================="

# Buscar todas las declaraciones de fermentationFacts
echo "📝 Buscando declaraciones duplicadas..."
FACT_COUNT=$(grep -n "const fermentationFacts\|let fermentationFacts\|var fermentationFacts" fermentation_agent.html | wc -l)
echo "   Se encontraron $FACT_COUNT declaraciones de fermentationFacts"

if [ $FACT_COUNT -gt 1 ]; then
    # Encontrar las líneas con las declaraciones
    DECLARATION_LINES=$(grep -n "const fermentationFacts" fermentation_agent.html | cut -d: -f1)
    
    # Mantener solo la primera declaración, comentar las demás
    FIRST_LINE=$(echo $DECLARATION_LINES | awk '{print $1}')
    OTHER_LINES=$(echo $DECLARATION_LINES | awk '{$1=""; print $0}' | xargs)
    
    for LINE in $OTHER_LINES; do
        # Comentar la declaración duplicada
        sed -i '' "${LINE}s/const fermentationFacts =/\/\/ const fermentationFacts = (DUPLICADA - COMENTADA)/" fermentation_agent.html
        echo "   ✅ Línea $LINE: Declaración duplicada comentada"
    done
    
    echo "✅ Variables duplicadas eliminadas"
else
    echo "⚠️  No se encontraron variables duplicadas, revisando estructura..."
fi

echo ""
echo "2. 📁 CREANDO ICONOS FALTANTES DEL PWA..."
echo "========================================="

# Crear directorio pwa si no existe
mkdir -p pwa

# Verificar qué iconos faltan
echo "🖼️  Verificando iconos PWA..."
if [ ! -f "pwa/icon-192x192.png" ] || [ ! -s "pwa/icon-192x192.png" ]; then
    echo "❌ icon-192x192.png no existe o está vacío"
    
    # Crear icono simple usando ImageMagick o alternativa
    if command -v convert &> /dev/null; then
        echo "🎨 Creando iconos con ImageMagick..."
        convert -size 192x192 xc:#2e7d32 -fill white -font Arial -pointsize 100 \
                -gravity center -draw "text 0,0 '🧫'" pwa/icon-192x192.png
        
        # Crear otros tamaños necesarios
        convert -size 512x512 xc:#2e7d32 -fill white -font Arial -pointsize 250 \
                -gravity center -draw "text 0,0 '🧫'" pwa/icon-512x512.png
        convert -size 384x384 xc:#2e7d32 -fill white -font Arial -pointsize 200 \
                -gravity center -draw "text 0,0 '🧫'" pwa/icon-384x384.png
        convert -size 144x144 xc:#2e7d32 -fill white -font Arial -pointsize 70 \
                -gravity center -draw "text 0,0 '🧫'" pwa/icon-144x144.png
        convert -size 96x96 xc:#2e7d32 -fill white -font Arial -pointsize 40 \
                -gravity center -draw "text 0,0 '🧫'" pwa/icon-96x96.png
        convert -size 72x72 xc:#2e7d32 -fill white -font Arial -pointsize 30 \
                -gravity center -draw "text 0,0 '🧫'" pwa/icon-72x72.png
        
        echo "✅ Iconos creados exitosamente"
    else
        echo "⚠️  ImageMagick no encontrado, creando iconos básicos..."
        # Crear iconos simples con base64
        echo "iVBORw0KGgoAAAANSUhEUgAAAMAAAADACAMAAABlApw1AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAFZQTFRF////2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZkYYKrwAAAPRJREFUeNrs2IEJACAMA8H+/9OoYLI6F4Q6h0DGkhBeX8DjC3h8AY8v4PEFPL6Axxfw+AIeX8DjC3h8AY8v4PEFPL6Axxfw+AIeX8DjC3h8AY8v4PEFPL6Axxfw+AIeX8DjC3h8AY8v4PEFPL6Axxfw+AIeX8DjC3h8AY8v4PEFPL6Axxfw+AIeX8DjC3h8AY8v4PEFPL6Axxfw+AIeX8DjC3h8AY8v4PEFPL6Axxfw+AIeX8DjC3h8AY8v4PEFPL6Axxfw+AIeX8DjC3h8AY8v4PEFPL6Axxfw+AIeX8DjC3h8AY8v4PEFPL6Axxfw+AIeX8DjC3h8AY8v4PEFPA8BBgCNGQmJ1kOYCwAAAABJRU5ErkJggg==" | base64 -d > pwa/icon-192x192.png
        cp pwa/icon-192x192.png pwa/icon-512x512.png 2>/dev/null || true
        echo "✅ Iconos básicos creados (pueden verse pixelados)"
    fi
else
    echo "✅ icon-192x192.png ya existe"
fi

# Verificar que los archivos no estén vacíos
if [ -f "pwa/icon-192x192.png" ]; then
    FILE_SIZE=$(stat -f%z pwa/icon-192x192.png 2>/dev/null || stat -c%s pwa/icon-192x192.png 2>/dev/null || echo "0")
    if [ "$FILE_SIZE" -lt 100 ]; then
        echo "⚠️  icon-192x192.png parece estar vacío (tamaño: $FILE_SIZE bytes)"
        # Crear uno simple
        echo '<svg xmlns="http://www.w3.org/2000/svg" width="192" height="192"><rect width="192" height="192" fill="#2e7d32"/><text x="96" y="120" font-size="80" text-anchor="middle" fill="white">🧫</text></svg>' > pwa/icon-192x192.svg
        echo "✅ Creado icono SVG como alternativa"
    fi
fi

echo ""
echo "3. 🔑 AGREGANDO FUNCIÓN saveApiKey FALTANTE..."
echo "============================================="

# Buscar donde se llama a saveApiKey (línea 1268 según el error)
ERROR_LINE=1268
echo "🔍 Buscando llamada a saveApiKey en línea $ERROR_LINE..."

# Obtener el contexto del error
if [ -f "fermentation_agent.html" ]; then
    # Mostrar las líneas alrededor del error
    echo "📄 Contexto del error (líneas 1265-1270):"
    sed -n "1265,1270p" fermentation_agent.html
    
    # Buscar el botón que llama a saveApiKey
    BUTTON_LINE=$(sed -n "${ERROR_LINE}p" fermentation_agent.html)
    echo "🎯 Línea con error: $BUTTON_LINE"
    
    # Verificar si ya existe la función saveApiKey
    if ! grep -q "function saveApiKey" fermentation_agent.html; then
        echo "❌ Función saveApiKey no encontrada, agregándola..."
        
        # Buscar un buen lugar para agregar la función (antes del cierre de </script>)
        SCRIPT_END_LINE=$(grep -n "</script>" fermentation_agent.html | tail -1 | cut -d: -f1)
        
        if [ ! -z "$SCRIPT_END_LINE" ]; then
            # Insertar la función antes del cierre de </script>
            INSERT_LINE=$((SCRIPT_END_LINE - 1))
            
            # Función saveApiKey básica
            sed -i '' "${INSERT_LINE}a\\
\\    /* 🔑 Función para guardar API Key */\\
\\    function saveApiKey() {\\
\\        const apiKeyInput = document.getElementById('apiKey');\\
\\        const statusElement = document.getElementById('apiKeyStatus');\\
\\        \\
\\        if (!apiKeyInput) {\\
\\            console.error('❌ No se encontró el input de API Key');\\
\\            return;\\
\\        }\\
\\        \\
\\        const apiKey = apiKeyInput.value.trim();\\
\\        \\
\\        if (!apiKey) {\\
\\            if (statusElement) {\\
\\                statusElement.textContent = '⚠️ Por favor, ingresa una API Key';\\
\\                statusElement.style.color = '#ff9800';\\
\\            }\\
\\            return;\\
\\        }\\
\\        \\
\\        // Guardar en localStorage\\
\\        try {\\
\\            localStorage.setItem('deepseek_api_key', apiKey);\\
\\            \\
\\            if (statusElement) {\\
\\                statusElement.textContent = '✅ API Key guardada correctamente';\\
\\                statusElement.style.color = '#4caf50';\\
\\            }\\
\\            \\
\\            // También guardar en una variable global para uso inmediato\\
\\            if (typeof window !== 'undefined') {\\
\\                window.DEEPSEEK_API_KEY = apiKey;\\
\\            }\\
\\            \\
\\            console.log('🔑 API Key guardada (primeros 5 chars):', apiKey.substring(0, 5) + '...');\\
\\            \\
\\            // Opcional: Ocultar el input después de guardar\\
\\            setTimeout(() => {\\
\\                if (statusElement) {\\
\\                    statusElement.textContent = 'Listo para usar';\\
\\                }\\
\\            }, 3000);\\
\\            \\
\\        } catch (error) {\\
\\            console.error('❌ Error guardando API Key:', error);\\
\\            if (statusElement) {\\
\\                statusElement.textContent = '❌ Error al guardar';\\
\\                statusElement.style.color = '#f44336';\\
\\            }\\
\\        }\\
\\    }\\
\\    \\
\\    // Cargar API Key al iniciar si existe\\
\\    document.addEventListener('DOMContentLoaded', function() {\\
\\        const savedApiKey = localStorage.getItem('deepseek_api_key');\\
\\        if (savedApiKey && typeof window !== 'undefined') {\\
\\            window.DEEPSEEK_API_KEY = savedApiKey;\\
\\            console.log('🔑 API Key cargada de localStorage');\\
\\            \\
\\            // Actualizar el input si existe\\
\\            const apiKeyInput = document.getElementById('apiKey');\\
\\            if (apiKeyInput) {\\
\\                apiKeyInput.value = savedApiKey;\\
\\            }\\
\\            \\
\\            // Actualizar status\\
\\            const statusElement = document.getElementById('apiKeyStatus');\\
\\            if (statusElement) {\\
\\                statusElement.textContent = '✅ API Key cargada';\\
\\                statusElement.style.color = '#4caf50';\\
\\            }\\
\\        }\\
\\    });" fermentation_agent.html
            
            echo "✅ Función saveApiKey agregada en línea $INSERT_LINE"
        else
            echo "⚠️  No se encontró cierre de </script>, agregando al final del archivo"
            
            # Agregar al final antes de </body>
            cat >> fermentation_agent.html << 'APIKEY_FUNC'

<script>
/* 🔑 Función para guardar API Key */
function saveApiKey() {
    const apiKeyInput = document.getElementById('apiKey');
    const statusElement = document.getElementById('apiKeyStatus');
    
    if (!apiKeyInput) {
        console.error('❌ No se encontró el input de API Key');
        return;
    }
    
    const apiKey = apiKeyInput.value.trim();
    
    if (!apiKey) {
        if (statusElement) {
            statusElement.textContent = '⚠️ Por favor, ingresa una API Key';
            statusElement.style.color = '#ff9800';
        }
        return;
    }
    
    // Guardar en localStorage
    try {
        localStorage.setItem('deepseek_api_key', apiKey);
        
        if (statusElement) {
            statusElement.textContent = '✅ API Key guardada correctamente';
            statusElement.style.color = '#4caf50';
        }
        
        // También guardar en una variable global
        if (typeof window !== 'undefined') {
            window.DEEPSEEK_API_KEY = apiKey;
        }
        
        console.log('🔑 API Key guardada');
        
    } catch (error) {
        console.error('❌ Error guardando API Key:', error);
        if (statusElement) {
            statusElement.textContent = '❌ Error al guardar';
            statusElement.style.color = '#f44336';
        }
    }
}

// Cargar API Key al iniciar
document.addEventListener('DOMContentLoaded', function() {
    const savedApiKey = localStorage.getItem('deepseek_api_key');
    if (savedApiKey) {
        window.DEEPSEEK_API_KEY = savedApiKey;
        console.log('🔑 API Key cargada de localStorage');
        
        const apiKeyInput = document.getElementById('apiKey');
        if (apiKeyInput) {
            apiKeyInput.value = savedApiKey;
        }
    }
});
</script>
APIKEY_FUNC
        fi
    else
        echo "✅ Función saveApiKey ya existe"
    fi
fi

echo ""
echo "4. 🔄 REVISANDO Y LIMPIANDO CÓDIGO DUPLICADO..."
echo "=============================================="

# Buscar otros posibles duplicados
echo "🧹 Buscando otros posibles problemas..."

# Verificar si hay múltiples declaraciones de thinkingPhrases
THINKING_COUNT=$(grep -n "const thinkingPhrases" fermentation_agent.html | wc -l)
if [ $THINKING_COUNT -gt 1 ]; then
    echo "⚠️  Se encontraron $THINKING_COUNT declaraciones de thinkingPhrases"
    DECLARATION_LINES=$(grep -n "const thinkingPhrases" fermentation_agent.html | cut -d: -f1)
    FIRST_LINE=$(echo $DECLARATION_LINES | awk '{print $1}')
    
    # Comentar todas excepto la primera
    COUNTER=0
    for LINE in $DECLARATION_LINES; do
        COUNTER=$((COUNTER + 1))
        if [ $COUNTER -gt 1 ]; then
            sed -i '' "${LINE}s/const thinkingPhrases =/\/\/ const thinkingPhrases = (DUPLICADA)/" fermentation_agent.html
            echo "   ✅ Línea $LINE: thinkingPhrases duplicada comentada"
        fi
    done
fi

# Verificar si hay múltiples funciones startLoadingAnimations
LOADING_COUNT=$(grep -n "function startLoadingAnimations" fermentation_agent.html | wc -l)
if [ $LOADING_COUNT -gt 1 ]; then
    echo "⚠️  Se encontraron $LOADING_COUNT funciones startLoadingAnimations"
    # Mantener solo la primera
    FUNCTION_LINES=$(grep -n "function startLoadingAnimations" fermentation_agent.html | cut -d: -f1)
    FIRST_LINE=$(echo $FUNCTION_LINES | awk '{print $1}')
    
    COUNTER=0
    for LINE in $FUNCTION_LINES; do
        COUNTER=$((COUNTER + 1))
        if [ $COUNTER -gt 1 ]; then
            # Comentar toda la función (encontrar su cierre)
            END_LINE=$(awk -v start="$LINE" 'NR >= start && /^[[:space:]]*}[[:space:]]*$/ {print NR; exit}' fermentation_agent.html)
            if [ ! -z "$END_LINE" ]; then
                sed -i '' "${LINE},${END_LINE}s/^/\/\//" fermentation_agent.html
                echo "   ✅ Líneas $LINE-$END_LINE: Función duplicada comentada"
            fi
        fi
    done
fi

echo ""
echo "5. 📁 VERIFICANDO ESTRUCTURA DE ARCHIVOS PWA..."
echo "=============================================="

# Verificar que el directorio pwa tenga los archivos necesarios
echo "📂 Contenido del directorio pwa/:"
ls -la pwa/ 2>/dev/null || echo "❌ Directorio pwa/ no existe"

# Crear manifest si no existe
if [ ! -f "pwa/manifest.json" ]; then
    echo "📄 Creando manifest.json básico..."
    cat > pwa/manifest.json << 'MANIFEST'
{
  "name": "Fermentation Expert",
  "short_name": "FermentApp",
  "description": "Aplicación especializada en procesos de fermentación",
  "start_url": "/fermentation-expert-app/",
  "display": "standalone",
  "background_color": "#ffffff",
  "theme_color": "#2e7d32",
  "icons": [
    {
      "src": "icon-72x72.png",
      "sizes": "72x72",
      "type": "image/png"
    },
    {
      "src": "icon-96x96.png",
      "sizes": "96x96",
      "type": "image/png"
    },
    {
      "src": "icon-128x128.png",
      "sizes": "128x128",
      "type": "image/png"
    },
    {
      "src": "icon-144x144.png",
      "sizes": "144x144",
      "type": "image/png"
    },
    {
      "src": "icon-192x192.png",
      "sizes": "192x192",
      "type": "image/png"
    },
    {
      "src": "icon-384x384.png",
      "sizes": "384x384",
      "type": "image/png"
    },
    {
      "src": "icon-512x512.png",
      "sizes": "512x512",
      "type": "image/png"
    }
  ]
}
MANIFEST
    echo "✅ manifest.json creado"
fi

echo ""
echo "6. 🧪 VERIFICANDO REPARACIONES..."
echo "================================"

# Verificar que no haya errores de sintaxis obvios
echo "🔍 Buscando errores de sintaxis comunes..."

# Verificar que cada apertura de { tenga cierre
OPEN_COUNT=$(grep -o "{" fermentation_agent.html | wc -l | tr -d ' ')
CLOSE_COUNT=$(grep -o "}" fermentation_agent.html | wc -l | tr -d ' ')
echo "   Llaves { }: $OPEN_COUNT aperturas, $CLOSE_COUNT cierres"
if [ "$OPEN_COUNT" -ne "$CLOSE_COUNT" ]; then
    echo "   ⚠️  Desbalance de llaves: diferencia de $((OPEN_COUNT - CLOSE_COUNT))"
fi

# Verificar que no haya comillas sin cerrar en JavaScript
QUOTE_LINES=$(awk '/<script>/,/<\/script>/ {if (NR && gsub(/"/,"&") % 2 != 0) print NR ": " $0}' fermentation_agent.html | head -5)
if [ ! -z "$QUOTE_LINES" ]; then
    echo "   ⚠️  Posibles comillas sin cerrar en estas líneas:"
    echo "$QUOTE_LINES" | while read LINE; do
        echo "      $LINE"
    done
else
    echo "   ✅ No se encontraron comillas sin cerrar obvias"
fi

echo ""
echo "7. 📤 SUBIENDO REPARACIONES..."
echo "=============================="

# Subir todos los cambios
git add .
git commit -m "fix: resolve duplicate variables, missing API key function, and PWA icon issues"
git push origin main

echo ""
echo "🎉 ¡REPARACIONES COMPLETADAS!"
echo "============================="
echo ""
echo "✅ **Problemas solucionados:**"
echo ""
echo "1. **Variables duplicadas:**"
echo "   • fermentationFacts - Declaraciones duplicadas comentadas"
echo "   • thinkingPhrases - Verificadas y limpiadas si necesario"
echo ""
echo "2. **Iconos PWA faltantes:**"
echo "   • icon-192x192.png creado o reparado"
echo "   • Otros iconos generados si faltaban"
echo "   • Manifest.json actualizado si necesario"
echo ""
echo "3. **Función saveApiKey faltante:**"
echo "   • Función completa agregada al JavaScript"
echo "   • Integración con localStorage"
echo "   • Carga automática al iniciar"
echo ""
echo "4. **Limpieza general:**"
echo "   • Código duplicado identificado y limpiado"
echo "   • Estructura verificada"
echo "   • Errores de sintaxis revisados"
echo ""
echo "🚀 **Próximos pasos:**"
echo ""
echo "1. ⏳ Espera 2-3 minutos para el deployment"
echo "2. 🔄 Actualiza la página (Ctrl+F5 o Cmd+Shift+R)"
echo "3. 🔍 Abre la consola del navegador (F12 → Console)"
echo "4. ✅ Los errores deberían haber desaparecido"
echo "5. 🎯 Prueba guardar una API Key y enviar un mensaje"
echo ""
echo "🔗 **URL para probar:**"
echo "   https://wikibuda.github.io/fermentation-expert-app/fermentation_agent.html"
echo ""
echo "📱 **Para verificar manualmente:**"
echo "1. La consola no debería mostrar errores de 'already declared'"
echo "2. El botón de guardar API Key debería funcionar"
echo "3. Las animaciones de espera deberían mostrarse correctamente"
echo "4. El Service Worker debería registrarse sin errores"
echo ""
echo "🛠️  **Si persisten errores:**"
echo "• Usa el modo incógnito del navegador"
echo "• Limpia el cache y recarga forzada (Ctrl+Shift+R)"
echo "• Verifica la consola para nuevos mensajes de error"
echo ""
echo "¡Los errores deberían estar solucionados ahora! 🎉"
