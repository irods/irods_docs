# Installation

iRODS is provided in binary form in a collection of interdependent packages.

An iRODS server has a 'catalog_service_role' and can be configured as either a 'provider' or a 'consumer'.  These two roles take the place of the previous
compile-time option which provided two separate binaries, formerly known as 'iCAT server' and 'Resource server'.  Since 4.2, a single server can be configured to serve in either role.

 - **Provider** - A server in the 'provider' role manages a Zone, handles the database connection to the iCAT metadata catalog (which could be either co-resident or hosted on a separate machine or cluster), and can provide [Storage Resources](../plugins/composable_resources.md#storage-resources).  At this time, an iRODS Zone will usually have exactly one server in the 'catalog_service_role' of 'provider'.  Configuring iRODS for High Availability is possible with additional work, and would include having more than one server in this role.
 - **Consumer** - A server in the 'consumer' role connects to an existing Zone and can provide additional storage resource(s).  An iRODS Zone can have zero or more servers in the 'catalog_service_role' of 'consumer'.

A 'provider' is just a 'consumer' that also provides the central point of coordination for the Zone and manages the metadata.

The simplest iRODS installation consists of one iRODS server in the 'provider' role.

## Catalog Service Provider

The irods-server package installs the iRODS binaries and management scripts.

Additionally, an iRODS database plugin is required. iRODS uses this plugin (see [Pluggable Database](../plugins/pluggable_database.md)) to communicate with the desired database management system (e.g. Oracle, MySQL, PostgreSQL).

The iRODS setup script (which also configures the iRODS database plugin) requires database connection information about an existing database.  iRODS neither creates nor manages a database instance itself, just the tables within the database. Therefore, the database instance should be created and configured before installing iRODS.

### Database Setup

iRODS can use many different database configurations.  Local co-resident database examples are included below:

#### PostgreSQL on Ubuntu:

~~~
$ (sudo) su - postgres
postgres$ psql
psql> CREATE USER irods WITH PASSWORD 'testpassword';
psql> CREATE DATABASE "ICAT";
psql> GRANT ALL PRIVILEGES ON DATABASE "ICAT" TO irods;
psql> ALTER DATABASE "ICAT" OWNER TO irods;
~~~

Confirmation of the permissions can be viewed with ``\l`` within the ``psql`` console:

~~~
 psql> \l
                                                   List of databases
   Name    |  Owner   | Encoding | Locale Provider | Collate |  Ctype  | ICU Locale | ICU Rules |   Access privileges   
-----------+----------+----------+-----------------+---------+---------+------------+-----------+-----------------------
 ICAT      | irods    | UTF8     | libc            | C.UTF-8 | C.UTF-8 |            |           | =Tc/irods            +
           |          |          |                 |         |         |            |           | irods=CTc/irods

 ...
 (N rows)
~~~

!!! Note
    A default system PostgreSQL installation on Ubuntu does not listen on a TCP port, it only listens on a local socket.  If your PostgreSQL server is localhost, use 'localhost' for "Database Server's Hostname or IP" in setup_irods.py below.

!!! Note
    A default system PostgreSQL installation may be configured for ident-based authentication which means the unix service account name must match the database user name.  iRODS currently assumes this is the case.

#### MySQL on Ubuntu:

~~~
$ mysql
mysql> CREATE DATABASE ICAT;
mysql> CREATE USER 'irods'@'localhost' IDENTIFIED BY 'testpassword';
mysql> GRANT ALL ON ICAT.* to 'irods'@'localhost';
~~~

Confirmation of the permissions can be viewed within the ``mysql`` console:

~~~
mysql> SHOW GRANTS FOR 'irods'@'localhost';
+--------------------------------------------------------------------------------------------------------------+
| Grants for irods@localhost                                                                                   |
+--------------------------------------------------------------------------------------------------------------+
| GRANT USAGE ON *.* TO 'irods'@'localhost' IDENTIFIED BY PASSWORD '*9F69E47E519D9CA02116BF5796684F7D0D45F8FA' |
| GRANT ALL PRIVILEGES ON `ICAT`.* TO 'irods'@'localhost'                                                      |
+--------------------------------------------------------------------------------------------------------------+
N rows in set (0.00 sec)

~~~

!!! Note
    While the MariaDB ODBC connector is more or less compatible with MySQL, iRODS does not currently support the MariaDB ODBC connector. Please use the MySQL ODBC connector instead. Additionally, iRODS is also incompatible with versions 8.1, 8.2, and 8.3 of the MySQL ODBC Connector. You'll need to use v8.0 or v8.4.

!!! Note
    MySQL v8.0 and v8.4 use a default transaction isolation level of `REPEATABLE-READ`. You'll need to change this to `READ-COMMITTED` so that iRODS operates properly. This setting needs to be set globally. One way to achieve this is by starting MySQL with `--transaction-isolation=READ-COMMITTED`. For more information, see [https://dev.mysql.com/doc/refman/8.0/en/innodb-transaction-isolation-levels.html](https://dev.mysql.com/doc/refman/8.0/en/innodb-transaction-isolation-levels.html).

!!! Note
    MySQL v8.0 and v8.4 queries operate in a case-insensitive manner by default. iRODS requires that data be handled in a case-sensitive way. One way to achieve this is by starting MySQL with a different character-set and collation scheme (e.g. `--character-set-server=utf8mb4` and `--collation-server=utf8mb4_0900_as_cs`). For more information, see [https://dev.mysql.com/doc/refman/8.0/en/charset.html](https://dev.mysql.com/doc/refman/8.0/en/charset.html).

#### MariaDB:

MariaDB can be used with the MySQL database plugin. Configuration is largely the same as MySQL (see the above section).

!!! Note
    iRODS does not currently support the MariaDB ODBC connector. Please use the MySQL ODBC connector instead. Additionally, iRODS is also incompatible with versions 8.1, 8.2, and 8.3 of the MySQL ODBC Connector. You'll need to use v8.0 or v8.4.

!!! Note
    MariaDB uses a default transaction isolation level of `REPEATABLE-READ`. You'll need to change this to `READ-COMMITTED` so that iRODS operates properly. This setting needs to be set globally. One way to achieve this is by starting MariaDB with `--transaction-isolation=READ-COMMITTED`. For more information, see [https://mariadb.com/kb/en/set-transaction/](https://mariadb.com/kb/en/set-transaction/).

!!! Note
    MariaDB queries operate in a case-insensitive manner by default. iRODS requires that data be handled in a case-sensitive way. One way to achieve this is by starting MariaDB with a different character-set and collation scheme (e.g. `--character-set-server=utf8mb4` and `--collation-server=utf8mb4_uca1400_as_cs`, or for versions of MariaDB prior to 10.10.1, `--character-set-server=utf8mb4` and `--collation-server=utf8mb4_bin`). For more information, see [https://mariadb.com/kb/en/character-sets/](https://mariadb.com/kb/en/character-sets/).

### iRODS Setup

!!! Important
    iRODS 4.3.0 has a dependency on the Python 3 library, [pyodbc](https://pypi.org/project/pyodbc/). Setup will fail if this library is not installed. CentOS 7 does not provide an RPM package for the Python 3 version of this library so it isn't declared as a dependency by the iRODS packages. Therefore, administrators must manually install the package. This can be accomplished by running the following: `sudo python3 -m pip install pyodbc`.

Installation of the iRODS server and PostgreSQL database plugin:

~~~
$ (sudo) apt-get install irods-server irods-database-plugin-postgres
~~~

On CentOS, some of the `irods-server` package dependencies can be satisfied from the EPEL repository provided by the `epel-release` package.

The `setup_irods.py` script below will prompt for, and then create, if necessary, a service account and service group which will own and operate the iRODS server binaries:

~~~
$ (sudo) python3 /var/lib/irods/scripts/setup_irods.py
~~~

The `setup_irods.py` script will ask for information in four (possibly five) sections:

1. Service Account
    - Service Account Name
    - Service Account Group
    - Catalog Service Role

2. Database Connection (if installing a 'provider')
    - ODBC Driver
    - Database Server's Hostname or IP
    - Database Server's Port
    - Database Name
    - Database User
    - Database Password
    - Stored Passwords Salt

3. iRODS Server Options
    - Zone Name
    - Zone Port
    - Parallel Port Range (Begin)
    - Parallel Port Range (End)
    - Schema Validation Base URI
    - iRODS Administrator Username

4. Keys and Passwords
    - zone_key
    - negotiation_key
    - iRODS Administrator Password

5. Vault Directory


More information about these values can be found in [Chapters 3 and 4 of the iRODS Beginner Training](https://github.com/irods/irods_training/tree/master/beginner).

!!! Note
    When running iRODS on pre-8.4 PostgreSQL, it is necessary to remove an optimized specific query which was not yet available:

~~~
irods@hostname:~/ $ iadmin rsq DataObjInCollReCur
~~~

## Default Environment

Once a server is up and running, the default environment can be shown:

~~~
irods@hostname:~/ $ ienv
irods_client_server_negotiation - request_server_negotiation
irods_client_server_policy - CS_NEG_REFUSE
irods_cwd - /tempZone/home/rods
irods_default_hash_scheme - SHA256
irods_default_number_of_transfer_threads - 4
irods_default_resource - demoResc
irods_encryption_algorithm - AES-256-CBC
irods_encryption_key_size - 32
irods_encryption_num_hash_rounds - 16
irods_encryption_salt_size - 8
irods_environment_file - /var/lib/irods/.irods/irods_environment.json
irods_home - /tempZone/home/rods
irods_host - <your.hostname>
irods_match_hash_policy - compatible
irods_maximum_size_for_single_buffer_in_megabytes - 32
irods_port - 1247
irods_session_environment_file - /var/lib/irods/.irods/irods_environment.json.14518
irods_transfer_buffer_size_for_parallel_transfer_in_megabytes - 4
irods_user_name - rods
irods_version - 4.2.0
irods_zone_name - tempZone
schema_name - irods_environment
schema_version - v3
~~~

## Unattended Install

iRODS can also be installed by providing a file matching the JSON schema found here:

- [https://github.com/irods/irods/blob/4.3.0/schemas/configuration/v4/unattended_installation.json.in](https://github.com/irods/irods/blob/4.3.0/schemas/configuration/v4/unattended_installation.json.in)

This form of installation is known as an **Unattended Install**. Using this form of setup can help with automated deployments.

!!! Important
    Care must be taken when using this form of installation as it will completely overwrite the **server_config.json** file and the service account's **irods_environment.json** file. This can lead to a non-functional server if the configuration files and database do not align. For that reason, it is highly recommended that backups of the configuration files mentioned be created first.

To perform an **Unattended Install**, you'd run the following:
```bash
$ (sudo) python3 /var/lib/irods/scripts/setup_irods.py --json_configuration_file /path/to/your/json/input/file
```

Below you'll find examples showing what the input file might contain for a [Catalog Service Provider](#input-file-for-catalog-service-provider) and [Catalog Service Consumer](#input-file-for-catalog-service-consumer).

### Input file for Catalog Service Provider
```json
{
    "admin_password": "rods",
    "default_resource_directory": "/var/lib/irods/Vault",
    "default_resource_name": "demoResc",
    "host_system_information": {
        "service_account_user_name": "irods",
        "service_account_group_name": "irods"
    },
    "service_account_environment": {
        "irods_client_server_negotiation": "request_server_negotiation",
        "irods_client_server_policy": "CS_NEG_REFUSE",
        "irods_connection_pool_refresh_time_in_seconds": 300,
        "irods_cwd": "/tempZone/home/rods",
        "irods_default_hash_scheme": "SHA256",
        "irods_default_number_of_transfer_threads": 4,
        "irods_default_resource": "demoResc",
        "irods_encryption_algorithm": "AES-256-CBC",
        "irods_encryption_key_size": 32,
        "irods_encryption_num_hash_rounds": 16,
        "irods_encryption_salt_size": 8,
        "irods_home": "/tempZone/home/rods",
        "irods_host": "irods-provider",
        "irods_match_hash_policy": "compatible",
        "irods_maximum_size_for_single_buffer_in_megabytes": 32,
        "irods_port": 1247,
        "irods_transfer_buffer_size_for_parallel_transfer_in_megabytes": 4,
        "irods_user_name": "rods",
        "irods_zone_name": "tempZone",
        "schema_name": "service_account_environment",
        "schema_version": "v4"
    },
    "server_config": {
        "advanced_settings": {
            "checksum_read_buffer_size_in_bytes": 1048576,
            "default_number_of_transfer_threads": 4,
            "default_temporary_password_lifetime_in_seconds": 120,
            "delay_rule_executors": [],
            "delay_server_sleep_time_in_seconds": 30,
            "dns_cache": {
                "eviction_age_in_seconds": 3600,
                "cache_clearer_sleep_time_in_seconds": 600,
                "shared_memory_size_in_bytes": 5000000
            },
            "hostname_cache": {
                "eviction_age_in_seconds": 3600,
                "cache_clearer_sleep_time_in_seconds": 600,
                "shared_memory_size_in_bytes": 2500000
            },
            "maximum_size_for_single_buffer_in_megabytes": 32,
            "maximum_size_of_delay_queue_in_bytes": 0,
            "maximum_temporary_password_lifetime_in_seconds": 1000,
            "migrate_delay_server_sleep_time_in_seconds": 5,
            "number_of_concurrent_delay_rule_executors": 4,
            "stacktrace_file_processor_sleep_time_in_seconds": 10,
            "transfer_buffer_size_for_parallel_transfer_in_megabytes": 4,
            "transfer_chunk_size_for_parallel_transfer_in_megabytes": 40
        },
        "catalog_provider_hosts": [
            "irods-provider"
        ],
        "catalog_service_role": "provider",
        "client_api_allowlist_policy": "enforce",
        "controlled_user_connection_list": {
            "control_type": "denylist",
            "users": []
        },
        "default_dir_mode": "0750",
        "default_file_mode": "0600",
        "default_hash_scheme": "SHA256",
        "default_resource_name": "demoResc",
        "environment_variables": {},
        "federation": [],
        "host": "irods-provider",
        "host_access_control": {
            "access_entries": []
        },
        "host_resolution": {
            "host_entries": []
        },
        "log_level": {
            "agent": "info",
            "agent_factory": "info",
            "api": "info",
            "authentication": "info",
            "database": "info",
            "delay_server": "info",
            "genquery2": "info",
            "legacy": "info",
            "microservice": "info",
            "network": "info",
            "resource": "info",
            "rule_engine": "info",
            "server": "info",
            "sql": "info"
        },
        "match_hash_policy": "compatible",
        "negotiation_key": "32_byte_server_negotiation_key__",
        "plugin_configuration": {
            "authentication": {},
            "database": {
                "postgres": {
                    "db_host": "catalog",
                    "db_name": "ICAT",
                    "db_odbc_driver": "PostgreSQL ANSI",
                    "db_password": "testpassword",
                    "db_port": 5432,
                    "db_username": "irods"
                }
            },
            "network": {},
            "resource": {},
            "rule_engines": [
                {
                    "instance_name": "irods_rule_engine_plugin-irods_rule_language-instance",
                    "plugin_name": "irods_rule_engine_plugin-irods_rule_language",
                    "plugin_specific_configuration": {
                        "re_data_variable_mapping_set": [
                            "core"
                        ],
                        "re_function_name_mapping_set": [
                            "core"
                        ],
                        "re_rulebase_set": [
                            "core"
                        ],
                        "regexes_for_supported_peps": [
                            "ac[^ ]*",
                            "msi[^ ]*",
                            "[^ ]*pep_[^ ]*_(pre|post|except|finally)"
                        ]
                    },
                    "shared_memory_instance": "irods_rule_language_rule_engine"
                },
                {
                    "instance_name": "irods_rule_engine_plugin-cpp_default_policy-instance",
                    "plugin_name": "irods_rule_engine_plugin-cpp_default_policy",
                    "plugin_specific_configuration": {}
                }
            ]
        },
        "rule_engine_namespaces": [
            ""
        ],
        "schema_name": "server_config",
        "schema_validation_base_uri": "file:///var/lib/irods/configuration_schemas",
        "schema_version": "v4",
        "server_port_range_end": 20199,
        "server_port_range_start": 20000,
        "xmsg_port": 1279,
        "zone_auth_scheme": "native",
        "zone_key": "TEMPORARY_ZONE_KEY",
        "zone_name": "tempZone",
        "zone_port": 1247,
        "zone_user": "rods"
    }
}
```

### Input file for Catalog Service Consumer
```json
{
    "admin_password": "rods",
    "default_resource_directory": "/var/lib/irods/Vault",
    "default_resource_name": "otherResc",
    "host_system_information": {
        "service_account_user_name": "irods",
        "service_account_group_name": "irods"
    },
    "service_account_environment": {
        "irods_client_server_negotiation": "request_server_negotiation",
        "irods_client_server_policy": "CS_NEG_REFUSE",
        "irods_connection_pool_refresh_time_in_seconds": 300,
        "irods_cwd": "/tempZone/home/rods",
        "irods_default_hash_scheme": "SHA256",
        "irods_default_number_of_transfer_threads": 4,
        "irods_default_resource": "otherResc",
        "irods_encryption_algorithm": "AES-256-CBC",
        "irods_encryption_key_size": 32,
        "irods_encryption_num_hash_rounds": 16,
        "irods_encryption_salt_size": 8,
        "irods_home": "/tempZone/home/rods",
        "irods_host": "irods-consumer",
        "irods_match_hash_policy": "compatible",
        "irods_maximum_size_for_single_buffer_in_megabytes": 32,
        "irods_port": 1247,
        "irods_transfer_buffer_size_for_parallel_transfer_in_megabytes": 4,
        "irods_user_name": "rods",
        "irods_zone_name": "tempZone",
        "schema_name": "service_account_environment",
        "schema_version": "v4"
    },
    "server_config": {
        "advanced_settings": {
            "checksum_read_buffer_size_in_bytes": 1048576,
            "default_number_of_transfer_threads": 4,
            "default_temporary_password_lifetime_in_seconds": 120,
            "delay_rule_executors": [],
            "delay_server_sleep_time_in_seconds": 30,
            "dns_cache": {
                "eviction_age_in_seconds": 3600,
                "cache_clearer_sleep_time_in_seconds": 600,
                "shared_memory_size_in_bytes": 5000000
            },
            "hostname_cache": {
                "eviction_age_in_seconds": 3600,
                "cache_clearer_sleep_time_in_seconds": 600,
                "shared_memory_size_in_bytes": 2500000
            },
            "maximum_size_for_single_buffer_in_megabytes": 32,
            "maximum_size_of_delay_queue_in_bytes": 0,
            "maximum_temporary_password_lifetime_in_seconds": 1000,
            "migrate_delay_server_sleep_time_in_seconds": 5,
            "number_of_concurrent_delay_rule_executors": 4,
            "stacktrace_file_processor_sleep_time_in_seconds": 10,
            "transfer_buffer_size_for_parallel_transfer_in_megabytes": 4,
            "transfer_chunk_size_for_parallel_transfer_in_megabytes": 40
        },
        "catalog_provider_hosts": [
            "irods-provider"
        ],
        "catalog_service_role": "consumer",
        "client_api_allowlist_policy": "enforce",
        "controlled_user_connection_list": {
            "control_type": "denylist",
            "users": []
        },
        "default_dir_mode": "0750",
        "default_file_mode": "0600",
        "default_hash_scheme": "SHA256",
        "default_resource_name": "otherResc",
        "environment_variables": {},
        "federation": [],
        "host": "irods-consumer",
        "host_access_control": {
            "access_entries": []
        },
        "host_resolution": {
            "host_entries": []
        },
        "log_level": {
            "agent": "info",
            "agent_factory": "info",
            "api": "info",
            "authentication": "info",
            "database": "info",
            "delay_server": "info",
            "genquery2": "info",
            "legacy": "info",
            "microservice": "info",
            "network": "info",
            "resource": "info",
            "rule_engine": "info",
            "server": "info",
            "sql": "info"
        },
        "match_hash_policy": "compatible",
        "negotiation_key": "32_byte_server_negotiation_key__",
        "plugin_configuration": {
            "authentication": {},
            "network": {},
            "resource": {},
            "rule_engines": [
                {
                    "instance_name": "irods_rule_engine_plugin-irods_rule_language-instance",
                    "plugin_name": "irods_rule_engine_plugin-irods_rule_language",
                    "plugin_specific_configuration": {
                        "re_data_variable_mapping_set": [
                            "core"
                        ],
                        "re_function_name_mapping_set": [
                            "core"
                        ],
                        "re_rulebase_set": [
                            "core"
                        ],
                        "regexes_for_supported_peps": [
                            "ac[^ ]*",
                            "msi[^ ]*",
                            "[^ ]*pep_[^ ]*_(pre|post|except|finally)"
                        ]
                    },
                    "shared_memory_instance": "irods_rule_language_rule_engine"
                },
                {
                    "instance_name": "irods_rule_engine_plugin-cpp_default_policy-instance",
                    "plugin_name": "irods_rule_engine_plugin-cpp_default_policy",
                    "plugin_specific_configuration": {}
                }
            ]
        },
        "rule_engine_namespaces": [
            ""
        ],
        "schema_name": "server_config",
        "schema_validation_base_uri": "file:///var/lib/irods/configuration_schemas",
        "schema_version": "v4",
        "server_port_range_end": 20199,
        "server_port_range_start": 20000,
        "xmsg_port": 1279,
        "zone_auth_scheme": "native",
        "zone_key": "TEMPORARY_ZONE_KEY",
        "zone_name": "tempZone",
        "zone_port": 1247,
        "zone_user": "rods"
    }
}
```

## Non-Package Install (Run In Place)

iRODS can be compiled from source and run from the same directory.  Although this is not recommended for production deployment, it may be useful for testing, running multiple iRODS servers on the same system, running iRODS on systems without a package manager, and users who do not have administrator rights on their system.

In order to build from source, iRODS needs its external dependencies satisfied (see [https://github.com/irods/externals](https://github.com/irods/externals) for any platform-specific instructions):

Let's assume you were successful in building all external dependencies.

Update the **PATH** environment variable so that the newly built `cmake` binary can be used:

```bash
user@hostname:~/externals $ export IRODS_EXTERNALS=$PWD
user@hostname:~/externals $ export PATH=$IRODS_EXTERNALS/cmake3.21.4-0/bin:$PATH
```

iRODS requires a few more dependencies before it can be compiled. Install the packages corresponding to the following:

- PAM Development Library
- Kerberos Development Library

Then, when building iRODS itself, CMake must be called with the appropriate flags:

```bash
user@hostname:~ $ git clone https://github.com/irods/irods
user@hostname:~ $ cd irods
user@hostname:~/irods $ git checkout <version-of-irods>
user@hostname:~/irods $ export IRODS_INSTALL_DIR=/path/to/the/non-package-root
user@hostname:~/irods $ mkdir build && cd build
user@hostname:~/irods/build $ cmake -DCMAKE_INSTALL_PREFIX=$IRODS_INSTALL_DIR -DIRODS_EXTERNALS_PACKAGE_ROOT=$IRODS_EXTERNALS ..
user@hostname:~/irods/build $ make non-package-install-postgres
```

The iCommands are a dependency of the iRODS server, and can be built with the following sequence:

```bash
user@hostname:~ $ git clone https://github.com/irods/irods_client_icommands
user@hostname:~ $ cd irods_client_icommands
user@hostname:~/irods_client_icommands $ git checkout <version-of-irods>
user@hostname:~/irods_client_icommands $ mkdir build && cd build
user@hostname:~/irods_client_icommands/build $ cmake -DCMAKE_INSTALL_PREFIX=$IRODS_INSTALL_DIR -DIRODS_DIR=$IRODS_INSTALL_DIR/lib/irods/cmake -DBUILD_DOCS=NO ..
user@hostname:~/irods_client_icommands/build $ make install
user@hostname:~/irods_client_icommands/build $ export LD_LIBRARY_PATH=$IRODS_INSTALL_DIR/lib:$IRODS_EXTERNALS/boost1.78.0-0/lib:$LD_LIBRARY_PATH
user@hostname:~/irods_client_icommands/build $ export PATH=$IRODS_INSTALL_DIR/bin:$IRODS_INSTALL_DIR/sbin:$PATH
```

Now that the system is built, you're going to need to install a few more dependencies for the setup script. Use the OS package manager (e.g. `apt`) to install the following:

- unixODBC runtime
- ODBC driver for your database

Use Python 3's `pip` to install the following packages (this step will require **root** privileges):

- jsonschema
- psutil
- pyodbc
- requests

Assuming you were successful in satisfying the dependencies and you have a running database, you're now ready to run the setup script. To do that, run the following:

```bash
user@hostname:~ $ cd <non-package-root>/var/lib/irods/scripts
user@hostname:<non-package-root>/var/lib/irods/scripts $ python3 setup_irods.py
```

### MacOSX

Installation of the iCommands on a MacOSX system requires the use of the "Non-Package Install" steps due to the lack of a system-level package manager.

# Quickstart

Successful installation will complete and result in a running iRODS server.  The iCommand ``ils`` will list your new iRODS administrator's empty home directory in the iRODS virtual filesystem:

~~~
irods@hostname:~/ $ ils
 /tempZone/home/rods:
~~~

When moving into production, you should cover the following steps as best practice:

## Changing the administrator account password

The default installation of iRODS comes with a single user account 'rods' that is also an admin account ('rodsadmin') with the password 'rods'.  You should change the password before letting anyone else into the system:

~~~
irods@hostname:~/ $ iadmin moduser rods password <newpassword>
~~~

To make sure everything succeeded, you will need to re-authenticate and check the new connection:

~~~
irods@hostname:~/ $ iinit
Enter your current iRODS password:
irods@hostname:~/ $ ils
/tempZone/home/rods:
~~~

If you see an authentication or other error message here, please try again.  The password update only manipulates a single database value, and is independent of other changes to the system.

## Changing the Zone name

The default installation of iRODS comes with a Zone named 'tempZone'.  You probably want to change the Zone name to something more domain-specific:

~~~
irods@hostname:~/ $ iadmin modzone tempZone name <newzonename>
If you modify the local zone name, you and other users will need to
change your irods_environment.json files to use it, you may need to update
server_config.json and, if rules use the zone name, you'll need to update
core.re.  This command will update various tables with the new name
and rename the top-level collection.
Do you really want to modify the local zone name? (enter y or yes to do so):y
OK, performing the local zone rename
~~~

Once the Zone has been renamed, you will need to update two files, one for the 'server', and one for the 'client'.

For the server, you will need to update your `server_config.json` file with the new zone name (a single key/value pair):

~~~
irods@hostname:~/ $ grep zone_name /etc/irods/server_config.json
    "zone_name": "**<newzonename>**",
~~~

For the client, you will need to update your `irods_environment.json` file with the new zone name (three key/value pairs):

~~~
irods@hostname:~/ $ cat .irods/irods_environment.json
{
    "irods_client_server_negotiation": "request_server_negotiation",
    "irods_client_server_policy": "CS_NEG_REFUSE",
    "irods_cwd": "/**<newzonename>**/home/rods",
    "irods_default_hash_scheme": "SHA256",
    "irods_default_number_of_transfer_threads": 4,
    "irods_default_resource": "demoResc",
    "irods_encryption_algorithm": "AES-256-CBC",
    "irods_encryption_key_size": 32,
    "irods_encryption_num_hash_rounds": 16,
    "irods_encryption_salt_size": 8,
    "irods_home": "/**<newzonename>**/home/rods",
    "irods_host": "<your.hostname>",
    "irods_match_hash_policy": "compatible",
    "irods_maximum_size_for_single_buffer_in_megabytes": 32,
    "irods_port": 1247,
    "irods_transfer_buffer_size_for_parallel_transfer_in_megabytes": 4,
    "irods_user_name": "rods",
    "irods_zone_name": "**<newzonename>**",
    "schema_name": "irods_environment",
    "schema_version": "v3"
}
~~~

Now, the connection should be reset and you should be able to list your empty iRODS collection again:

~~~
irods@hostname:~/ $ iinit
Enter your current iRODS password:
irods@hostname:~/ $ ils
/<newzonename>/home/rods:
~~~

## Changing the zone_key and negotiation_key

iRODS 4.1+ servers use the `zone_key` and `negotiation_key` to mutually authenticate.  These two variables should be changed from their default values in `/etc/irods/server_config.json`:

~~~
"zone_key": "TEMPORARY_ZONE_KEY",
"negotiation_key":   "32_byte_server_negotiation_key__",
~~~

The `zone_key` can be up to 49 alphanumeric characters long and cannot include a hyphen.  The 'negotiation_key' must be exactly 32 alphanumeric bytes long.  These values need to be the same on all servers in the same Zone, or they will not be able to authenticate (see [Server Authentication](../system_overview/federation.md#server-authentication) for more information).

The following error will be logged if a negotiation_key is missing:

~~~
ERROR: client_server_negotiation_for_server - sent negotiation_key is empty
~~~

The following error will be logged when the negotiation_key values do not align and/or are not exactly 32 bytes long:

~~~
ERROR: client-server negotiation_key mismatch
~~~

## Add additional resource(s)

The default installation of iRODS comes with a single resource named 'demoResc' which stores its files in the `/var/lib/irods/Vault` directory.  You will want to create additional resources at disk locations of your choosing as the 'demoResc' may not have sufficient disk space available for your intended usage scenarios.  The following command will create a basic 'unixfilesystem' resource on the designated host at the designated full path:

~~~
irods@hostname:~/ $ iadmin mkresc <newrescname> unixfilesystem <fully.qualified.domain.name>:</full/path/to/new/vault>
~~~

Additional information about creating resources can be found with:

~~~
irods@hostname:~/ $ iadmin help mkresc
 mkresc Name Type [Host:Path] [ContextString] (make Resource)
Create (register) a new coordinating or storage resource.

Name is the name of the new resource.
Type is the resource type.
Host is the DNS host name.
Path is the defaultPath for the vault.
ContextString is any contextual information relevant to this resource.
  (semi-colon separated key=value pairs e.g. "a=b;c=d")

A ContextString can be added to a coordinating resource (where there is
no hostname or vault path to be set) by explicitly setting the Host:Path
to an empty string ('').
~~~

Creating new resources does not make them default for any existing or new users.  You will need to make sure that default resources are properly set for newly ingested files.

## Add additional user(s)

The default installation of iRODS comes with a single user 'rods' which is a designated 'rodsadmin' type user account.  You will want to create additional user accounts (of type 'rodsuser') and set their passwords before allowing connections to your new Zone:

~~~
irods@hostname:~/ $ iadmin mkuser <newusername> rodsuser

irods@hostname:~/ $ iadmin lu
rods#tempZone
<newusername>#tempZone

irods@hostname:~/ $ iadmin help mkuser
 mkuser Name[#Zone] Type (make user)
Create a new iRODS user in the ICAT database

Name is the user name to create
Type is the user type (see 'lt user_type' for a list)
Zone is the user's zone (for remote-zone users)

Tip: Use moduser to set a password or other attributes,
     use 'aua' to add a user auth name (GSI DN or Kerberos Principal name)
~~~

It is best to change your Zone name before adding new users as any existing users would need to be informed of the new connection information and changes that would need to be made to their local irods_environment.json files.

