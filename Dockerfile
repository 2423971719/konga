FROM node:12.16-alpine

RUN apk upgrade --update \
&& apk add bash git ca-certificates \
&& npm install -g bower

COPY package.json /app/package.json
COPY package-lock.json /app/package-lock.json
COPY bower.json /app/bower.json

WORKDIR /app

RUN npm --unsafe-perm --production ci \
&& apk del git

COPY . /app

RUN rm -rf /var/cache/apk/* \
/app/.git \
/app/screenshots \
/app/test \
&& adduser -H -S -g "Konga service owner" -D -u 1200 -s /sbin/nologin konga \
&& mkdir /app/kongadata /app/.tmp \
&& chown -R 1200:1200 /app/views /app/kongadata /app/.tmp

EXPOSE 1337

VOLUME /app/kongadata

ENTRYPOINT ["/app/start.sh"]
