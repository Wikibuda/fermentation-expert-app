// Service Worker para Fermentation Expert App
const CACHE_NAME = 'fermentation-expert-v1.0';
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
  'https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css',
  'https://code.jquery.com/jquery-3.6.0.min.js'
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
      .then(() => {
        console.log('🧫 Service Worker: Instalación completada');
        return self.skipWaiting();
      })
  );
});

// Activación del Service Worker
self.addEventListener('activate', event => {
  console.log('🧫 Service Worker: Activando...');
  // Limpiar caches viejos
  event.waitUntil(
    caches.keys().then(cacheNames => {
      return Promise.all(
        cacheNames.map(cache => {
          if (cache !== CACHE_NAME) {
            console.log('🧫 Service Worker: Eliminando cache viejo:', cache);
            return caches.delete(cache);
          }
        })
      );
    }).then(() => {
      console.log('🧫 Service Worker: Ahora controla todos los clients');
      return self.clients.claim();
    })
  );
});

// Interceptar solicitudes
self.addEventListener('fetch', event => {
  // No cachear solicitudes a la API de DeepSeek
  if (event.request.url.includes('api.deepseek.com')) {
    return;
  }
  
  event.respondWith(
    caches.match(event.request)
      .then(response => {
        // Devuelve del cache si existe
        if (response) {
          console.log('🧫 Service Worker: Sirviendo desde cache:', event.request.url);
          return response;
        }
        
        // Si no está en cache, haz la solicitud de red
        return fetch(event.request)
          .then(response => {
            // Verifica si es una respuesta válida
            if(!response || response.status !== 200 || response.type !== 'basic') {
              return response;
            }
            
            // Clona la respuesta para cachear
            const responseToCache = response.clone();
            
            caches.open(CACHE_NAME)
              .then(cache => {
                cache.put(event.request, responseToCache);
              });
            
            return response;
          })
          .catch(error => {
            // Si estamos offline y es una página HTML, muestra offline page
            if (event.request.headers.get('accept').includes('text/html')) {
              return caches.match('/fermentation-expert-app/index.html');
            }
            
            // Para otros recursos, puedes mostrar un fallback
            if (event.request.url.includes('.css')) {
              return new Response(
                'body { background: #2e7d32; color: white; padding: 20px; font-family: Arial; }',
                { headers: { 'Content-Type': 'text/css' } }
              );
            }
            
            console.error('🧫 Service Worker: Error en fetch:', error);
            throw error;
          });
      })
  );
});

// Manejar mensajes desde la app
self.addEventListener('message', event => {
  if (event.data.type === 'SKIP_WAITING') {
    self.skipWaiting();
  }
});

// Sincronización en background (para futuras funcionalidades)
self.addEventListener('sync', event => {
  if (event.tag === 'sync-fermentation-data') {
    console.log('🧫 Service Worker: Sincronizando datos...');
    // Aquí podrías sincronizar datos cuando haya conexión
  }
});

// Push notifications (para futuras funcionalidades)
self.addEventListener('push', event => {
  const options = {
    body: event.data ? event.data.text() : '¡Nueva actualización en Fermentation Expert!',
    icon: '/fermentation-expert-app/pwa/icon-192x192.png',
    badge: '/fermentation-expert-app/pwa/icon-96x96.png',
    vibrate: [200, 100, 200],
    data: {
      url: '/fermentation-expert-app/'
    },
    actions: [
      {
        action: 'open',
        title: 'Abrir app'
      },
      {
        action: 'close',
        title: 'Cerrar'
      }
    ]
  };
  
  event.waitUntil(
    self.registration.showNotification('Fermentation Expert', options)
  );
});

self.addEventListener('notificationclick', event => {
  event.notification.close();
  
  if (event.action === 'open') {
    event.waitUntil(
      clients.openWindow('/fermentation-expert-app/')
    );
  }
});
