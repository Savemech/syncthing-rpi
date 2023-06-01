FROM alpine


ENV SYNCTHING_VERSION=1.23.4


RUN apk upgrade --no-cache && \
    apk add --no-cache tini ca-certificates su-exec tzdata && \
    apk add --no-cache --virtual .build-deps apache2-utils curl tar && \
    cd /usr/bin && \
    url="https://github.com/syncthing/syncthing/releases/download/v${SYNCTHING_VERSION}/syncthing-linux-arm-v${SYNCTHING_VERSION}.tar.gz" && \
    curl -L $url | tar xz --wildcards --strip-components 1 --exclude "etc/*" "*/syncthing" && \
    apk del .build-deps && \
    addgroup -S syncthing && adduser -S -G syncthing syncthing && \
    ln -sf /dev/stdout /var/log/syncthing.log


#ENTRYPOINT ["/sbin/tini", "--"]
CMD ["su-exec", "syncthing", "syncthing", "--no-browser", "--no-restart", "--logflags=0", "home=/syncthing/config","--gui-address=0.0.0.0:8384", "--logfile=/var/log/syncthing.log"]

