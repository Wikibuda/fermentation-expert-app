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
