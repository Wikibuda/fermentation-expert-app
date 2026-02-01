.PHONY: help install test lint format clean setup deploy

help:
	@echo "Fermentation Expert App - Comandos de Desarrollo"
	@echo ""
	@echo "Available commands:"
	@echo "  make setup     Configurar proyecto (primer uso)"
	@echo "  make install   Instalar dependencias"
	@echo "  make test      Ejecutar tests"
	@echo "  make lint      Verificar calidad de código"
	@echo "  make format    Formatear código"
	@echo "  make clean     Limpiar archivos temporales"
	@echo "  make deploy    Desplegar a producción"
	@echo "  make help      Mostrar esta ayuda"

setup:
	@echo "🔧 Configurando proyecto..."
	python3 -m venv venv
	@echo "✅ Entorno virtual creado"
	@echo ""
	@echo "📋 Para activar el entorno virtual:"
	@echo "  source venv/bin/activate  # Linux/Mac"
	@echo "  venv\Scripts\activate     # Windows"
	@echo ""
	@echo "📦 Luego ejecuta: make install"

install:
	@echo "📦 Instalando dependencias..."
	pip install --upgrade pip
	pip install -r requirements.txt
	pip install pre-commit
	pre-commit install
	@echo "✅ Dependencias instaladas"

test:
	@echo "🧪 Ejecutando tests..."
	python -m pytest tests/ -v --tb=short
	@echo "✅ Tests completados"

lint:
	@echo "🔍 Verificando calidad de código..."
	flake8 .
	black --check .
	mypy .
	@echo "✅ Verificación completada"

format:
	@echo "🎨 Formateando código..."
	black .
	isort .
	@echo "✅ Código formateado"

clean:
	@echo "🧹 Limpiando archivos temporales..."
	find . -type f -name "*.pyc" -delete
	find . -type d -name "__pycache__" -delete
	find . -type f -name ".DS_Store" -delete
	rm -rf build/ dist/ *.egg-info .coverage htmlcov/ .pytest_cache/
	@echo "✅ Limpieza completada"

deploy:
	@echo "🚀 Desplegando a producción..."
	@echo "Este comando desplegaría la aplicación"
	@echo "Configura el despliegue en docs/deployment.md"
	@echo "✅ Comando de despliegue configurado"

venv-check:
	@if [ -z "$$VIRTUAL_ENV" ]; then \
		echo "⚠️  No estás en un entorno virtual"; \
		echo "Ejecuta: source venv/bin/activate"; \
		exit 1; \
	else \
		echo "✅ Entorno virtual activo: $$VIRTUAL_ENV"; \
	fi
