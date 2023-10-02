FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
        bison \
        cmake \
        flex \
        g++ \
        git \
        gnupg \
        lsb-release \
        make \
        nano \
        python3 \
        python3-pip \
        python3-venv \
        rsync \
        tig \
        wget \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/*

RUN wget -qO- https://packages.irods.org/irods-signing-key.asc | tee /etc/apt/trusted.gpg.d/renci-irods-signing-key.asc && \
    echo "deb [arch=amd64] https://packages.irods.org/apt/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/renci-irods.list && \
    wget -qO- https://core-dev.irods.org/irods-core-dev-signing-key.asc | tee /etc/apt/trusted.gpg.d/renci-irods-core-dev-signing-key.asc && \
    echo "deb [arch=amd64] https://core-dev.irods.org/apt/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/renci-irods-core-dev.list

RUN apt-get update && \
    apt-get install -y \
        irods-icommands \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/*

RUN mkdir -p /root/.irods && \
    echo "{}" | tee /root/.irods/irods_environment.json

COPY run_make.sh /run_make.sh
ENTRYPOINT ["bash", "/run_make.sh"]
