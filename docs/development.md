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

### Build latest

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

## References

[clone-repository]: https://github.com/senzing-garage/knowledge-base/blob/main/HOWTO/clone-repository.md
[docker]: https://github.com/senzing-garage/knowledge-base/blob/main/WHATIS/docker.md
[git]: https://github.com/senzing-garage/knowledge-base/blob/main/WHATIS/git.md
[make]: https://github.com/senzing-garage/knowledge-base/blob/main/WHATIS/make.md
