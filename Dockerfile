ARG BASE_IMAGE=debian:12-slim@sha256:df52e55e3361a81ac1bead266f3373ee55d29aa50cf0975d440c2be3483d8ed3
FROM ${BASE_IMAGE} AS builder

ENV REFRESHED_AT=2025-09-02

# ACCEPT_EULA and SENZING_ACCEPT_EULA to be replaced by --build-arg

ARG ACCEPT_EULA=no
ARG SENZING_ACCEPT_EULA=no
ARG SENZING_APT_INSTALL_PACKAGE="senzingsdk-runtime"
ARG SENZING_APT_REPOSITORY_URL="https://senzing-production-apt.s3.amazonaws.com/senzingrepo_2.0.0-1_all.deb"

# -----------------------------------------------------------------------------
# Stage: builder
# -----------------------------------------------------------------------------

# Run as "root" for system installation.

USER root

# Eliminate warning messages.

ENV TERM=xterm

# Install packages via apt-get.

RUN apt-get update \
 && apt-get -y install \
      curl \
      gnupg \
      tree \
      wget

# Install Senzing repository index.

RUN curl \
      --output /senzingrepo_2.0.0-1_all.deb \
      ${SENZING_APT_REPOSITORY_URL} \
 && apt-get -y install /senzingrepo_2.0.0-1_all.deb \
 && apt-get update \
 && rm /senzingrepo_2.0.0-1_all.deb

# Install Senzing package.

RUN apt-get -y install ${SENZING_APT_INSTALL_PACKAGE}
RUN tree /opt/senzing

HEALTHCHECK CMD sudo yum list installed | grep ${SENZING_APT_INSTALL_PACKAGE}

# Support for msodbcsql17.

RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
 && curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list \
 && apt-get update \
 && apt-get -y install msodbcsql17 || true \
 && mkdir -p /opt/microsoft

# -----------------------------------------------------------------------------
# Stage: Final
# -----------------------------------------------------------------------------

FROM ${BASE_IMAGE} AS final
ENV REFRESHED_AT=2025-09-02
LABEL Name="senzing/installer" \
  Maintainer="support@senzing.com" \
  Version="2.0.1"

# Run as non-root container

USER 1001

# Copy files from repository.

COPY ./rootfs /

# Copy files from prior stage.

COPY --from=builder /opt/senzing     /opt/local-senzing
COPY --from=builder /opt/microsoft   /opt/local-microsoft
COPY --from=builder /etc/opt/senzing /opt/local-senzing/etc/opt/senzing

# Runtime execution:  Copy the baked in files to mounted volume(s)

ENTRYPOINT ["/app/docker-entrypoint.sh"]
