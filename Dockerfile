FROM ubuntu:22.04 AS build

WORKDIR /app

# Install elm
RUN apt update && apt install curl -y \
      && curl -L -o elm.gz https://github.com/elm/compiler/releases/download/0.19.3/elm-0.19.3-linux-x64.gz \
      && gunzip elm.gz \
      && chmod +x elm

# Copy files
COPY elm.json .
COPY build.sh .
COPY ./data/ data/
COPY ./posts/ posts/
COPY ./src/ src/

# Compile the app
RUN PATH="/app/:$PATH" /app/build.sh index.html

FROM nginx:1.31-alpine

WORKDIR /app

COPY --from=build /app/index.html .
COPY ./css css/

COPY config/nginx.conf /etc/nginx/nginx.conf

LABEL org.opencontainers.image.source=https://github.com/aloussase/portfolio
LABEL org.opencontainers.image.description="My personal portfolio website"
LABEL org.opencontainers.image.licenses=MIT
