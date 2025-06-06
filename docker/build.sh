#!/bin/bash

# Script para construir la imagen Docker del pipeline CAZy

set -e

# Variables
IMAGE_NAME="cazypipeline"
IMAGE_TAG="1.0.0"
FULL_IMAGE_NAME="${IMAGE_NAME}:${IMAGE_TAG}"

echo "🐳 Construyendo imagen Docker: ${FULL_IMAGE_NAME}"

# Construir la imagen
docker build -t ${FULL_IMAGE_NAME} -f docker/Dockerfile docker/

echo "✅ Imagen construida exitosamente: ${FULL_IMAGE_NAME}"

# Verificar la imagen
echo "🔍 Verificando la imagen..."
docker run --rm ${FULL_IMAGE_NAME} python -c "
import Bio
import requests
import bs4
print('✅ Todas las dependencias instaladas correctamente')
print(f'BioPython: {Bio.__version__}')
print(f'Requests: {requests.__version__}')
print(f'BeautifulSoup: {bs4.__version__}')
"

echo "🎉 ¡Imagen lista para usar!"
echo "Para usar la imagen: docker run --rm -it ${FULL_IMAGE_NAME}"