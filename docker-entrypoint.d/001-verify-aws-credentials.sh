#!/bin/sh

set -e
if [ "x$DEBUG" = 'xtrue' ]; then
    set -x
fi

if [ "x$CHECK_ENVIRONMENT" = 'xfalse' ]; then
    echo 'Environment variables check has been disabled.'
    exit 0
fi

if [ -z "$AWS_ACCESS_KEY_ID" ]; then
    echo "The 'AWS_ACCESS_KEY_ID' environment variable has to be set, aborting..."
    exit 1
fi

if [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
    echo "The 'AWS_SECRET_ACCESS_KEY' environment variable has to be set, aborting..."
    exit 1
fi
