FROM python:3.7-alpine3.9

RUN apk --no-cache add g++ \
    && pip install --no-cache-dir locustio pyzmq

RUN mkdir /scripts
VOLUME /scripts

EXPOSE 5557 5558 8089

RUN addgroup -S locust && adduser -H -D -S locust -G locust

USER locust
