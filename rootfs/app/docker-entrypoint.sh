#!/usr/bin/env bash

cp --recursive /opt/local-senzing/. /opt/senzing || true

if [[ "${SENZING_DEPLOY_OPT_MICROSOFT}" == "true" ]]; then
    echo "Copying to /opt/microsoft"
    cp --recursive /opt/local-microsoft/. /opt/microsoft || true
fi

"$@"
