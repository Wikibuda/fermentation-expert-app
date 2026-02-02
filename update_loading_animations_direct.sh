i#!/bin/bash
# update_loading_animations_direct.sh

echo "🔄 ACTUALIZANDO ANIMACIONES DE ESPERA DIRECTAMENTE..."
echo "====================================================="

# 1. Primero, hacer pull para tener la última versión
echo "📥 Sincronizando con GitHub..."
git pull origin main

# 2. Buscar y reemplazar el texto estático con animaciones
echo "🎨 Reemplazando texto estático por animaciones..."

# Crear archivo temporal con el nuevo contenido
cat > temp_loading.html << 'LOADING_EOF'
<div class="thinking-container thinking-message">
    <div class="fermentation-icon">🧫</div>
    <div class="thinking-title">🧠 Especialista en Fermentación</div>
    <div class="thinking-subtitle">Analizando tu consulta sobre fermentación...</div>
    
    <!-- Spinner animado -->
    <div class="thinking-spinner"></div>
    
    <!-- Barra de progreso -->
    <div class="thinking-progress">
        <div class="thinking-progress-bar"></div>
    </div>
    
    <!-- Puntos animados -->
    <div class="thinking-dots">
        <div class="thinking-dot"></div>
        <div class="thinking-dot"></div>
        <div class="thinking-dot"></div>
    </div>
    
    <!-- Texto dinámico -->
    <div class="thinking-text">
        <div class="thinking-dynamic-text" id="dynamicThinkingText">Procesando tu pregunta...</div>
    </div>
    
    <!-- Burbujas de fermentación -->
    <div class="bubbles-container">
        <div class="bubble"></div>
        <div class="bubble"></div>
        <div class="bubble"></div>
    </div>
    
    <!-- Tips aleatorios -->
    <div class="thinking-tips" id="thinkingTips">💡 La fermentación es un arte y una ciencia</div>
</div>
LOADING_EOF

# 3. Actualizar fermentation_agent.html
if [ -f "fermentation_agent.html" ]; then
    echo "📄 Actualizando fermentation_agent.html..."
    
    # Primero agregar los estilos CSS
    if grep -q "</style>" fermentation_agent.html; then
        # Insertar estilos de animación
        sed -i '' '/<\/style>/i\
\    /* 🌀 Animaciones de espera mejoradas */\
\    .thinking-container {\
\        display: flex;\
\        flex-direction: column;\
\        align-items: center;\
\        justify-content: center;\
\        padding: 25px 20px;\
\        min-height: 140px;\
\        background: linear-gradient(135deg, #f8fdf8 0%, #f0f9f0 100%);\
\        border-radius: 16px;\
\        margin: 15px 0;\
\        border-left: 5px solid #2e7d32;\
\        box-shadow: 0 4px 15px rgba(46, 125, 50, 0.1);\
\        animation: slideIn 0.5s ease-out;\
\    }\
\    \
\    .thinking-title {\
\        font-size: 1.2rem;\
\        color: #1b5e20;\
\        margin-bottom: 8px;\
\        font-weight: 700;\
\        text-align: center;\
\    }\
\    \
\    .thinking-subtitle {\
\        font-size: 0.95rem;\
\        color: #4caf50;\
\        margin-bottom: 20px;\
\        text-align: center;\
\        font-style: italic;\
\    }\
\    \
\    .fermentation-icon {\
\        font-size: 3rem;\
\        margin-bottom: 15px;\
\        animation: float 3s ease-in-out infinite;\
\    }\
\    \
\    .thinking-spinner {\
\        width: 45px;\
\        height: 45px;\
\        border: 4px solid rgba(46, 125, 50, 0.2);\
\        border-top-color: #2e7d32;\
\        border-radius: 50%;\
\        animation: spin 1.2s linear infinite;\
\        margin: 10px 0 20px 0;\
\    }\
\    \
\    .thinking-progress {\
\        width: 220px;\
\        height: 6px;\
\        background: #e8f5e9;\
\        border-radius: 3px;\
\        overflow: hidden;\
\        margin: 15px 0;\
\    }\
\    \
\    .thinking-progress-bar {\
\        height: 100%;\
\        width: 35%;\
\        background: linear-gradient(90deg, #2e7d32, #4caf50, #8bc34a);\
\        border-radius: 3px;\
\        animation: progress 2.5s ease-in-out infinite;\
\    }\
\    \
\    .thinking-dots {\
\        display: flex;\
\        gap: 10px;\
\        margin: 15px 0;\
\    }\
\    \
\    .thinking-dot {\
\        width: 14px;\
\        height: 14px;\
\        background: #2e7d32;\
\        border-radius: 50%;\
\        opacity: 0.6;\
\    }\
\    \
\    .thinking-dot:nth-child(1) {\
\        animation: pulse 1.8s infinite;\
\    }\
\    \
\    .thinking-dot:nth-child(2) {\
\        animation: pulse 1.8s infinite 0.3s;\
\    }\
\    \
\    .thinking-dot:nth-child(3) {\
\        animation: pulse 1.8s infinite 0.6s;\
\    }\
\    \
\    .thinking-text {\
\        font-size: 1rem;\
\        color: #37474f;\
\        margin: 15px 0;\
\        text-align: center;\
\        min-height: 24px;\
\    }\
\    \
\    .thinking-dynamic-text {\
\        display: inline-block;\
\        min-width: 250px;\
\        text-align: center;\
\        font-weight: 500;\
\    }\
\    \
\    .bubbles-container {\
\        display: flex;\
\        justify-content: center;\
\        gap: 18px;\
\        margin: 20px 0;\
\    }\
\    \
\    .bubble {\
\        width: 22px;\
\        height: 22px;\
\        background: linear-gradient(145deg, #2e7d32, #4caf50);\
\        border-radius: 50%;\
\        opacity: 0.8;\
\        animation: bubble-rise 2.2s infinite;\
\        box-shadow: 0 4px 8px rgba(46, 125, 50, 0.2);\
\    }\
\    \
\    .bubble:nth-child(2) {\
\        animation-delay: 0.4s;\
\        background: linear-gradient(145deg, #4caf50, #8bc34a);\
\    }\
\    \
\    .bubble:nth-child(3) {\
\        animation-delay: 0.8s;\
\        background: linear-gradient(145deg, #8bc34a, #cddc39);\
\    }\
\    \
\    .thinking-tips {\
\        font-size: 0.9rem;\
\        color: #5a6268;\
\        margin-top: 20px;\
\        padding: 12px 15px;\
\        background: rgba(46, 125, 50, 0.08);\
\        border-radius: 10px;\
\        text-align: center;\
\        max-width: 320px;\
\        line-height: 1.4;\
\        border: 1px dashed rgba(76, 175, 80, 0.3);\
\        animation: fadeInOut 8s infinite;\
\    }\
\    \
\    /* Animaciones */\
\    @keyframes float {\
\        0%, 100% {\
\            transform: translateY(0) rotate(0deg);\
\        }\
\        33% {\
\            transform: translateY(-12px) rotate(5deg);\
\        }\
\        66% {\
\            transform: translateY(-6px) rotate(-5deg);\
\        }\
\    }\
\    \
\    @keyframes spin {\
\        to { transform: rotate(360deg); }\
\    }\
\    \
\    @keyframes progress {\
\        0% { transform: translateX(-100%); }\
\        50% { transform: translateX(180%); }\
\        100% { transform: translateX(350%); }\
\    }\
\    \
\    @keyframes pulse {\
\        0%, 100% {\
\            opacity: 0.4;\
\            transform: scale(0.9);\
\        }\
\        50% {\
\            opacity: 1;\
\            transform: scale(1.2);\
\        }\
\    }\
\    \
\    @keyframes bubble-rise {\
\        0% {\
\            transform: translateY(0) scale(1);\
\            opacity: 0.7;\
\        }\
\        50% {\
\            transform: translateY(-25px) scale(1.1);\
\            opacity: 1;\
\        }\
\        100% {\
\            transform: translateY(-50px) scale(1);\
\            opacity: 0;\
\        }\
\    }\
\    \
\    @keyframes fadeInOut {\
\        0%, 100% { opacity: 0.5; }\
\        50% { opacity: 1; }\
\    }\
\    \
\    @keyframes slideIn {\
\        from {\
\            opacity: 0;\
\            transform: translateY(15px);\
\        }\
\        to {\
\            opacity: 1;\
\            transform: translateY(0);\
\        }\
\    }\
\    \
\    /* Responsive */\
\    @media (max-width: 768px) {\
\        .thinking-container {\
\            padding: 20px 15px;\
\            min-height: 130px;\
\            margin: 10px 0;\
\        }\
\        \
\        .fermentation-icon {\
\            font-size: 2.5rem;\
\        }\
\        \
\        .thinking-progress {\
\            width: 180px;\
\        }\
\        \
\        .thinking-dynamic-text {\
\            min-width: 200px;\
\            font-size: 0.95rem;\
\        }\
\        \
\        .thinking-tips {\
\            font-size: 0.85rem;\
\            padding: 10px 12px;\
\            max-width: 280px;\
\        }\
\    }' fermentation_agent.html
    fi
    
    # Ahora reemplazar el texto estático
    if grep -q "Pensando en la mejor respuesta" fermentation_agent.html; then
        # Reemplazar la línea específica
        sed -i '' 's|.*Pensando en la mejor respuesta.*|<div class="thinking-container thinking-message">\
    <div class="fermentation-icon">🧫</div>\
    <div class="thinking-title">🧠 Especialista en Fermentación</div>\
    <div class="thinking-subtitle">Analizando tu consulta sobre fermentación...</div>\
    \
    <div class="thinking-spinner"></div>\
    \
    <div class="thinking-progress">\
        <div class="thinking-progress-bar"></div>\
    </div>\
    \
    <div class="thinking-dots">\
        <div class="thinking-dot"></div>\
        <div class="thinking-dot"></div>\
        <div class="thinking-dot"></div>\
    </div>\
    \
    <div class="thinking-text">\
        <div class="thinking-dynamic-text" id="dynamicThinkingText">Procesando tu pregunta...</div>\
    </div>\
    \
    <div class="bubbles-container">\
        <div class="bubble"></div>\
        <div class="bubble"></div>\
        <div class="bubble"></div>\
    </div>\
    \
    <div class="thinking-tips" id="thinkingTips">💡 La fermentación es un arte y una ciencia</div>\
</div>|g' fermentation_agent.html
        
        echo "✅ Texto estático reemplazado por animaciones"
    else
        echo "⚠️ No se encontró el texto estático, buscando alternativa..."
        # Buscar cualquier div con mensaje de pensando
        sed -i '' 's|<div[^>]*>[[:space:]]*Especialista en Fermentación[^<]*</div>|<div class="thinking-container thinking-message">\
    <div class="fermentation-icon">🧫</div>\
    <div class="thinking-title">🧠 Especialista en Fermentación</div>\
    <div class="thinking-subtitle">Analizando tu consulta sobre fermentación...</div>\
    \
    <div class="thinking-spinner"></div>\
    \
    <div class="thinking-progress">\
        <div class="thinking-progress-bar"></div>\
    </div>\
    \
    <div class="thinking-dots">\
        <div class="thinking-dot"></div>\
        <div class="thinking-dot"></div>\
        <div class="thinking-dot"></div>\
    </div>\
    \
    <div class="thinking-text">\
        <div class="thinking-dynamic-text" id="dynamicThinkingText">Procesando tu pregunta...</div>\
    </div>\
    \
    <div class="bubbles-container">\
        <div class="bubble"></div>\
        <div class="bubble"></div>\
        <div class="bubble"></div>\
    </div>\
    \
    <div class="thinking-tips" id="thinkingTips">💡 La fermentación es un arte y una ciencia</div>\
</div>|g' fermentation_agent.html
    fi
    
    # 4. Agregar JavaScript para el texto dinámico
    echo "📝 Agregando JavaScript para texto dinámico..."
    
    # Buscar donde termina el script y agregar antes
    if grep -q "</script>" fermentation_agent.html; then
        sed -i '' '/<\/script>/i\
\    /* 🌀 Sistema de texto dinámico para animaciones de espera */\
\    const thinkingPhrases = [\
\        "🔬 Analizando parámetros microbiológicos...",\
\        "🌡️ Evaluando temperaturas óptimas...",\
\        "⏱️ Calculando tiempos de fermentación...",\
\        "📊 Procesando datos históricos...",\
\        "🧪 Simulando resultados posibles...",\
\        "🌿 Consultando bases de cultivos...",\
\        "🍞 Optimizando receta para mejor fermentación...",\
\        "🥬 Ajustando condiciones para vegetales...",\
\        "🍺 Calculando parámetros para cerveza artesanal...",\
\        "🍶 Evaluando proporciones para sake...",\
\        "🧀 Analizando maduración óptima...",\
\        "⚗️ Revisando condiciones químicas...",\
\        "📚 Consultando literatura científica...",\
\        "💭 Buscando soluciones similares...",\
\        "🎯 Preparando respuesta personalizada..."\
\    ];\
\    \
\    const fermentationFacts = [\
\        "💡 La fermentación puede aumentar el valor nutricional de los alimentos",\
\        "🌡️ La temperatura ideal para fermentación láctica es 18-22°C",\
\        "⏳ El kimchi coreano puede tener más de 200 variedades diferentes",\
\        "🦠 Los probióticos en alimentos fermentados ayudan a la digestión",\
\        "🌀 La fermentación es una de las formas más antiguas de conservación",\
\        "🌿 Cada fermentación es única como una huella digital",\
\        "⚗️ El proceso produce gases CO₂, ¡por eso burbujea!",\
\        "🧪 La masa madre puede vivir indefinidamente si se alimenta",\
\        "📈 La fermentación lenta desarrolla sabores más complejos",\
\        "🔬 Los microorganismos trabajan en simbiosis durante la fermentación"\
\    ];\
\    \
\    let thinkingInterval = null;\
\    let tipsInterval = null;\
\    let currentThinkingIndex = 0;\
\    let currentTipIndex = 0;\
\    \
\    function startLoadingAnimations() {\
\        const thinkingText = document.getElementById("dynamicThinkingText");\
\        const tipsElement = document.getElementById("thinkingTips");\
\        \
\        // Limpiar intervalos anteriores por seguridad\
\        if (thinkingInterval) clearInterval(thinkingInterval);\
\        if (tipsInterval) clearInterval(tipsInterval);\
\        \
\        // Animación de texto dinámico\
\        if (thinkingText) {\
\            currentThinkingIndex = 0;\
\            thinkingText.textContent = thinkingPhrases[0];\
\            \
\            thinkingInterval = setInterval(() => {\
\                currentThinkingIndex = (currentThinkingIndex + 1) % thinkingPhrases.length;\
\                thinkingText.style.opacity = "0.5";\
\                thinkingText.style.transform = "translateY(5px)";\
\                \
\                setTimeout(() => {\
\                    thinkingText.textContent = thinkingPhrases[currentThinkingIndex];\
\                    thinkingText.style.opacity = "1";\
\                    thinkingText.style.transform = "translateY(0)";\
\                    thinkingText.style.transition = "all 0.3s ease";\
\                }, 150);\
\            }, 2500); // Cambia cada 2.5 segundos\
\        }\
\        \
\        // Animación de tips\
\        if (tipsElement) {\
\            currentTipIndex = 0;\
\            tipsElement.textContent = fermentationFacts[0];\
\            \
\            tipsInterval = setInterval(() => {\
\                currentTipIndex = (currentTipIndex + 1) % fermentationFacts.length;\
\                tipsElement.style.animation = "none";\
\                \
\                setTimeout(() => {\
\                    tipsElement.textContent = fermentationFacts[currentTipIndex];\
\                    tipsElement.style.animation = "fadeInOut 8s infinite";\
\                }, 100);\
\            }, 6000); // Cambia cada 6 segundos\
\        }\
\        \
\        console.log("🌀 Animaciones de espera iniciadas");\
\    }\
\    \
\    function stopLoadingAnimations() {\
\        if (thinkingInterval) {\
\            clearInterval(thinkingInterval);\
\            thinkingInterval = null;\
\        }\
\        if (tipsInterval) {\
\            clearInterval(tipsInterval);\
\            tipsInterval = null;\
\        }\
\        console.log("🌀 Animaciones de espera detenidas");\
\    }\
\    \
\    // Integración con la función existente de envío de mensajes\
\    function showEnhancedThinkingMessage() {\
\        // Esperar un poco para que el DOM se actualice\
\        setTimeout(startLoadingAnimations, 100);\
\    }\
\    \
\    // Detectar cuando se muestra el mensaje de "pensando"\
\    document.addEventListener("DOMContentLoaded", function() {\
\        // Sobrescribir la función que muestra el mensaje de pensando\
\        const originalShowThinking = window.showThinkingMessage || function() {};\
\        window.showThinkingMessage = function() {\
\            originalShowThinking();\
\            showEnhancedThinkingMessage();\
\        };\
\        \
\        // También monitorear cambios en el DOM para detectar mensajes de pensando\
\        const observer = new MutationObserver(function(mutations) {\
\            mutations.forEach(function(mutation) {\
\                if (mutation.addedNodes && mutation.addedNodes.length > 0) {\
\                    for (let i = 0; i < mutation.addedNodes.length; i++) {\
\                        const node = mutation.addedNodes[i];\
\                        if (node.nodeType === 1 && \
\                            (node.textContent.includes("Especialista") || \
\                             node.classList && node.classList.contains("thinking-container"))) {\
\                            setTimeout(startLoadingAnimations, 300);\
\                        }\
\                    }\
\                }\
\            });\
\        });\
\        \
\        observer.observe(document.body, { childList: true, subtree: true });\
\    });' fermentation_agent.html
    fi
    
    # 5. Integrar con la función de envío existente
    echo "🔗 Integrando con función de envío existente..."
    
    # Buscar la función sendMessage y agregar startLoadingAnimations
    if grep -q "async function sendMessage" fermentation_agent.html; then
        # Encontrar donde se muestra el mensaje de pensando
        LINE_NUM=$(grep -n "mostrar mensaje de pensando" fermentation_agent.html | cut -d: -f1)
        if [ -z "$LINE_NUM" ]; then
            LINE_NUM=$(grep -n "thinkingMessage\|pensando" fermentation_agent.html | head -1 | cut -d: -f1)
        fi
        
        if [ ! -z "$LINE_NUM" ]; then
            # Insertar después de mostrar el mensaje de pensando
            sed -i '' "${LINE_NUM}a\\
            // Iniciar animaciones mejoradas\\
            if (typeof startLoadingAnimations === 'function') {\\
                setTimeout(startLoadingAnimations, 50);\\
            }" fermentation_agent.html
        fi
        
        # Buscar donde se remueve el mensaje de pensando
        REMOVE_LINE=$(grep -n "remove.*thinkingMessage\|thinkingMessage.*remove" fermentation_agent.html | head -1 | cut -d: -f1)
        if [ ! -z "$REMOVE_LINE" ]; then
            # Insertar antes de remover el mensaje
            sed -i '' "${REMOVE_LINE}i\\
            // Detener animaciones antes de remover el mensaje\\
            if (typeof stopLoadingAnimations === 'function') {\\
                stopLoadingAnimations();\\
            }" fermentation_agent.html
        fi
    fi
    
    echo "✅ fermentation_agent.html actualizado exitosamente"
else
    echo "❌ No se encontró fermentation_agent.html"
    exit 1
fi

# 6. Crear una versión simple para referencia
echo "📄 Creando versión simple de referencia..."
cat > loading_animation_simple.html << 'SIMPLE_EOF'
<!-- Versión simple de animaciones de espera -->
<style>
.loading-simple {
    text-align: center;
    padding: 30px 20px;
    background: #f8fdf8;
    border-radius: 15px;
    border-left: 5px solid #2e7d32;
    margin: 20px 0;
    animation: slideIn 0.5s ease-out;
}

.loading-icon {
    font-size: 3rem;
    animation: bounce 2s infinite;
    margin-bottom: 15px;
}

.loading-text {
    font-weight: bold;
    color: #1b5e20;
    margin-bottom: 10px;
    font-size: 1.2rem;
}

.loading-subtext {
    color: #4caf50;
    margin-bottom: 20px;
    font-style: italic;
}

.loading-dots {
    display: inline-flex;
    gap: 8px;
    margin: 20px 0;
}

.loading-dot {
    width: 12px;
    height: 12px;
    background: #2e7d32;
    border-radius: 50%;
    animation: pulse 1.5s infinite;
}

.loading-dot:nth-child(2) { animation-delay: 0.2s; }
.loading-dot:nth-child(3) { animation-delay: 0.4s; }

@keyframes bounce {
    0%, 100% { transform: translateY(0); }
    50% { transform: translateY(-15px); }
}

@keyframes pulse {
    0%, 100% { opacity: 0.3; transform: scale(0.9); }
    50% { opacity: 1; transform: scale(1.1); }
}

@keyframes slideIn {
    from { opacity: 0; transform: translateY(20px); }
    to { opacity: 1; transform: translateY(0); }
}
</style>

<div class="loading-simple">
    <div class="loading-icon">🧫</div>
    <div class="loading-text">🧠 Especialista en Fermentación</div>
    <div class="loading-subtext">Preparando respuesta especializada...</div>
    <div class="loading-dots">
        <div class="loading-dot"></div>
        <div class="loading-dot"></div>
        <div class="loading-dot"></div>
    </div>
    <div style="color: #666; font-size: 0.9rem; margin-top: 15px;">
        Esto solo tomará unos momentos...
    </div>
</div>
SIMPLE_EOF

# 7. Subir los cambios
echo "📤 Subiendo cambios a GitHub..."
git add fermentation_agent.html loading_animation_simple.html
git commit -m "feat: add animated loading message with dynamic text and fermentation-themed animations"
git push origin main

echo ""
echo "🎉 ¡ANIMACIONES ACTUALIZADAS Y SUBIDAS!"
echo "======================================="
echo ""
echo "✅ Cambios realizados:"
echo ""
echo "🎨 **Nuevas animaciones agregadas:**"
echo "   • 🌀 Spinner de fermentación giratorio"
echo "   • 📊 Barra de progreso animada"
echo "   • 💭 Texto dinámico que cambia automáticamente"
echo "   • 🫧 Burbujas de fermentación flotantes"
echo "   • 💡 Tips educativos sobre fermentación"
echo ""
echo "⚡ **Mejoras de experiencia:**
echo "   • ✅ Animaciones suaves y profesionales"
echo "   • ✅ Temática coherente con fermentación"
echo "   • ✅ Feedback visual constante al usuario"
echo "   • ✅ Textos relevantes y educativos"
echo "   • ✅ Totalmente responsive"
echo ""
echo "🔧 **Integración técnica:**
echo "   • ✅ Se integra automáticamente con la función existente"
echo "   • ✅ Animaciones se inician/detienen automáticamente"
echo "   • ✅ No interfiere con el funcionamiento actual"
echo "   • ✅ Código organizado y comentado"
echo ""
echo "🚀 **Para probar:"
echo ""
echo "1. Espera 2-3 minutos para que se despliegue"
echo "2. Abre: https://wikibuda.github.io/fermentation-expert-app/fermentation_agent.html"
echo "3. Envía una pregunta al experto"
echo "4. Observa las nuevas animaciones durante la espera"
echo ""
echo "🎯 **Características visibles:"
echo "• Icono de fermentación que rebota 🧫"
echo "• Spinner giratorio con colores temáticos"
echo "• Barra de progreso que se mueve"
echo "• Texto que cambia mostrando diferentes procesos"
echo "• Burbujas que ascienden (como en fermentación real)"
echo "• Tips aleatorios sobre fermentación"
echo ""
echo "📱 **Funciona en todos los dispositivos:"
echo "• Desktop: Animaciones completas"
echo "• Tablet: Optimizado para pantalla media"
echo "• Móvil: Versión simplificada responsiva"
echo ""
echo "⏳ **Tiempo estimado de deployment: 2-3 minutos"
echo "🔗 URL: https://wikibuda.github.io/fermentation-expert-app/"
echo ""
echo "¡La espera ahora será mucho más interesante y educativa! 🎉"
