ARG PYTHON_VERSION
FROM python:${PYTHON_VERSION}-slim AS builder

ARG POETRY_VERSION

ENV POETRY_HOME=/opt/poetry \
    VENV_PATH=/opt/virtualenvs/venv \
    POETRY_NO_INTERACTION=1 \
    POETRY_CACHE_DIR=/tmp/poetry_cache
ENV VIRTUAL_ENV=$VENV_PATH

RUN python -m venv $POETRY_HOME && \
    $POETRY_HOME/bin/pip install --no-cache-dir -U setuptools && \
    $POETRY_HOME/bin/pip install --no-cache-dir poetry==${POETRY_VERSION}

WORKDIR /app

RUN python -m venv $VENV_PATH
