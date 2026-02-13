ARG PYTHON_VERSION=3.12
FROM python:${PYTHON_VERSION}-slim AS builder

ARG POETRY_VERSION=2.2.1

ENV POETRY_HOME=/opt/poetry
ENV VENV_PATH=/opt/virtualenvs/venv

RUN python -m venv $POETRY_HOME && \
    $POETRY_HOME/bin/pip install --no-cache-dir -U pip setuptools && \
    $POETRY_HOME/bin/pip install --no-cache-dir poetry==${POETRY_VERSION}

ENV POETRY_NO_INTERACTION=1 \
    POETRY_CACHE_DIR=/tmp/poetry_cache

WORKDIR /app

RUN python -m venv $VENV_PATH

ENV VIRTUAL_ENV=$VENV_PATH
