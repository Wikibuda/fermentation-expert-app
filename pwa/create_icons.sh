#!/bin/bash
# Convertir SVG a múltiples tamaños usando ImageMagick o crear manualmente

# Si ImageMagick está disponible
if command -v convert &> /dev/null; then
    echo "🖼️ Creando iconos con ImageMagick..."
    
    # Tamaños para PWA
    convert -background "#2e7d32" -fill white -font Arial -pointsize 72 -gravity center \
            label:"🧫" -resize 72x72 icon-72x72.png
    
    convert -background "#2e7d32" -fill white -font Arial -pointsize 96 -gravity center \
            label:"🧫" -resize 96x96 icon-96x96.png
    
    convert -background "#2e7d32" -fill white -font Arial -pointsize 128 -gravity center \
            label:"🧫" -resize 128x128 icon-128x128.png
    
    convert -background "#2e7d32" -fill white -font Arial -pointsize 144 -gravity center \
            label:"🧫" -resize 144x144 icon-144x144.png
    
    convert -background "#2e7d32" -fill white -font Arial -pointsize 152 -gravity center \
            label:"🧫" -resize 152x152 icon-152x152.png
    
    convert -background "#2e7d32" -fill white -font Arial -pointsize 192 -gravity center \
            label:"🧫" -resize 192x192 icon-192x192.png
    
    convert -background "#2e7d32" -fill white -font Arial -pointsize 384 -gravity center \
            label:"🧫" -resize 384x384 icon-384x384.png
    
    convert -background "#2e7d32" -fill white -font Arial -pointsize 512 -gravity center \
            label:"🧫" -resize 512x512 icon-512x512.png
    
    # Crear favicon.ico (combinación de 16x16, 32x32, 64x64)
    convert -background "#2e7d32" -fill white -font Arial -pointsize 10 -gravity center \
            label:"🧫" -resize 16x16 favicon-16x16.png
    convert -background "#2e7d32" -fill white -font Arial -pointsize 20 -gravity center \
            label:"🧫" -resize 32x32 favicon-32x32.png
    convert -background "#2e7d32" -fill white -font Arial -pointsize 40 -gravity center \
            label:"🧫" -resize 64x64 favicon-64x64.png
    convert favicon-16x16.png favicon-32x32.png favicon-64x64.png ../favicon.ico
    
    # Apple touch icon
    convert -background "#2e7d32" -fill white -font Arial -pointsize 150 -gravity center \
            label:"🧫" -resize 180x180 apple-touch-icon.png
    cp apple-touch-icon.png ../apple-touch-icon.png
    
    # Maskable icon (para Android)
    convert -size 512x512 xc:#2e7d32 -fill white -font Arial -pointsize 200 \
            -gravity center -draw "text 0,0 '🧫'" \
            -draw "circle 256,256 410,256" \
            maskable-icon.png
            
    echo "✅ Iconos creados exitosamente"
else
    echo "⚠️ ImageMagick no encontrado, creando iconos básicos..."
    # Crear iconos simples manualmente
    echo '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512">
    <rect width="512" height="512" fill="#2e7d32"/>
    <text x="256" y="340" font-size="240" text-anchor="middle" fill="white">🧫</text>
    </svg>' | tee icon-512x512.svg
    
    # Copiar el mismo SVG para todos los tamaños (los navegadores escalan)
    cp icon-512x512.svg icon-192x192.svg
    cp icon-512x512.svg icon-384x384.svg
    cp icon-512x512.svg ../favicon.svg
    
    echo "✅ Iconos SVG creados (convierte a PNG online si es necesario)"
fi

# Crear screenshots de ejemplo para la tienda de apps
cat > screenshot1.html << 'SCREENSHOT'
<!DOCTYPE html>
<html>
<head>
    <style>
        body { margin: 0; padding: 20px; background: #f5f7fa; font-family: Arial; }
        .screenshot {
            width: 360px; height: 640px;
            background: white;
            border-radius: 30px;
            padding: 20px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            margin: 0 auto;
        }
        .header { background: #2e7d32; color: white; padding: 20px; border-radius: 20px; text-align: center; }
        .content { padding: 20px; }
        .message { background: #e8f5e9; padding: 10px; border-radius: 10px; margin: 10px 0; }
    </style>
</head>
<body>
    <div class="screenshot">
        <div class="header">
            <h1>🧫 Fermentation Expert</h1>
            <p>Tu asistente de fermentación</p>
        </div>
        <div class="content">
            <div class="message">👋 ¡Hola! Soy tu experto en fermentación</div>
            <div class="message">🌿 ¿Qué quieres fermentar hoy?</div>
            <div class="message">🍞 Pan sourdough</div>
            <div class="message">🥬 Chucrut y kimchi</div>
            <div class="message">🍺 Cerveza artesanal</div>
        </div>
    </div>
</body>
</html>
SCREENSHOT

echo "📸 Screenshot de ejemplo creado"
