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
