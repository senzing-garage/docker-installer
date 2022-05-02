#!/usr/bin/env bash

cp --recursive /opt/local-senzing/. /opt/senzing || true

if [[ ! -z "${SENZING_DEPLOY_ETC_OPT_SENZING}" ]]; then
    echo "Copying to /etc/opt/senzing"
    cp --recursive /etc/opt/local-senzing/. /etc/opt/senzing || true
fi

if [[ ! -z "${SENZING_DEPLOY_OPT_MICROSOFT}" ]]; then
    echo "Copying to /opt/microsoft"
    cp --recursive /opt/local-microsoft/. /opt/microsoft || true
fi

"$@"
