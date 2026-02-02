#!/bin/bash
# test_deployment.sh - Prueba completa del despliegue

echo "🧪 PRUEBA DE DEPLOYMENT - OPCIÓN 1"
echo "=================================="

echo ""
echo "1. 📋 VERIFICANDO WORKFLOW..."
echo "   URL: https://github.com/Wikibuda/fermentation-expert-app/actions"
echo ""
echo "   Busca:"
echo "   ✅ Workflow 'CI/CD Pipeline' o similar"
echo "   ✅ Estado 'completed' (verde)"
echo "   ✅ Sin errores 'Permission denied'"

echo ""
echo "2. 🌐 PROBANDO PÁGINA..."
STATUS=$(curl -s -o /dev/null -w "%{http_code}" https://Wikibuda.github.io/fermentation-expert-app/ 2>/dev/null || echo "error")
echo "   HTTP Status: $STATUS"
if [ "$STATUS" = "200" ]; then
    echo "   ✅ Página carga correctamente (200 OK)"
elif [ "$STATUS" = "404" ]; then
    echo "   ⚠️  Página no encontrada (404)"
    echo "   Puede que aún no se haya desplegado o esté en proceso"
elif [ "$STATUS" = "error" ]; then
    echo "   ❌ No se pudo conectar"
else
    echo "   ⚠️  Status: $STATUS"
fi

echo ""
echo "3. 📁 VERIFICANDO RAMA gh-pages..."
if git show-ref --verify --quiet refs/remotes/origin/gh-pages; then
    echo "   ✅ Rama gh-pages existe"
    echo "   Último commit:"
    git log -1 --oneline origin/gh-pages 2>/dev/null || echo "   No se pudo acceder"
else
    echo "   ❌ Rama gh-pages NO existe"
    echo "   El deployment aún no ha creado la rama"
fi

echo ""
echo "4. ⚙️ VERIFICANDO CONFIGURACIÓN GITHUB PAGES..."
echo "   Ve a: https://github.com/Wikibuda/fermentation-expert-app/settings/pages"
echo ""
echo "   Debería mostrar:"
echo "   ✅ 'Your site is published at https://Wikibuda.github.io/fermentation-expert-app/'"
echo "   ✅ Source configurado (GitHub Actions o gh-pages branch)"

echo ""
echo "5. 📊 RESUMEN:"
if [ "$STATUS" = "200" ] && git show-ref --verify --quiet refs/remotes/origin/gh-pages; then
    echo "   🎉 ¡TODO FUNCIONA CORRECTAMENTE!"
    echo "   La aplicación está en: https://Wikibuda.github.io/fermentation-expert-app/"
    echo "   Abriendo ahora..."
    open https://Wikibuda.github.io/fermentation-expert-app/fermentation_agent.html
elif [ "$STATUS" = "404" ] && git show-ref --verify --quiet refs/remotes/origin/gh-pages; then
    echo "   ⚠️  La rama existe pero la página no carga"
    echo "   Espera 1-2 minutos y prueba de nuevo"
elif [ "$STATUS" = "200" ] && ! git show-ref --verify --quiet refs/remotes/origin/gh-pages; then
    echo "   ⚠️  La página carga pero no hay rama gh-pages"
    echo "   Puede estar cacheado o usar otro método"
else
    echo "   🔧 Aún no funciona completamente"
    echo "   Necesitas:"
    echo "   1. Que el workflow se complete"
    echo "   2. Configurar Pages en GitHub"
    echo "   3. Esperar 2-3 minutos"
fi

echo ""
echo "6. 🚀 ACCIÓN INMEDIATA:"
echo "   Para forzar un nuevo deployment:"
echo "   git commit --allow-empty -m 'Trigger deployment' && git push origin main"
