#!/bin/sh

set -e

if [ -z "$AWS_ACCESS_KEY_ID" ]; then
  echo "AWS_ACCESS_KEY_ID is not set. Quitting."
  exit 1
fi

if [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
  echo "AWS_SECRET_ACCESS_KEY is not set. Quitting."
  exit 1
fi
ldd ./assume-role-arn
stat ./assume-role-arn
file ./assume-role-arn

eval $(./assume-role-arn $*)

echo "::set-env name=AWS_ACCESS_KEY_ID::${AWS_ACCESS_KEY_ID}"
echo "::set-env name=AWS_SECRET_ACCESS_KEY::${AWS_SECRET_ACCESS_KEY}"
echo "::set-env name=AWS_SESSION_TOKEN::${AWS_SESSION_TOKEN}"