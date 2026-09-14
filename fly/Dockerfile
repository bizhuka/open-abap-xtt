# syntax = docker/dockerfile:1

# Match local Node (require() of ESM temporal-polyfill needs Node 22+)
ARG NODE_VERSION=24.19.0
FROM node:${NODE_VERSION}-slim AS base

LABEL fly_launch_runtime="Node.js"

WORKDIR /app
ENV NODE_ENV="production"


FROM base AS build

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git node-gyp pkg-config python-is-python3

COPY package-lock.json package.json ./
RUN npm ci --include=dev

COPY abaplint.json abap_transpile.json ./
COPY src ./src
# COPY test ./test
COPY runtime ./runtime
COPY scripts ./scripts
COPY server.mjs ./
COPY public ./public
COPY web ./web

RUN npm run verify


FROM base

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y git && \
    rm -rf /var/lib/apt/lists/*

COPY --from=build /app /app

EXPOSE 3000
CMD [ "npm", "start" ]
