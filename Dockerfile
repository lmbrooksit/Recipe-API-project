FROM python:3.9-alpine3.13
LABEL maintainer="lee"

ENV PYTHONBUFFERED=1

# Install dependencies
RUN apk update && apk add --no-cache \
    gcc \
    musl-dev \
    postgresql-dev \
    libpq \
    build-base \
    linux-headers

# Copy and set up requirements
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app

# Install flake8
RUN pip install flake8

# Set up virtual environment and install dependencies
ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ "$DEV" = "true" ]; then /py/bin/pip install -r /tmp/requirements.dev.txt; fi && \
    rm -rf /tmp

# Add non-root user
RUN adduser -D django-user
ENV PATH="/py/bin:$PATH"

USER django-user
EXPOSE 8000
