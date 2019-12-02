# AWS Assume role action

It lets you assume a role and sets the credentials accordingly. 

## Usage

The action under the hood uses the https://github.com/nordcloud/assume-role-arn tool and follows the same version schema. Below is a simple example where you pass `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` via Github secrets, and assume role in passed in `DEPLOYMENT_ROLE` with additional external id `DEPLOYMENT_EXID`. The action will set the needed credentials for later steps. For more switches you can check `assume-role-arn` tool.

Example:

```yaml
name: CI

on: [push]

jobs:
  build:

    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v1
    - uses: nordcloud/aws-assume-role@master
      env: 
        AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
        AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
      with:
        args: -r ${{ secrets.DEPLOYMENT_ROLE }} -e ${{ secrets.DEPLOYMENT_EXID }}
```

## Authors

Dariusz Dwornikowski, Nordcloud 🇵🇱 
