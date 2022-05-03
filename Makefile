# Git variables

GIT_REPOSITORY_NAME := $(shell basename `git rev-parse --show-toplevel`)
GIT_VERSION := $(shell git describe --always --tags --long --dirty | sed -e 's/\-0//' -e 's/\-g.......//')

# Docker variables

DOCKER_IMAGE_NAME ?= senzing/installer
DOCKER_IMAGE_TAG ?= $(GIT_REPOSITORY_NAME):$(GIT_VERSION)
MSSQL_ACCEPT_EULA ?= no
SENZING_ACCEPT_EULA ?= no
SENZING_APT_INSTALL_PACKAGE ?= senzingapi
SENZING_APT_REPOSITORY_PRODUCTION ?= "https://senzing-production-apt.s3.amazonaws.com/senzingrepo_1.0.0-1_amd64.deb"
SENZING_APT_REPOSITORY_STAGING ?= "https://senzing-staging-apt.s3.amazonaws.com/senzingstagingrepo_1.0.0-1_amd64.deb"
SENZING_DATA_VERSION ?= 3.0.0

# -----------------------------------------------------------------------------
# The first "make" target runs as default.
# -----------------------------------------------------------------------------

.PHONY: default
default: help

# -----------------------------------------------------------------------------
# Docker-based builds
# -----------------------------------------------------------------------------

.PHONY: docker-build
docker-build:
	docker build \
		--build-arg ACCEPT_EULA=$(MSSQL_ACCEPT_EULA) \
		--build-arg SENZING_ACCEPT_EULA=$(SENZING_ACCEPT_EULA) \
		--build-arg SENZING_APT_INSTALL_PACKAGE=$(SENZING_APT_INSTALL_PACKAGE) \
		--no-cache \
	    --tag $(DOCKER_IMAGE_NAME) \
		--tag $(DOCKER_IMAGE_NAME):$(GIT_VERSION) \
		.

.PHONY: docker-build-from-staging
docker-build-from-staging:
	docker build \
		--build-arg ACCEPT_EULA=$(MSSQL_ACCEPT_EULA) \		
		--build-arg SENZING_ACCEPT_EULA=$(SENZING_ACCEPT_EULA) \
		--build-arg SENZING_APT_INSTALL_PACKAGE=$(SENZING_APT_INSTALL_PACKAGE) \
		--build-arg SENZING_APT_REPOSITORY=$(SENZING_APT_REPOSITORY_STAGING) \
		--build-arg SENZING_DATA_VERSION=$(SENZING_DATA_VERSION) \
		--tag $(DOCKER_IMAGE_NAME) \
		--tag $(DOCKER_IMAGE_NAME):$(GIT_VERSION) \
		.

# -----------------------------------------------------------------------------
# Clean up targets
# -----------------------------------------------------------------------------

.PHONY: docker-rmi-for-build
docker-rmi-for-build:
	-docker rmi --force \
		$(DOCKER_IMAGE_NAME):$(GIT_VERSION) \
		$(DOCKER_IMAGE_NAME)


.PHONY: clean
clean: docker-rmi-for-build

# -----------------------------------------------------------------------------
# Help
# -----------------------------------------------------------------------------

.PHONY: help
help:
	@echo "List of make targets:"
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$' | xargs
