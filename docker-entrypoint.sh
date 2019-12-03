#!/bin/sh

set -e
if [ "x$DEBUG" = 'xtrue' ]; then
    set -x
fi

export PATH='/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin'

DIRECTORY='/docker-entrypoint.d'

if [ -d $DIRECTORY ] && [ -n "$(ls -A $DIRECTORY)" ]; then
    for file in ${DIRECTORY}/*; do
        case "$file" in
            *.sh)
                if [ -x "$file" ]; then
                    echo "$0: RUNNING: $file"
                    "$file"
                else
                    echo "$0: SOURCING: $file"
                    . "$file"
                fi
                ;;
            *) echo "$0: IGNORING: $file" ;;
        esac
        echo
    done
fi

if [ ! -d "${HOME}/.cache" ]; then
    mkdir -p "${HOME}/.cache"
    chmod u+rwx,g=,o= "${HOME}/.cache"
fi

if [ "${1#-}" != "$1" ]; then
    set -- assume-role-arn.sh "$@"
else
    set -- assume-role-arn.sh
fi

exec "$@"
