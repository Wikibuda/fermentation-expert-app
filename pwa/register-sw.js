// Registrar Service Worker
if ('serviceWorker' in navigator) {
  window.addEventListener('load', function() {
    const swPath = '/fermentation-expert-app/pwa/service-worker.js';
    
    navigator.serviceWorker.register(swPath)
      .then(registration => {
        console.log('🧫 Service Worker registrado exitosamente:', registration.scope);
        
        // Verificar actualizaciones
        registration.addEventListener('updatefound', () => {
          const newWorker = registration.installing;
          console.log('🧫 Nueva versión del Service Worker encontrada');
          
          newWorker.addEventListener('statechange', () => {
            if (newWorker.state === 'installed' && navigator.serviceWorker.controller) {
              // Nueva versión disponible
              if (confirm('¡Nueva versión disponible! ¿Actualizar ahora?')) {
                newWorker.postMessage({ type: 'SKIP_WAITING' });
                window.location.reload();
              }
            }
          });
        });
      })
      .catch(error => {
        console.error('🧫 Error registrando Service Worker:', error);
      });
    
    // Verificar conexión
    navigator.serviceWorker.ready.then(registration => {
      console.log('🧫 Service Worker listo');
      
      // Verificar si estamos online/offline
      if (!navigator.onLine) {
        console.log('🧫 App funcionando en modo offline');
        showOfflineMessage();
      }
      
      window.addEventListener('online', () => {
        console.log('🧫 Conexión restaurada');
        hideOfflineMessage();
      });
      
      window.addEventListener('offline', () => {
        console.log('🧫 Sin conexión');
        showOfflineMessage();
      });
    });
  });
}

// Funciones para modo offline
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
    `;
    offlineMsg.innerHTML = '⚠️ Modo offline - Funcionalidad limitada';
    document.body.appendChild(offlineMsg);
  }
}

function hideOfflineMessage() {
  const offlineMsg = document.getElementById('offline-message');
  if (offlineMsg) {
    offlineMsg.remove();
  }
}

// Solicitar permisos para notificaciones
function requestNotificationPermission() {
  if ('Notification' in window && Notification.permission === 'default') {
    Notification.requestPermission().then(permission => {
      console.log('🧫 Permiso de notificación:', permission);
    });
  }
}

// Inicializar cuando el DOM esté listo
document.addEventListener('DOMContentLoaded', () => {
  requestNotificationPermission();
  
  // Agregar botón de instalación PWA
  if ('beforeinstallprompt' in window) {
    let deferredPrompt;
    
    window.addEventListener('beforeinstallprompt', (e) => {
      e.preventDefault();
      deferredPrompt = e;
      
      // Mostrar botón de instalación
      const installBtn = document.createElement('button');
      installBtn.id = 'install-pwa-btn';
      installBtn.innerHTML = '📱 Instalar App';
      installBtn.style.cssText = `
        position: fixed;
        bottom: 20px;
        right: 20px;
        background: #2e7d32;
        color: white;
        border: none;
        padding: 10px 20px;
        border-radius: 25px;
        cursor: pointer;
        z-index: 1000;
        box-shadow: 0 4px 12px rgba(46, 125, 50, 0.3);
      `;
      
      installBtn.addEventListener('click', () => {
        installBtn.style.display = 'none';
        deferredPrompt.prompt();
        
        deferredPrompt.userChoice.then(choiceResult => {
          console.log('🧫 Elección del usuario:', choiceResult.outcome);
          deferredPrompt = null;
        });
      });
      
      document.body.appendChild(installBtn);
    });
  }
  
  // Detectar si es PWA instalada
  if (window.matchMedia('(display-mode: standalone)').matches) {
    console.log('🧫 Ejecutando como PWA instalada');
    document.body.classList.add('pwa-installed');
  }
});
