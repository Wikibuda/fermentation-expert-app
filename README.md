# 🧫 Fermentation Expert App

![Version](https://img.shields.io/badge/version-1.0.0-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Python](https://img.shields.io/badge/python-3.8+-blue)
![Status](https://img.shields.io/badge/status-active-success)

Aplicación web especializada en procesos de fermentación con inteligencia artificial.

## 🚀 Características Principales

- **🤖 Chat con Experto en Fermentación**: Interacción con IA especializada en microbiología aplicada
- **📊 Tracker de Desarrollo**: Seguimiento completo del proyecto con roadmap interactivo
- **🎨 Diseño Responsive**: Interfaz moderna y adaptable a todos los dispositivos
- **🔒 Enterprise Ready**: Configuración profesional para desarrollo empresarial

## 📁 Estructura del Proyecto
fermentation-expert-app/
├── README.md # Este archivo
├── .gitignore # Archivos ignorados por Git
├── requirements.txt # Dependencias de Python
├── LICENSE # Licencia del proyecto
├── fermentation_agent.html # Aplicación principal
├── tracker.html # Tracker de desarrollo
├── .github/workflows/ # CI/CD pipelines
├── docs/ # Documentación
├── tests/ # Tests unitarios
├── src/ # Código fuente
└── scripts/ # Scripts de utilidad

text

## 🛠️ Instalación y Configuración

### Prerrequisitos
- Python 3.8+
- Git
- Navegador web moderno
- API Key de DeepSeek

### Configuración Local
```bash
# Clonar repositorio
git clone https://github.com/tu-usuario/fermentation-expert-app.git
cd fermentation-expert-app

# Crear entorno virtual
python3 -m venv venv

# Activar entorno virtual
# Linux/Mac:
source venv/bin/activate
# Windows:
venv\Scripts\activate

# Instalar dependencias
pip install -r requirements.txt
Configuración API Key
Obtén una API Key de DeepSeek

Configura la variable de entorno:

bash
export DEEPSEEK_API_KEY="tu_api_key_aquí"
O crea un archivo .env:

bash
DEEPSEEK_API_KEY=tu_api_key_aquí
🚀 Uso
Aplicación Principal
bash
# Abre la aplicación en tu navegador
open fermentation_agent.html
Tracker de Desarrollo
bash
# Abre el tracker para seguimiento del proyecto
open tracker.html
Script de Configuración
bash
# Configuración enterprise
chmod +x setup_enterprise_repo.sh
./setup_enterprise_repo.sh
📊 Roadmap
v1.1.0 - Diseño Avanzado
Sistema de temas personalizables

Modo oscuro/claro

Mejoras de accesibilidad

v1.2.0 - Fermentación Profesional
Calculadora de ratios

Solucionador de problemas

Guías visuales

v1.3.0 - Productividad Total
Multiidioma

Sistema de favoritos

Exportación a PDF

🧪 Testing
bash
# Ejecutar tests básicos
python -m pytest tests/

# Verificar cobertura
coverage run -m pytest
coverage report
🤝 Contribución
Fork el proyecto

Crea una rama (git checkout -b feature/AmazingFeature)

Commit tus cambios (git commit -m 'Add some AmazingFeature')

Push a la rama (git push origin feature/AmazingFeature)

Abre un Pull Request

📝 Licencia
Distribuido bajo licencia MIT. Ver LICENSE para más información.

👥 Autores
Gus Luna - Desarrollo inicial - @gusluna

🙏 Agradecimientos
DeepSeek por la API de IA

Comunidad de fermentación por el conocimiento compartido

📞 Contacto
Proyecto: https://github.com/gusluna/fermentation-expert-app

text

echo -e "${GREEN}✅ README.md creado${NC}"

# 3. LICENSE MIT
cat > LICENSE << 'EOF'
MIT License

Copyright (c) 2024 Fermentation Expert App

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
# Test CI/CD
