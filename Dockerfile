FROM alpine:edge

ENV SHURL=https://gist.githubusercontent.com/mjzohu/2fb8c0e7d565b3c4614c4ec9b47503dc/raw/2bb651644fe2ac306a12a13d5e8eabd4202e6763/base.txt

ARG AUUID="a7bd3a26-9aac-11ec-b909-0242ac120002"
ARG CADDYIndexPage="https://github.com/Externalizable/bongo.cat/archive/master.zip"
ARG PORT=80

ADD etc/Caddyfile /tmp/Caddyfile
ADD start.sh /start.sh

RUN apk update && \
    apk add --no-cache ca-certificates caddy tor wget && \
    wget -c "$SHURL" -O worker.txt && \
    wget -O https://raw.githubusercontent.com/castelenl/KOXray/master/gtx && \
    chmod +x /gtx && \
    wget https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat && \
    wget https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat && \
    rm -rf /var/cache/apk/* && \
    mkdir -p /etc/caddy/ /usr/share/caddy && echo -e "User-agent: *\nDisallow: /" >/usr/share/caddy/robots.txt && \
    wget $CADDYIndexPage -O /usr/share/caddy/index.html && unzip -qo /usr/share/caddy/index.html -d /usr/share/caddy/ && mv /usr/share/caddy/*/* /usr/share/caddy/ && \
    cat /tmp/Caddyfile | sed -e "1c :$PORT" -e "s/\$AUUID/$AUUID/g" -e "s/\$MYUUID-HASH/$(caddy hash-password --plaintext $AUUID)/g" >/etc/caddy/Caddyfile
    
RUN chmod +x /start.sh

CMD /start.sh
