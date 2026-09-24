FROM eclipse-temurin:17-jdk-alpine

ENV VIRTUAL_ENV=/opt/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
ENV SPARK_HOME=/opt/venv/lib/python3.12/site-packages/pyspark

RUN apk add bash && \
  apk add nano && \
  apk add postgresql-client && \
  apk add python3 && \
  apk add --no-cache py3-pip && \
  apk add --no-cache py3-virtualenv && \
  python3 -m venv $VIRTUAL_ENV && \
  pip install --upgrade pip && \
  pip install pyspark && \
  pip install pytest

WORKDIR /src

COPY . /src
