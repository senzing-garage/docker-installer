#!/usr/bin/env bash

cp --recursive /opt/local-senzing/. /opt/senzing || true

if [[ ! "${SENZING_DEPLOY_POSTGRESQL_GOVERNOR}" == "true" ]]; then
    echo "Removing /etc/opt/senzing/g2/python/senzing_governor.py"
    rm /opt/senzing/g2/python/senzing_governor.py
fi

if [[ "${SENZING_DEPLOY_ETC_OPT_SENZING}" == "true" ]]; then
    echo "Copying to /etc/opt/senzing"
    cp --recursive /etc/opt/local-senzing/. /etc/opt/senzing || true
fi

if [[ "${SENZING_DEPLOY_OPT_MICROSOFT}" == "true" ]]; then
    echo "Copying to /opt/microsoft"
    cp --recursive /opt/local-microsoft/. /opt/microsoft || true
fi

"$@"
