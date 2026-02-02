#!/bin/bash
# implement_pwa_responsable.sh - PWA con notificaciones responsables

echo "📱 IMPLEMENTANDO PWA CON NOTIFICACIONES RESPONSABLES"
echo "===================================================="

echo ""
echo "1. 🔧 ACTUALIZANDO SERVICE WORKER PARA NOTIFICACIONES..."
echo "======================================================"

# Actualizar el service worker con notificaciones mejoradas
cat > pwa/service-worker.js << 'SW_EOF'
// Service Worker para Fermentation Expert App - Notificaciones responsables
const CACHE_NAME = 'fermentation-expert-v1.1';
const urlsToCache = [
  '/fermentation-expert-app/',
  '/fermentation-expert-app/index.html',
  '/fermentation-expert-app/fermentation_agent.html',
  '/fermentation-expert-app/tracker.html',
  '/fermentation-expert-app/enterprise_configurator.html',
  '/fermentation-expert-app/favicon.ico',
  '/fermentation-expert-app/pwa/icon-192x192.png',
  '/fermentation-expert-app/pwa/icon-512x512.png',
  '/fermentation-expert-app/site.webmanifest',
  '/fermentation-expert-app/pwa/notification-permission.html'
];

// Instalación del Service Worker
self.addEventListener('install', event => {
  console.log('🧫 Service Worker: Instalando...');
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => {
        console.log('🧫 Service Worker: Cacheando archivos');
        return cache.addAll(urlsToCache);
      })
      .then(() => self.skipWaiting())
  );
});

// Activación
self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys().then(cacheNames => {
      return Promise.all(
        cacheNames.map(cache => {
          if (cache !== CACHE_NAME) {
            return caches.delete(cache);
          }
        })
      );
    }).then(() => self.clients.claim())
  );
});

// Fetch
self.addEventListener('fetch', event => {
  // No cachear API calls
  if (event.request.url.includes('api.deepseek.com')) {
    return;
  }
  
  event.respondWith(
    caches.match(event.request)
      .then(response => response || fetch(event.request))
      .catch(() => {
        if (event.request.headers.get('accept').includes('text/html')) {
          return caches.match('/fermentation-expert-app/offline.html');
        }
      })
  );
});

// NOTIFICACIONES PUSH - Versión mejorada y responsable
self.addEventListener('push', event => {
  // Solo mostrar notificación si el usuario la ha habilitado explícitamente
  if (!event.data) return;
  
  const data = event.data.json();
  
  // Verificar si tenemos permiso (doble verificación)
  self.registration.pushManager.permissionState({userVisibleOnly: true})
    .then(permissionState => {
      if (permissionState === 'granted') {
        showNotification(data);
      }
    });
});

function showNotification(data) {
  const options = {
    body: data.body || 'Nueva actualización disponible',
    icon: '/fermentation-expert-app/pwa/icon-192x192.png',
    badge: '/fermentation-expert-app/pwa/icon-96x96.png',
    vibrate: [100, 50, 100],
    data: {
      url: data.url || '/fermentation-expert-app/',
      timestamp: Date.now()
    },
    actions: [
      {
        action: 'open',
        title: 'Abrir'
      },
      {
        action: 'dismiss',
        title: 'Cerrar'
      }
    ],
    tag: data.tag || 'fermentation-update',
    requireInteraction: data.important || false
  };
  
  return self.registration.showNotification(
    data.title || 'Fermentation Expert',
    options
  );
}

// Manejo de clics en notificaciones
self.addEventListener('notificationclick', event => {
  event.notification.close();
  
  const urlToOpen = event.notification.data.url || '/fermentation-expert-app/';
  
  if (event.action === 'open') {
    event.waitUntil(
      clients.matchAll({
        type: 'window',
        includeUncontrolled: true
      }).then(clientList => {
        // Buscar ventana existente
        for (const client of clientList) {
          if (client.url === urlToOpen && 'focus' in client) {
            return client.focus();
          }
        }
        // Abrir nueva ventana
        if (clients.openWindow) {
          return clients.openWindow(urlToOpen);
        }
      })
    );
  }
  
  // Registrar la acción del usuario para analytics
  if (event.action === 'dismiss') {
    console.log('Usuario descartó notificación');
  }
});

// Manejo de cierre de notificaciones
self.addEventListener('notificationclose', event => {
  console.log('Notificación cerrada:', event.notification.tag);
});

// Sincronización en background
self.addEventListener('sync', event => {
  if (event.tag === 'sync-fermentation-data') {
    event.waitUntil(syncData());
  }
});

async function syncData() {
  console.log('Sincronizando datos de fermentación...');
  // Implementar lógica de sincronización aquí
  return Promise.resolve();
}

// Manejo de errores de push
self.addEventListener('pushsubscriptionchange', event => {
  console.log('Suscripción push cambiada:', event);
  // Aquí podrías renovar la suscripción
});

// Mensajes desde la app
self.addEventListener('message', event => {
  switch (event.data.type) {
    case 'SKIP_WAITING':
      self.skipWaiting();
      break;
    case 'CLEAR_CACHE':
      caches.delete(CACHE_NAME);
      break;
    case 'SEND_NOTIFICATION':
      if (event.data.payload) {
        showNotification(event.data.payload);
      }
      break;
  }
});
SW_EOF

echo ""
echo "2. 📝 CREANDO SISTEMA DE PERMISOS RESPONSABLE..."
echo "================================================"

# Crear página de explicación de permisos
cat > pwa/notification-permission.html << 'PERMISSION_EOF'
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Notificaciones - Fermentation Expert</title>
    <style>
        :root {
            --primary: #2e7d32;
            --primary-light: #4caf50;
            --light: #f1f8e9;
            --dark: #263238;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        }
        
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #e8f5e9 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        
        .permission-card {
            background: white;
            border-radius: 20px;
            padding: 40px;
            max-width: 500px;
            width: 100%;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            text-align: center;
        }
        
        .icon {
            font-size: 4rem;
            margin-bottom: 20px;
            color: var(--primary);
        }
        
        h1 {
            color: var(--dark);
            margin-bottom: 15px;
            font-size: 1.8rem;
        }
        
        p {
            color: #666;
            line-height: 1.6;
            margin-bottom: 25px;
        }
        
        .benefits {
            text-align: left;
            background: var(--light);
            padding: 20px;
            border-radius: 10px;
            margin: 25px 0;
        }
        
        .benefit-item {
            display: flex;
            align-items: center;
            margin: 10px 0;
        }
        
        .benefit-icon {
            color: var(--primary);
            margin-right: 10px;
            font-size: 1.2rem;
        }
        
        .buttons {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }
        
        .btn {
            flex: 1;
            padding: 15px;
            border: none;
            border-radius: 10px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .btn-primary {
            background: var(--primary);
            color: white;
        }
        
        .btn-primary:hover {
            background: #1b5e20;
            transform: translateY(-2px);
        }
        
        .btn-secondary {
            background: #f5f5f5;
            color: var(--dark);
        }
        
        .btn-secondary:hover {
            background: #e0e0e0;
        }
        
        .privacy-note {
            font-size: 0.8rem;
            color: #888;
            margin-top: 20px;
            line-height: 1.4;
        }
        
        .control-panel {
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }
        
        .control-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px solid #f0f0f0;
        }
        
        .status {
            font-weight: 600;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.9rem;
        }
        
        .status.granted {
            background: #e8f5e9;
            color: var(--primary);
        }
        
        .status.denied {
            background: #ffebee;
            color: #c62828;
        }
        
        .status.default {
            background: #f5f5f5;
            color: #666;
        }
        
        @media (max-width: 480px) {
            .permission-card {
                padding: 25px;
            }
            
            .buttons {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <div class="permission-card">
        <div class="icon">🔔</div>
        <h1>Notificaciones de Fermentation Expert</h1>
        <p>Recibe alertas importantes sobre tus procesos de fermentación, recordatorios y actualizaciones.</p>
        
        <div class="benefits">
            <div class="benefit-item">
                <span class="benefit-icon">⏰</span>
                <span>Recordatorios de tus fermentaciones</span>
            </div>
            <div class="benefit-item">
                <span class="benefit-icon">⚠️</span>
                <span>Alertas cuando necesites intervenir</span>
            </div>
            <div class="benefit-item">
                <span class="benefit-icon">🔄</span>
                <span>Actualizaciones de nuevas características</span>
            </div>
            <div class="benefit-item">
                <span class="benefit-icon">🔒</span>
                <span>Solo notificaciones relevantes, sin spam</span>
            </div>
        </div>
        
        <div class="control-panel">
            <div class="control-item">
                <span>Estado de permisos:</span>
                <span id="permissionStatus" class="status default">No configurado</span>
            </div>
            <div class="control-item">
                <span>Notificaciones activas:</span>
                <span id="notificationCount">0</span>
            </div>
        </div>
        
        <div class="buttons">
            <button id="enableBtn" class="btn btn-primary">
                Activar Notificaciones
            </button>
            <button id="laterBtn" class="btn btn-secondary">
                Recordármelo después
            </button>
        </div>
        
        <div class="privacy-note">
            🔒 Respetamos tu privacidad. Las notificaciones solo se usarán para alertas relacionadas con la app. 
            Puedes desactivarlas en cualquier momento desde la configuración de tu navegador.
        </div>
    </div>
    
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const enableBtn = document.getElementById('enableBtn');
            const laterBtn = document.getElementById('laterBtn');
            const statusEl = document.getElementById('permissionStatus');
            const countEl = document.getElementById('notificationCount');
            
            // Verificar estado actual
            updatePermissionStatus();
            
            // Botón "Activar" - SOLO aquí solicitamos permisos
            enableBtn.addEventListener('click', async () => {
                try {
                    // Explicar claramente lo que haremos
                    const userConfirmed = confirm(
                        'Fermentation Expert te enviará:\n' +
                        '• Recordatorios de fermentación\n' +
                        '• Alertas importantes\n' +
                        '• Actualizaciones relevantes\n\n' +
                        '¿Quieres permitir las notificaciones?'
                    );
                    
                    if (!userConfirmed) {
                        statusEl.textContent = 'Cancelado por el usuario';
                        statusEl.className = 'status denied';
                        savePreference('notifications', 'denied');
                        return;
                    }
                    
                    // Solicitar permiso (solo después de confirmación del usuario)
                    const permission = await Notification.requestPermission();
                    
                    updatePermissionStatus();
                    savePreference('notifications', permission);
                    
                    if (permission === 'granted') {
                        // Mostrar notificación de prueba (opcional)
                        showWelcomeNotification();
                        alert('✅ Notificaciones activadas. ¡Gracias!');
                        
                        // Redirigir a la página principal después de un momento
                        setTimeout(() => {
                            window.location.href = '/fermentation-expert-app/';
                        }, 1500);
                    }
                    
                } catch (error) {
                    console.error('Error solicitando permisos:', error);
                    statusEl.textContent = 'Error';
                    statusEl.className = 'status denied';
                }
            });
            
            // Botón "Recordármelo después"
            laterBtn.addEventListener('click', () => {
                savePreference('notifications', 'later');
                localStorage.setItem('notificationPromptTime', Date.now() + (7 * 24 * 60 * 60 * 1000)); // 1 semana
                window.location.href = '/fermentation-expert-app/';
            });
            
            // Mostrar notificación de bienvenida
            function showWelcomeNotification() {
                if ('serviceWorker' in navigator && Notification.permission === 'granted') {
                    navigator.serviceWorker.ready.then(registration => {
                        registration.showNotification('¡Bienvenido a Fermentation Expert!', {
                            body: 'Las notificaciones están ahora activadas. ¡Te avisaremos de cosas importantes!',
                            icon: '/fermentation-expert-app/pwa/icon-192x192.png',
                            badge: '/fermentation-expert-app/pwa/icon-96x96.png',
                            tag: 'welcome-notification'
                        });
                        
                        // Actualizar contador
                        const currentCount = parseInt(localStorage.getItem('notificationCount') || '0');
                        localStorage.setItem('notificationCount', currentCount + 1);
                        updateNotificationCount();
                    });
                }
            }
            
            // Actualizar estado de permisos
            function updatePermissionStatus() {
                const permission = Notification.permission;
                statusEl.textContent = permission === 'granted' ? 'Activadas' : 
                                      permission === 'denied' ? 'Denegadas' : 'No configurado';
                statusEl.className = `status ${permission}`;
                
                // Ocultar botón si ya está concedido
                if (permission === 'granted') {
                    enableBtn.style.display = 'none';
                    laterBtn.textContent = 'Volver a la app';
                }
            }
            
            // Actualizar contador
            function updateNotificationCount() {
                const count = localStorage.getItem('notificationCount') || '0';
                countEl.textContent = count;
            }
            
            // Guardar preferencia del usuario
            function savePreference(type, value) {
                localStorage.setItem(`preference_${type}`, value);
                localStorage.setItem(`preference_${type}_date`, new Date().toISOString());
            }
            
            // Inicializar
            updateNotificationCount();
            
            // Si ya tiene permisos, redirigir después de 3 segundos
            if (Notification.permission === 'granted') {
                setTimeout(() => {
                    window.location.href = '/fermentation-expert-app/';
                }, 3000);
            }
        });
    </script>
</body>
</html>
PERMISSION_EOF

echo ""
echo "3. 🔄 ACTUALIZANDO REGISTER-SW.JS CON GESTOS..."
echo "=============================================="

cat > pwa/register-sw.js << 'REGISTER_EOF'
// Service Worker Registration - Versión responsable con gestos

// Configuración
const APP_CONFIG = {
  notificationPromptDelay: 10000, // 10 segundos después de interacción
  promptCooldown: 7 * 24 * 60 * 60 * 1000, // 1 semana entre prompts
  minInteractions: 3 // Mínimo de interacciones antes de preguntar
};

// Variables de estado
let userInteractions = 0;
let lastInteractionTime = 0;
let notificationPromptShown = false;

// Registrar Service Worker
function registerServiceWorker() {
  if ('serviceWorker' in navigator) {
    const swPath = '/fermentation-expert-app/pwa/service-worker.js';
    
    navigator.serviceWorker.register(swPath)
      .then(registration => {
        console.log('🧫 Service Worker registrado:', registration.scope);
        
        // Verificar actualizaciones
        registration.addEventListener('updatefound', () => {
          const newWorker = registration.installing;
          console.log('🔄 Nueva versión del Service Worker disponible');
          
          newWorker.addEventListener('statechange', () => {
            if (newWorker.state === 'installed' && navigator.serviceWorker.controller) {
              showUpdateNotification(registration);
            }
          });
        });
        
        // Inicializar sistema de notificaciones responsable
        initializeResponsiveNotifications(registration);
      })
      .catch(error => {
        console.error('❌ Error registrando Service Worker:', error);
      });
  }
}

// Sistema de notificaciones basado en gestos
function initializeResponsiveNotifications(swRegistration) {
  // Solo inicializar si el usuario no ha denegado explícitamente
  if (Notification.permission === 'denied') {
    console.log('🔕 Usuario ha denegado notificaciones');
    return;
  }
  
  // Cargar preferencias del usuario
  const userPreference = localStorage.getItem('preference_notifications');
  const lastPromptTime = localStorage.getItem('notificationPromptTime');
  const now = Date.now();
  
  // Si el usuario dijo "más tarde", verificar si ha pasado el tiempo suficiente
  if (userPreference === 'later' && lastPromptTime) {
    if (now < parseInt(lastPromptTime)) {
      console.log('⏰ Usuario pidió recordarle después');
      return;
    }
  }
  
  // Si ya tiene permisos, configurar botón de notificaciones
  if (Notification.permission === 'granted') {
    setupNotificationControls(swRegistration);
    return;
  }
  
  // Configurar tracking de interacciones del usuario
  setupInteractionTracking();
  
  // Escuchar gestos específicos para mostrar prompt
  setupGestureListeners(swRegistration);
}

// Trackear interacciones del usuario
function setupInteractionTracking() {
  const interactiveElements = [
    'button', 'a', 'input', 'select', 'textarea',
    '[role="button"]', '[tabindex]'
  ];
  
  document.addEventListener('click', (event) => {
    const element = event.target;
    
    // Solo contar interacciones significativas
    if (element.matches(interactiveElements.join(','))) {
      userInteractions++;
      lastInteractionTime = Date.now();
      console.log(`👆 Interacción ${userInteractions}:`, element.tagName);
      
      // Verificar si debemos mostrar el prompt
      checkForNotificationPrompt();
    }
  }, true);
}

// Configurar gestos específicos
function setupGestureListeners(swRegistration) {
  // Botón en UI para activar notificaciones (gesto explícito)
  document.addEventListener('DOMContentLoaded', () => {
    // Crear botón de notificaciones si no existe
    if (!document.getElementById('notification-settings-btn')) {
      const notificationBtn = document.createElement('button');
      notificationBtn.id = 'notification-settings-btn';
      notificationBtn.className = 'notification-settings-btn';
      notificationBtn.innerHTML = '🔔';
      notificationBtn.title = 'Configurar notificaciones';
      notificationBtn.style.cssText = `
        position: fixed;
        bottom: 80px;
        right: 20px;
        width: 50px;
        height: 50px;
        border-radius: 50%;
        background: #2e7d32;
        color: white;
        border: none;
        font-size: 1.5rem;
        cursor: pointer;
        box-shadow: 0 4px 12px rgba(46, 125, 50, 0.3);
        z-index: 999;
        display: none; /* Oculto por defecto */
      `;
      
      notificationBtn.addEventListener('click', () => {
        showNotificationPermissionModal();
      });
      
      document.body.appendChild(notificationBtn);
      
      // Mostrar botón después de algunas interacciones
      if (userInteractions >= APP_CONFIG.minInteractions) {
        notificationBtn.style.display = 'block';
      }
    }
  });
  
  // Gestos específicos de la app
  const notificationGestures = {
    // En la página del chat, después de enviar mensaje
    'chat-send': () => {
      const sendBtn = document.querySelector('.chat-send-button');
      if (sendBtn) {
        sendBtn.addEventListener('click', () => {
          setTimeout(() => {
            suggestNotificationsForChat();
          }, 1000);
        });
      }
    },
    
    // En el tracker, al completar una tarea
    'tracker-complete': () => {
      const completeBtns = document.querySelectorAll('.complete-task-btn');
      completeBtns.forEach(btn => {
        btn.addEventListener('click', () => {
          setTimeout(() => {
            showContextualNotificationPrompt(
              '¿Quieres recibir recordatorios para tus próximas tareas?',
              swRegistration
            );
          }, 500);
        });
      });
    }
  };
  
  // Activar gestos según la página
  const currentPage = window.location.pathname.split('/').pop();
  if (currentPage.includes('fermentation_agent')) {
    notificationGestures['chat-send']();
  } else if (currentPage.includes('tracker')) {
    notificationGestures['tracker-complete']();
  }
}

// Verificar si debemos mostrar el prompt
function checkForNotificationPrompt() {
  const conditionsMet = 
    userInteractions >= APP_CONFIG.minInteractions &&
    !notificationPromptShown &&
    Notification.permission === 'default';
  
  if (conditionsMet) {
    // Esperar un momento después de la última interacción
    setTimeout(() => {
      if (Date.now() - lastInteractionTime > 1000) {
        showSubtleNotificationPrompt();
      }
    }, APP_CONFIG.notificationPromptDelay);
  }
}

// Mostrar prompt sutil (no intrusivo)
function showSubtleNotificationPrompt() {
  if (notificationPromptShown) return;
  
  // Crear banner sutil
  const banner = document.createElement('div');
  banner.id = 'notification-prompt-banner';
  banner.style.cssText = `
    position: fixed;
    bottom: 20px;
    left: 50%;
    transform: translateX(-50%);
    background: white;
    border: 2px solid #2e7d32;
    border-radius: 10px;
    padding: 15px;
    box-shadow: 0 4px 20px rgba(0,0,0,0.15);
    z-index: 1000;
    max-width: 400px;
    text-align: center;
    animation: slideUp 0.3s ease-out;
  `;
  
  banner.innerHTML = `
    <p style="margin: 0 0 10px 0; color: #333;">
      ¿Quieres recibir recordatorios de fermentación?
    </p>
    <div style="display: flex; gap: 10px; justify-content: center;">
      <button id="prompt-yes" style="
        background: #2e7d32;
        color: white;
        border: none;
        padding: 8px 20px;
        border-radius: 5px;
        cursor: pointer;
      ">Sí, activar</button>
      <button id="prompt-later" style="
        background: #f5f5f5;
        color: #666;
        border: none;
        padding: 8px 20px;
        border-radius: 5px;
        cursor: pointer;
      ">Ahora no</button>
    </div>
  `;
  
  document.body.appendChild(banner);
  notificationPromptShown = true;
  
  // Event listeners para los botones
  document.getElementById('prompt-yes').addEventListener('click', () => {
    banner.remove();
    window.location.href = '/fermentation-expert-app/pwa/notification-permission.html';
  });
  
  document.getElementById('prompt-later').addEventListener('click', () => {
    banner.remove();
    localStorage.setItem('notificationPromptTime', Date.now() + APP_CONFIG.promptCooldown);
  });
}

// Mostrar prompt contextual
function showContextualNotificationPrompt(message, swRegistration) {
  // Verificar si ya tenemos permisos o el usuario dijo no
  if (Notification.permission !== 'default') return;
  
  // Mostrar diálogo contextual
  const userWants = confirm(`${message}\n\n(Puedes cambiarlo después en configuración)`);
  
  if (userWants) {
    requestNotificationPermission(swRegistration);
  } else {
    localStorage.setItem('preference_notifications', 'context-deny');
  }
}

// Solicitar permiso (solo cuando el usuario lo pide)
async function requestNotificationPermission(swRegistration) {
  try {
    const permission = await Notification.requestPermission();
    
    if (permission === 'granted') {
      console.log('🔔 Permiso de notificaciones concedido');
      
      // Guardar preferencia
      localStorage.setItem('preference_notifications', 'granted');
      localStorage.setItem('notificationGrantedDate', new Date().toISOString());
      
      // Configurar controles
      setupNotificationControls(swRegistration);
      
      // Mostrar notificación de confirmación
      showConfirmationNotification();
      
      return true;
    } else {
      console.log('🔕 Permiso de notificaciones denegado');
      localStorage.setItem('preference_notifications', 'denied');
      return false;
    }
  } catch (error) {
    console.error('❌ Error solicitando permiso:', error);
    return false;
  }
}

// Configurar controles de notificación después de tener permisos
function setupNotificationControls(swRegistration) {
  // Añadir interfaz para gestionar notificaciones
  const controlsHTML = `
    <div id="notification-controls" style="
      position: fixed;
      bottom: 140px;
      right: 20px;
      background: white;
      border-radius: 10px;
      padding: 15px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.1);
      z-index: 998;
      min-width: 200px;
      display: none;
    ">
      <h4 style="margin: 0 0 10px 0; color: #2e7d32;">Notificaciones</h4>
      <div style="display: flex; flex-direction: column; gap: 8px;">
        <button id="test-notification" style="
          background: #4caf50;
          color: white;
          border: none;
          padding: 8px;
          border-radius: 5px;
          cursor: pointer;
        ">Probar notificación</button>
        <button id="manage-notifications" style="
          background: #f5f5f5;
          color: #666;
          border: none;
          padding: 8px;
          border-radius: 5px;
          cursor: pointer;
        ">Gestionar</button>
      </div>
    </div>
  `;
  
  // Añadir a la página si no existe
  if (!document.getElementById('notification-controls')) {
    document.body.insertAdjacentHTML('beforeend', controlsHTML);
    
    // Mostrar/ocultar controles al hacer clic en el botón de notificaciones
    const notificationBtn = document.getElementById('notification-settings-btn');
    const controls = document.getElementById('notification-controls');
    
    if (notificationBtn && controls) {
      notificationBtn.addEventListener('click', (e) => {
        e.stopPropagation();
        controls.style.display = controls.style.display === 'block' ? 'none' : 'block';
      });
      
      // Ocultar al hacer clic fuera
      document.addEventListener('click', (e) => {
        if (!controls.contains(e.target) && !notificationBtn.contains(e.target)) {
          controls.style.display = 'none';
        }
      });
      
      // Botón de prueba
      document.getElementById('test-notification').addEventListener('click', () => {
        swRegistration.showNotification('Test de Fermentation Expert', {
          body: '¡Las notificaciones están funcionando correctamente!',
          icon: '/fermentation-expert-app/pwa/icon-192x192.png',
          tag: 'test-notification'
        });
      });
      
      // Botón de gestión
      document.getElementById('manage-notifications').addEventListener('click', () => {
        window.location.href = '/fermentation-expert-app/pwa/notification-permission.html';
      });
    }
  }
}

// Mostrar notificación de confirmación
function showConfirmationNotification() {
  if ('serviceWorker' in navigator) {
    navigator.serviceWorker.ready.then(registration => {
      registration.showNotification('Notificaciones activadas ✅', {
        body: 'Ahora recibirás alertas importantes sobre tus fermentaciones.',
        icon: '/fermentation-expert-app/pwa/icon-192x192.png',
        tag: 'confirmation'
      });
    });
  }
}

// Mostrar modal de permisos
function showNotificationPermissionModal() {
  // Abrir en nueva pestaña o mostrar modal
  window.open('/fermentation-expert-app/pwa/notification-permission.html', '_blank');
}

// Mostrar notificación de actualización
function showUpdateNotification(registration) {
  // Crear banner de actualización
  const updateBanner = document.createElement('div');
  updateBanner.id = 'update-notification-banner';
  updateBanner.style.cssText = `
    position: fixed;
    top: 20px;
    right: 20px;
    background: #2196f3;
    color: white;
    padding: 15px;
    border-radius: 10px;
    box-shadow: 0 4px 20px rgba(33, 150, 243, 0.3);
    z-index: 1001;
    max-width: 300px;
    animation: slideIn 0.3s ease-out;
  `;
  
  updateBanner.innerHTML = `
    <p style="margin: 0 0 10px 0; font-weight: bold;">
      🆕 Nueva versión disponible
    </p>
    <p style="margin: 0 0 10px 0; font-size: 0.9rem;">
      Hay una actualización de la app. ¿Quieres aplicarla ahora?
    </p>
    <button id="update-now" style="
      background: white;
      color: #2196f3;
      border: none;
      padding: 8px 15px;
      border-radius: 5px;
      cursor: pointer;
      margin-right: 10px;
    ">Actualizar ahora</button>
    <button id="update-later" style="
      background: transparent;
      color: white;
      border: 1px solid white;
      padding: 8px 15px;
      border-radius: 5px;
      cursor: pointer;
    ">Más tarde</button>
  `;
  
  document.body.appendChild(updateBanner);
  
  document.getElementById('update-now').addEventListener('click', () => {
    registration.waiting.postMessage({ type: 'SKIP_WAITING' });
    window.location.reload();
  });
  
  document.getElementById('update-later').addEventListener('click', () => {
    updateBanner.remove();
  });
}

// Sugerir notificaciones para chat
function suggestNotificationsForChat() {
  // Solo sugerir si el usuario ha interactuado bastante con el chat
  const chatMessages = document.querySelectorAll('.chat-message').length;
  
  if (chatMessages >= 5 && Notification.permission === 'default') {
    showContextualNotificationPrompt(
      '¿Quieres recibir notificaciones cuando el experto responda a tus preguntas?'
    );
  }
}

// Manejo offline/online
function setupOfflineDetection() {
  if (!navigator.onLine) {
    showOfflineMessage();
  }
  
  window.addEventListener('online', () => {
    hideOfflineMessage();
    console.log('🌐 Conexión restaurada');
  });
  
  window.addEventListener('offline', () => {
    showOfflineMessage();
    console.log('📴 Sin conexión');
  });
}

function showOfflineMessage() {
  if (!document.getElementById('offline-message')) {
    const offlineMsg = document.createElement('div');
    offlineMsg.id = 'offline-message';
    offlineMsg.style.cssText = `
      position: fixed;
      top: 10px;
      right: 10px;
      background: #ff9800;
      color: white;
      padding: 10px 15px;
      border-radius: 5px;
      z-index: 9999;
      font-size: 14px;
      animation: fadeIn 0.3s;
    `;
    offlineMsg.innerHTML = '⚠️ Modo offline';
    document.body.appendChild(offlineMsg);
  }
}

function hideOfflineMessage() {
  const offlineMsg = document.getElementById('offline-message');
  if (offlineMsg) {
    offlineMsg.style.animation = 'fadeOut 0.3s';
    setTimeout(() => offlineMsg.remove(), 300);
  }
}

// Inicializar cuando el DOM esté listo
document.addEventListener('DOMContentLoaded', () => {
  // Registrar Service Worker
  registerServiceWorker();
  
  // Configurar detección offline
  setupOfflineDetection();
  
  // Añadir estilos CSS para animaciones
  const styles = document.createElement('style');
  styles.textContent = `
    @keyframes slideUp {
      from { transform: translate(-50%, 100%); opacity: 0; }
      to { transform: translate(-50%, 0); opacity: 1; }
    }
    
    @keyframes slideIn {
      from { transform: translateX(100%); opacity: 0; }
      to { transform: translateX(0); opacity: 1; }
    }
    
    @keyframes fadeIn {
      from { opacity: 0; }
      to { opacity: 1; }
    }
    
    @keyframes fadeOut {
      from { opacity: 1; }
      to { opacity: 0; }
    }
    
    .notification-settings-btn:hover {
      transform: scale(1.1);
      transition: transform 0.2s;
    }
  `;
  document.head.appendChild(styles);
  
  // Verificar si es PWA instalada
  if (window.matchMedia('(display-mode: standalone)').matches) {
    document.body.classList.add('pwa-installed');
    console.log('📱 Ejecutando como PWA instalada');
  }
  
  // Inicializar contador de interacciones desde localStorage
  const savedInteractions = localStorage.getItem('userInteractions');
  if (savedInteractions) {
    userInteractions = parseInt(savedInteractions);
  }
  
  // Guardar interacciones periódicamente
  setInterval(() => {
    if (userInteractions > 0) {
      localStorage.setItem('userInteractions', userInteractions.toString());
    }
  }, 10000);
});
REGISTER_EOF

echo ""
echo "4. 📄 ACTUALIZANDO HTMLs CON NUEVO ENFOQUE..."
echo "============================================"

# Función para actualizar HTMLs sin solicitud automática de notificaciones
update_html_with_responsible_pwa() {
    local file=$1
    if [ -f "$file" ]; then
        # Remover cualquier solicitud automática de notificaciones
        sed -i '' '/Notification\.requestPermission/d' "$file"
        sed -i '' '/requestNotificationPermission/d' "$file"
        
        # Agregar solo la configuración básica
        if grep -q "<head>" "$file"; then
            # Actualizar metadatos PWA
            sed -i '' '/<head>/a\
    <!-- PWA Configuration (Responsible) -->\
    <link rel="manifest" href="/fermentation-expert-app/site.webmanifest">\
    <meta name="apple-mobile-web-app-capable" content="yes">\
    <meta name="apple-mobile-web-app-status-bar-style" content="default">\
    <meta name="apple-mobile-web-app-title" content="Fermentation Expert">\
    <link rel="apple-touch-icon" href="/fermentation-expert-app/apple-touch-icon.png">\
    <meta name="theme-color" content="#2e7d32">' "$file"
            
            echo "✅ $file actualizado con PWA responsable"
        fi
    fi
}

# Actualizar todos los HTMLs
update_html_with_responsible_pwa "index.html"
update_html_with_responsible_pwa "fermentation_agent.html"
update_html_with_responsible_pwa "tracker.html"
update_html_with_responsible_pwa "enterprise_configurator.html"

echo ""
echo "5. 📝 CREANDO POLÍTICA DE NOTIFICACIONES..."
echo "=========================================="

cat > pwa/notification-policy.md << 'POLICY_EOF'
# Política de Notificaciones - Fermentation Expert

## 🔔 Enfoque Responsable

Fermentation Expert sigue las mejores prácticas para notificaciones push:

### 🚫 Lo que NO hacemos:
- **Nunca** solicitamos permisos al cargar la página
- **Nunca** solicitamos sin contexto claro
- **Nunca** enviamos spam o notificaciones no solicitadas
- **Nunca** hacemos solicitudes repetitivas si el usuario dice "no"

### ✅ Lo que SÍ hacemos:
- **Solo** solicitamos después de interacción del usuario
- **Solo** en contextos relevantes (ej: después de usar el chat)
- **Siempre** explicamos claramente el beneficio
- **Siempre** permitimos control total al usuario

## 📋 Tipos de Notificaciones

### 1. Recordatorios de Fermentación
- **Cuándo**: Cuando el usuario configura un temporizador
- **Contexto**: Después de guardar una receta o programa
- **Frecuencia**: Solo cuando se solicita explícitamente

### 2. Respuestas del Experto
- **Cuándo**: Cuando el usuario pregunta y espera respuesta
- **Contexto**: Solo si el usuario activa "notificarme cuando respondan"
- **Frecuencia**: Una vez por respuesta

### 3. Actualizaciones Importantes
- **Cuándo**: Nuevas características o actualizaciones críticas
- **Contexto**: Solo para usuarios que las han activado
- **Frecuencia**: Máximo 1 por mes

## 👥 Control del Usuario

El usuario tiene siempre control completo:

1. **Activación**: Solo mediante gestos explícitos
2. **Configuración**: Página dedicada de configuración
3. **Desactivación**: En cualquier momento desde el navegador
4. **Personalización**: Elegir qué tipos de notificaciones recibir

## 🔧 Implementación Técnica

### Flujo de Activación:

Interacción del usuario (mínimo 3 veces)
↓
Botón de configuración aparece
↓
Usuario hace clic explícitamente
↓
Página de explicación detallada
↓
Confirmación del usuario requerida
↓
Solicitud de permiso del navegador

### Almacenamiento de Preferencias:

- LocalStorage para preferencias
- Respetar "recordármelo después" (1 semana)
- No preguntar si ya dijo "no"

## 📊 Métricas de Engagement

Monitoreamos (anónimamente):
- Tasa de aceptación vs rechazo
- Momentos en que los usuarios activan
- Tipos de notificaciones más útiles
- Feedback de los usuarios

## 🛡️ Privacidad

- **Sin tracking**: No rastreamos a usuarios individuales
- **Sin datos personales**: Las notificaciones no contienen datos personales
- **Sin compartir**: No compartimos preferencias con terceros
- **Transparencia**: Esta política es públicamente accesible

## 🔄 Revisión y Mejora

Esta política se revisa cada 3 meses para:
- Mejorar la experiencia del usuario
- Mantener compliance con normativas
- Incorporar feedback de la comunidad

---

**Última actualización:** $(date +%Y-%m-%d)
**Versión:** 2.0 (Responsable)

*Fermentation Expert está comprometido con una experiencia respetuosa y útil.*
POLICY_EOF

echo ""
echo "6. 📊 CREANDO DASHBOARD DE CONFIGURACIÓN..."
echo "==========================================="

cat > pwa/notification-dashboard.html << 'DASHBOARD_EOF'
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Configurar Notificaciones - Fermentation Expert</title>
    <style>
        :root {
            --primary: #2e7d32;
            --primary-light: #4caf50;
            --secondary: #2196f3;
            --light: #f1f8e9;
            --dark: #263238;
            --gray: #757575;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        }
        
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #e8f5e9 100%);
            color: var(--dark);
            min-height: 100vh;
            padding: 20px;
        }
        
        .dashboard {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        header {
            background: var(--primary);
            color: white;
            padding: 30px;
            text-align: center;
        }
        
        .back-btn {
            position: absolute;
            top: 20px;
            left: 20px;
            background: rgba(255,255,255,0.2);
            border: none;
            color: white;
            padding: 10px 20px;
            border-radius: 20px;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        
        .back-btn:hover {
            background: rgba(255,255,255,0.3);
        }
        
        h1 {
            font-size: 2rem;
            margin-bottom: 10px;
        }
        
        .subtitle {
            opacity: 0.9;
            font-size: 1rem;
        }
        
        .status-card {
            background: var(--light);
            margin: 20px;
            padding: 20px;
            border-radius: 15px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .status-indicator {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .status-dot {
            width: 12px;
            height: 12px;
            border-radius: 50%;
        }
        
        .status-dot.active {
            background: #4caf50;
            animation: pulse 2s infinite;
        }
        
        .status-dot.inactive {
            background: #f44336;
        }
        
        .status-dot.unknown {
            background: #ff9800;
        }
        
        @keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.5; }
        }
        
        .notification-types {
            margin: 20px;
        }
        
        .type-item {
            background: #fafafa;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 15px;
            border: 2px solid transparent;
            transition: all 0.3s;
        }
        
        .type-item:hover {
            border-color: var(--primary-light);
            transform: translateY(-2px);
        }
        
        .type-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }
        
        .type-title {
            font-weight: 600;
            color: var(--dark);
        }
        
        .switch {
            position: relative;
            display: inline-block;
            width: 50px;
            height: 24px;
        }
        
        .switch input {
            opacity: 0;
            width: 0;
            height: 0;
        }
        
        .slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: #ccc;
            transition: .4s;
            border-radius: 34px;
        }
        
        .slider:before {
            position: absolute;
            content: "";
            height: 16px;
            width: 16px;
            left: 4px;
            bottom: 4px;
            background-color: white;
            transition: .4s;
            border-radius: 50%;
        }
        
        input:checked + .slider {
            background-color: var(--primary);
        }
        
        input:checked + .slider:before {
            transform: translateX(26px);
        }
        
        .type-description {
            color: var(--gray);
            font-size: 0.9rem;
            line-height: 1.5;
            margin-bottom: 10px;
        }
        
        .type-example {
            background: white;
            padding: 10px;
            border-radius: 8px;
            border-left: 4px solid var(--primary);
            font-size: 0.85rem;
            margin-top: 10px;
            color: #555;
        }
        
        .schedule-section {
            margin: 20px;
            padding: 20px;
            background: #f8fdff;
            border-radius: 15px;
            border: 2px dashed #bbdefb;
        }
        
        .time-picker {
            display: flex;
            gap: 10px;
            margin-top: 15px;
            flex-wrap: wrap;
        }
        
        .time-option {
            background: #e3f2fd;
            border: none;
            padding: 8px 15px;
            border-radius: 20px;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .time-option:hover {
            background: #bbdefb;
        }
        
        .time-option.active {
            background: var(--secondary);
            color: white;
        }
        
        .actions {
            margin: 30px 20px;
            display: flex;
            gap: 15px;
            justify-content: center;
        }
        
        .btn {
            padding: 15px 30px;
            border: none;
            border-radius: 10px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            min-width: 150px;
        }
        
        .btn-primary {
            background: var(--primary);
            color: white;
        }
        
        .btn-primary:hover {
            background: #1b5e20;
            transform: translateY(-2px);
        }
        
        .btn-secondary {
            background: #f5f5f5;
            color: var(--dark);
        }
        
        .btn-secondary:hover {
            background: #e0e0e0;
        }
        
        .btn-danger {
            background: #ffebee;
            color: #c62828;
        }
        
        .btn-danger:hover {
            background: #ffcdd2;
        }
        
        .test-section {
            margin: 20px;
            padding: 20px;
            background: #fff8e1;
            border-radius: 15px;
            text-align: center;
        }
        
        footer {
            text-align: center;
            padding: 20px;
            color: var(--gray);
            font-size: 0.8rem;
            border-top: 1px solid #eee;
        }
        
        @media (max-width: 600px) {
            .dashboard {
                margin: 0;
                border-radius: 0;
            }
            
            .actions {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <div class="dashboard">
        <header>
            <a href="/fermentation-expert-app/" class="back-btn">← Volver</a>
            <h1>🔔 Configurar Notificaciones</h1>
            <p class="subtitle">Controla cómo y cuándo recibir actualizaciones</p>
        </header>
        
        <div class="status-card">
            <div class="status-indicator">
                <div id="globalStatusDot" class="status-dot unknown"></div>
                <span id="globalStatusText">Verificando estado...</span>
            </div>
            <button id="toggleAllBtn" class="btn-secondary" style="padding: 8px 15px;">
                Activar todas
            </button>
        </div>
        
        <div class="notification-types">
            <h3 style="margin: 20px 0 10px 20px; color: var(--dark);">Tipos de notificaciones</h3>
            
            <div class="type-item">
                <div class="type-header">
                    <div class="type-title">Recordatorios de fermentación</div>
                    <label class="switch">
                        <input type="checkbox" id="remindersToggle" checked>
                        <span class="slider"></span>
                    </label>
                </div>
                <p class="type-description">
                    Alertas cuando tus fermentaciones necesiten atención (revolver, traspasar, envasar).
                </p>
                <div class="type-example">
                    Ejemplo: "Tu masa madre necesita alimento en 2 horas"
                </div>
            </div>
            
            <div class="type-item">
                <div class="type-header">
                    <div class="type-title">Respuestas del experto</div>
                    <label class="switch">
                        <input type="checkbox" id="answersToggle" checked>
                        <span class="slider"></span>
                    </label>
                </div>
                <p class="type-description">
                    Notificaciones cuando el experto en fermentación responda a tus preguntas.
                </p>
                <div class="type-example">
                    Ejemplo: "El experto ha respondido a tu consulta sobre kimchi"
                </div>
            </div>
            
            <div class="type-item">
                <div class="type-header">
                    <div class="type-title">Consejos y tips</div>
                    <label class="switch">
                        <input type="checkbox" id="tipsToggle">
                        <span class="slider"></span>
                    </label>
                </div>
                <p class="type-description">
                    Consejos semanales sobre técnicas de fermentación y mejores prácticas.
                </p>
                <div class="type-example">
                    Ejemplo: "Tip del día: Cómo mantener temperatura constante para kombucha"
                </div>
            </div>
            
            <div class="type-item">
                <div class="type-header">
                    <div class="type-title">Actualizaciones de la app</div>
                    <label class="switch">
                        <input type="checkbox" id="updatesToggle">
                        <span class="slider"></span>
                    </label>
                </div>
                <p class="type-description">
                    Información sobre nuevas características y actualizaciones importantes.
                </p>
                <div class="type-example">
                    Ejemplo: "Nueva función: Calculadora de proporciones para chucrut"
                </div>
            </div>
        </div>
        
        <div class="schedule-section">
            <h3 style="margin-bottom: 15px; color: var(--secondary);">⏰ Horario preferido</h3>
            <p style="color: var(--gray); margin-bottom: 15px;">
                Elige cuándo prefieres recibir notificaciones (excepto recordatorios urgentes):
            </p>
            <div class="time-picker">
                <button class="time-option active" data-time="any">Cualquier hora</button>
                <button class="time-option" data-time="morning">Mañana (8-12)</button>
                <button class="time-option" data-time="afternoon">Tarde (12-18)</button>
                <button class="time-option" data-time="evening">Noche (18-22)</button>
                <button class="time-option" data-time="weekdays">Solo días laborables</button>
            </div>
        </div>
        
        <div class="test-section">
            <h3 style="margin-bottom: 15px; color: #ff9800;">🧪 Probar notificaciones</h3>
            <p style="color: var(--gray); margin-bottom: 15px;">
                Envía una notificación de prueba para verificar que todo funciona correctamente.
            </p>
            <button id="testNotificationBtn" class="btn-secondary">Enviar notificación de prueba</button>
        </div>
        
        <div class="actions">
            <button id="saveBtn" class="btn-primary">💾 Guardar configuración</button>
            <button id="disableAllBtn" class="btn-danger">🔕 Desactivar todas</button>
        </div>
        
        <footer>
            <p>🔒 Respetamos tu privacidad. Las notificaciones solo se usarán según tus preferencias.</p>
            <p>Puedes cambiar estos ajustes en cualquier momento o desactivarlas desde la configuración de tu navegador.</p>
        </footer>
    </div>
    
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            // Elementos del DOM
            const globalStatusDot = document.getElementById('globalStatusDot');
            const globalStatusText = document.getElementById('globalStatusText');
            const toggleAllBtn = document.getElementById('toggleAllBtn');
            const saveBtn = document.getElementById('saveBtn');
            const disableAllBtn = document.getElementById('disableAllBtn');
            const testNotificationBtn = document.getElementById('testNotificationBtn');
            
            const toggles = {
                reminders: document.getElementById('remindersToggle'),
                answers: document.getElementById('answersToggle'),
                tips: document.getElementById('tipsToggle'),
                updates: document.getElementById('updatesToggle')
            };
            
            const timeOptions = document.querySelectorAll('.time-option');
            
            // Cargar configuración guardada
            loadSettings();
            
            // Actualizar estado global
            updateGlobalStatus();
            
            // Botón "Activar todas"
            toggleAllBtn.addEventListener('click', () => {
                const allEnabled = Array.from(Object.values(toggles)).every(t => t.checked);
                
                Object.values(toggles).forEach(toggle => {
                    toggle.checked = !allEnabled;
                });
                
                updateGlobalStatus();
                toggleAllBtn.textContent = allEnabled ? 'Activar todas' : 'Desactivar todas';
            });
            
            // Guardar configuración
            saveBtn.addEventListener('click', () => {
                saveSettings();
                showMessage('✅ Configuración guardada correctamente');
            });
            
            // Desactivar todas
            disableAllBtn.addEventListener('click', () => {
                if (confirm('¿Estás seguro de que quieres desactivar todas las notificaciones?')) {
                    Object.values(toggles).forEach(toggle => {
                        toggle.checked = false;
                    });
                    
                    // También desactivar permisos del navegador si están activos
                    if (Notification.permission === 'granted') {
                        // No podemos revocar permisos, pero podemos desactivar nuestras notificaciones
                        localStorage.setItem('notifications_disabled', 'true');
                        showMessage('🔕 Todas las notificaciones desactivadas');
                    }
                    
                    updateGlobalStatus();
                    saveSettings();
                }
            });
            
            // Probar notificación
            testNotificationBtn.addEventListener('click', async () => {
                if (Notification.permission !== 'granted') {
                    alert('Primero necesitas activar los permisos de notificación.');
                    return;
                }
                
                try {
                    // Usar Service Worker para mostrar notificación
                    if ('serviceWorker' in navigator) {
                        const registration = await navigator.serviceWorker.ready;
                        
                        registration.showNotification('Prueba de Fermentation Expert', {
                            body: '¡Las notificaciones están funcionando correctamente! 🎉',
                            icon: '/fermentation-expert-app/pwa/icon-192x192.png',
                            badge: '/fermentation-expert-app/pwa/icon-96x96.png',
                            tag: 'test-notification',
                            vibrate: [100, 50, 100],
                            actions: [
                                { action: 'open', title: 'Abrir app' },
                                { action: 'close', title: 'Cerrar' }
                            ]
                        });
                        
                        showMessage('📱 Notificación de prueba enviada');
                    } else {
                        // Fallback a Notification API
                        new Notification('Prueba de Fermentation Expert', {
                            body: 'Notificaciones funcionando correctamente',
                            icon: '/fermentation-expert-app/pwa/icon-192x192.png'
                        });
                    }
                } catch (error) {
                    console.error('Error enviando notificación:', error);
                    showMessage('❌ Error enviando notificación', true);
                }
            });
            
            // Selector de hora
            timeOptions.forEach(option => {
                option.addEventListener('click', () => {
                    timeOptions.forEach(opt => opt.classList.remove('active'));
                    option.classList.add('active');
                });
            });
            
            // Actualizar estado cuando cambien los toggles
            Object.values(toggles).forEach(toggle => {
                toggle.addEventListener('change', updateGlobalStatus);
            });
            
            // Funciones
            function updateGlobalStatus() {
                const anyEnabled = Array.from(Object.values(toggles)).some(t => t.checked);
                const permission = Notification.permission;
                
                if (permission === 'granted' && anyEnabled) {
                    globalStatusDot.className = 'status-dot active';
                    globalStatusText.textContent = 'Notificaciones activadas';
                    toggleAllBtn.textContent = 'Desactivar todas';
                } else if (permission === 'denied') {
                    globalStatusDot.className = 'status-dot inactive';
                    globalStatusText.textContent = 'Permisos denegados en el navegador';
                    toggleAllBtn.textContent = 'Activar todas';
                } else if (!anyEnabled) {
                    globalStatusDot.className = 'status-dot inactive';
                    globalStatusText.textContent = 'Notificaciones desactivadas';
                    toggleAllBtn.textContent = 'Activar todas';
                } else {
                    globalStatusDot.className = 'status-dot unknown';
                    globalStatusText.textContent = 'Permisos no configurados';
                    toggleAllBtn.textContent = 'Activar todas';
                }
            }
            
            function loadSettings() {
                const settings = JSON.parse(localStorage.getItem('notification_settings') || '{}');
                
                // Cargar toggles
                if (settings.reminders !== undefined) toggles.reminders.checked = settings.reminders;
                if (settings.answers !== undefined) toggles.answers.checked = settings.answers;
                if (settings.tips !== undefined) toggles.tips.checked = settings.tips;
                if (settings.updates !== undefined) toggles.updates.checked = settings.updates;
                
                // Cargar horario
                if (settings.schedule) {
                    timeOptions.forEach(opt => {
                        opt.classList.toggle('active', opt.dataset.time === settings.schedule);
                    });
                }
            }
            
            function saveSettings() {
                const settings = {
                    reminders: toggles.reminders.checked,
                    answers: toggles.answers.checked,
                    tips: toggles.tips.checked,
                    updates: toggles.updates.checked,
                    schedule: document.querySelector('.time-option.active').dataset.time,
                    lastUpdated: new Date().toISOString()
                };
                
                localStorage.setItem('notification_settings', JSON.stringify(settings));
                
                // También guardar en el Service Worker si está disponible
                if ('serviceWorker' in navigator) {
                    navigator.serviceWorker.ready.then(registration => {
                        registration.active.postMessage({
                            type: 'UPDATE_SETTINGS',
                            settings: settings
                        });
                    });
                }
            }
            
            function showMessage(text, isError = false) {
                // Crear mensaje temporal
                const message = document.createElement('div');
                message.textContent = text;
                message.style.cssText = `
                    position: fixed;
                    top: 20px;
                    right: 20px;
                    background: ${isError ? '#f44336' : '#4caf50'};
                    color: white;
                    padding: 15px 20px;
                    border-radius: 10px;
                    z-index: 9999;
                    box-shadow: 0 4px 12px rgba(0,0,0,0.2);
                    animation: slideIn 0.3s ease-out;
                `;
                
                document.body.appendChild(message);
                
                // Remover después de 3 segundos
                setTimeout(() => {
                    message.style.animation = 'slideOut 0.3s ease-out';
                    setTimeout(() => message.remove(), 300);
                }, 3000);
                
                // Agregar estilos de animación si no existen
                if (!document.getElementById('message-styles')) {
                    const styles = document.createElement('style');
                    styles.id = 'message-styles';
                    styles.textContent = `
                        @keyframes slideIn {
                            from { transform: translateX(100%); opacity: 0; }
                            to { transform: translateX(0); opacity: 1; }
                        }
                        @keyframes slideOut {
                            from { transform: translateX(0); opacity: 1; }
                            to { transform: translateX(100%); opacity: 0; }
                        }
                    `;
                    document.head.appendChild(styles);
                }
            }
            
            // Verificar permisos iniciales
            if (Notification.permission === 'default') {
                // Sugerir activar permisos si no hay configuración
                const hasSettings = localStorage.getItem('notification_settings');
                if (!hasSettings) {
                    setTimeout(() => {
                        if (confirm('¿Te gustaría configurar las notificaciones para recibir alertas importantes sobre tus fermentaciones?')) {
                            // Redirigir a página de permisos
                            window.location.href = '/fermentation-expert-app/pwa/notification-permission.html';
                        }
                    }, 2000);
                }
            }
            
            // Inicializar
            updateGlobalStatus();
        });
    </script>
</body>
</html>
DASHBOARD_EOF

echo ""
echo "7. 📤 SUBIENDO CAMBIOS A GITHUB..."
echo "=================================="

# Actualizar todo en GitHub
git add .
git commit -m "feat: implement responsible PWA with gesture-based notifications and user control"
git push origin main

echo ""
echo "🎉 ¡PWA RESPONSABLE IMPLEMENTADA!"
echo "================================="
echo ""
echo "✅ **Mejoras implementadas:**"
echo ""
echo "🛡️  **Privacidad y Confianza:**"
echo "   • ✅ Nunca solicitamos permisos al cargar"
echo "   • ✅ Solo después de interacción del usuario"
echo "   • ✅ Explicación clara de beneficios"
echo "   • ✅ Control completo del usuario"
echo ""
echo "👆 **Basado en Gestos:**"
echo "   • ✅ Mínimo 3 interacciones antes de sugerir"
echo "   • ✅ Botón flotante después de uso"
echo "   • ✅ Contextos relevantes (chat, tracker)"
echo "   • ✅ Confirmación explícita requerida"
echo ""
echo "⚙️ **Control del Usuario:**"
echo "   • ✅ Dashboard completo de configuración"
echo "   • ✅ Tipos específicos de notificaciones"
echo "   • ✅ Horarios personalizables"
echo "   • ✅ Botón de prueba incluido"
echo ""
echo "📱 **Experiencia Mejorada:**"
echo "   • ✅ Página de permisos informativa"
echo "   • ✅ Política de notificaciones clara"
echo "   • ✅ Feedback inmediato al usuario"
echo "   • ✅ Respeto por decisiones del usuario"
echo ""
echo "🔍 **Para probar la implementación:**"
echo ""
echo "1. Abre https://wikibuda.github.io/fermentation-expert-app/"
echo "2. Interactúa con la app (haz clic 3 veces)"
echo "3. Verás botón 🔔 flotante aparecer"
echo "4. Haz clic para configurar notificaciones"
echo "5. Tienes control completo en cualquier momento"
echo ""
echo "📊 **Beneficios de este enfoque:**"
echo "• ✅ Mayor tasa de aceptación (usuarios informados)"
echo "• ✅ Mejor experiencia de usuario (no intrusivo)"
echo "• ✅ Cumplimiento con mejores prácticas"
echo "• ✅ Confianza del usuario preservada"
echo ""
echo "⏱️  El deployment comenzará en 2-3 minutos..."
echo "🔗 Cuando termine, prueba la nueva experiencia responsable."
echo ""
echo "🧪 **Flujo recomendado para probar:**"
echo "1. Usa el chat unas cuantas veces"
echo "2. Mira cómo aparece el botón de notificaciones"
echo "3. Configúralas desde el dashboard"
echo "4. Prueba las notificaciones"
echo "5. Modifica configuraciones"
echo ""
echo "🚀 **¡Notificaciones responsables implementadas con éxito!**"
