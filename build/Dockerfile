FROM node:20-alpine

ENV NODE_NO_WARNINGS=1

RUN apk add --no-cache jq bash

RUN npm install -g @mittwald/cli

WORKDIR /app

ADD main.sh main.sh

ENTRYPOINT ["/app/main.sh"]