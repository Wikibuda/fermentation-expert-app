#!/bin/bash
# add_favicon_and_enhance.sh

echo "🎨 AGREGANDO FAVICON Y MEJORANDO APARIENCIA"
echo "=========================================="

echo ""
echo "1. 🖼️ CREANDO FAVICON..."
# Crear favicon simple con ImageMagick
if command -v convert &> /dev/null; then
    # Crear varios tamaños de favicon
    convert -size 64x64 xc:#2e7d32 -fill white -pointsize 40 -gravity center -draw "text 0,0 '🧫'" favicon-64.png
    convert -size 32x32 xc:#2e7d32 -fill white -pointsize 20 -gravity center -draw "text 0,0 '🧫'" favicon-32.png
    convert -size 16x16 xc:#2e7d32 -fill white -pointsize 8 -gravity center -draw "text 0,0 'F'" favicon-16.png
    
    # Convertir a ICO (formato favicon)
    convert favicon-16.png favicon-32.png favicon-64.png favicon.ico
    
    # Crear también apple-touch-icon
    convert -size 180x180 xc:#2e7d32 -fill white -pointsize 80 -gravity center -draw "text 0,0 '🧫'" apple-touch-icon.png
    
    # Crear manifest para PWA
    cat > site.webmanifest << 'MANIFEST'
{
  "name": "Fermentation Expert App",
  "short_name": "FermentationApp",
  "description": "Aplicación web especializada en procesos de fermentación",
  "start_url": "/fermentation-expert-app/",
  "display": "standalone",
  "background_color": "#2e7d32",
  "theme_color": "#2e7d32",
  "icons": [
    {
      "src": "/fermentation-expert-app/favicon-16.png",
      "sizes": "16x16",
      "type": "image/png"
    },
    {
      "src": "/fermentation-expert-app/favicon-32.png",
      "sizes": "32x32",
      "type": "image/png"
    },
    {
      "src": "/fermentation-expert-app/favicon-64.png",
      "sizes": "64x64",
      "type": "image/png"
    },
    {
      "src": "/fermentation-expert-app/apple-touch-icon.png",
      "sizes": "180x180",
      "type": "image/png"
    }
  ]
}
MANIFEST
    
    echo "✅ Favicon creado: favicon.ico, favicon-*.png, apple-touch-icon.png"
else
    # Si no tiene ImageMagick, crear favicon simple manualmente
    echo "⚠️  ImageMagick no encontrado, creando favicon básico..."
    echo "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAACXBIWXMAAAsTAAALEwEAmpwYAAAA" > favicon.b64
    echo "B0lEQVR4nGNgGAWjYBQMOwA2NjYGBgYGBkZGRgZGRkYGRkZGBkZGRgZGRkYGRkZGBkZGRgZGRkYG" >> favicon.b64
    echo "RkZGBkZGRgZGRkYGRkZGBkZGRgZGRkYGRkZGBkZGRgZGRkYGRkZGBkZGRgZGRkYGRkZGBkZGRgZG" >> favicon.b64
    echo "RkYGRkZGBkZGRgZGRkYGRkZGBkZGRgZGRkYGRkZGBkZGRgZGRkYGJgAAAAD//wMAQlsD6M0AAAAA" >> favicon.b64
    echo "SUVORK5CYII=" >> favicon.b64
    base64 -d favicon.b64 > favicon.ico 2>/dev/null || echo "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAYSURBVDhPYxgFo2AUjIJRMAoAAQAABAABHwC6qg8eTgAAAABJRU5ErkJggg==" | base64 -d > favicon.ico
    rm -f favicon.b64
    echo "✅ Favicon básico creado: favicon.ico"
fi

echo ""
echo "2. 📄 ACTUALIZANDO HTML CON FAVICON Y METADATOS..."

# Actualizar fermentation_agent.html
if [ -f "fermentation_agent.html" ]; then
    # Buscar </head> y agregar antes
    sed -i '' '/<\/head>/i\
    <!-- Favicon and PWA -->\
    <link rel="apple-touch-icon" sizes="180x180" href="apple-touch-icon.png">\
    <link rel="icon" type="image/png" sizes="32x32" href="favicon-32.png">\
    <link rel="icon" type="image/png" sizes="16x16" href="favicon-16.png">\
    <link rel="manifest" href="site.webmanifest">\
    <link rel="mask-icon" href="favicon.svg" color="#2e7d32">\
    <meta name="msapplication-TileColor" content="#2e7d32">\
    <meta name="theme-color" content="#2e7d32">\
    \
    <!-- Open Graph / Facebook -->\
    <meta property="og:type" content="website">\
    <meta property="og:url" content="https://wikibuda.github.io/fermentation-expert-app/fermentation_agent.html">\
    <meta property="og:title" content="Fermentation Expert App">\
    <meta property="og:description" content="Aplicación web especializada en procesos de fermentación con inteligencia artificial">\
    <meta property="og:image" content="https://wikibuda.github.io/fermentation-expert-app/og-image.png">\
    \
    <!-- Twitter -->\
    <meta property="twitter:card" content="summary_large_image">\
    <meta property="twitter:url" content="https://wikibuda.github.io/fermentation-expert-app/fermentation_agent.html">\
    <meta property="twitter:title" content="Fermentation Expert App">\
    <meta property="twitter:description" content="Aplicación web especializada en procesos de fermentación con inteligencia artificial">\
    <meta property="twitter:image" content="https://wikibuda.github.io/fermentation-expert-app/og-image.png">\
    ' fermentation_agent.html
    
    # También mejorar el title
    sed -i '' 's|<title>Especialista en Fermentación Avanzado</title>|<title>🧫 Fermentation Expert App - Chat con Especialista</title>|' fermentation_agent.html
    
    echo "✅ fermentation_agent.html actualizado"
fi

# Actualizar tracker.html
if [ -f "tracker.html" ]; then
    sed -i '' '/<\/head>/i\
    <!-- Favicon -->\
    <link rel="apple-touch-icon" sizes="180x180" href="apple-touch-icon.png">\
    <link rel="icon" type="image/png" sizes="32x32" href="favicon-32.png">\
    <link rel="icon" type="image/png" sizes="16x16" href="favicon-16.png">\
    <link rel="manifest" href="site.webmanifest">\
    <meta name="theme-color" content="#2e7d32">\
    ' tracker.html
    
    sed -i '' 's|<title>Tracker de Desarrollo - Fermentation Expert</title>|<title>📊 Tracker - Fermentation Expert App</title>|' tracker.html
    echo "✅ tracker.html actualizado"
fi

# Actualizar enterprise_configurator.html
if [ -f "enterprise_configurator.html" ]; then
    sed -i '' '/<\/head>/i\
    <!-- Favicon -->\
    <link rel="apple-touch-icon" sizes="180x180" href="apple-touch-icon.png">\
    <link rel="icon" type="image/png" sizes="32x32" href="favicon-32.png">\
    <link rel="icon" type="image/png" sizes="16x16" href="favicon-16.png">\
    <link rel="manifest" href="site.webmanifest">\
    <meta name="theme-color" content="#2e7d32">\
    ' enterprise_configurator.html
    
    sed -i '' 's|<title>🚀 Configurador Enterprise Ready</title>|<title>⚙️ Configurador - Fermentation Expert App</title>|' enterprise_configurator.html
    echo "✅ enterprise_configurator.html actualizado"
fi

echo ""
echo "3. 🖼️ CREANDO IMAGEN OG (Open Graph)..."
# Crear imagen social simple (og-image.png)
cat > generate_og_image.sh << 'OG_SCRIPT'
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
OG_SCRIPT

chmod +x generate_og_image.sh
./generate_og_image.sh

echo ""
echo "4. 📄 MEJORANDO index.html..."
if [ -f "index.html" ]; then
    cat > index.html << 'INDEX_EOF'
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>🧫 Fermentation Expert App</title>
    
    <!-- Favicon and PWA -->
    <link rel="apple-touch-icon" sizes="180x180" href="apple-touch-icon.png">
    <link rel="icon" type="image/png" sizes="32x32" href="favicon-32.png">
    <link rel="icon" type="image/png" sizes="16x16" href="favicon-16.png">
    <link rel="manifest" href="site.webmanifest">
    <meta name="theme-color" content="#2e7d32">
    
    <!-- Open Graph -->
    <meta property="og:title" content="Fermentation Expert App">
    <meta property="og:description" content="Aplicación web especializada en procesos de fermentación con inteligencia artificial">
    <meta property="og:image" content="https://wikibuda.github.io/fermentation-expert-app/og-image.png">
    <meta property="og:url" content="https://wikibuda.github.io/fermentation-expert-app/">
    <meta property="og:type" content="website">
    
    <!-- Twitter -->
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="Fermentation Expert App">
    <meta name="twitter:description" content="Aplicación web especializada en procesos de fermentación con inteligencia artificial">
    <meta name="twitter:image" content="https://wikibuda.github.io/fermentation-expert-app/og-image.png">
    
    <style>
        :root {
            --primary: #2e7d32;
            --primary-dark: #1b5e20;
            --primary-light: #4caf50;
            --light: #f1f8e9;
            --dark: #263238;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, sans-serif;
        }
        
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #e8f5e9 100%);
            color: var(--dark);
            min-height: 100vh;
            padding: 20px;
            line-height: 1.6;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            padding: 40px;
        }
        
        header {
            text-align: center;
            margin-bottom: 50px;
            padding-bottom: 30px;
            border-bottom: 3px solid var(--primary-light);
        }
        
        .logo {
            font-size: 4rem;
            margin-bottom: 20px;
            animation: float 3s ease-in-out infinite;
        }
        
        @keyframes float {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }
        
        h1 {
            font-size: 2.8rem;
            color: var(--primary);
            margin-bottom: 15px;
        }
        
        .subtitle {
            font-size: 1.2rem;
            color: #666;
            max-width: 600px;
            margin: 0 auto;
        }
        
        .apps-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
            margin: 40px 0;
        }
        
        .app-card {
            background: var(--light);
            border-radius: 15px;
            padding: 30px;
            text-decoration: none;
            color: inherit;
            transition: all 0.3s ease;
            border: 2px solid transparent;
            position: relative;
            overflow: hidden;
        }
        
        .app-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 5px;
            background: var(--primary);
        }
        
        .app-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 35px rgba(46, 125, 50, 0.15);
            border-color: var(--primary);
        }
        
        .app-icon {
            font-size: 3rem;
            margin-bottom: 20px;
            display: inline-block;
        }
        
        .app-title {
            font-size: 1.5rem;
            margin-bottom: 15px;
            color: var(--primary-dark);
        }
        
        .app-desc {
            color: #666;
            margin-bottom: 20px;
            line-height: 1.7;
        }
        
        .app-features {
            list-style: none;
            margin: 20px 0;
            padding: 0;
        }
        
        .app-features li {
            padding: 5px 0;
            padding-left: 25px;
            position: relative;
        }
        
        .app-features li::before {
            content: '✓';
            position: absolute;
            left: 0;
            color: var(--primary);
            font-weight: bold;
        }
        
        .tech-stack {
            margin-top: 40px;
            padding-top: 30px;
            border-top: 1px solid #eee;
            text-align: center;
        }
        
        .tech-icons {
            display: flex;
            justify-content: center;
            gap: 20px;
            flex-wrap: wrap;
            margin-top: 20px;
        }
        
        .tech-icon {
            background: var(--light);
            padding: 10px 20px;
            border-radius: 20px;
            font-size: 0.9rem;
            color: var(--primary);
            font-weight: 500;
        }
        
        footer {
            text-align: center;
            margin-top: 50px;
            padding-top: 30px;
            border-top: 1px solid #eee;
            color: #888;
            font-size: 0.9rem;
        }
        
        .github-link {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            background: #333;
            color: white;
            padding: 12px 25px;
            border-radius: 25px;
            text-decoration: none;
            margin-top: 20px;
            transition: all 0.3s;
        }
        
        .github-link:hover {
            background: #000;
            transform: translateY(-2px);
        }
        
        @media (max-width: 768px) {
            .container {
                padding: 20px;
            }
            
            h1 {
                font-size: 2rem;
            }
            
            .apps-grid {
                grid-template-columns: 1fr;
            }
            
            .logo {
                font-size: 3rem;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <header>
            <div class="logo">🧫</div>
            <h1>Fermentation Expert App</h1>
            <p class="subtitle">
                Aplicación web especializada en procesos de fermentación con inteligencia artificial.
                Herramientas profesionales para fermentadores de todos los niveles.
            </p>
        </header>
        
        <div class="apps-grid">
            <a href="fermentation_agent.html" class="app-card">
                <div class="app-icon">🤖</div>
                <h3 class="app-title">Chat con Experto en Fermentación</h3>
                <p class="app-desc">
                    Interactúa con un especialista en microbiología aplicada, bioquímica fermentativa 
                    y técnicas tradicionales/modernas de fermentación.
                </p>
                <ul class="app-features">
                    <li>Asesoramiento científico preciso</li>
                    <li>Diagnóstico de problemas</li>
                    <li>Guías paso a paso</li>
                    <li>Protocolos de seguridad</li>
                </ul>
            </a>
            
            <a href="tracker.html" class="app-card">
                <div class="app-icon">📊</div>
                <h3 class="app-title">Tracker de Desarrollo</h3>
                <p class="app-desc">
                    Seguimiento completo del proyecto con roadmap interactivo, 
                    planificación de features y gestión de tareas.
                </p>
                <ul class="app-features">
                    <li>Roadmap visual por versiones</li>
                    <li>Seguimiento de progreso</li>
                    <li>Gestión de tareas</li>
                    <li>Exportación a PDF/JSON</li>
                </ul>
            </a>
            
            <a href="enterprise_configurator.html" class="app-card">
                <div class="app-icon">⚙️</div>
                <h3 class="app-title">Configurador Enterprise</h3>
                <p class="app-desc">
                    Herramienta para configurar proyectos con estándares empresariales:
                    CI/CD, testing, documentación y más.
                </p>
                <ul class="app-features">
                    <li>Configuración automática</li>
                    <li>Plantillas profesionales</li>
                    <li>Workflows predefinidos</li>
                    <li>Best practices incluídas</li>
                </ul>
            </a>
        </div>
        
        <div class="tech-stack">
            <h3>🚀 Tecnologías Utilizadas</h3>
            <div class="tech-icons">
                <span class="tech-icon">HTML5</span>
                <span class="tech-icon">CSS3</span>
                <span class="tech-icon">JavaScript</span>
                <span class="tech-icon">GitHub Pages</span>
                <span class="tech-icon">DeepSeek API</span>
                <span class="tech-icon">GitHub Actions</span>
            </div>
        </div>
        
        <footer>
            <p>© 2024 Fermentation Expert App • Proyecto open source</p>
            <a href="https://github.com/Wikibuda/fermentation-expert-app" class="github-link">
                <svg height="20" viewBox="0 0 16 16" width="20" fill="white">
                    <path d="M8 0C3.58 0 0 3.58 0 8c0 3.54 2.29 6.53 5.47 7.59.4.07.55-.17.55-.38 0-.19-.01-.82-.01-1.49-2.01.37-2.53-.49-2.69-.94-.09-.23-.48-.94-.82-1.13-.28-.15-.68-.52-.01-.53.63-.01 1.08.58 1.23.82.72 1.21 1.87.87 2.33.66.07-.52.28-.87.51-1.07-1.78-.2-3.64-.89-3.64-3.95 0-.87.31-1.59.82-2.15-.08-.2-.36-1.02.08-2.12 0 0 .67-.21 2.2.82.64-.18 1.32-.27 2-.27.68 0 1.36.09 2 .27 1.53-1.04 2.2-.82 2.2-.82.44 1.1.16 1.92.08 2.12.51.56.82 1.27.82 2.15 0 3.07-1.87 3.75-3.65 3.95.29.25.54.73.54 1.48 0 1.07-.01 1.93-.01 2.2 0 .21.15.46.55.38A8.013 8.013 0 0016 8c0-4.42-3.58-8-8-8z"></path>
                </svg>
                Ver en GitHub
            </a>
            <p style="margin-top: 20px; font-size: 0.8rem;">
                🧪 ¡Felices fermentaciones!
            </p>
        </footer>
    </div>
    
    <script>
        // Efecto de aparición suave
        document.addEventListener('DOMContentLoaded', function() {
            const cards = document.querySelectorAll('.app-card');
            cards.forEach((card, index) => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(20px)';
                
                setTimeout(() => {
                    card.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, index * 200);
            });
            
            // Añadir año actual al footer
            document.querySelector('footer p').innerHTML = 
                `© ${new Date().getFullYear()} Fermentation Expert App • Proyecto open source`;
        });
    </script>
</body>
</html>
INDEX_EOF
    echo "✅ index.html mejorado con diseño profesional"
fi

echo ""
echo "5. 📤 SUBIENDO TODO A GITHUB..."
git add .
git commit -m "feat: add favicon, improve design and add PWA support"
git push origin main

echo ""
echo "🎉 ¡FAVICON Y MEJORAS DE DISEÑO AGREGADAS!"
echo ""
echo "✅ Qué se agregó:"
echo "   • 🖼️  Favicon en múltiples tamaños (.ico, .png)"
echo "   • 📱 Soporte PWA (manifest, apple-touch-icon)"
echo "   • 🎨 Open Graph meta tags para redes sociales"
echo "   • 💫 Diseño profesional mejorado en index.html"
echo "   • 🎯 Títulos y meta tags actualizados en todas las páginas"
echo ""
echo "⏱️  El deployment se ejecutará automáticamente..."
echo "🔗 En 2-3 minutos verás los cambios en:"
echo "   https://Wikibuda.github.io/fermentation-expert-app/"
echo ""
echo "📱 Prueba en diferentes dispositivos y comprueba el favicon en la pestaña del navegador!"
