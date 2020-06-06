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

### Contents

1. [Expectations](#expectations)
1. [Demonstrate](#demonstrate)
    1. [EULA](#eula)
    1. [Docker volumes](#docker-volumes)
    1. [Docker network](#docker-network)
    1. [Docker user](#docker-user)
    1. [Database support](#database-support)
    1. [External database](#external-database)
    1. [Run Docker container](#run-docker-container)
1. [Develop](#develop)
    1. [Prerequisites for development](#prerequisites-for-development)
    1. [Clone repository](#clone-repository)
    1. [Build Docker image](#build-docker-image)
1. [Advanced](#advanced)
    1. [Configuration](#configuration)
1. [Errors](#errors)
1. [References](#references)

#### Legend

1. :thinking: - A "thinker" icon means that a little extra thinking may be required.
   Perhaps there are some choices to be made.
   Perhaps it's an optional step.
1. :pencil2: - A "pencil" icon means that the instructions may need modification before performing.
1. :warning: - A "warning" icon means that something tricky is happening, so pay attention.

## Expectations

- **Space:** This repository and demonstration require 6 GB free disk space.
- **Time:** Budget 40 minutes to get the demonstration up-and-running, depending on CPU and network speeds.
- **Background knowledge:** This repository assumes a working knowledge of:
  - [Docker](https://github.com/Senzing/knowledge-base/blob/master/WHATIS/docker.md)

## Demonstrate

### EULA

To use the Senzing code, you must agree to the End User License Agreement (EULA).

1. :warning: This step is intentionally tricky and not simply copy/paste.
   This ensures that you make a conscious effort to accept the EULA.
   Example:

    <code>export SENZING_ACCEPT_EULA="&lt;the value from [this link](https://github.com/Senzing/knowledge-base/blob/master/lists/environment-variables.md#senzing_accept_eula)&gt;"</code>

### Environment variables

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

### Build Docker image

1. Run the `docker build` command.
   Example:

    ```console
    docker build \
        --build-arg SENZING_ACCEPT_EULA=${SENZING_ACCEPT_EULA} \
        --tag ${SENZING_DOCKER_IMAGE_TAG} \
        ${SENZING_APT_INSTALL_PACKAGE_PARAMETER} \
        https://github.com/Senzing/docker-installer.git
    ```

### Run Docker image

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

## Develop

The following instructions are used when modifying and building the Docker image.

### Prerequisites for development

:thinking: The following tasks need to be complete before proceeding.
These are "one-time tasks" which may already have been completed.

1. The following software programs need to be installed:
    1. [git](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/install-git.md)
    1. [make](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/install-make.md)
    1. [docker](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/install-docker.md)

### Clone repository

For more information on environment variables,
see [Environment Variables](https://github.com/Senzing/knowledge-base/blob/master/lists/environment-variables.md).

1. Set these environment variable values:

    ```console
    export GIT_ACCOUNT=senzing
    export GIT_REPOSITORY=docker-installer
    export GIT_ACCOUNT_DIR=~/${GIT_ACCOUNT}.git
    export GIT_REPOSITORY_DIR="${GIT_ACCOUNT_DIR}/${GIT_REPOSITORY}"
    ```

1. Using the environment variables values just set, follow steps in [clone-repository](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/clone-repository.md) to install the Git repository.

### Build Docker image

1. **Option #1:** Using `docker` command and GitHub.

    ```console
    sudo docker build \
      --tag senzing/installer \
      https://github.com/senzing/docker-installer.git
    ```

1. **Option #2:** Using `docker` command and local repository.

    ```console
    cd ${GIT_REPOSITORY_DIR}
    sudo docker build --tag senzing/installer .
    ```

1. **Option #3:** Using `make` command.

    ```console
    cd ${GIT_REPOSITORY_DIR}
    sudo make docker-build
    ```

    Note: `sudo make docker-build-development-cache` can be used to create cached Docker layers.

## Advanced

### Configuration

Configuration values specified by environment variable or command line parameter.

- **[SENZING_ACCEPT_EULA](https://github.com/Senzing/knowledge-base/blob/master/lists/environment-variables.md#senzing_accept_eula)**

## Errors

1. See [docs/errors.md](docs/errors.md).

## References
