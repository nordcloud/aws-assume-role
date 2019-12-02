FROM alpine:latest
COPY LICENSE.md /
ENV VERSION 0.3.3
RUN apk update && apk add wget ca-certificates file && rm -rf /var/cache/apk/*   &&   update-ca-certificates 
RUN wget https://github.com/nordcloud/assume-role-arn/releases/download/v${VERSION}/assume-role-arn-linux -O /assume-role-arn && \
    chmod a+x /assume-role-arn
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
WORKDIR /
ENTRYPOINT ["/entrypoint.sh"]