# docker-installer

If you are beginning your journey with [Senzing],
please start with [Senzing Quick Start guides].

You are in the [Senzing Garage] where projects are "tinkered" on.
Although this GitHub repository may help you understand an approach to using Senzing,
it's not considered to be "production ready" and is not considered to be part of the Senzing product.
Heck, it may not even be appropriate for your application of Senzing!

## Synopsis

Create a docker image that can be used to install Senzing via a `cp` command.

## Overview

This repository shows how to create a Docker image that has Senzing [baked-in].
The Docker container is used to copy the "baked-in" Senzing files to mounted volumes.

This alleviates the root container requirement seen in the [senzing/yum] Docker container.

## Build Docker container

### EULAs

To use the Senzing code, you must agree to the End User License Agreement (EULA).

1. :warning: This step is intentionally tricky and not simply copy/paste.
   This ensures that you make a conscious effort to accept the EULA.
   Example:

    <code>export SENZING_ACCEPT_EULA="&lt;the value from [this link]&gt;"</code>

:thinking: If using the the Microsoft MS-SQL database,
you must agree to the Microsoft End User License Agreement (EULA).
See [MSSQL_ACCEPT_EULA].

1. **Optional**
   To install Microsoft's MS-SQL driver (`msodbcsql17`),
   accept the Microsoft EULA.
   Example:

    ```console
    export MSSQL_ACCEPT_EULA=Y

    ```

### Environment variables

1. :pencil2: Identify the desired Senzing package.
   Options:
    - senzingapi-poc
    - senzingapi-runtime
    - senzingapi-setup
    - senzingapi-tools

   Example:

    ```console
    export SENZING_PACKAGE=senzingapi-runtime

    ```

1. View the available versions of the Senzing package.
   Example:

    ```console
    docker run --rm senzing/apt list -a ${SENZING_PACKAGE}

    ```

1. :pencil2: From the list in the prior command, choose the desired Senzing version, modify the following, and run.
   Example:

    ```console
    export SENZING_PACKAGE_VERSION="4.0.0-00000"

    ```

### Build image

1. Run the `docker build` command.
   Example:

    ```console
    sudo docker build \
        --build-arg ACCEPT_EULA=${MSSQL_ACCEPT_EULA:-no} \
        --build-arg SENZING_ACCEPT_EULA=${SENZING_ACCEPT_EULA:-no} \
        --build-arg SENZING_APT_INSTALL_PACKAGE="${SENZING_PACKAGE}=${SENZING_PACKAGE_VERSION}" \
        --tag senzing/installer-${SENZING_PACKAGE}:${SENZING_PACKAGE_VERSION} \
        https://github.com/senzing-garage/docker-installer.git#main

    ```

## Run

### Environment variables for runtime

1. :pencil2: Identify the Senzing package and version from prior step.
   Example:

    ```console
    export SENZING_PACKAGE=senzingapi-runtime
    export SENZING_PACKAGE_VERSION="4.0.0-00000"

    ```

### Output directory

1. :pencil2: Specify where to install Senzing on local system.
   Example:

    ```console
    export SENZING_OPT_SENZING_DIR=~/${SENZING_PACKAGE}-${SENZING_PACKAGE_VERSION}

    ```

1. Make the output directory.
   This ensures the correct ownership and permissions on the directory.
   Example:

    ```console
    mkdir -p ${SENZING_OPT_SENZING_DIR}

    ```

### Run image

#### Install only Senzing binaries

1. Run the [docker run] command.
   Example:

    ```console
    docker run \
        --rm \
        --volume ${SENZING_OPT_SENZING_DIR}:/opt/senzing \
        senzing/installer-${SENZING_PACKAGE}:${SENZING_PACKAGE_VERSION}

    ```

#### As different user

:thinking: **Optional:**  The Docker container runs as "USER 1001".
Use if a different userid (UID) is required.
Reference: [docker run --user]

1. :pencil2: Identify user.
    1. **Example #1:** Use specific UID. User "0" is `root`.

        ```console
        export SENZING_RUNAS_USER="0"

        ```

    1. **Example #2:** Use current user.

        ```console
        export SENZING_RUNAS_USER=$(id -u):$(id -g)

        ```

1. Run the [docker run] command.
   Example:

    ```console
    docker run \
        --volume ${SENZING_OPT_SENZING_DIR}:/opt/senzing \
        --user ${SENZING_RUNAS_USER} \
        senzing/installer-${SENZING_PACKAGE}:${SENZING_PACKAGE_VERSION}

    ```

#### Install Microsoft MS-SQL Drivers

1. :pencil2: Specify where to install Microsoft drivers and Senzing configuration on local system.
   Example:

    ```console
    export SENZING_OPT_MICROSOFT_DIR=${SENZING_OPT_SENZING_DIR}/microsoft

    ```

1. Make directories.
   Example:

    ```console
    mkdir -p ${SENZING_OPT_MICROSOFT_DIR}

    ```

1. Run the [docker run] command.
   Example:

    ```console
    docker run \
        --env SENZING_DEPLOY_OPT_MICROSOFT=true \
        --rm \
        --volume ${SENZING_OPT_SENZING_DIR}:/opt/senzing \
        --volume ${SENZING_OPT_MICROSOFT_DIR}:/opt/microsoft \
        senzing/installer-${SENZING_PACKAGE}:${SENZING_PACKAGE_VERSION}

    ```

### Parameters

Configuration values specified by environment variable or command line parameter.

- **[SENZING_ACCEPT_EULA]**
- **[SENZING_OPT_SENZING_DIR]**

## References

- [Development]
- [Errors]
- [Examples]

[baked-in]: https://github.com/senzing-garage/knowledge-base/blob/main/WHATIS/baked-in.md
[Development]: docs/development.md
[docker run --user]: https://docs.docker.com/engine/reference/run/#user
[docker run]: https://docs.docker.com/engine/reference/commandline/run/
[Errors]: docs/errors.md
[Examples]: docs/examples.md
[MSSQL_ACCEPT_EULA]: https://github.com/senzing-garage/knowledge-base/blob/main/lists/environment-variables.md#mssql_accept_eula
[Senzing Garage]: https://github.com/senzing-garage
[Senzing Quick Start guides]: https://docs.senzing.com/quickstart/
[SENZING_ACCEPT_EULA]: https://github.com/senzing-garage/knowledge-base/blob/main/lists/environment-variables.md#senzing_accept_eula
[SENZING_OPT_SENZING_DIR]: https://github.com/senzing-garage/knowledge-base/blob/main/lists/environment-variables.md#SENZING_OPT_SENZING_DIR
[Senzing]: https://senzing.com/
[senzing/yum]: https://github.com/senzing-garage/docker-yum
[this link]: https://github.com/senzing-garage/knowledge-base/blob/main/lists/environment-variables.md#senzing_accept_eula
