#!/usr/bin/env bash

cp --recursive /opt/local-senzing/. /opt/senzing

if [[ ! -z "${SENZING_DEPLOY_ETC_OPT_SENZING}" ]]; then
    cp --recursive /etc/opt/local-senzing/. /etc/opt/senzing
fi

if [[ ! -z "${SENZING_DEPLOY_OPT_MICROSOFT}" ]]; then
    cp --recursive /opt/local-microsoft/.   /opt/microsoft
fi

"$@"
