# Usar imagen base de conda con Python
FROM condaforge/mambaforge:latest

# Metadatos
LABEL description="CAZy Pipeline - Custom container for fetching and combining CAZy sequences"
LABEL version="1.0.0"
LABEL maintainer="dlo"

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    git \
    procps \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copiar archivo de environment
COPY environment.yml /tmp/environment.yml

# Crear environment de conda con las dependencias
RUN mamba env create -f /tmp/environment.yml && \
    mamba clean -a

# Activar el environment por defecto (corregir formato ENV)
ENV PATH=/opt/conda/envs/cazypipeline/bin:$PATH
ENV CONDA_DEFAULT_ENV=cazypipeline

# Verificar instalación
RUN python -c "import Bio; print(f'BioPython version: {Bio.__version__}')" && \
    python -c "import requests; print(f'Requests version: {requests.__version__}')" && \
    python -c "import bs4; print(f'BeautifulSoup version: {bs4.__version__}')"

# Crear directorio de trabajo
WORKDIR /app

# Usuario no-root para seguridad
RUN useradd -m -s /bin/bash cazypipeline
USER cazypipeline

# Comando por defecto
CMD ["/bin/bash"]