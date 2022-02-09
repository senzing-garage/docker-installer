ARG BASE_IMAGE=debian:11.2-slim@sha256:4c25ffa6ef572cf0d57da8c634769a08ae94529f7de5be5587ec8ce7b9b50f9c
FROM ${BASE_IMAGE} as builder

ENV REFRESHED_AT=2022-02-09

LABEL Name="senzing/installer" \
      Maintainer="support@senzing.com" \
      Version="1.0.2"

# SENZING_ACCEPT_EULA to be replaced by --build-arg

ARG SENZING_ACCEPT_EULA=no
ARG SENZING_APT_INSTALL_PACKAGE="senzingapi"

# -----------------------------------------------------------------------------
# Stage: builder
# -----------------------------------------------------------------------------

# Need to be root to do "apt" operations.

USER root

# eliminate a couple of warning messages.
ENV TERM=xterm

# Install packages via apt.

RUN apt update \
 && apt -y install \
        # apt-transport-https \
        curl \
        gnupg \
        # sudo \
        wget

# Install Senzing repository index.

RUN curl \
        --output /senzingrepo_1.0.0-1_amd64.deb \
        https://senzing-production-apt.s3.amazonaws.com/senzingrepo_1.0.0-1_amd64.deb \
 && apt -y install /senzingrepo_1.0.0-1_amd64.deb \
 && apt update
#  && rm /senzingrepo_1.0.0-1_amd64.deb

# Install Senzing package.
#   Note: The system location for "data" should be /opt/senzing/data, hence the "mv" command.

RUN apt -y install ${SENZING_APT_INSTALL_PACKAGE} \
 && mv /opt/senzing/data/2.0.0/* /opt/senzing/data/
#  && mv /opt/senzing /opt/local-senzing

# -----------------------------------------------------------------------------
# Stage: Final
# -----------------------------------------------------------------------------

FROM ${BASE_IMAGE} AS runner

LABEL Name="senzing/installer" \
      Maintainer="support@senzing.com" \
      Version="1.0.2"


# Finally, make the container a non-root container again.

USER 1001

# Copy files from builder.

COPY --from=builder /opt/senzing /opt/local-senzing

# Runtime command:  Copy the baked in Senzing to mounted volume(s)

CMD ["cp", "--archive", "/opt/local-senzing/.", "/opt/senzing"]
