#!/bin/sh

set -e
if [ "x${DEBUG}" = 'xtrue' ]; then
    set -x && VERBOSE='true'
fi

export PATH='/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin'

ASSUME_ROLE_ARN='assume-role-arn'

if [ "x${AWS_PROFILE}" != 'x' ]; then
    ASSUME_ROLE_ARN="$ASSUME_ROLE_ARN -p $AWS_PROFILE"
fi

if [ "x${ROLE_ARN}" != 'x' ]; then
    ASSUME_ROLE_ARN="$ASSUME_ROLE_ARN -r $ROLE_ARN"
fi

if [ "x${ROLE_SESSION_NAME}" != 'x' ]; then
    ASSUME_ROLE_ARN="$ASSUME_ROLE_ARN -n $ROLE_SESSION_NAME"
fi

if [ "x${EXTERNAL_ID}" != 'x' ]; then
    ASSUME_ROLE_ARN="$ASSUME_ROLE_ARN -e $EXTERNAL_ID"
fi

if [ "x${SKIP_CACHE}" = 'xtrue' ]; then
    ASSUME_ROLE_ARN="$ASSUME_ROLE_ARN -skipCache"
fi

if [ "x${VERBOSE}" = 'xtrue' ]; then
    ASSUME_ROLE_ARN="$ASSUME_ROLE_ARN -v"
fi

ASSUME_ROLE_ARN="$ASSUME_ROLE_ARN $*"
set -- "$ASSUME_ROLE_ARN"

eval "$($ASSUME_ROLE_ARN)"

if [ -n "$AWS_ACCESS_KEY_ID" ]; then
    echo "::set-env name=${ENV_PREFIX}AWS_ACCESS_KEY_ID::${AWS_ACCESS_KEY_ID}"
    echo "::set-env name=${ENV_PREFIX}AWS_SECRET_ACCESS_KEY::${AWS_SECRET_ACCESS_KEY}"
    echo "::set-env name=${ENV_PREFIX}AWS_SESSION_TOKEN::${AWS_SESSION_TOKEN}"
    echo "::add-mask::${ENV_PREFIX}${AWS_ACCESS_KEY_ID}"
    echo "::add-mask::${ENV_PREFIX}${AWS_SECRET_ACCESS_KEY}"
    echo "::add-mask::${ENV_PREFIX}${AWS_SESSION_TOKEN}"
fi
