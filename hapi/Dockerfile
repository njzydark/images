FROM node:24-slim

RUN npm install -g @twsxtd/hapi

ENV HAPI_LISTEN_HOST=0.0.0.0
ENV HAPI_LISTEN_PORT=3006
ENV HAPI_HOME=/config
ENV DB_PATH=/config/hapi.db

WORKDIR /config

EXPOSE 3006

ENTRYPOINT ["hapi"]
CMD ["server"]