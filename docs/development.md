# docker-installer development

**Note:** This has been tested on Linux and Darwin/macOS.
It has not been tested on Windows.

## Prerequisites for development

:thinking: The following tasks need to be complete before proceeding.
These are "one-time tasks" which may already have been completed.

1. The following software programs need to be installed:
    1. [git]
    1. [make]
    1. [docker]

## Install Git repository

1. Identify git repository.

    ```console
    export GIT_ACCOUNT=senzing-garage
    export GIT_REPOSITORY=docker-installer
    export GIT_ACCOUNT_DIR=~/${GIT_ACCOUNT}.git
    export GIT_REPOSITORY_DIR="${GIT_ACCOUNT_DIR}/${GIT_REPOSITORY}"

    ```

1. Using the environment variables values just set, follow
   steps in [clone-repository] to install the Git repository.

## Build

### Build latest senzingapi-runtime

1. **Production:** Build Docker image from latest Senzing production version.
   Example:

    ```console
    cd ${GIT_REPOSITORY_DIR}
    make docker-build

    ```

    Inspect container.
    Example:

    ```console
    docker run -it --user 0 --rm senzing/installer-senzingapi-runtime:latest /bin/bash

    ```

1. **Staging:** Build Docker image from latest Senzing staging version.
   Example:

    ```console
    cd ${GIT_REPOSITORY_DIR}
    make docker-build-from-staging

    ```

    Inspect container.
    Example:

    ```console
    docker run -it --user 0 --rm senzing/installer-senzingapi-runtime-staging:latest /bin/bash

    ```

### Build versioned package from staging

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
    docker run --rm senzing/apt-staging list -a ${SENZING_PACKAGE}

    ```

1. :pencil2: From the list in the prior command, choose the desired Senzing version, modify the following, and run.
   Example:

    ```console
    export SENZING_PACKAGE_VERSION="4.0.0-00000"

    ```

1. Build Docker image from latest Senzing production version.
   Example:

    ```console
    cd ${GIT_REPOSITORY_DIR}
    make docker-build-from-staging

    ```

    Inspect container.
    Example:

    ```console
    docker run -it --user 0 --rm senzing/installer-${SENZING_PACKAGE}-staging:${SENZING_PACKAGE_VERSION} /bin/bash

    ```

## Run

1. :pencil2: Identify the Senzing package and version from prior step.
   Example:

    ```console
    export SENZING_PACKAGE=senzingapi-runtime
    export SENZING_PACKAGE_VERSION="4.0.0-00000"

    ```

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

1. **Production:** Run the [docker run] command.
   Example:

    ```console
    docker run \
        --rm \
        --volume ${SENZING_OPT_SENZING_DIR}:/opt/senzing \
        senzing/installer-${SENZING_PACKAGE}:${SENZING_PACKAGE_VERSION}

    ```

1. **Staging:** Run the [docker run] command.
   Example:

    ```console
    docker run \
        --rm \
        --volume ${SENZING_OPT_SENZING_DIR}:/opt/senzing \
        senzing/installer-${SENZING_PACKAGE}-staging:${SENZING_PACKAGE_VERSION}

    ```

1. The `${SENZING_OPT_SENZING_DIR}` directory will contain the extracted Senzing package.
   Example:

    ```console
    tree ${SENZING_OPT_SENZING_DIR}
    ```

## References

[clone-repository]: https://github.com/senzing-garage/knowledge-base/blob/main/HOWTO/clone-repository.md
[docker run]: https://docs.docker.com/engine/reference/commandline/run/
[docker]: https://github.com/senzing-garage/knowledge-base/blob/main/WHATIS/docker.md
[git]: https://github.com/senzing-garage/knowledge-base/blob/main/WHATIS/git.md
[make]: https://github.com/senzing-garage/knowledge-base/blob/main/WHATIS/make.md
