ARG alpine_version="${alpine_version:-latest}"

FROM alpine:${alpine_version} AS builder

ARG version="${version:-0.3.3}"

RUN set -eux && \
    mkdir -p /build

WORKDIR /build

COPY . ./

RUN set -eux && \
    apk --no-cache --update add ca-certificates && \
    apk --no-cache --update add curl && \
    apk --no-cache --update add jq && \
    echo "Using assume-role-arn version: $version" && \
    if [ "x${version}" = 'xlatest' ]; then \
        curl -s 'https://api.github.com/repos/nordcloud/assume-role-arn/releases/latest' | \
            jq -r '.assets[] | select(.name | contains("linux")) | .browser_download_url' | \
                xargs curl -L -o /build/assume-role-arn; \
    else \
        curl -L -o /build/assume-role-arn "https://github.com/nordcloud/assume-role-arn/releases/download/v${version}/assume-role-arn-linux"; \
    fi;

FROM alpine:${alpine_version}

ARG version="${version:-0.3.3}"

LABEL \
    org.label-schema.schema-version="1.0" \
    org.label-schema.name="aws-assume-role" \
    org.label-schema.version="${version}" \
    org.label-schema.description="It lets you assume a role and sets the credentials accordingly." \
    org.label-schema.license="MIT" \
    org.label-schema.url="https://github.com/nordcloud/aws-assume-role" \
    org.label-schema.vcs-url="https://github.com/nordcloud/aws-assume-role.git" \
    org.label-schema.vcs-type="Git" \
    org.label-schema.vendor="Nordcloud <info@nordcloud.com> (http://www.nordcloud.com/)" \
    version="${version}" \
    maintainer="Dariusz Dwornikowski <dariusz.dwornikowski@nordcloud.com>" \
    license="MIT" \
    vendor="Open Source Software"

ENV GOGC off

ENV AWS_PROFILE ""
ENV AWS_ACCESS_KEY_ID ""
ENV AWS_SECRET_ACCESS_KEY ""

ENV ROLE_ARN ""
ENV ROLE_SESSION_NAME ""
ENV EXTERNAL_ID ""

ENV VERBOSE false

ENV DEBUG false

WORKDIR /tmp

RUN set -eux && \
    apk --no-cache --update add ca-certificates && \
    rm -Rf /var/lib/apt/lists/* && \
    rm -Rf /var/cache/apk/* && \
    rm -Rf /tmp/* && \
    rm -Rf /var/tmp/*

COPY --from=builder \
    /build/assume-role-arn \
    /build/assume-role-arn.sh \
    /usr/local/bin/

COPY --from=builder \
    /build/docker-entrypoint.sh /docker-entrypoint.sh

RUN set -eux && \
    mkdir -p /docker-entrypoint.d && \
    chmod 755 /usr/local/bin/assume-role-arn && \
    chmod 755 /usr/local/bin/assume-role-arn.sh && \
    chmod 755 /docker-entrypoint.sh

COPY --from=builder \
    /build/docker-entrypoint.d/* /docker-entrypoint.d/

RUN set -eux && \
    chmod 755 /docker-entrypoint.d/*

STOPSIGNAL SIGKILL

ENTRYPOINT [ "/docker-entrypoint.sh" ]
