#!/bin/bash
# migrate_to_modern_pages.sh

echo "🚀 MIGRANDO A GITHUB PAGES MODERNO"
echo "================================="

echo ""
echo "📋 PROBLEMA IDENTIFICADO:"
echo "   • Workflow viejo: peaceiris/actions-gh-pages@v3"
echo "   • Necesita rama: gh-pages"
echo "   • GitHub Pages moderno: NO necesita rama gh-pages"

echo ""
echo "1. 🔧 CREANDO WORKFLOW MODERNO..."
mkdir -p .github/workflows

cat > .github/workflows/pages.yml << 'MODERN_EOF'
name: Deploy to GitHub Pages

on:
  push:
    branches: [ main ]
  workflow_dispatch:

# Estos permisos son CRÍTICOS para el nuevo sistema
permissions:
  contents: read
  pages: write
  id-token: write

# Solo un despliegue a la vez
concurrency:
  group: "pages"
  cancel-in-progress: true

jobs:
  deploy:
    runs-on: ubuntu-latest
    
    # Environment para tracking
    environment:
      name: github-pages
      url: \${{ steps.deployment.outputs.page_url }}
    
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4
        with:
          fetch-depth: 0  # Descargar todo el historial
      
      - name: Setup GitHub Pages
        uses: actions/configure-pages@v3
      
      - name: Create .nojekyll file
        run: |
          touch .nojekyll
          echo "¡Despliegue moderno sin rama gh-pages!" > deploy-info.txt
      
      - name: Upload to GitHub Pages
        uses: actions/upload-pages-artifact@v2
        with:
          path: '.'
          retention-days: 1
      
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v2
MODERN_EOF

echo "✅ Workflow moderno creado en .github/workflows/pages.yml"

echo ""
echo "2. 📄 CREANDO ARCHIVOS DE CONFIGURACIÓN..."
# Archivo .nojekyll (importante para GitHub Pages)
touch .nojekyll

# Asegurar que index.html existe
if [ ! -f index.html ]; then
  cat > index.html << 'INDEX_EOF'
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fermentation Expert App</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; padding: 50px; }
        .app-link { display: inline-block; margin: 20px; padding: 20px; 
                   background: #2e7d32; color: white; text-decoration: none;
                   border-radius: 10px; width: 250px; }
        .app-link:hover { background: #1b5e20; }
    </style>
</head>
<body>
    <h1>🧫 Fermentation Expert App</h1>
    <p>Aplicación web especializada en procesos de fermentación</p>
    
    <a href="fermentation_agent.html" class="app-link">
        <h3>🤖 Chat con Experto</h3>
        <p>Asistente de IA especializado</p>
    </a>
    
    <a href="tracker.html" class="app-link">
        <h3>📊 Tracker</h3>
        <p>Seguimiento de desarrollo</p>
    </a>
</body>
</html>
INDEX_EOF
fi

echo ""
echo "3. 📤 SUBIENDO CAMBIOS..."
git add .
git commit -m "feat: migrate to modern GitHub Pages deployment"
git push origin main

echo ""
echo "✅ ¡MIGRACIÓN COMPLETADA!"
echo ""
echo "📝 AHORA EN GITHUB:"
echo "1. Actions ejecutará el NUEVO workflow"
echo "2. NO necesita rama gh-pages"
echo "3. Desplegará directamente desde main"
echo ""
echo "⏱️  Espera 2-3 minutos..."
echo "🔗 Luego prueba: https://Wikibuda.github.io/fermentation-expert-app/"
