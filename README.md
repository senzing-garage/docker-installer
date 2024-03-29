# docker-installer

If you are beginning your journey with
[Senzing](https://senzing.com/),
please start with
[Senzing Quick Start guides](https://docs.senzing.com/quickstart/).

You are in the
[Senzing Garage](https://github.com/senzing-garage)
where projects are "tinkered" on.
Although this GitHub repository may help you understand an approach to using Senzing,
it's not considered to be "production ready" and is not considered to be part of the Senzing product.
Heck, it may not even be appropriate for your application of Senzing!

## Synopsis

Create a docker image that can be used to install Senzing via a `cp` command.

## Overview

This repository shows how to create a Docker image that has Senzing
[baked-in](https://github.com/senzing-garage/knowledge-base/blob/main/WHATIS/baked-in.md).
The Docker container is used to copy the "baked-in" Senzing files to mounted volumes.

This alleviates the root container requirement seen in the
[senzing/yum](https://github.com/senzing-garage/docker-yum) Docker container.

### Contents

1. [Preamble](#preamble)
    1. [Legend](#legend)
1. [Expectations](#expectations)
1. [Build](#build)
    1. [EULA](#eula)
    1. [Environment variables](#environment-variables)
    1. [Build image](#build-image)
1. [Run](#run)
    1. [Environment variables for runtime](#environment-variables-for-runtime)
    1. [Output directory](#output-directory)
    1. [Run image](#run-image)
1. [References](#references)

## Preamble

At [Senzing](http://senzing.com),
we strive to create GitHub documentation in a
"[don't make me think](https://github.com/senzing-garage/knowledge-base/blob/main/WHATIS/dont-make-me-think.md)" style.
For the most part, instructions are copy and paste.
Whenever thinking is needed, it's marked with a "thinking" icon :thinking:.
Whenever customization is needed, it's marked with a "pencil" icon :pencil2:.
If the instructions are not clear, please let us know by opening a new
[Documentation issue](https://github.com/senzing-garage/template-python/issues/new?template=documentation_request.md)
describing where we can improve.   Now on with the show...

### Legend

1. :thinking: - A "thinker" icon means that a little extra thinking may be required.
   Perhaps there are some choices to be made.
   Perhaps it's an optional step.
1. :pencil2: - A "pencil" icon means that the instructions may need modification before performing.
1. :warning: - A "warning" icon means that something tricky is happening, so pay attention.

## Expectations

- **Space:** This repository and demonstration require 6 GB free disk space.
- **Time:** Budget 40 minutes to get the demonstration up-and-running, depending on CPU and network speeds.
- **Background knowledge:** This repository assumes a working knowledge of:
  - [Docker](https://github.com/senzing-garage/knowledge-base/blob/main/WHATIS/docker.md)

## Build

### EULA

To use the Senzing code, you must agree to the End User License Agreement (EULA).

1. :warning: This step is intentionally tricky and not simply copy/paste.
   This ensures that you make a conscious effort to accept the EULA.
   Example:

    <code>export SENZING_ACCEPT_EULA="&lt;the value from [this link](https://github.com/senzing-garage/knowledge-base/blob/main/lists/environment-variables.md#senzing_accept_eula)&gt;"</code>

:thinking: If using the the Microsoft MS-SQL database,
you must agree to the Microsoft End User License Agreement (EULA).
See [MSSQL_ACCEPT_EULA](https://github.com/senzing-garage/knowledge-base/blob/main/lists/environment-variables.md#mssql_accept_eula).

1. **Optional**
   To install Microsoft's MS-SQL driver (`msodbcsql17`),
   accept the Microsoft EULA.
   Example:

   ```console
   export MSSQL_ACCEPT_EULA=Y
   ```

### Environment variables

There are 2 options for specifying the version of Senzing to build.
The first method uses `source` to set environment variables for the latest build.
The second method is a manual method to specify environment variables.
Only one method need be used.

1. **Option #1:** Set environment variables for latest version of Senzing.
   Example:

    ```console
    source <(curl -X GET https://raw.githubusercontent.com/Senzing/knowledge-base/main/lists/senzing-versions-latest.sh)

    ```

1. **Option #2:** Specify Senzing version desired.
   See [Senzing API Version History](https://senzing.com/releases/).
   Example:

    ```console
    export SENZING_VERSION_SENZINGAPI="3.5.1"
    export SENZING_VERSION_SENZINGAPI_BUILD="3.5.1-23104"

    ```

   To find the `SENZING_VERSION_SENZINGAPI_BUILD` for a particular Senzing API version, you can use `apt` or `yum` or email [support@senzing.com](mailto:support@senzing.com).

### Build image

1. Run the `docker build` command.
   Example:

    ```console
    sudo docker build \
        --build-arg ACCEPT_EULA=${MSSQL_ACCEPT_EULA:-no} \
        --build-arg SENZING_ACCEPT_EULA=${SENZING_ACCEPT_EULA:-no} \
        --build-arg SENZING_APT_INSTALL_PACKAGE="senzingapi=${SENZING_VERSION_SENZINGAPI_BUILD}" \
        --tag senzing/installer:${SENZING_VERSION_SENZINGAPI} \
        https://github.com/senzing-garage/docker-installer.git#main

    ```

## Run

### Environment variables for runtime

1. :pencil2: Specify Senzing version desired.
   See [Senzing API Version History](https://senzing.com/releases/).
   Example:

    ```console
    export SENZING_VERSION_SENZINGAPI="3.5.1"

    ```

### Output directory

1. :pencil2: Specify where to install Senzing on local system.
   Example:

    ```console
    export SENZING_OPT_SENZING_DIR=~/my-senzing

    ```

1. Make the output directory.
   This ensures the correct ownership and permissions on the directory.
   Example:

    ```console
    mkdir -p ${SENZING_OPT_SENZING_DIR}

    ```

### Run image

#### Install only Senzing binaries

1. Run the [`docker run`](https://docs.docker.com/engine/reference/commandline/run/) command.
   Example:

    ```console
    docker run \
        --rm \
        --volume ${SENZING_OPT_SENZING_DIR}:/opt/senzing \
        senzing/installer:${SENZING_VERSION_SENZINGAPI}

    ```

#### As different user

:thinking: **Optional:**  The Docker container runs as "USER 1001".
Use if a different userid (UID) is required.
Reference: [docker run --user](https://docs.docker.com/engine/reference/run/#user)

1. :pencil2: Identify user.
    1. **Example #1:** Use specific UID. User "0" is `root`.

        ```console
        export SENZING_RUNAS_USER="0"

        ```

    1. **Example #2:** Use current user.

        ```console
        export SENZING_RUNAS_USER=$(id -u):$(id -g)

        ```

1. Run the [`docker run`](https://docs.docker.com/engine/reference/commandline/run/) command.
   Example:

    ```console
    docker run \
        --volume ${SENZING_OPT_SENZING_DIR}:/opt/senzing \
        --user ${SENZING_RUNAS_USER} \
        senzing/installer:${SENZING_VERSION_SENZINGAPI}

    ```

#### Install Microsoft MS-SQL Drivers

1. :pencil2: Specify where to install Microsoft drivers and Senzing configuration on local system.
   Example:

    ```console
    export SENZING_ETC_DIR=${SENZING_OPT_SENZING_DIR}/etc
    export SENZING_OPT_MICROSOFT_DIR=${SENZING_OPT_SENZING_DIR}/microsoft

    ```

1. Make directories.
   Example:

    ```console
    mkdir -p ${SENZING_ETC_DIR}
    mkdir -p ${SENZING_OPT_MICROSOFT_DIR}

    ```

1. Run the [`docker run`](https://docs.docker.com/engine/reference/commandline/run/) command.
   Example:

    ```console
    docker run \
        --env SENZING_DEPLOY_ETC_OPT_SENZING=true \
        --env SENZING_DEPLOY_OPT_MICROSOFT=true \
        --rm \
        --volume ${SENZING_OPT_SENZING_DIR}:/opt/senzing \
        --volume ${SENZING_ETC_DIR}:/etc/opt/senzing \
        --volume ${SENZING_OPT_MICROSOFT_DIR}:/opt/microsoft \
        senzing/installer:${SENZING_VERSION_SENZINGAPI}

    ```

### Parameters

Configuration values specified by environment variable or command line parameter.

- **[SENZING_ACCEPT_EULA](https://github.com/senzing-garage/knowledge-base/blob/main/lists/environment-variables.md#senzing_accept_eula)**
- **[SENZING_OPT_SENZING_DIR](https://github.com/senzing-garage/knowledge-base/blob/main/lists/environment-variables.md#SENZING_OPT_SENZING_DIR)**

## References

- [Development](docs/development.md)
- [Errors](docs/errors.md)
- [Examples](docs/examples.md)
