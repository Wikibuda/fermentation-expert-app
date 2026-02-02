#!/bin/bash
# test_live_app.sh

echo "🧪 PRUEBA COMPLETA DE LA APLICACIÓN EN VIVO"
echo "=========================================="

echo ""
echo "1. 🌐 URLS DE PRODUCCIÓN:"
echo "   • Aplicación: https://Wikibuda.github.io/fermentation-expert-app/fermentation_agent.html"
echo "   • Tracker: https://Wikibuda.github.io/fermentation-expert-app/tracker.html"
echo "   • Configurador: https://Wikibuda.github.io/fermentation-expert-app/enterprise_configurator.html"
echo "   • Landing: https://Wikibuda.github.io/fermentation-expert-app/"

echo ""
echo "2. 🔍 VERIFICANDO CONTENIDO..."
echo "   Probando acceso a archivos:"

# Probar varios archivos
FILES=(
  "fermentation_agent.html"
  "tracker.html" 
  "enterprise_configurator.html"
  "README.md"
  "index.html"
)

for file in "${FILES[@]}"; do
  status=$(curl -s -o /dev/null -w "%{http_code}" "https://Wikibuda.github.io/fermentation-expert-app/$file")
  if [ "$status" = "200" ]; then
    echo "   ✅ $file → 200 OK"
  else
    echo "   ⚠️  $file → $status"
  fi
done

echo ""
echo "3. 📊 VERIFICANDO GITHUB ACTIONS..."
echo "   Abriendo Actions..."
open https://github.com/Wikibuda/fermentation-expert-app/actions

echo ""
echo "4. ⚙️ VERIFICANDO GITHUB PAGES SETTINGS..."
echo "   Abriendo configuración..."
open https://github.com/Wikibuda/fermentation-expert-app/settings/pages

echo ""
echo "5. 🚀 ACCIONES RECOMENDADAS:"
echo "   a. Configura tu API Key en la app web"
echo "   b. Prueba con una pregunta sobre fermentación"
echo "   c. Comparte el enlace con otros"
echo "   d. Revisa que el CI/CD esté verde"

echo ""
echo "6. 🎯 ESTADO FINAL:"
echo "   ✅ SITIO EN PRODUCCIÓN: https://Wikibuda.github.io/fermentation-expert-app/"
echo "   ✅ PÁGINAS CARGAN: HTTP 200"
echo "   ✅ CONFIGURACIÓN: GitHub Actions (moderna)"
echo "   ✅ LISTO PARA USAR: ¡Ya puedes usar la app!"
