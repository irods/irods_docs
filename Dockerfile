#
# iRODS Build Documentation
#
FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN \
  apt-get update && \
  apt-get install -y \
    python3 \
    lsb-release \
    git \
    tig \
    nano \
    python3-venv \
    make \
    cmake \
    g++ \
    flex \
    bison \
    wget \
    gnupg \
    rsync \
  && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/*

RUN wget -qO - https://packages.irods.org/irods-signing-key.asc | apt-key add - && \
    echo "deb [arch=amd64] https://packages.irods.org/apt/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/renci-irods.list && \
    wget -qO - https://core-dev.irods.org/irods-core-dev-signing-key.asc | apt-key add - && \
    echo "deb [arch=amd64] https://core-dev.irods.org/apt/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/renci-irods-core-dev.list

RUN \
  apt-get update && \
  apt-get install -y irods-icommands && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/*

RUN \
  mkdir -p /root/.irods && \
  echo "{}" | tee /root/.irods/irods_environment.json

COPY . /irods_docs
RUN ["chmod", "+x", "/irods_docs/run_make.sh"]
ENTRYPOINT ["/irods_docs/run_make.sh"]
