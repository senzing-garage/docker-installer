ARG BASE_IMAGE=debian:13-slim@sha256:a347fd7510ee31a84387619a492ad6c8eb0af2f2682b916ff3e643eb076f925a
FROM ${BASE_IMAGE} AS builder

ENV REFRESHED_AT=2025-09-02

# ACCEPT_EULA and SENZING_ACCEPT_EULA to be replaced by --build-arg

ARG ACCEPT_EULA=no
ARG SENZING_ACCEPT_EULA=no
ARG SENZING_APT_INSTALL_PACKAGE="senzingsdk-runtime"
ARG SENZING_APT_REPOSITORY_URL="https://senzing-production-apt.s3.amazonaws.com/senzingrepo_2.0.1-1_all.deb"

# -----------------------------------------------------------------------------
# Stage: builder
# -----------------------------------------------------------------------------

# Run as "root" for system installation.

USER root

# Eliminate warning messages.

ENV TERM=xterm

# Install packages via apt-get.

RUN apt-get update \
 && apt-get -y --no-install-recommends install \
      ca-certificates \
      curl \
      gnupg \
      tree \
      wget

# Install Senzing repository index and package.

RUN curl \
      --output /senzingrepo.deb \
      ${SENZING_APT_REPOSITORY_URL} \
  && apt-get -y install --no-install-recommends /senzingrepo.deb \
  && apt-get update \
  && rm /senzingrepo.deb \
  && apt-get -y --no-install-recommends install ${SENZING_APT_INSTALL_PACKAGE}

RUN tree /opt/senzing

HEALTHCHECK CMD sudo apt list ${SENZING_APT_INSTALL_PACKAGE}

# Support for msodbcsql17.

RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
 && curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list \
 && apt-get update \
 && apt-get -y --no-install-recommends install msodbcsql17 || true \
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
