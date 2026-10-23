ARG PYTHON_VERSION=3.12
FROM python:${PYTHON_VERSION}-slim AS builder

ARG POETRY_VERSION=2.2.1
ARG PIP_SPEC="pip @ https://files.pythonhosted.org/packages/3f/06/3e4420302363fbb71be3c7f35ce042f54bfca330e3e66b3a2e3c4cca579f/pip-26.2.2-py3-none-any.whl#sha256=fd7f4dfa8190e014013b9f08f3e973f4e4c26ffd179a204895533a7254813a70"

ENV POETRY_HOME=/opt/poetry
ENV VENV_PATH=/opt/virtualenvs/venv

# Patch the OS CA bundle and system pip (eMudhra/emSign CA incident)
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates && \
    rm -rf /var/lib/apt/lists/* && \
    pip install --no-cache-dir "${PIP_SPEC}"

# Poetry uses requests, which reads the standalone certifi bundle
RUN python -m venv $POETRY_HOME && \
    $POETRY_HOME/bin/pip install --no-cache-dir "${PIP_SPEC}" && \
    $POETRY_HOME/bin/pip install --no-cache-dir -U setuptools && \
    $POETRY_HOME/bin/pip install --no-cache-dir poetry==${POETRY_VERSION} "certifi>=2026.10.19"

ENV POETRY_NO_INTERACTION=1 \
    POETRY_CACHE_DIR=/tmp/poetry_cache

WORKDIR /app

RUN python -m venv $VENV_PATH && \
    $VENV_PATH/bin/pip install --no-cache-dir "${PIP_SPEC}"

ENV VIRTUAL_ENV=$VENV_PATH
