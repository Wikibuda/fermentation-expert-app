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
