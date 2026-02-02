#!/bin/bash
# add_loading_animations.sh

echo "🌀 AGREGANDO ANIMACIONES DE ESPERA AL CHAT"
echo "=========================================="

# Primero, verificar que el archivo existe
if [ ! -f "fermentation_agent.html" ]; then
    echo "❌ No se encuentra fermentation_agent.html"
    exit 1
fi

# Crear backup
cp fermentation_agent.html fermentation_agent.html.backup

echo ""
echo "1. 🎨 AGREGANDO ESTILOS CSS PARA ANIMACIONES..."
echo "=============================================="

# Buscar el cierre de </style> para agregar antes
if grep -q "</style>" fermentation_agent.html; then
    # Agregar estilos de animación antes del cierre de </style>
    sed -i '' '/<\/style>/i\
    /* 🌀 Animaciones de espera */\
    .thinking-container {\
        display: flex;\
        flex-direction: column;\
        align-items: center;\
        justify-content: center;\
        padding: 20px;\
        min-height: 120px;\
        background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);\
        border-radius: 15px;\
        margin: 10px 0;\
        border-left: 4px solid #2e7d32;\
    }\
    \
    .thinking-title {\
        font-size: 1.1rem;\
        color: #2e7d32;\
        margin-bottom: 15px;\
        font-weight: 600;\
        text-align: center;\
    }\
    \
    .thinking-subtitle {\
        font-size: 0.9rem;\
        color: #6c757d;\
        margin-bottom: 20px;\
        text-align: center;\
        font-style: italic;\
    }\
    \
    /* Opción 1: Puntos animados */\
    .thinking-dots {\
        display: flex;\
        gap: 8px;\
        margin-bottom: 20px;\
    }\
    \
    .thinking-dot {\
        width: 12px;\
        height: 12px;\
        background: #2e7d32;\
        border-radius: 50%;\
        opacity: 0.6;\
    }\
    \
    .thinking-dot:nth-child(1) {\
        animation: pulse 1.5s infinite;\
    }\
    \
    .thinking-dot:nth-child(2) {\
        animation: pulse 1.5s infinite 0.3s;\
    }\
    \
    .thinking-dot:nth-child(3) {\
        animation: pulse 1.5s infinite 0.6s;\
    }\
    \
    /* Opción 2: Barra de progreso animada */\
    .thinking-progress {\
        width: 200px;\
        height: 4px;\
        background: #dee2e6;\
        border-radius: 2px;\
        overflow: hidden;\
        margin: 15px 0;\
    }\
    \
    .thinking-progress-bar {\
        height: 100%;\
        width: 30%;\
        background: linear-gradient(90deg, #2e7d32, #4caf50);\
        border-radius: 2px;\
        animation: progress 2s ease-in-out infinite;\
    }\
    \
    /* Opción 3: Ícono de fermentación animado */\
    .fermentation-icon {\
        font-size: 2.5rem;\
        margin-bottom: 15px;\
        animation: float 3s ease-in-out infinite;\
    }\
    \
    /* Opción 4: Spinner moderno */\
    .thinking-spinner {\
        width: 40px;\
        height: 40px;\
        border: 3px solid rgba(46, 125, 50, 0.2);\
        border-top-color: #2e7d32;\
        border-radius: 50%;\
        animation: spin 1s linear infinite;\
        margin: 15px 0;\
    }\
    \
    /* Opción 5: Burbujas de fermentación */\
    .bubbles-container {\
        display: flex;\
        justify-content: center;\
        gap: 15px;\
        margin: 20px 0;\
    }\
    \
    .bubble {\
        width: 20px;\
        height: 20px;\
        background: #2e7d32;\
        border-radius: 50%;\
        opacity: 0.7;\
        animation: bubble-rise 2s infinite;\
    }\
    \
    .bubble:nth-child(2) {\
        animation-delay: 0.3s;\
        background: #4caf50;\
    }\
    \
    .bubble:nth-child(3) {\
        animation-delay: 0.6s;\
        background: #8bc34a;\
    }\
    \
    /* Animaciones */\
    @keyframes pulse {\
        0%, 100% {\
            opacity: 0.6;\
            transform: scale(1);\
        }\
        50% {\
            opacity: 1;\
            transform: scale(1.2);\
        }\
    }\
    \
    @keyframes progress {\
        0% {\
            transform: translateX(-100%);\
        }\
        50% {\
            transform: translateX(150%);\
        }\
        100% {\
            transform: translateX(350%);\
        }\
    }\
    \
    @keyframes float {\
        0%, 100% {\
            transform: translateY(0) rotate(0deg);\
        }\
        50% {\
            transform: translateY(-10px) rotate(5deg);\
        }\
    }\
    \
    @keyframes spin {\
        to {\
            transform: rotate(360deg);\
        }\
    }\
    \
    @keyframes bubble-rise {\
        0% {\
            transform: translateY(0) scale(1);\
            opacity: 0.7;\
        }\
        50% {\
            transform: translateY(-20px) scale(1.1);\
            opacity: 1;\
        }\
        100% {\
            transform: translateY(-40px) scale(1);\
            opacity: 0;\
        }\
    }\
    \
    /* Texto animado */\
    .thinking-text {\
        font-size: 1rem;\
        color: #495057;\
        margin: 10px 0;\
        text-align: center;\
    }\
    \
    .thinking-dynamic-text {\
        display: inline-block;\
        min-width: 200px;\
        text-align: center;\
    }\
    \
    .thinking-tips {\
        font-size: 0.85rem;\
        color: #6c757d;\
        margin-top: 15px;\
        padding: 10px;\
        background: rgba(46, 125, 50, 0.05);\
        border-radius: 8px;\
        text-align: center;\
        max-width: 300px;\
        animation: fadeInOut 6s infinite;\
    }\
    \
    @keyframes fadeInOut {\
        0%, 100% { opacity: 0.5; }\
        50% { opacity: 1; }\
    }\
    \
    /* Efectos de aparición */\
    .thinking-message {\
        animation: slideIn 0.5s ease-out;\
    }\
    \
    @keyframes slideIn {\
        from {\
            opacity: 0;\
            transform: translateY(10px);\
        }\
        to {\
            opacity: 1;\
            transform: translateY(0);\
        }\
    }\
    \
    /* Responsive */\
    @media (max-width: 768px) {\
        .thinking-container {\
            padding: 15px;\
            min-height: 100px;\
        }\
        \
        .fermentation-icon {\
            font-size: 2rem;\
        }\
        \
        .thinking-progress {\
            width: 150px;\
        }\
    }' fermentation_agent.html
fi

echo ""
echo "2. 🔄 ACTUALIZANDO EL CÓDIGO JAVASCRIPT..."
echo "=========================================="

# Buscar la función que muestra "Pensando en la mejor respuesta..."
if grep -q "Pensando en la mejor respuesta" fermentation_agent.html; then
    # Encontrar la línea específica para reemplazar
    LINE_NUMBER=$(grep -n "Pensando en la mejor respuesta" fermentation_agent.html | cut -d: -f1)
    
    if [ ! -z "$LINE_NUMBER" ]; then
        # Crear archivo temporal con el contenido actualizado
        awk -v line="$LINE_NUMBER" '
        NR == line {
            print "                            <div class=\"thinking-container thinking-message\">";
            print "                                <div class=\"fermentation-icon\">🧫</div>";
            print "                                <div class=\"thinking-title\">🧠 Especialista en Fermentación</div>";
            print "                                <div class=\"thinking-subtitle\">Analizando tu consulta...</div>";
            print "                                ";
            print "                                <!-- Opción 1: Spinner + progreso -->";
            print "                                <div class=\"thinking-spinner\"></div>";
            print "                                <div class=\"thinking-progress\">";
            print "                                    <div class=\"thinking-progress-bar\"></div>";
            print "                                </div>";
            print "                                ";
            print "                                <!-- Opción 2: Puntos animados -->";
            print "                                <div class=\"thinking-dots\">";
            print "                                    <div class=\"thinking-dot\"></div>";
            print "                                    <div class=\"thinking-dot\"></div>";
            print "                                    <div class=\"thinking-dot\"></div>";
            print "                                </div>";
            print "                                ";
            print "                                <!-- Texto dinámico -->";
            print "                                <div class=\"thinking-text\">";
            print "                                    <div class=\"thinking-dynamic-text\" id=\"dynamicThinkingText\">Procesando tu pregunta sobre fermentación...</div>";
            print "                                </div>";
            print "                                ";
            print "                                <!-- Burbujas de fermentación -->";
            print "                                <div class=\"bubbles-container\">";
            print "                                    <div class=\"bubble\"></div>";
            print "                                    <div class=\"bubble\"></div>";
            print "                                    <div class=\"bubble\"></div>";
            print "                                </div>";
            print "                                ";
            print "                                <!-- Tips aleatorios -->";
            print "                                <div class=\"thinking-tips\" id=\"thinkingTips\">💡 La paciencia es clave en la fermentación</div>";
            print "                            </div>";
            next;
        }
        { print }
        ' fermentation_agent.html > fermentation_agent.html.tmp
        
        mv fermentation_agent.html.tmp fermentation_agent.html
    fi
fi

echo ""
echo "3. 📝 AGREGANDO TEXTO DINÁMICO Y TIPS..."
echo "======================================="

# Buscar el cierre de </script> para agregar antes
if grep -q "</script>" fermentation_agent.html; then
    # Agregar lógica de texto dinámico
    sed -i '' '/<\/script>/i\
    \    /* 🌀 Animaciones de espera dinámicas */\
    \    const thinkingTips = [\
    \        "💡 Analizando técnicas de fermentación...",\
    \        "🔬 Revisando parámetros microbiológicos...",\
    \        "🌿 Consultando bases de datos de cultivos...",\
    \        "⚗️ Evaluando condiciones óptimas...",\
    \        "⏱️ Calculando tiempos de proceso...",\
    \        "🌡️ Optimizando temperaturas...",\
    \        "📊 Procesando datos históricos...",\
    \        "🧪 Simulando resultados...",\
    \        "🔍 Buscando soluciones similares...",\
    \        "📚 Revisando literatura científica...",\
    \        "🍞 Ajustando receta para mejor fermentación...",\
    \        "🥬 Optimizando condiciones para vegetales...",\
    \        "🍺 Calculando parámetros para cerveza...",\
    \        "🍶 Ajustando proporciones para sake...",\
    \        "🧀 Evaluando maduración óptima..."\
    \    ];\
    \    \
    \    const fermentationFacts = [\
    \        "¿Sabías que la fermentación puede aumentar el valor nutricional de los alimentos?",\
    \        "La temperatura ideal para la fermentación láctica es entre 18-22°C",\
    \        "El kimchi coreano puede tener más de 200 variedades",\
    \        "La masa madre puede vivir indefinidamente si se alimenta regularmente",\
    \        "El proceso de fermentación produce gases CO₂, ¡por eso burbujea!",\
    \        "Los probióticos en alimentos fermentados ayudan a la digestión",\
    \        "La fermentación es una de las formas más antiguas de conservación",\
    \        "Cada fermentación es única como una huella digital"\
    \    ];\
    \    \
    \    let thinkingInterval;\
    \    let tipInterval;\
    \    let tipIndex = 0;\
    \    let thinkingIndex = 0;\
    \    \
    \    function startThinkingAnimations() {\
    \        const dynamicText = document.getElementById("dynamicThinkingText");\
    \        const tipsElement = document.getElementById("thinkingTips");\
    \        \
    \        if (dynamicText) {\
    \            thinkingIndex = 0;\
    \            thinkingInterval = setInterval(() => {\
    \                thinkingIndex = (thinkingIndex + 1) % thinkingTips.length;\
    \                dynamicText.textContent = thinkingTips[thinkingIndex];\
    \                \
    \                // Efecto de transición\
    \                dynamicText.style.opacity = 0.7;\
    \                setTimeout(() => {\
    \                    dynamicText.style.opacity = 1;\
    \                    dynamicText.style.transition = "opacity 0.5s";\
    \                }, 50);\
    \            }, 3000); // Cambia cada 3 segundos\
    \        }\
    \        \
    \        if (tipsElement) {\
    \            tipIndex = 0;\
    \            tipInterval = setInterval(() => {\
    \                tipIndex = (tipIndex + 1) % fermentationFacts.length;\
    \                tipsElement.textContent = `💡 ${fermentationFacts[tipIndex]}`;\
    \                \
    \                // Efecto de fade\
    \                tipsElement.style.animation = "none";\
    \                setTimeout(() => {\
    \                    tipsElement.style.animation = "fadeInOut 6s infinite";\
    \                }, 10);\
    \            }, 6000); // Cambia cada 6 segundos\
    \        }\
    \        \
    \        // También animar otros elementos\
    \        animateProgressBar();\
    \    }\
    \    \
    \    function stopThinkingAnimations() {\
    \        if (thinkingInterval) {\
    \            clearInterval(thinkingInterval);\
    \        }\
    \        if (tipInterval) {\
    \            clearInterval(tipInterval);\
    \        }\
    \    }\
    \    \
    \    function animateProgressBar() {\
    \        const progressBar = document.querySelector(".thinking-progress-bar");\
    \        if (progressBar) {\
    \            // La animación CSS ya lo hace, pero podemos agregar variación\
    \            setInterval(() => {\
    \                const randomWidth = 20 + Math.random() * 40;\
    \                progressBar.style.width = `${randomWidth}%`;\
    \            }, 1500);\
    \        }\
    \    }\
    \    \
    \    // Iniciar animaciones cuando se muestra el mensaje de "pensando"\
    \    function showThinkingMessage() {\
    \        startThinkingAnimations();\
    \    }\
    \    \
    \    // Detener animaciones cuando llega la respuesta\
    \    function hideThinkingMessage() {\
    \        stopThinkingAnimations();\
    \    }\
    ' fermentation_agent.html
fi

echo ""
echo "4. 🔧 INTEGRANDO CON LA FUNCIÓN EXISTENTE..."
echo "==========================================="

# Buscar la función que maneja el envío de mensajes
if grep -q "async function sendMessage" fermentation_agent.html; then
    # Agregar llamadas a las animaciones
    sed -i '' '/async function sendMessage/,/^    }/ {
        /showThinkingMessage\./! {
            /"Pensando en la mejor respuesta/ {
                a\
        showThinkingMessage();
            }
        }
    }' fermentation_agent.html
    
    # Buscar donde se limpia el mensaje de pensando y agregar stop
    sed -i '' '/document\.getElementById.*thinkingMessage.*remove/ {
        a\
        hideThinkingMessage();
    }' fermentation_agent.html
fi

echo ""
echo "5. 🎯 AGREGANDO VERSIÓN MÍNIMA (ALTERNATIVA SIMPLE)..."
echo "===================================================="

# Crear también una versión simple por si se prefiere
cat > simple_loading.html << 'SIMPLE_EOF'
<div class="thinking-container">
    <div style="text-align: center; padding: 20px;">
        <div style="font-size: 2rem; margin-bottom: 10px; animation: bounce 1s infinite;">🧫</div>
        <div style="font-weight: bold; color: #2e7d32; margin-bottom: 5px;">
            Especialista en Fermentación
        </div>
        <div style="color: #666; margin-bottom: 15px; font-style: italic;">
            Preparando tu respuesta...
        </div>
        <div style="display: flex; justify-content: center; gap: 8px; margin-bottom: 20px;">
            <div style="width: 10px; height: 10px; background: #2e7d32; border-radius: 50%; 
                 animation: pulse 1s infinite;"></div>
            <div style="width: 10px; height: 10px; background: #4caf50; border-radius: 50%; 
                 animation: pulse 1s infinite 0.2s;"></div>
            <div style="width: 10px; height: 10px; background: #8bc34a; border-radius: 50%; 
                 animation: pulse 1s infinite 0.4s;"></div>
        </div>
        <div style="font-size: 0.9rem; color: #888;">
            Esto puede tomar unos segundos...
        </div>
    </div>
</div>

<style>
@keyframes bounce {
    0%, 100% { transform: translateY(0); }
    50% { transform: translateY(-10px); }
}
@keyframes pulse {
    0%, 100% { opacity: 0.3; transform: scale(0.9); }
    50% { opacity: 1; transform: scale(1.1); }
}
</style>
SIMPLE_EOF

echo ""
echo "6. 📱 CREANDO VERSIÓN PARA MÓVIL OPTIMIZADA..."
echo "============================================="

cat > mobile_loading.html << 'MOBILE_EOF'
<div class="thinking-mobile">
    <div class="mobile-thinking-content">
        <!-- Icono animado -->
        <div class="mobile-icon">🥬</div>
        
        <!-- Texto principal -->
        <div class="mobile-title">Procesando...</div>
        
        <!-- Barra de progreso minimalista -->
        <div class="mobile-progress-track">
            <div class="mobile-progress-bar"></div>
        </div>
        
        <!-- Indicador de actividad -->
        <div class="mobile-activity">
            <span class="activity-dot"></span>
            <span class="activity-text">Analizando fermentación</span>
        </div>
        
        <!-- Tiempo estimado -->
        <div class="mobile-estimate">
            ⏱️ <span id="timeEstimate">10s</span> restantes
        </div>
    </div>
</div>

<style>
.thinking-mobile {
    background: linear-gradient(135deg, #f8fff9 0%, #f0f9f1 100%);
    border-radius: 12px;
    padding: 15px;
    margin: 10px;
    border-left: 3px solid #2e7d32;
}

.mobile-thinking-content {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 12px;
}

.mobile-icon {
    font-size: 2rem;
    animation: mobile-float 2s ease-in-out infinite;
}

.mobile-title {
    font-weight: 600;
    color: #2e7d32;
    font-size: 1rem;
}

.mobile-progress-track {
    width: 100%;
    height: 3px;
    background: #e0e0e0;
    border-radius: 1.5px;
    overflow: hidden;
}

.mobile-progress-bar {
    height: 100%;
    width: 40%;
    background: linear-gradient(90deg, #2e7d32, #4caf50);
    border-radius: 1.5px;
    animation: mobile-progress 2s ease-in-out infinite;
}

.mobile-activity {
    display: flex;
    align-items: center;
    gap: 8px;
    font-size: 0.85rem;
    color: #666;
}

.activity-dot {
    width: 6px;
    height: 6px;
    background: #4caf50;
    border-radius: 50%;
    animation: mobile-pulse 1.5s infinite;
}

.mobile-estimate {
    font-size: 0.8rem;
    color: #888;
    text-align: center;
}

@keyframes mobile-float {
    0%, 100% { transform: translateY(0) rotate(0deg); }
    50% { transform: translateY(-5px) rotate(5deg); }
}

@keyframes mobile-progress {
    0% { transform: translateX(-100%); }
    100% { transform: translateX(250%); }
}

@keyframes mobile-pulse {
    0%, 100% { opacity: 0.3; }
    50% { opacity: 1; }
}

/* Efecto de conteo regresivo */
@keyframes countdown {
    from { opacity: 1; }
    to { opacity: 0.5; }
}
</style>

<script>
// Actualizar tiempo estimado
let timeLeft = 10;
const timeElement = document.getElementById('timeEstimate');
const countdownInterval = setInterval(() => {
    timeLeft--;
    if (timeLeft <= 0) {
        timeLeft = 5; // Reiniciar
        timeElement.style.animation = 'countdown 0.5s';
        setTimeout(() => {
            timeElement.style.animation = '';
        }, 500);
    }
    timeElement.textContent = `${timeLeft}s`;
}, 1000);

// Cambiar iconos aleatoriamente
const icons = ['🧫', '🥬', '🍞', '🍶', '⚗️', '🔬', '🌡️', '⏱️'];
const iconElement = document.querySelector('.mobile-icon');
setInterval(() => {
    const randomIcon = icons[Math.floor(Math.random() * icons.length)];
    iconElement.textContent = randomIcon;
}, 2000);
</script>
MOBILE_EOF

echo ""
echo "7. 📤 ACTUALIZANDO Y SUBIENDO..."
echo "================================"

# Crear un archivo de demostración de las animaciones
cat > loading_demo.html << 'DEMO_EOF'
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Demo Animaciones de Espera - Fermentation Expert</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        }
        
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #e8f5e9 100%);
            padding: 20px;
            min-height: 100vh;
        }
        
        .demo-container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        
        h1 {
            color: #2e7d32;
            margin-bottom: 10px;
            text-align: center;
        }
        
        .subtitle {
            color: #666;
            text-align: center;
            margin-bottom: 30px;
        }
        
        .demo-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin: 30px 0;
        }
        
        .demo-card {
            background: #f8f9fa;
            border-radius: 15px;
            padding: 25px;
            border: 2px solid #e9ecef;
            transition: all 0.3s;
        }
        
        .demo-card:hover {
            border-color: #2e7d32;
            transform: translateY(-5px);
        }
        
        .demo-title {
            color: #1b5e20;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .preview-area {
            min-height: 150px;
            display: flex;
            justify-content: center;
            align-items: center;
            margin: 20px 0;
            background: white;
            border-radius: 10px;
            padding: 20px;
        }
        
        .btn {
            display: inline-block;
            background: #2e7d32;
            color: white;
            padding: 10px 20px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            margin-top: 10px;
            transition: all 0.3s;
        }
        
        .btn:hover {
            background: #1b5e20;
            transform: translateY(-2px);
        }
        
        .code-block {
            background: #263238;
            color: #e0e0e0;
            padding: 15px;
            border-radius: 8px;
            font-family: monospace;
            font-size: 0.9rem;
            overflow-x: auto;
            margin-top: 15px;
            display: none;
        }
        
        .toggle-code {
            background: none;
            border: none;
            color: #2e7d32;
            cursor: pointer;
            font-size: 0.9rem;
            margin-top: 10px;
        }
        
        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: #2e7d32;
            text-decoration: none;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="demo-container">
        <a href="/fermentation-expert-app/" class="back-link">← Volver a la app</a>
        
        <h1>🎨 Demo: Animaciones de Espera</h1>
        <p class="subtitle">Elige tu estilo favorito para la espera de respuesta</p>
        
        <div class="demo-grid">
            <!-- Estilo 1: Completo -->
            <div class="demo-card">
                <h3 class="demo-title">🎭 Estilo Completo</h3>
                <p>Todas las animaciones: spinner, progreso, burbujas y tips dinámicos.</p>
                <div class="preview-area" id="preview1">
                    <!-- Se cargará dinámicamente -->
                </div>
                <button class="toggle-code" onclick="toggleCode('code1')">Ver código</button>
                <div id="code1" class="code-block">
                    // Usa el estilo completo en fermentation_agent.html
                </div>
            </div>
            
            <!-- Estilo 2: Minimalista -->
            <div class="demo-card">
                <h3 class="demo-title">✨ Estilo Minimalista</h3>
                <p>Simple, limpio y rápido. Ideal para conexiones lentas.</p>
                <div class="preview-area" id="preview2"></div>
                <button class="toggle-code" onclick="toggleCode('code2')">Ver código</button>
                <div id="code2" class="code-block">
                    // Código minimalista disponible en simple_loading.html
                </div>
            </div>
            
            <!-- Estilo 3: Móvil -->
            <div class="demo-card">
                <h3 class="demo-title">📱 Estilo Móvil</h3>
                <p>Optimizado para pantallas pequeñas con tiempo estimado.</p>
                <div class="preview-area" id="preview3"></div>
                <button class="toggle-code" onclick="toggleCode('code3')">Ver código</button>
                <div id="code3" class="code-block">
                    // Código móvil en mobile_loading.html
                </div>
            </div>
        </div>
        
        <div style="text-align: center; margin-top: 30px;">
            <a href="fermentation_agent.html" class="btn">Probar en el chat real →</a>
        </div>
    </div>
    
    <script>
        // Cargar las vistas previas
        document.addEventListener('DOMContentLoaded', () => {
            // Vista previa 1: Estilo completo
            fetch('simple_loading.html')
                .then(response => response.text())
                .then(html => {
                    document.getElementById('preview1').innerHTML = html;
                });
            
            // Vista previa 2: Minimalista
            document.getElementById('preview2').innerHTML = `
                <div style="text-align: center;">
                    <div style="font-size: 1.5rem; margin-bottom: 10px;">🧠</div>
                    <div style="font-weight: bold; color: #2e7d32;">Pensando...</div>
                    <div style="display: flex; gap: 5px; margin-top: 15px; justify-content: center;">
                        <div style="width: 8px; height: 8px; background: #2e7d32; border-radius: 50%;
                             animation: demo-pulse 1s infinite;"></div>
                        <div style="width: 8px; height: 8px; background: #2e7d32; border-radius: 50%;
                             animation: demo-pulse 1s infinite 0.2s;"></div>
                        <div style="width: 8px; height: 8px; background: #2e7d32; border-radius: 50%;
                             animation: demo-pulse 1s infinite 0.4s;"></div>
                    </div>
                </div>
                <style>
                    @keyframes demo-pulse {
                        0%, 100% { opacity: 0.3; transform: scale(0.8); }
                        50% { opacity: 1; transform: scale(1.2); }
                    }
                </style>
            `;
            
            // Vista previa 3: Móvil
            document.getElementById('preview3').innerHTML = `
                <div style="width: 100%; max-width: 250px;">
                    <div style="text-align: center; font-size: 1.8rem; margin-bottom: 10px;
                         animation: demo-float 2s infinite;">🥬</div>
                    <div style="font-weight: 600; color: #2e7d32; text-align: center; margin-bottom: 10px;">
                        Analizando...
                    </div>
                    <div style="background: #e0e0e0; height: 3px; border-radius: 1.5px; overflow: hidden;">
                        <div style="height: 100%; width: 60%; background: #4caf50; border-radius: 1.5px;
                             animation: demo-slide 2s infinite;"></div>
                    </div>
                    <div style="font-size: 0.8rem; color: #666; text-align: center; margin-top: 10px;">
                        ⏱️ 15s restantes
                    </div>
                </div>
                <style>
                    @keyframes demo-float {
                        0%, 100% { transform: translateY(0); }
                        50% { transform: translateY(-5px); }
                    }
                    @keyframes demo-slide {
                        0% { transform: translateX(-100%); }
                        100% { transform: translateX(200%); }
                    }
                </style>
            `;
        });
        
        function toggleCode(id) {
            const codeBlock = document.getElementById(id);
            codeBlock.style.display = codeBlock.style.display === 'block' ? 'none' : 'block';
        }
    </script>
</body>
</html>
DEMO_EOF

echo ""
echo "🎉 ¡ANIMACIONES AGREGADAS!"
echo "========================"
echo ""
echo "✅ Qué se ha implementado:"
echo ""
echo "🎨 **4 Estilos de Animación:**"
echo "   • 🔄 Spinner de fermentación animado"
echo "   • 📊 Barra de progreso con movimiento"
echo "   • 💭 Texto dinámico que cambia"
echo "   • 🫧 Burbujas de fermentación flotantes"
echo ""
echo "📝 **Contenido Dinámico:**"
echo "   • 💡 Tips aleatorios sobre fermentación"
echo "   • 🔬 Mensajes de proceso realistas"
echo "   • ⏱️ Conteo regresivo estimado"
echo "   • 🎯 Iconos que cambian aleatoriamente"
echo ""
echo "⚡ **Funcionalidades JavaScript:"
echo "   • ⏳ Animaciones que inician automáticamente"
echo "   • 🛑 Se detienen cuando llega la respuesta"
echo "   • 🔄 Ciclos de texto automáticos"
echo "   • 📱 Responsive para todos los dispositivos"
echo ""
echo "🔧 **Archivos Creados:"
echo "   • ✅ fermentation_agent.html actualizado"
echo "   • 📄 simple_loading.html (alternativa minimalista)"
echo "   • 📱 mobile_loading.html (versión móvil)"
echo "   • 🎭 loading_demo.html (página de demostración)"
echo ""
echo "🚀 **Para probar:"
echo ""
echo "1. El deployment se ejecutará automáticamente"
echo "2. En 2-3 minutos, abre:"
echo "   https://wikibuda.github.io/fermentation-expert-app/fermentation_agent.html"
echo "3. Envía un mensaje al experto"
echo "4. ¡Disfruta de las nuevas animaciones!"
echo ""
echo "🎯 **Opciones disponibles:"
echo "• Usar el estilo completo (recomendado)"
echo "• Cambiar al estilo minimalista si prefieres simple"
echo "• Usar versión móvil si hay problemas de rendimiento"
echo ""
echo "¡La espera ahora será mucho más interesante! 🎨"
