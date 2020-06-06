# docker-installer

## Preamble

At [Senzing](http://senzing.com),
we strive to create GitHub documentation in a
"[don't make me think](https://github.com/Senzing/knowledge-base/blob/master/WHATIS/dont-make-me-think.md)" style.
For the most part, instructions are copy and paste.
Whenever thinking is needed, it's marked with a "thinking" icon :thinking:.
Whenever customization is needed, it's marked with a "pencil" icon :pencil2:.
If the instructions are not clear, please let us know by opening a new
[Documentation issue](https://github.com/Senzing/template-python/issues/new?template=documentation_request.md)
describing where we can improve.   Now on with the show...

## Overview

This repository shows how to create a Docker image that has Senzing
[baked-in](https://github.com/Senzing/knowledge-base/blob/master/WHATIS/baked-in.md).
The Docker container is used to copy the "baked-in" Senzing files to mounted volumes.

This alleviates the requirement for a root container seen in the
[senzing/yum](https://github.com/Senzing/docker-yum) Docker container.

## EULA

To use the Senzing code, you must agree to the End User License Agreement (EULA).

1. :warning: This step is intentionally tricky and not simply copy/paste.
   This ensures that you make a conscious effort to accept the EULA.
   Example:

    <code>export SENZING_ACCEPT_EULA="&lt;the value from [this link](https://github.com/Senzing/knowledge-base/blob/master/lists/environment-variables.md#senzing_accept_eula)&gt;"</code>

## Environment variables

1. :thinking: **Optional:**
   Only needed if a specific version of Senzing is required.
   If `SENZING_APT_INSTALL_PACKAGE_PARAMETER` is not specified, the latest version of Senzing will be used.

    1. :pencil2: Identify the Senzing package name to be installed.
       Example:

        ```console
        export SENZING_APT_INSTALL_PACKAGE="senzing=1.15.1"
        ```

    1. Create a `docker run` parameter with the value.
       Example:

        ```console
        export SENZING_APT_INSTALL_PACKAGE_PARAMETER="--build-arg SENZING_APT_INSTALL_PACKAGE=${SENZING_APT_INSTALL_PACKAGE}"
        ```

1. Specify Docker image name.
   This allows container tags like `senzing/installer:1.15.1` to match the version of Senzing to be installed.
   Example:

    ```console
    export SENZING_DOCKER_IMAGE_TAG="senzing/installer:latest"
    ```

## Build Docker image

1. Run the `docker build` command.
   Example:

    ```console
    docker build \
        --build-arg SENZING_ACCEPT_EULA=${SENZING_ACCEPT_EULA} \
        --tag ${SENZING_DOCKER_IMAGE_TAG} \
        ${SENZING_APT_INSTALL_PACKAGE_PARAMETER} \
        https://github.com/Senzing/docker-installer.git
    ```

## Run Docker image

1. Specify where to install Senzing on local system.
   Example:

    ```console
    export SENZING_OPT_DIR=/opt/my-senzing
    ```

1. Run the `docker run` command.
   Example:

    ```console
    docker run \
        --volume ${SENZING_OPT_DIR}:/opt/senzing \
        ${SENZING_DOCKER_IMAGE_TAG}
    ```

## Advanced

### Configuration

Configuration values specified by environment variable or command line parameter.

- **[SENZING_ACCEPT_EULA](https://github.com/Senzing/knowledge-base/blob/master/lists/environment-variables.md#senzing_accept_eula)**

## Errors

1. See [docs/errors.md](docs/errors.md).

## References
