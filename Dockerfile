FROM alpine:latest
COPY LICENSE.md /
ENV VERSION 0.3.3
RUN apk update && apk add wget ca-certificates  && rm -rf /var/cache/apk/*   &&   update-ca-certificates 
#RUN mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2
RUN wget https://github.com/nordcloud/assume-role-arn/releases/download/v${VERSION}/assume-role-arn-linux -O /assume-role-arn && \
    chmod a+x /assume-role-arn
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]