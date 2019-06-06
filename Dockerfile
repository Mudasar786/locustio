FROM python:3.7-alpine3.9

ENV PYTHONUNBUFFERED 1

RUN apk update && \
        apk add --no-cache \
        gcc \
        g++ \
        musl-dev \
        linux-headers \
        zeromq-dev \
        libzmq

RUN pip install -U pip && \
    pip install --no-cache-dir locustio pyzmq

RUN mkdir /scripts

VOLUME /scripts

EXPOSE 8089 5557 5558

RUN addgroup -S locust && adduser -H -D -S locust -G locust

USER locust
