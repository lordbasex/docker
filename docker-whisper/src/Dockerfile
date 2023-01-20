FROM nvidia/cuda:12.0.0-base-ubuntu20.04

ENV PYTHON_VERSION=3.9

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get -qq update \
    && apt-get -qq install --no-install-recommends \
    python${PYTHON_VERSION} \
    python3-pip \
    ffmpeg \
    git \
    jq \
    bash \
    screen \
    && rm -rf /var/lib/apt/lists/*

RUN ln -s -f /usr/bin/python${PYTHON_VERSION} /usr/bin/python3 && \
    ln -s -f /usr/bin/python${PYTHON_VERSION} /usr/bin/python && \
    ln -s -f /usr/bin/pip3 /usr/bin/pip

RUN pip install -U pip setuptools \
    && pip install git+https://github.com/openai/whisper.git

WORKDIR /app

COPY ./test.py /app
COPY ./demo0.wav /app
COPY ./demo1-18_53s.mp3 /app
COPY docker-entrypoint.sh /

RUN cp -fra /app /app.org

ENTRYPOINT ["/usr/bin/sh", "/docker-entrypoint.sh"]

CMD ["/bin/bash"]
