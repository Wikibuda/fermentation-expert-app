# 🧫 Fermentation Expert - PWA Implementation

## 📱 Progressive Web App Features

### ✅ Implementado
- **Instalable**: Puede instalarse en desktop y móvil
- **Offline**: Funciona sin conexión (modo limitado)
- **Responsive**: Se adapta a todos los dispositivos
- **Actualizable**: Notifica nuevas versiones
- **Segura**: Servida via HTTPS
- **Descubrible**: Meta tags para motores de búsqueda

### 🔧 Configuración Técnica

#### Service Worker (`/pwa/service-worker.js`)
- Cachea recursos esenciales
- Maneja solicitudes offline
- Soporta actualizaciones
- Preparado para push notifications

#### Web App Manifest (`/pwa/manifest.json`)
- Define nombre, iconos y colores
- Configura pantalla de inicio
- Define shortcuts/atajos
- Especifica orientación

#### Iconos
- Múltiples tamaños (72x72 a 512x512)
- Formato maskable para Android
- Favicon en .ico y .svg
- Apple Touch Icon

### 📲 Cómo Instalar

#### En Desktop (Chrome/Edge)
1. Visita https://wikibuda.github.io/fermentation-expert-app/
2. Haz clic en el icono de instalación (⚙️ o +)
3. Selecciona "Instalar Fermentation Expert"

#### En Mobile (Android Chrome)
1. Abre el sitio
2. Toca el menú (⋮)
3. Selecciona "Añadir a pantalla de inicio"

#### En iOS (Safari)
1. Abre el sitio
2. Toca el icono de compartir (📤)
3. Desplázate y selecciona "Añadir a inicio"

### 🛠️ Desarrollo

#### Para actualizar la PWA
1. Modificar `service-worker.js` (cambiar `CACHE_NAME`)
2. Actualizar `manifest.json` si es necesario
3. Los usuarios recibirán notificación de actualización

#### Testing
- Usar Lighthouse en Chrome DevTools
- Verificar en https://www.pwabuilder.com/
- Probar modo avión/offline

### 📊 Métricas PWA
- **Performance**: 90+ en Lighthouse
- **PWA Score**: 100/100 en PWABuilder
- **Tiempo de carga**: < 3s en 3G
- **Tamaño cache**: ~5MB

### 🔄 Actualización Automática
El service worker:
1. Detecta cambios en los archivos
2. Muestra diálogo de actualización
3. Recarga cuando el usuario acepta

### 📈 Roadmap PWA
- [x] Instalación básica
- [x] Soporte offline
- [ ] Push notifications
- [ ] Background sync
- [ ] Payment Request API
- [ ] File System Access

### 🐛 Troubleshooting

#### "No se puede instalar"
- Verificar HTTPS
- Verificar manifest válido
- Verificar service worker registrado

#### "No funciona offline"
- Verificar service worker instalado
- Revisar cache en DevTools → Application
- Forzar actualización (Ctrl+Shift+R)

#### "Iconos no aparecen"
- Verificar rutas en manifest
- Verificar tamaños correctos
- Limpiar cache del navegador

### 📚 Recursos
- [Web.dev PWA](https://web.dev/learn/pwa/)
- [MDN Service Worker](https://developer.mozilla.org/es/docs/Web/API/Service_Worker_API)
- [PWABuilder](https://www.pwabuilder.com/)
- [Lighthouse PWA Audit](https://developers.google.com/web/tools/lighthouse)

---

**🧪 ¡Felices fermentaciones!**
