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
~~~

Confirmation of the permissions can be viewed with ``\l`` within the ``psql`` console:

~~~
 psql> \l
                                   List of databases
    Name    |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges
 -----------+----------+----------+-------------+-------------+-----------------------
  ICAT      | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =Tc/postgres         +
            |          |          |             |             | postgres=CTc/postgres+
            |          |          |             |             | irods=CTc/postgres
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
    MySQL v5.7 uses a default transaction isolation level of `REPEATABLE-READ`. You'll need to change this to `READ-COMMITTED` so that iRODS operates properly. This setting needs to be set globally. One way to achieve this is by starting MySQL with `--transaction-isolation=READ-COMMITTED`. For more information, see [https://dev.mysql.com/doc/refman/5.7/en/innodb-transaction-isolation-levels.html](https://dev.mysql.com/doc/refman/5.7/en/innodb-transaction-isolation-levels.html).
    
!!! Note
    MySQL v5.7 queries operate in a case-insensitive manner by default. iRODS requires that data be handled in a case-sensitive way. One way to achieve this is by starting MySQL with a different character-set and collation scheme (e.g. `--character-set-server=latin1` and `--collation-server=latin1_general_cs`). Enabling UTF-8 support will require more than setting two options on startup and is out of scope for this document. For more information, see [https://dev.mysql.com/doc/refman/5.7/en/charset.html](https://dev.mysql.com/doc/refman/5.7/en/charset.html) and [https://dev.mysql.com/doc/refman/5.7/en/column-count-limit.html](https://dev.mysql.com/doc/refman/5.7/en/column-count-limit.html).

### iRODS Setup

Installation of the iRODS server and PostgreSQL database plugin:

~~~
$ (sudo) apt-get install irods-server irods-database-plugin-postgres
~~~

On CentOS, some of the `irods-server` package dependencies can be satisfied from the EPEL repository provided by the `epel-release` package.

The `setup_irods.py` script below will prompt for, and then create, if necessary, a service account and service group which will own and operate the iRODS server binaries:

~~~
$ (sudo) python /var/lib/irods/scripts/setup_irods.py
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
    - Control Plane Port
    - Schema Validation Base URI
    - iRODS Administrator Username

4. Keys and Passwords
    - zone_key
    - negotiation_key
    - Control Plane Key
    - iRODS Administrator Password

5. Vault Directory

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
irods_server_control_plane_encryption_algorithm - AES-256-CBC
irods_server_control_plane_encryption_num_hash_rounds - 16
irods_server_control_plane_key - 32_byte_server_control_plane_key
irods_server_control_plane_port - 1248
irods_session_environment_file - /var/lib/irods/.irods/irods_environment.json.14518
irods_transfer_buffer_size_for_parallel_transfer_in_megabytes - 4
irods_user_name - rods
irods_version - 4.2.0
irods_zone_name - tempZone
schema_name - irods_environment
schema_version - v3
~~~

## Non-Package Install (Run In Place)

iRODS can be compiled from source and run from the same directory.  Although this is not recommended for production deployment, it may be useful for testing, running multiple iRODS servers on the same system, running iRODS on systems without a package manager, and users who do not have administrator rights on their system.

In order to build from source, iRODS needs its external dependencies satisfied:

~~~
user@hostname:~/ $ export IRODS_EXTERNALS=/tmp/irods-externals
user@hostname:~/ $ git clone https://github.com/irods/externals $IRODS_EXTERNALS
user@hostname:~/ $ cd $IRODS_EXTERNALS
user@hostname:/tmp/irods-externals $ ./install_prerequisites.py
user@hostname:/tmp/irods-externals $ make
~~~

Use the newly built version of CMake:

~~~
user@hostname:/tmp/irods-externals $ export PATH=$IRODS_EXTERNALS/cmake3.5.2-0/bin:$PATH
~~~

Then, when building iRODS itself, CMake must be called with the appropriate flags:

~~~
user@hostname:~/irods/ $ export IRODS_INSTALL_DIR=/path/to/the/non-package-root
user@hostname:~/irods/ $ mkdir build
user@hostname:~/irods/build $ cmake -DCMAKE_INSTALL_PREFIX=$IRODS_INSTALL_DIR -DIRODS_EXTERNALS_PACKAGE_ROOT=$IRODS_EXTERNALS ../
user@hostname:~/irods/build $ make non-package-install-postgres
~~~

The iCommands are a dependency of the iRODS server, and can be built with the following sequence:

~~~
user@hostname:~/irods_client_icommands/build $ cmake -DCMAKE_INSTALL_PREFIX=$IRODS_INSTALL_DIR -DIRODS_DIR=$IRODS_INSTALL_DIR/usr/lib/irods/cmake ../
user@hostname:~/irods_client_icommands/build $ make install
user@hostname:~/irods_client_icommands/build $ export LD_LIBRARY_PATH=$IRODS_INSTALL_DIR/usr/lib
user@hostname:~/irods_client_icommands/build $ export PATH=$IRODS_INSTALL_DIR/usr/bin:$IRODS_INSTALL_DIR/usr/sbin:$PATH
~~~

After the system is built, the `setup_irods.py` script should be run, the same as a binary installation:

~~~
user@hostname:<non-package-root>/var/lib/irods $ python ./scripts/setup_irods.py
~~~

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
    "irods_server_control_plane_encryption_algorithm": "AES-256-CBC",
    "irods_server_control_plane_encryption_num_hash_rounds": 16,
    "irods_server_control_plane_key": "32_byte_server_control_plane_key",
    "irods_server_control_plane_port": 1248,
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

