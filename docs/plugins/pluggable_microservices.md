#

iRODS has been modularized whereby existing iRODS 3.x functionality has been replaced and provided by small, interoperable plugins.  The first plugin functionality to be completed was pluggable microservices.  Pluggable microservices allow users to add new microservices to an existing iRODS server without recompiling the server or even restarting any running processes.  A microservice plugin contains a single compiled microservice shared object file to be found and loaded by the server.  Development examples can be found in the iRODS training repository under [advanced/irods_microservice_plugin_example](https://github.com/irods/irods_training/tree/master/advanced/irods_microservice_plugin_example).

A separate development package, irods-dev, contains the necessary header files to write your own microservice plugins (as well as any other type of iRODS plugin).
