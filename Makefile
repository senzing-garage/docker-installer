# Git variables

GIT_REPOSITORY_NAME := $(shell basename `git rev-parse --show-toplevel`)
GIT_VERSION := $(shell git describe --always --tags --long --dirty | sed -e 's/\-0//' -e 's/\-g.......//')

# Docker variables

MSSQL_ACCEPT_EULA ?= Y
SENZING_ACCEPT_EULA ?= I_ACCEPT_THE_SENZING_EULA
SENZING_APT_REPOSITORY_PRODUCTION ?= "https://senzing-production-apt.s3.amazonaws.com/senzingrepo_1.0.0-1_amd64.deb"
SENZING_APT_REPOSITORY_STAGING ?= "https://senzing-staging-apt.s3.amazonaws.com/senzingstagingrepo_1.0.0-1_amd64.deb"
SENZING_PACKAGE ?= senzingapi-runtime
SENZING_PACKAGE_VERSION ?= "latest"
DOCKER_IMAGE_NAME ?= senzing/installer-$(SENZING_PACKAGE)
SENZING_APT_INSTALL_PACKAGE ?= "$(SENZING_PACKAGE)"

ifneq ($(SENZING_PACKAGE_VERSION), "latest")
	SENZING_APT_INSTALL_PACKAGE := "$(SENZING_APT_INSTALL_PACKAGE)=$(SENZING_PACKAGE_VERSION)"
endif

# -----------------------------------------------------------------------------
# The first "make" target runs as default.
# -----------------------------------------------------------------------------

.PHONY: default
default: help

# -----------------------------------------------------------------------------
# Docker-based builds
# -----------------------------------------------------------------------------

.PHONY: bob
bob:
	@echo $(DOCKER_IMAGE_NAME)
	@echo $(SENZING_APT_INSTALL_PACKAGE)
	@echo $(SENZING_PACKAGE_VERSION)


.PHONY: docker-build
docker-build:
	docker build \
		--build-arg ACCEPT_EULA=$(MSSQL_ACCEPT_EULA) \
		--build-arg SENZING_ACCEPT_EULA=$(SENZING_ACCEPT_EULA) \
		--build-arg SENZING_APT_INSTALL_PACKAGE=$(SENZING_APT_INSTALL_PACKAGE) \
		--no-cache \
		--tag $(DOCKER_IMAGE_NAME):$(SENZING_PACKAGE_VERSION) \
		.


.PHONY: docker-build-from-staging
docker-build-from-staging:
	docker build \
		--build-arg ACCEPT_EULA=$(MSSQL_ACCEPT_EULA) \
		--build-arg SENZING_ACCEPT_EULA=$(SENZING_ACCEPT_EULA) \
		--build-arg SENZING_APT_INSTALL_PACKAGE=$(SENZING_APT_INSTALL_PACKAGE) \
		--build-arg SENZING_APT_REPOSITORY=$(SENZING_APT_REPOSITORY_STAGING) \
		--no-cache \
		--tag $(DOCKER_IMAGE_NAME)-staging:$(SENZING_PACKAGE_VERSION) \
		.

# -----------------------------------------------------------------------------
# Clean up targets
# -----------------------------------------------------------------------------

.PHONY: docker-rmi-for-build
docker-rmi-for-build:
	-docker rmi --force \
		$(DOCKER_IMAGE_NAME)


.PHONY: clean
clean: docker-rmi-for-build

# -----------------------------------------------------------------------------
# Utility targets
# -----------------------------------------------------------------------------

.PHONY: help
help:
	@echo "List of make targets:"
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$' | xargs


.PHONY: print-make-variables
print-make-variables:
	@$(foreach V,$(sort $(.VARIABLES)), \
		$(if $(filter-out environment% default automatic, \
		$(origin $V)),$(info $V=$($V) ($(value $V)))))
