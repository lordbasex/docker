FROM node:13.10-alpine

LABEL maintainer="Federico Pereira <fpereira@cnsoluciones.com>"

ENV LINK='http://www.cnsoluciones.com'

WORKDIR /usr/src/app

RUN apk add --update bash && rm -rf /var/cache/apk/*

COPY package*.json ./
COPY server.js ./

RUN yarn install && cp -fra /usr/src/app/node_modules/ /usr/src/

EXPOSE 9559

CMD [ "npm", "start" ]
