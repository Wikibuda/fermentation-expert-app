#!/bin/bash
# Si tiene ImageMagick, crear imagen OG
if command -v convert &> /dev/null; then
    convert -size 1200x630 gradient:#2e7d32-#4caf50 -fill white \
        -pointsize 60 -gravity north -draw "text 0,100 '🧫 Fermentation Expert App'" \
        -pointsize 30 -gravity center -draw "text 0,0 'Aplicación web especializada\nen procesos de fermentación'" \
        -pointsize 20 -gravity south -draw "text 0,50 'wikibuda.github.io/fermentation-expert-app'" \
        og-image.png
    echo "✅ og-image.png creada"
else
    # Crear imagen placeholder
    echo '<svg width="1200" height="630" xmlns="http://www.w3.org/2000/svg">
        <defs>
            <linearGradient id="gradient" x1="0%" y1="0%" x2="100%" y2="100%">
                <stop offset="0%" stop-color="#2e7d32"/>
                <stop offset="100%" stop-color="#4caf50"/>
            </linearGradient>
        </defs>
        <rect width="1200" height="630" fill="url(#gradient)"/>
        <text x="600" y="150" font-family="Arial" font-size="60" fill="white" text-anchor="middle">🧫 Fermentation Expert App</text>
        <text x="600" y="300" font-family="Arial" font-size="30" fill="white" text-anchor="middle">
            <tspan x="600" dy="0">Aplicación web especializada</tspan>
            <tspan x="600" dy="40">en procesos de fermentación</tspan>
        </text>
        <text x="600" y="550" font-family="Arial" font-size="20" fill="white" text-anchor="middle">wikibuda.github.io/fermentation-expert-app</text>
    </svg>' | tee og-image.svg
    echo "✅ og-image.svg creada (conviértela a PNG manualmente si es necesario)"
fi
