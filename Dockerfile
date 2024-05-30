ARG BASE_IMAGE=debian:11.9-slim@sha256:0e75382930ceb533e2f438071307708e79dc86d9b8e433cc6dd1a96872f2651d
FROM ${BASE_IMAGE} as builder

ENV REFRESHED_AT=2024-05-22

# ACCEPT_EULA and SENZING_ACCEPT_EULA to be replaced by --build-arg

ARG ACCEPT_EULA=no
ARG SENZING_ACCEPT_EULA=no
ARG SENZING_APT_INSTALL_PACKAGE="senzingapi"
ARG SENZING_APT_REPOSITORY_URL="https://senzing-production-apt.s3.amazonaws.com/senzingrepo_2.0.0-1_all.deb"
ARG SENZING_DATA_VERSION=5.0.0

# -----------------------------------------------------------------------------
# Stage: builder
# -----------------------------------------------------------------------------

# Need to be root to do "apt" operations.

USER root

# Eliminate warning messages.

ENV TERM=xterm

# Install packages via apt-get.

RUN apt-get update \
  && apt-get -y install \
  curl \
  gnupg \
  wget

# Install Senzing repository index.

RUN curl \
  --output /senzingrepo_2.0.0-1_all.deb \
  ${SENZING_APT_REPOSITORY_URL} \
  && apt-get -y install \
  /senzingrepo_2.0.0-1_all.deb \
  && apt-get update \
  && rm /senzingrepo_2.0.0-1_all.deb

# Install Senzing package.
#   Note: The system location for "data" should be /opt/senzing/data, hence the "mv" command.

RUN apt-get -y install ${SENZING_APT_INSTALL_PACKAGE} \
  && mv /opt/senzing/data/${SENZING_DATA_VERSION}/* /opt/senzing/data/

HEALTHCHECK CMD sudo yum list installed | grep ${SENZING_APT_INSTALL_PACKAGE}

# Install senzing_governor.py.

RUN curl -X GET \
  --output /opt/senzing/g2/python/senzing_governor.py \
  https://raw.githubusercontent.com/Senzing/governor-postgresql-transaction-id/main/senzing_governor.py

# Support for msodbcsql17.

RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
  && curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list \
  && apt-get update \
  && apt-get -y install msodbcsql17 || true \
  && mkdir -p /opt/microsoft

# -----------------------------------------------------------------------------
# Stage: Final
# -----------------------------------------------------------------------------

FROM ${BASE_IMAGE} AS runner

ENV REFRESHED_AT=2024-05-22

LABEL Name="senzing/installer" \
  Maintainer="support@senzing.com" \
  Version="1.3.5"

# Finally, make the container a non-root container again.

USER 1001

# Copy files from repository.

COPY ./rootfs /

# Copy files from builder.

COPY --from=builder /opt/senzing     /opt/local-senzing
COPY --from=builder /opt/microsoft   /opt/local-microsoft

# Runtime command:  Copy the baked in files to mounted volume(s)

ENTRYPOINT ["/app/docker-entrypoint.sh"]
