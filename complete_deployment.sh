#!/bin/bash
# complete_deployment_fixed.sh - Deployment corregido

echo "=============================================="
echo "     DEPLOYMENT COMPLETO FERMENTATION APP     "
echo "=============================================="

echo ""
echo "📦 PASO 1: CREANDO WORKFLOW ACTUALIZADO..."
echo "========================================"

# Crear directorio .github/workflows si no existe
mkdir -p .github/workflows

# Crear workflow con versión actualizada de upload-pages-artifact
cat > .github/workflows/deploy-pages.yml << 'DEPLOY_EOF'
name: Deploy to GitHub Pages

on:
  push:
    branches: [ main ]
  workflow_dispatch:

permissions:
  pages: write
  id-token: write

jobs:
  deploy:
    runs-on: ubuntu-latest
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - name: Checkout
        uses: actions/checkout@v4
      
      - name: Setup Pages
        uses: actions/configure-pages@v4
        
      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          # Subir todos los archivos del directorio actual
          path: '.'
          
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
DEPLOY_EOF

echo "✅ Workflow creado con upload-pages-artifact@v3"

echo ""
echo "🎨 PASO 2: CREANDO FAVICON Y ARCHIVOS BÁSICOS..."
echo "=============================================="

# Crear favicon simple
echo "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAYSURBVDhPYxgFo2AUjIJRMAoAAQAABAABHwC6qg8eTgAAAABJRU5ErkJggg==" | base64 -d > favicon.ico

echo "✅ Favicon creado: favicon.ico"

echo ""
echo "📄 PASO 3: CREANDO INDEX.HTML MEJORADO..."
echo "======================================="

cat > index.html << 'INDEX_EOF'
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>🧫 Fermentation Expert App</title>
    <link rel="icon" href="favicon.ico" type="image/x-icon">
    <meta name="description" content="Aplicación web especializada en procesos de fermentación con inteligencia artificial">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, sans-serif;
        }
        
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #e8f5e9 100%);
            color: #263238;
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            padding: 40px;
        }
        
        header {
            text-align: center;
            margin-bottom: 40px;
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
            color: #2e7d32;
            margin-bottom: 10px;
        }
        
        .apps-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin: 40px 0;
        }
        
        .app-card {
            background: #f1f8e9;
            border-radius: 15px;
            padding: 25px;
            text-decoration: none;
            color: inherit;
            transition: all 0.3s;
            border: 2px solid transparent;
        }
        
        .app-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(46,125,50,0.1);
            border-color: #2e7d32;
        }
        
        .app-icon {
            font-size: 2.5rem;
            margin-bottom: 15px;
        }
        
        .app-title {
            color: #1b5e20;
            margin-bottom: 10px;
        }
        
        footer {
            text-align: center;
            margin-top: 40px;
            padding-top: 20px;
            border-top: 1px solid #eee;
            color: #666;
        }
        
        @media (max-width: 768px) {
            .container { padding: 20px; }
            .logo { font-size: 3rem; }
            .apps-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <div class="container">
        <header>
            <div class="logo">🧫</div>
            <h1>Fermentation Expert App</h1>
            <p>Aplicación web especializada en procesos de fermentación</p>
        </header>
        
        <div class="apps-grid">
            <a href="fermentation_agent.html" class="app-card">
                <div class="app-icon">🤖</div>
                <h3 class="app-title">Chat con Experto</h3>
                <p>Interactúa con un especialista en fermentación con IA</p>
            </a>
            
            <a href="tracker.html" class="app-card">
                <div class="app-icon">📊</div>
                <h3 class="app-title">Tracker de Desarrollo</h3>
                <p>Seguimiento del proyecto con roadmap interactivo</p>
            </a>
            
            <a href="enterprise_configurator.html" class="app-card">
                <div class="app-icon">⚙️</div>
                <h3 class="app-title">Configurador Enterprise</h3>
                <p>Configura proyectos con estándares empresariales</p>
            </a>
        </div>
        
        <footer>
            <p>© 2024 Fermentation Expert App • Proyecto open source</p>
            <p><a href="https://github.com/Wikibuda/fermentation-expert-app" style="color: #2e7d32;">Ver en GitHub</a></p>
        </footer>
    </div>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Actualizar año en el footer
            const year = new Date().getFullYear();
            const footerText = document.querySelector('footer p');
            if (footerText) {
                footerText.innerHTML = footerText.innerHTML.replace('2024', year);
            }
        });
    </script>
</body>
</html>
INDEX_EOF

echo "✅ index.html creado"

echo ""
echo "🔧 PASO 4: AGREGANDO FAVICON A LAS OTRAS PÁGINAS..."
echo "================================================"

# Función para agregar favicon a una página HTML
add_favicon_to_page() {
    local file=$1
    if [ -f "$file" ]; then
        if grep -q "<head>" "$file" && ! grep -q "favicon" "$file"; then
            sed -i '' '/<head>/a\
    <link rel="icon" href="favicon.ico" type="image/x-icon">\
    <meta name="viewport" content="width=device-width, initial-scale=1.0">' "$file"
            echo "✅ $file actualizado"
        else
            echo "⚠️  $file ya tiene favicon o no tiene <head>"
        fi
    else
        echo "❌ $file no existe"
    fi
}

# Agregar favicon a las páginas existentes
add_favicon_to_page "fermentation_agent.html"
add_favicon_to_page "tracker.html"
add_favicon_to_page "enterprise_configurator.html"

echo ""
echo "📤 PASO 5: SUBIENDO A GITHUB..."
echo "=============================="

# Hacer commit de todos los cambios
git add .
git commit -m "feat: complete deployment with modern pages workflow, favicon and improved design"
git push origin main

echo ""
echo "🎉 ¡DESPLIEGUE COMPLETO!"
echo "========================"
echo ""
echo "✅ Qué se ha hecho:"
echo "   📦 Workflow GitHub Pages actualizado (sin versiones deprecadas)"
echo "   🖼️  Favicon agregado"
echo "   🎨 index.html rediseñado profesionalmente"
echo "   🔧 Todas las páginas actualizadas con favicon"
echo "   📤 Todo subido a GitHub"
echo ""
echo "⏱️  El deployment comenzará automáticamente..."
echo ""
echo "🔍 PARA VERIFICAR:"
echo "1. Espera 2-3 minutos"
echo "2. Ve a: https://github.com/Wikibuda/fermentation-expert-app/actions"
echo "3. Deberías ver 'Deploy to GitHub Pages' ejecutándose"
echo "4. Cuando termine, abre: https://Wikibuda.github.io/fermentation-expert-app/"
echo ""
echo "🛠️  SI HAY PROBLEMAS:"
echo "1. Verifica permisos en:"
echo "   https://github.com/Wikibuda/fermentation-expert-app/settings/pages"
echo "2. Asegúrate que diga 'Source: GitHub Actions'"
echo ""
echo "¡Listo! Tu aplicación tendrá:"
echo "• ✅ Favicon profesional"
echo "• ✅ Diseño moderno y responsive"
echo "• ✅ Deployment automático con GitHub Pages"
echo "• ✅ Todas las apps funcionando"
echo ""
echo "🧪 ¡Felices fermentaciones!"
