#

The following configuration files control nearly all aspects of how an iRODS deployment functions. All JSON files validate against the  [configuration schemas in each installation](https://github.com/irods/irods/tree/main/schemas/configuration/v4).

## ~/.odbc.ini

This file, in the home directory of the unix service account (default 'irods'), defines the unixODBC connection details needed for the iCommands to communicate with the iCAT database. This file was created by the installer package and probably should not be changed.

## ~/.irods/.irodsA

This scrambled password file is saved after an `iinit` is run. If this file does not exist, then each iCommand will prompt for a password before authenticating with the iRODS server. If this file does exist, then each iCommand will read this file and use the contents as a cached password token and skip the password prompt. This file can be deleted manually or can be removed by running `iexit full`.

## /etc/irods/server_config.json

This file defines the behavior of the server Agent that answers individual requests coming into iRODS. It is created and populated by the installer package.

!!! IMPORTANT
    All configuration settings are required unless marked as optional. The value associated with a key represents the default value. 

```json
{
    "advanced_settings": {
        // (Optional)
        // The number of seconds between runs of the CRON task which ensures that the agent factory is running.
        // Changing this value requires a server restart in order to take effect.
        "agent_factory_watcher_sleep_time_in_seconds": 5,

        // The number of threads used for parallel transfers.
        "default_number_of_transfer_threads": 4,

        // The number of seconds a server-side temporary password is good.
        "default_temporary_password_lifetime_in_seconds": 120,

        // (Optional)
        // A list of iRODS server hostnames the delay server dispatches rules to for execution.
        // If the list is empty, the delay server will dispatch rules to the local server for execution.
        "delay_rule_executors": [],

        // (Optional)
        // The number of seconds the delay server sleeps before checking the catalog for rules
        // ready for execution.
        "delay_server_sleep_time_in_seconds": 30,

        // (Optional)
        // Contains settings for controlling the behavior of the internal DNS cache.
        "dns_cache": {
            // The amount of shared memory allocated to the DNS cache.
            "shared_memory_size_in_bytes": 5000000,

            // The amount of time an entry stays valid before being evicted from the cache.
            "eviction_age_in_seconds": 3600,

            // The number of seconds between runs of the CRON task which clears the internal DNS cache.
            // Changing this value requires a server restart in order to take effect.
            "cache_clearer_sleep_time_in_seconds": 600
        },

        // (Optional)
        // Contains settings for controlling the behavior of the internal Hostname cache.
        "hostname_cache": {
            // The amount of shared memory allocated to the Hostname cache.
            "shared_memory_size_in_bytes": 2500000,

            // The amount of time an entry stays valid before being evicted from the cache.
            "eviction_age_in_seconds": 3600,

            // The number of seconds between runs of the CRON task which clears the internal hostname cache.
            // Changing this value requires a server restart in order to take effect.
            "cache_clearer_sleep_time_in_seconds": 600
        },

        // Defines the maximum data size for single buffer transfers.
        // When the data size exceeds the defined threshold, parallel transfer is used.
        // Connecting clients and servers within the same zone must use the same value.
        "maximum_size_for_single_buffer_in_megabytes": 32,

        // (Optional)
        // The maximum number of bytes available to the delay queue.
        // When set to 0, the delay server will use as much memory as it needs to hold queued rules.
        "maximum_size_of_delay_queue_in_bytes": 0,

        // The amount of time a temporary password remains valid.
        "maximum_temporary_password_lifetime_in_seconds": 1000,

        // (Optional)
        // The number of seconds between runs of the CRON task which executes the delay server migration algorithm.
        // Changing this value requires a server restart in order to take effect.
        "migrate_delay_server_sleep_time_in_seconds": 5,

        // (Optional)
        // The number of delay rules allowed to execute simultaneously.
        "number_of_concurrent_delay_rule_executors": 4,

        // (Optional)
        // The amount of time the stacktrace file processing thread sleeps before files are
        // processed and written to the log file.
        // Changing this value requires a server restart in order to take effect.
        "stacktrace_file_processor_sleep_time_in_seconds": 10,

        // Defines the size of the buffer used for sending and receiving bytes across the network
        // during parallel transfer. Clients and servers within the same zone must use the same value.
        "transfer_buffer_size_for_parallel_transfer_in_megabytes": 4,

        // Defines the number of bytes to read-from/write-to the disk during parallel transfer.
        // Clients and servers within the same zone must use the same value.
        "transfer_chunk_size_for_parallel_transfer_in_megabytes": 40
    },

    // An array of fully qualified domain names of this Zone's catalog service provider.
    "catalog_provider_hosts": [],

    // The role of this server.
    // The following values are supported: provider, consumer
    "catalog_service_role": "",

    // Controls which API operations are accessible to non-rodsadmin users.
    //
    // The following values are supported: enforce, disabled
    //
    // When set to "enforce", the server will expose a subset of operations that can be executed by any user.
    // Administrative operations will require rodsadmin level privileges. This option does not apply to
    // rodsadmin users.
    //
    // When set to "disabled", the server will operate without consulting the allowlist. This is equivalent
    // to how the server behaved prior to iRODS 4.3.0.
    "client_api_allowlist_policy": "enforce",

    // Defines the list of users that can connect to this server.
    "controlled_user_connection_list": {
        // Defines the type of list.
        //
        // The following values are supported: allowlist, denylist
        //
        // When set to "allowlist", all users except the ones defined in "users" will be blocked
        // from connecting to the server.
        //
        // When set to "denylist", all users except the ones defined in "users" will be allowed to
        // connect to the server.
        "control_type": "denylist",

        // A list of fully qualified user names in the form of "username#zone".
        // The interpretation of this list changes based on the "control_type".
        "users": []
    },

    // The unix filesystem octal mode for a newly created directory within a resource vault.
    "default_dir_mode": "0750",

    // The unix filesystem octal mode for a newly created file within a resource vault.
    "default_file_mode": "0600",

    // The hash scheme used for file integrity checking.
    //
    // The following values are supported: MD5, SHA256
    //
    // See "Checksum Configuration" for more details.
    "default_hash_scheme": "SHA256",

    // Contains a set of key-value pairs of the form VARIABLE=VALUE such as "ORACLE_HOME=/full/path"
    // from the server's environment. This setting can be empty.
    "environment_variables": {
        "VARIABLE_NAME": "VALUE", // This is an example.

        // ... Additional Entries ...
    },

    // Contains an array of objects, each containing the parameters necessary for federating with another grid.
    "federation": [
        // Defines a single remote zone.
        {
            // An array of hostnames of the catalog service providers in the federated zone.
            "catalog_provider_hosts": [], 

            // The 32-byte encryption key of the federated zone.
            "negotiation_key": "", 

            // The shared authentication secret of the federated zone.
            "zone_key": "",

            // The name of the federated zone.
            "zone_name": "",

            // (Optional)
            // The port number used by the remote zone for communication.
            "zone_port": 1247 
        },

        // ... Additional Entries ...
    ],

    // See "Host Access Control" section for more details.
    "host_access_control": {
        // Defines zero or more objects used to control access to the local iRODS instance.
        "access_entries": [
            // Defines a single access constraint.
            {
                // Defines which user is allowed access to the server.
                "user": "",

                // Defines which group is allowed access to the server.
                "group": "",

                // With the "mask" property, defines which host(s) are allowed access to the server.
                "address": "",

                // With the "address" property, defines which host(s) are allowed access to the server.
                "mask": ""
            },

            // ... Additional Entries ...
        ]
    },

    // See "Host Resolution" section for more details.
    "host_resolution": {
        // Defines zero or more objects containing hostname resolution information for
        // local or remote iRODS servers.
        "host_entries": [
            // Defines a single resolution rule.
            {
                // Identifies whether the hostnames defined under "addresses" represent local or remote
                // hostnames.
                //
                // The following values are supported: local, remote
                "address_type": "",

                // A list of strings defining hostname aliases.
                "addresses": []
            },

            // ... Additional Entries ...
        ]
    },

    // Holds the log level for various log message categories used throughout the server.
    // Missing log categories default to "info".
    // 
    // The following values are supported: trace, debug, info, warn, error, critical
    "log_level": {
        "agent": "info",
        "agent_factory": "info",
        "api": "info",
        "authentication": "info",
        "database": "info",
        "delay_server": "info",
        "legacy": "info",
        "microservice": "info",
        "network": "info",
        "resource": "info",
        "rule_engine": "info",
        "server": "info"
    },

    // Indicates to iRODS whether to use the hash used by the client or the data at rest, or to force
    // the use of the default hash scheme: strict or compatible.
    "match_hash_policy": "compatible",

    // A 32-byte encryption key shared by the zone for use in the advanced negotiation handshake at the
    // beginning of an iRODS client connection.
    "negotiation_key": "",

    // Holds several different properties such as database connection information, rule engine configuration, etc.
    "plugin_configuration": {
        // This property is currently unused.
        "authentication": {},

        // (Optional)
        // Defines database connection information.
        // This only applies to servers running as a catalog provider or delay server.
        "database": {
            // The type of database iRODS is using for the catalog.
            // The following property names are supported: postgres, mysql, and oracle
            "catalog_database_type": {
                // The hostname of the database server (can be localhost).
                "db_host": "localhost",

                // The name of the database used as the catalog.
                "db_name": "ICAT",

                // The name of the ODBC entry used by the server (normally defined in /etc/odbcinst.ini).
                "db_odbc_driver": "",

                // The password for the "db_username" to connect to the "db_name".
                "db_password": "",

                // The port number on which the database server is listening.
                "db_port": 0,

                // The database user name.
                "db_username": ""
            }
        },

        // This property is currently unused.
        "network": {},

        // This property is currently unused.
        "resource": {},

        // Defines the set of enabled rule engine plugins for this iRODS instance.
        // Plugins will be consulted in the order defined by this list. When empty, policy will not fire
        // on this server.
        "rule_engines": [
            // (Optional)
            // Defines and enables a single rule engine plugin.
            {
                // The name of the plugin instance.
                // For plugins that allow multiple instances to be configured on a single server, this allows
                // the admin to assign unique names to each instance. This helps to improve the admin's chances
                // of tracking down which plugin did what.
                "instance_name": "",

                // The name of a plugin inside of /usr/lib/irods/plugins/rule_engines.
                // The name must not include the "lib" prefix or ".so" filename extension.
                //
                // For example, the native rule engine plugin has the following name:
                //
                //     /usr/lib/irods/plugin/rule_engines/libirods_rule_engine_plugin-irods_rule_language.so
                //
                // Therefore, this property would have a value of:
                //
                //     "irods_rule_engine_plugin-irods_rule_language"
                //
                "plugin_name": "",

                // Any and all configuration settings required by the plugin must be defined inside of
                // this setting. Each plugin should provide documentation detailing supported settings.
                "plugin_specific_configuration": {},

                // Defines the name used in allocating shared memory for this specific rule engine plugin.
                // The memory is allocated by the server on startup. The server will always allocate
                // 30000000 bytes.
                "shared_memory_instance": ""
            },

            // ... Additional Entries ...
        ]
    },

    // Defines the list of namespaces used during PEP processing.
    //
    // Each entry acts as a prefix to each PEP. This results in (N PEPs triggered * M namespaces).
    // Each entry in the list will cause one additional iteration through the list of available PEPs.
    //
    // PEPs are not allowed to cross namespace boundaries. This also means rule engine plugin continuation 
    // does not work across namespaces.
    //
    // Keep in mind that defining additional namespaces will slow down the server.
    "rule_engine_namespaces": [
        ""
    ],

    // Defines the filename of the JSON schema used for validation when not specified explicitly.
    "schema_name": "server_config",

    // The URI against which the iRODS server configuration is validated.
    //
    // The following values are supported:
    // - An absolute path in the local filesystem
    // - A http(s) endpoint pointing to valid JSON schema files
    // - The value "off"
    //
    // When set to off, schema validation is skipped.
    "schema_validation_base_uri": "file:///var/lib/irods/configuration_schemas",

    // Defines the version of the schema used for validation.
    // This normally maps to a directory under /var/lib/irods/configuration_schemas.
    "schema_version": "v4",

    // The algorithm used to encrypt the control plane communications.
    // This must be the same across all iRODS servers in a Zone.
    "server_control_plane_encryption_algorithm": "AES-256-CBC",

    // The number of hash rounds used in the control plane communications.
    // This must be the same across all iRODS servers in a Zone.
    "server_control_plane_encryption_num_hash_rounds": 16,

    // The amount of time before a control plane operation will timeout.
    //
    // The following values are supported:
    // - 0:    Returns immediately with an EAGAIN error if the message cannot be sent or there is no message to receive.
    // - -1:   Blocks until the message is sent or a message is available.
    // - Else: For sending, tries to send the message for that amount of time in milliseconds before returning with an EAGAIN error.
    //         For receiving, waits for a message for that amount of time in milliseconds before returning with an EAGAIN error.
    //
    // For more details, see ZMQ_SNDTIMEO/ZMQ_RCVTIMEO here: http://api.zeromq.org/4-1:zmq-setsockopt
    //
    // Changing this value requires a server restart in order to take effect.
    "server_control_plane_timeout_milliseconds": 10000,

    // The beginning of the port number range available for parallel transfers.
    // This must be the same across all iRODS servers in a Zone.
    "server_port_range_start": 20000,

    // The end of the port number range available for parallel transfers.
    // This must be the same across all iRODS servers in a Zone.
    "server_port_range_end": 20199,

    // The authentication scheme used by the zone_user: native or pam_password.
    "zone_auth_scheme": "native",

    // The shared secret used for authentication and identification of server-to-server communication.
    // This can be a string of any length, excluding the use of hyphens, for historical purposes.
    // This must be the same across all iRODS servers in a Zone.
    "zone_key": "TEMPORARY_ZONE_KEY",

    // The name of the Zone in which the server participates.
    // This must be the same across all iRODS servers in a Zone.
    "zone_name": "tempZone",

    // The main port number used by the Zone for communication.
    // This must be the same across all iRODS servers in a Zone.
    "zone_port": 1247,

    // The name of the rodsadmin user running this iRODS instance.
    "zone_user": "rods"
}
```

## Host Resolution

The `host_resolution` server_config.json property serves as an iRODS-owned version of /etc/hosts.  It defines network aliases when you may not have permission to update hostnames on the servers in the Zone.

The order of precedence of hostname resolution in iRODS is `host_resolution`, then the local `/etc/hosts` file, then DNS.

The `local` entry can define multiple addresses for the local server.

The `remote` entries each define a remote server with a set of aliases.

The first address in each stanza is the preferred address and will be used for connecting to clients and remote servers. This first address should be the hostname of the server in question and is expected to match the result of running `hostname` on that server. The additional addresses are the aliases.

An example `host_resolution` configuration:

```json
"host_resolution": {
    "host_entries": [
        {
            "address_type": "local",
            "addresses": [
                "xx.yy.nn.zz",
                "longname.example.org"
            ]
        },
        {
            "address_type": "remote",
            "addresses": [
                "aa.bb.cc.dd",
                "fqdn.example.org",
                "morefqdn.example.org"
            ]
        },
        {
            "address_type": "remote",
            "addresses": [
                "ddd.eee.fff.xxx",
                "another.example.org"
            ]
        }
    ]
}
```

## Host Access Control

The `host_access_control` server_config.json property defines an iRODS-specific firewall.

This property allows certain users, groups, and hosts access to iRODS.  It is consulted when `msiCheckHostAccessControl` is invoked by the rule engine (on by default via `acChkHostAccessControl`).

The first entry specifies a user that is allowed to connect to this iRODS server. An entry of "all" means all users are allowed.

The second entry specifies a group name that is allowed to connect. An entry of "all" means, all groups are allowed.

The third and fourth entries specify the host address and the network mask. Together, they define the client IPv4 addresses that are permitted to connect to the iRODS server.  The mask entry specifies which bits will be ignored (i.e. after those bits are ignored, the incoming connection host must match the address entry).

An example `host_access_control` configuration:

```json
"host_access_control": {
    "access_entries": [
        {
            "user": "all",
            "group": "all",
            "address": "127.0.0.1",
            "mask": "255.255.255.255"
        }
    ]
}
```

## ~/.irods/irods_environment.json

This is the main iRODS configuration file defining the iRODS environment. Any changes are effective immediately since iCommands reload their environment on every execution.

```json
{
    // (Optional)
    // Set to "request_server_negotiation" indicating advanced negotiation is desired,
    // for use in enabling SSL and other technologies.
    "irods_client_server_negotiation": "request_server_negotiation",

    // (Optional)
    // Controls whether the client and server should use SSL/TLS for communication.
    //
    // The following values are supported:
    // - CS_NEG_REFUSE:    Do not use SSL
    // - CS_NEG_REQUIRE:   Demand SSL be used
    // - CS_NEG_DONT_CARE: Let the server decide if SSL should be used
    "irods_client_server_policy": "CS_NEG_REFUSE",

    // (Optional)
    // Number of seconds after which an existing connection in a connection pool is refreshed.
    "irods_connection_pool_refresh_time_in_seconds": 300,

    // (Optional)
    // The current working collection within iRODS.
    "irods_cwd": "",

    // (Optional)
    // The hash scheme used for file integrity checking.
    //
    // The following values are supported: MD5, SHA256
    //
    // See "Checksum Configuration" for more details.
    "irods_default_hash_scheme": "SHA256",

    // (Optional)
    // The default number of threads used for parallel transfers.
    "irods_default_number_of_transfer_threads": 4,

    // (Optional)
    // The name of the resource used for iRODS operations if one is not specified.
    // See "Default Resource Configuration" section for more details.
    "irods_default_resource": "demoResc",

    // (Optional)
    // EVP-supplied encryption algorithm for parallel transfer encryption.
    "irods_encryption_algorithm": "AES-256-CBC",

    // (Optional)
    // Key size for parallel transfer encryption.
    "irods_encryption_key_size": 32,

    // (Optional)
    // Number of hash rounds for parallel transfer encryption.
    "irods_encryption_num_hash_rounds": 16,

    // (Optional)
    // Salt size for parallel transfer encryption.
    "irods_encryption_salt_size": 8,

    // (Optional)
    // The Distinguished Name of the GSI Server.
    "irods_gsi_server_dn": "",

    // (Optional)
    // The home directory within the iRODS Zone for a given user.
    "irods_home": "",

    // The fully qualified domain name of the target iRODS server to connect to.
    "irods_host": "",

    // (Optional)
    "irods_match_hash_policy": "compatible",

    // (Optional)
    // Defines the maximum data size for single buffer transfers.
    // When the data size exceeds the defined threshold, parallel transfer is used.
    // Connecting clients and servers within the same zone must use the same value.
    "irods_maximum_size_for_single_buffer_in_megabytes": 32,

    // (Optional) (Deprecated)
    // Defines the log level.
    //
    // See "Troubleshooting > Debugging Levels" for more details.
    "irods_log_level": 5,

    // (Optional)
    // Defines the level of server certificate authentication to perform.
    //
    // The following values are supported: none, cert, hostname
    //
    // When set to "none", authentication is skipped.
    //
    // When set to "cert", the server will verify that the certificate was signed by a trusted CA.
    //
    // When set to "hostname", the server will do everything defined by the "cert" level and then verify
    // that the FQDN of the iRODS server matches either the common name or one of the subjectAltNames in
    // the certificate.
    "irods_ssl_verify_server": "hostname",

    // (Optional)
    // Directory to use for the client side plugins.
    // See section entitled "Distributing iCommands" for more details.
    "irods_plugins_home": "",

    // The port number on which the target iRODS server is listening.
    // This must match the port number used by the Zone.
    "irods_port": 1247,

    // (Optional)
    // The algorithm used to encrypt the control plane communications.
    // This must be the same across all iRODS servers in a Zone.
    "irods_server_control_plane_encryption_algorithm": "AES-256-CBC",

    // (Optional)
    // The number of hash rounds used in the control plane communications.
    // This must be the same across all iRODS servers in a Zone.
    "irods_server_control_plane_encryption_num_hash_rounds": 16,

    // (Optional)
    // The encryption key required for communicating with the iRODS grid control plane.
    "irods_server_control_plane_key": "32_byte_server_control_plane_key",

    // (Optional)
    // The port number on which the control plane listens.
    "irods_server_control_plane_port": 1248,

    // (Optional)
    // Location of a file of trusted CA certificates in PEM format.
    // Note that the certificates in this file are used in conjunction with the system
    // default trusted certificates.
    "irods_ssl_ca_certificate_file": "",

    // (Optional)
    // Location of a directory containing CA certificates in PEM format.
    // The files each contain one CA certificate. The files are looked up by the CA subject name hash
    // value, which must hence be available. If more than one CA certificate with the same name hash
    // value exist, the extension must be different (e.g. 9d66eef0.0, 9d66eef0.1 etc). The search is
    // performed in the ordering of the extension number, regardless of other properties of the
    // certificates. Use the ‘c_rehash’ utility to create the necessary links.
    "irods_ssl_ca_certificate_path": "",

    // (Optional)
    // The file containing the server's certificate chain.
    // The certificates must be in PEM format and must be sorted starting with the subject's
    // certificate (actual client or server certificate), followed by intermediate CA certificates
    // if applicable, and ending at the highest level (root) CA.
    "irods_ssl_certificate_chain_file": "",

    // (Optional)
    // The private key corresponding to the server's certificate in the certificate chain file.
    "irods_ssl_certificate_key_file": "",

    // (Optional)
    // The Diffie-Hellman parameter file location.
    "irods_ssl_dh_params_file": "",

    // (Optional)
    // The number of seconds between TCP keep-alive probes. The default value in the TCP specification is 75. For more
    // details, see:
    //  - man tcp
    //  - https://tldp.org/HOWTO/TCP-Keepalive-HOWTO/usingkeepalive.html
    //
    // If this option is not set or set to a non-positive value, the socket option for TCP_KEEPINTVL will remain unset.
    // This means that the value of tcp_keepalive_intvl in use for the kernel configuration will be used for iRODS
    // sockets using TCP keepalive. The range of acceptable values is defined by the range of acceptable values for the
    // TCP_KEEPINTVL option. If a value outside of the acceptable range is provided, an error will be returned and the
    // socket will be closed. If a non-positive value is used, the option will be considered not set.
    //
    // The default value used in the iRODS environment is -1 to indicate that the socket option should remain unset.
    "irods_tcp_keepalive_intvl_in_seconds": -1,

    // (Optional)
    // The maximum number of TCP keep-alive probes to send before giving up and killing the connection if no response is
    // obtained from the other end. The default value in the TCP specification is 9. For more details, see:
    //  - man tcp
    //  - https://tldp.org/HOWTO/TCP-Keepalive-HOWTO/usingkeepalive.html
    //
    // If this option is not set or set to a non-positive value, the socket option for TCP_KEEPCNT will remain unset.
    // This means that the value of tcp_keepalive_probes in use for the kernel configuration will be used for iRODS
    // sockets using TCP keepalive. The range of acceptable values is defined by the range of acceptable values for the
    // TCP_KEEPCNT option. If a value outside of the acceptable range is provided, an error will be returned and the
    // socket will be closed.
    //
    // The default value used in the iRODS environment is -1 to indicate that the socket option should remain unset.
    "irods_tcp_keepalive_probes": -1,

    // (Optional)
    // The number of seconds a connection needs to be idle before TCP begins sending out keep-alive probes. The default
    // value in the TCP specification is 7200 seconds (2 hours). An idle connection is terminated after approximately an
    // additional 11 minutes (9 probes at an interval of 75 seconds apart) when keep-alive is enabled. For more details,
    // see:
    //  - man tcp
    //  - https://tldp.org/HOWTO/TCP-Keepalive-HOWTO/usingkeepalive.html
    //
    // If this option is not set or set to a non-positive value, the socket option for TCP_KEEPIDLE will remain unset.
    // This means that the value of tcp_keepalive_time in use for the kernel configuration will be used for iRODS
    // sockets using TCP keepalive. The range of acceptable values is defined by the range of acceptable values for the
    // TCP_KEEPIDLE option. If a value outside of the acceptable range is provided, an error will be returned and the
    // socket will be closed.
    //
    // The default value used in the iRODS environment is -1 to indicate that the socket option should remain unset.
    "irods_tcp_keepalive_time_in_seconds": -1,

    // (Optional)
    // Defines the size of the buffer used for sending and receiving bytes across the network
    // during parallel transfer. Clients and servers within the same zone must use the same value.
    "irods_transfer_buffer_size_for_parallel_transfer_in_megabytes": 4,

    // The username within iRODS for this account.
    "irods_user_name": "",

    // The name of the iRODS Zone.
    "irods_zone_name": "",

    // (Optional)
    // Defines the filename of the JSON schema used for validation when not specified explicitly.
    // Only applies to service account environment files.
    "schema_name": "service_account_environment",

    // (Optional)
    // Defines the version of the schema used for validation.
    // Only applies to service account environment files.
    "schema_version": "v4"
}
```

A client environment file might look like this.

```json
{
    "irods_host": "example.org",
    "irods_port": 1247,
    "irods_user_name": "alice",
    "irods_zone_name": "tempZone"
}
```

And here is a service account environment file defining the minimum settings needed to manage an iRODS server.

```json
{
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
    "irods_host": "example.org",
    "irods_match_hash_policy": "compatible",
    "irods_maximum_size_for_single_buffer_in_megabytes": 32,
    "irods_port": 1247,
    "irods_server_control_plane_encryption_algorithm": "AES-256-CBC",
    "irods_server_control_plane_encryption_num_hash_rounds": 16,
    "irods_server_control_plane_key": "32_byte_server_control_plane_key",
    "irods_server_control_plane_port": 1248,
    "irods_transfer_buffer_size_for_parallel_transfer_in_megabytes": 4,
    "irods_user_name": "rods",
    "irods_zone_name": "tempZone",
    "schema_name": "service_account_environment",
    "schema_version": "v4"
}
```

To use an environment file other than `~/.irods/irods_environment.json`, set `IRODS_ENVIRONMENT_FILE` to load from a different location:

```bash
export IRODS_ENVIRONMENT_FILE=/full/path/to/different.json
```

Other individual environment variables can be set by using the UPPERCASE versions of the variables named above, for example:

```bash
export IRODS_CWD='/tempZone/home/public'
```

# Checksum Configuration

Checksums in iRODS 4.0+ can be calculated using one of multiple hashing schemes.  Since the default hashing scheme for iRODS 4.0+ is SHA256, some existing earlier checksums may need to be recalculated and stored in the iCAT.

The following two settings, the default hash scheme and the match hash policy, need to be set on both the client and the server:

<table>
<tr>
<th>Client (irods_environment.json)</th>
<th>Server (server_config.json)</th>
</tr>
<tr>
<td>irods_default_hash_scheme<br />
 - SHA256 (default)<br />
 - MD5
</td>
<td>default_hash_scheme<br />
 - SHA256 (default)<br />
 - MD5
</td>
</tr>
<tr>
<td>irods_match_hash_policy<br />
 - Compatible (default)<br />
 - Strict
</td>
<td>match_hash_policy<br />
 - Compatible (default)<br />
 - Strict
</td>
</tr>
</table>


When a request is made, the sender and receiver's hash schemes and the receiver's policy are considered:

|  Sender      |   Receiver             |   Result                          |
| ------------ | ---------------------- | --------------------------------- |
|  MD5         |   MD5                  |   Success with MD5                |
|  SHA256      |   SHA256               |   Success with SHA256             |
|  MD5         |   SHA256, Compatible   |   Success with MD5                |
|  MD5         |   SHA256, Strict       |   Error, USER_HASH_TYPE_MISMATCH  |
|  SHA256      |   MD5, Compatible      |   Success with SHA256             |
|  SHA256      |   MD5, Strict          |   Error, USER_HASH_TYPE_MISMATCH  |

If the sender and receiver have consistent hash schemes defined, everything will match.

If the sender and receiver have inconsistent hash schemes defined, and the receiver's policy is set to 'compatible', the sender's hash scheme is used.

If the sender and receiver have inconsistent hash schemes defined, and the receiver's policy is set to 'strict', a USER_HASH_TYPE_MISMATCH error occurs.

# Default Resource Configuration

The placement of new Data Objects (and replicas) into a Zone is determined by the 'resolve_resource_hierarchy' function on the server to
which the client is connected.  It takes into consideration the conditional input from the client request and the default resource as
defined on the server (usually in core.re) and, along with the configuration of msiSetDefaultResc(), selects an appropriate target resource.

When the client is an **administrator (rodsadmin)**, the following results can be expected:

|  Client               |  Server                                |  Result   |  If does_not_exist       |
| --------------------- | -------------------------------------- | --------- | ------------------------ |
|  iput foo             |  msiSetDefaultResc('svr', 'preferred') |  'svr'    |  SYS_RESC_DOES_NOT_EXIST |
|  iput -R 'myResc' foo |  msiSetDefaultResc('svr', 'preferred') |  'myResc' |  SYS_RESC_DOES_NOT_EXIST |
|  iput foo             |  msiSetDefaultResc('svr', 'forced')    |  'svr'    |  SYS_RESC_DOES_NOT_EXIST |
|  iput -R 'myResc' foo |  msiSetDefaultResc('svr', 'forced')    |  'myResc' |  SYS_RESC_DOES_NOT_EXIST |
|  iput foo             |  msiSetDefaultResc('svr', 'null')      |  'svr'    |  SYS_RESC_DOES_NOT_EXIST |
|  iput -R 'myResc' foo |  msiSetDefaultResc('svr', 'null')      |  'myResc' |  SYS_RESC_DOES_NOT_EXIST |

When the client is a **regular user (rodsuser)**, the following results can be expected:

|  Client               |  Server                                |  Result   |  If does_not_exist       |
| --------------------- | -------------------------------------- | --------- | ------------------------ |
|  iput foo             |  msiSetDefaultResc('svr', 'preferred') |  'svr'    |  SYS_RESC_DOES_NOT_EXIST |
|  iput -R 'myResc' foo |  msiSetDefaultResc('svr', 'preferred') |  'myResc' |  SYS_RESC_DOES_NOT_EXIST |
|  iput foo             |  msiSetDefaultResc('svr', 'forced')    |  'svr'    |  SYS_RESC_DOES_NOT_EXIST |
|  iput -R 'myResc' foo |  msiSetDefaultResc('svr', 'forced')    |  'svr'    |  SYS_RESC_DOES_NOT_EXIST |
|  iput foo             |  msiSetDefaultResc('svr', 'null')      |  'svr'    |  SYS_RESC_DOES_NOT_EXIST |
|  iput -R 'myResc' foo |  msiSetDefaultResc('svr', 'null')      |  'myResc' |  SYS_RESC_DOES_NOT_EXIST |

In general, a client preference will be honored by the server.

The only difference between the administrator and regular user behavior is when the client
requests a resource and the server is set to 'forced'.  In this case, an administrator can override the server
setting and a regular user cannot.

When the determined target resource does not exist, the server will return the 'SYS_RESC_DOES_NOT_EXIST' error.

The data placement policy is evaluated and enforced by the server to which the client is connected.  Any other
servers involved in the data transfer will honor the evaluation by the initially connected server.

# Special Characters

The default setting for 'standard_conforming_strings' in PostgreSQL 9.1+ was changed to 'on'.  Non-standard characters in iRODS Object names will require this setting to be changed to 'off'.  Without the correct setting, this may generate a USER_INPUT_PATH_ERROR error.
