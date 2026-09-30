# Imagen basada en Eclipse Temurin 17 JDK sobre Ubuntu Jammy con soporte multi-architectura para funcionar en Apple Silicon y maquinas compatibles con la arquitectura x86_64
FROM eclipse-temurin:17-jdk-jammy

# TARGETARCH lo define automaticamente BuildKit/buildx (amd64 o arm64) segun la plataforma de destino
ARG TARGETARCH

ENV VIRTUAL_ENV=/opt/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
ENV SPARK_HOME=/opt/venv/lib/python3.10/site-packages/pyspark
ENV QUARTO_VERSION=1.10.18
ENV TYPST_VERSION=0.15.1

# Instalar los paquetes del sistema requeridos para el entorno de desarrollo y ejecución de Python y Spark
RUN apt-get update && \
<<<<<<< HEAD
<<<<<<< Updated upstream
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
=======
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
  git \
  unzip \
  curl \
  xz-utils && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Pre-instalar el entorno virtual de Python y los paquetes necesarios para el desarrollo y ejecución de Spark
RUN python3 -m venv $VIRTUAL_ENV && \
=======
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
  git \
  unzip \
  curl \
  xz-utils && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Pre-instalar el entorno virtual de Python y los paquetes necesarios para el desarrollo y ejecución de Spark
RUN python3 -m venv $VIRTUAL_ENV && \
>>>>>>> 5d119cbc (Add uv)
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
  "pandas<3.0.0" \
  uv

# Instalar Quarto (deb oficial, seleccionando el paquete segun la arquitectura de destino)
RUN QUARTO_ARCH=$([ "$TARGETARCH" = "arm64" ] && echo "arm64" || echo "amd64") && \
  curl -fsSL -o /tmp/quarto.deb "https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-${QUARTO_ARCH}.deb" && \
  apt-get update && \
  apt-get install -y --no-install-recommends /tmp/quarto.deb && \
  rm -f /tmp/quarto.deb && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Instalar Typst (binario estatico, seleccionando el target segun la arquitectura de destino)
RUN TYPST_TARGET=$([ "$TARGETARCH" = "arm64" ] && echo "aarch64-unknown-linux-musl" || echo "x86_64-unknown-linux-musl") && \
  curl -fsSL -o /tmp/typst.tar.xz "https://github.com/typst/typst/releases/download/v${TYPST_VERSION}/typst-${TYPST_TARGET}.tar.xz" && \
  tar -xJf /tmp/typst.tar.xz -C /tmp && \
  mv "/tmp/typst-${TYPST_TARGET}/typst" /usr/local/bin/typst && \
  rm -rf /tmp/typst.tar.xz "/tmp/typst-${TYPST_TARGET}"
<<<<<<< HEAD
>>>>>>> Stashed changes
=======
>>>>>>> 5d119cbc (Add uv)


# Silencing some warnings from Hadoop native code
RUN mkdir -p $SPARK_HOME/conf && \
  printf 'logger.nativecode.name = org.apache.hadoop.util.NativeCodeLoader\nlogger.nativecode.level = error\n' >> $SPARK_HOME/conf/log4j2.properties