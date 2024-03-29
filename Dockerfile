ARG BASE_IMAGE=debian:11.9-slim@sha256:a165446a88794db4fec31e35e9441433f9552ae048fb1ed26df352d2b537cb96
FROM ${BASE_IMAGE} as builder

ENV REFRESHED_AT=2024-03-18

LABEL Name="senzing/installer" \
      Maintainer="support@senzing.com" \
      Version="1.3.4"

# ACCEPT_EULA and SENZING_ACCEPT_EULA to be replaced by --build-arg

ARG ACCEPT_EULA=no
ARG SENZING_ACCEPT_EULA=no
ARG SENZING_APT_INSTALL_PACKAGE="senzingapi"
ARG SENZING_APT_REPOSITORY_URL="https://senzing-production-apt.s3.amazonaws.com/senzingrepo_1.0.1-1_all.deb"
ARG SENZING_DATA_VERSION=4.0

# -----------------------------------------------------------------------------
# Stage: builder
# -----------------------------------------------------------------------------

# Need to be root to do "apt" operations.

USER root

# Eliminate warning messages.

ENV TERM=xterm

# Install packages via apt.

RUN apt update \
 && apt-get -y install \
        curl \
        gnupg \
        wget

# Install Senzing repository index.

RUN curl \
      --output /senzingrepo_1.0.1-1_all.deb \
      ${SENZING_APT_REPOSITORY_URL} \
 && apt -y install \
      /senzingrepo_1.0.1-1_all.deb \
 && apt update \
 && rm /senzingrepo_1.0.1-1_all.deb

# Install Senzing package.
#   Note: The system location for "data" should be /opt/senzing/data, hence the "mv" command.

RUN apt -y install ${SENZING_APT_INSTALL_PACKAGE} \
 && mv /opt/senzing/data/${SENZING_DATA_VERSION}/* /opt/senzing/data/

# Install senzing_governor.py.

RUN curl -X GET \
    --output /opt/senzing/g2/python/senzing_governor.py \
    https://raw.githubusercontent.com/Senzing/governor-postgresql-transaction-id/main/senzing_governor.py

# Support for msodbcsql17.

RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
 && curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list \
 && apt-get update \
 && apt -y install msodbcsql17 || true \
 && mkdir -p /opt/microsoft

# -----------------------------------------------------------------------------
# Stage: Final
# -----------------------------------------------------------------------------

FROM ${BASE_IMAGE} AS runner

ENV REFRESHED_AT=2024-03-18

LABEL Name="senzing/installer" \
      Maintainer="support@senzing.com" \
      Version="1.3.4"

# Finally, make the container a non-root container again.

USER 1001

# Copy files from repository.

COPY ./rootfs /

# Copy files from builder.

COPY --from=builder /opt/senzing     /opt/local-senzing
COPY --from=builder /opt/microsoft   /opt/local-microsoft

# Runtime command:  Copy the baked in files to mounted volume(s)

ENTRYPOINT ["/app/docker-entrypoint.sh"]
