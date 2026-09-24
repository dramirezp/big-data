# Imagen basada en Eclipse Temurin 17 JDK sobre Ubuntu Jammy con soporte multi-architectura para funcionar en Apple Silicon y maquinas compatibles con la arquitectura x86_64
FROM eclipse-temurin:17-jdk-jammy

ENV VIRTUAL_ENV=/opt/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
ENV SPARK_HOME=/opt/venv/lib/python3.10/site-packages/pyspark

# Instalar los paquetes del sistema requeridos para el entorno de desarrollo y ejecución de Python y Spark
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      bash \
      nano \
      build-essential \
      postgresql-client \
      python3 \
      python3-dev \
      python3-pip \
      python3-venv \
      libffi-dev \
      libopenblas-dev \
      zlib1g-dev \
      libjpeg-dev \
      libzmq3-dev \
      git && \
      unzip && \
      apt-get clean && \
      rm -rf /var/lib/apt/lists/*

# Pre-instalar el entorno virtual de Python y los paquetes necesarios para el desarrollo y ejecución de Spark
RUN python3 -m venv $VIRTUAL_ENV && \
    pip install --upgrade pip setuptools wheel && \
    pip install \
      numpy \
      matplotlib \
      seaborn \
      pyspark \
      pytest \
      notebook \
      ipykernel \
      findspark \
      "pandas<3.0.0"


# Silencing some warnings from Hadoop native code
RUN mkdir -p $SPARK_HOME/conf && \
  printf 'logger.nativecode.name = org.apache.hadoop.util.NativeCodeLoader\nlogger.nativecode.level = error\n' >> $SPARK_HOME/conf/log4j2.properties