FROM python:3.9-slim

# Evitar prompts de configuración
ENV DEBIAN_FRONTEND=noninteractive

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    build-essential \
    libsm6 \
    libxext6 \
    libxrender-dev \
    tk \
    && rm -rf /var/lib/apt/lists/*

# Instalar Jupyter y dependencias de Python
RUN pip install --no-cache-dir \
    spacy \
    jupyter \
    torch==1.9.0 \
    torchvision \
    torchtext==0.10 \
    nltk \
    datasets \
    "numpy<2"

# Descargar modelos de spaCy
RUN python -m spacy download en_core_web_sm && \
    python -m spacy download de_core_news_sm

# Preparar NLTK
RUN python -m nltk.downloader stopwords

# Crear directorio para notebooks
WORKDIR /workspace
VOLUME /workspace

# Exponer el puerto del Jupyter
EXPOSE 8888

# Iniciar Jupyter Notebook sin token ni password
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--NotebookApp.token=''", "--NotebookApp.password=''"]
