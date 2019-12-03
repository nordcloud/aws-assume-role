#!/bin/sh

set -e
if [ "x$DEBUG" = 'xtrue' ]; then
    set -x && VERBOSE='true'
fi

export PATH='/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin'

ASSUME_ROLE_ARN='assume-role-arn'

if [ "x$AWS_PROFILE" = 'xtrue' ]; then
    ASSUME_ROLE_ARN="$ASSUME_ROLE_ARN -p $AWS_PROFILE"
fi

if [ "x$ROLE_ARN" = 'xtrue' ]; then
    ASSUME_ROLE_ARN="$ASSUME_ROLE_ARN -r $ROLE_ARN"
fi

if [ "x$ROLE_SESSION_NAME" != 'x' ]; then
    ASSUME_ROLE_ARN="$ASSUME_ROLE_ARN -n $ROLE_SESSION_NAME"
fi

if [ "x$EXTERNAL_ID" != 'x' ]; then
    ASSUME_ROLE_ARN="$ASSUME_ROLE_ARN -e $EXTERNAL_ID"
fi

if [ "x$VERBOSE" = 'xtrue' ]; then
    ASSUME_ROLE_ARN="$ASSUME_ROLE_ARN -v"
fi

ASSUME_ROLE_ARN="$ASSUME_ROLE_ARN $*"
set -- "$ASSUME_ROLE_ARN"

eval "$($ASSUME_ROLE_ARN)"

if [ -n "$AWS_ACCESS_KEY_ID" ]; then
    echo "::set-env name=AWS_ACCESS_KEY_ID::${AWS_ACCESS_KEY_ID}"
    echo "::set-env name=AWS_SECRET_ACCESS_KEY::${AWS_SECRET_ACCESS_KEY}"
    echo "::set-env name=AWS_SESSION_TOKEN::${AWS_SESSION_TOKEN}"
fi
