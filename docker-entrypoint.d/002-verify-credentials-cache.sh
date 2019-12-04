#!/bin/sh

set -e
if [ "x${DEBUG}" = 'xtrue' ]; then
    set -x
fi

if [ "x${SKIP_CACHE}" = 'xtrue' ]; then
    echo 'Credentials cache has been disabled.'
    exit 0
fi

echo 'Credentials cache is enabled.'
