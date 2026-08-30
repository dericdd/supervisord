ARG BASE_IMAGE=ubuntu:26.04
FROM ${BASE_IMAGE} AS supervisord

# >> Install Dependencies:
RUN \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
      supervisor \
      wget \
      zip \
      nano \
      gettext \
      procps \
      iproute2 \
      netcat-openbsd \
      less \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# >> Copy base entrypoint.sh script:
COPY --chmod=755 assets/entrypoint.sh /entrypoint.sh
RUN \
  mkdir /entrypoint.d && \
  chmod 755 /entrypoint.sh && \
  chmod 775 /entrypoint.d

# >> Copy HypervisorD Entrypoints:
# @important @note > SupervisorD needs to be executed last because it is the (only) running service.
COPY --chmod=755 assets/entrypoint-supervisord.sh /entrypoint.d/95-supervisord.sh

# >> Copy base healthcheck.sh script:
COPY --chmod=755 assets/healthcheck.sh /healthcheck.sh
RUN \
  mkdir /healthcheck.d && \
  chmod 755 /healthcheck.sh && \
  chmod 775 /healthcheck.d

# >> Copy SupervisorD HealthCheck:
COPY --chmod=755 assets/healthcheck-supervisord.sh /healthcheck.d/01-supervisord.sh

# >> Remove NoLogin Flag:
#    - NOTE: This is done to remove the nologin flag that seems to be in < CentOS-8 that prevents logins. 
#    - NOTE: Leave these comments here for when we update to CentOS8... had to dig far for to solve this problem.
RUN rm -f /run/nologin

ENTRYPOINT ["/entrypoint.sh"]

# >> @note That HEALTHCHECK is not inherant if you extend this image. 
HEALTHCHECK \
  CMD /healthcheck.sh
