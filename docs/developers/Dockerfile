FROM  ubuntu:18.04
RUN   apt-get update
RUN   DEBIAN_FRONTEND=noninteractive apt-get -y install postgresql sudo wget gnupg2 git tig
SHELL ["bash","-c"]
RUN   service postgresql start ; \
      su - postgres -c "psql" <<<" CREATE USER irods WITH PASSWORD 'testpassword'; \
      CREATE DATABASE \"ICAT\"; \
      GRANT ALL PRIVILEGES ON DATABASE \"ICAT\" TO irods;"
RUN   wget -qO - https://packages.irods.org/irods-signing-key.asc | sudo apt-key add - ;\
      echo "deb [arch=amd64] https://packages.irods.org/apt/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/renci-irods.list ;\
      sudo apt-get update
RUN   apt-get -y install irods-server irods-database-plugin-postgres
