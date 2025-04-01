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
        // The size of the buffer used for reading during checksum calculation.
        // Increasing this value will result in fewer reads of a replica. Values must be representable as a 32
        // bit integer.
        "checksum_read_buffer_size_in_bytes": 1048576,

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

    // The FQDN or hostname which identifies the server.
    //
    // The following rules apply:
    // - Must not be the string "localhost"
    // - Must be resolvable by the local server
    // - Must resolve to the local server
    "host": "",

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
        "genquery2": "info",
        "legacy": "info",
        "microservice": "info",
        "network": "info",
        "resource": "info",
        "rule_engine": "info",
        "server": "info",
        "sql": "info"
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

    // (Optional)
    // Defines server-side TLS configurations. Although the "tls" object itself is optional,
    // all sub-properties are required if "tls" is defined.
    "tls": {
        // Absolute path to the file containing the server's certificate chain.
        // The certificates must be in PEM format and must be sorted starting with the subject's
        // certificate (actual client or server certificate), followed by intermediate CA certificates
        // if applicable, and ending at the highest level (root) CA.
        "certificate_chain_file": "",

        // Absolute path to the file containing the private key corresponding to the server's
        // certificate in the certificate chain file.
        "certificate_key_file": "",

        // Absolute path to the Diffie-Hellman parameter file.
        "dh_params_file": ""
    },

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
    // for use in enabling TLS and other technologies.
    "irods_client_server_negotiation": "request_server_negotiation",

    // (Optional)
    // Controls whether the client and server should use TLS for communication.
    //
    // The following values are supported:
    // - CS_NEG_REFUSE:    Do not use TLS
    // - CS_NEG_REQUIRE:   Demand TLS be used
    // - CS_NEG_DONT_CARE: Let the server decide if TLS should be used
    "irods_client_server_policy": "CS_NEG_REFUSE",

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

## Checksum Configuration

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

## Default Resource Configuration

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

## Special Characters

The default setting for 'standard_conforming_strings' in PostgreSQL 9.1+ was changed to 'on'.  Non-standard characters in iRODS Object names will require this setting to be changed to 'off'.  Without the correct setting, this may generate a USER_INPUT_PATH_ERROR error.

## Authentication Configuration

As of iRODS 4.3.1, authentication settings are now configured through rows in the `R_GRID_CONFIGURATION` table in the iRODS Catalog.

### History (pre-4.3.1 configuration)

Historically, authentication configuration had been limited to the PAM authentication scheme (now known as the `pam_password` authentication scheme). These settings were configured through `server_config.json` like this (default values are shown):
```json
{
	"plugin_configuration": {
		"authentication": {
			"pam_password": {
				"no_extend": false,
				"password_length": 20,
				"password_max_time": 1209600,
				"password_min_time": 121
			}
		},
	}
}
```
The configuration is tied to the server on which the `server_config.json` file exists. The configuration is also named for PAM/`pam_password` authentication even though the configuration values are also used for `native` authentication's time-to-live (TTL) option. For PAM authentication, having the settings tied to a particular server is not a problem because PAM authentication requires redirecting to the catalog service provider.

On upgrade to 4.3.1, the values which exist in `server_config.json` are inserted into `R_GRID_CONFIGURATION`. The configurations apply to authentication zone-wide.

The `password_length` configuration has been removed in 4.3.1. The configuration was used to determine the maximum length of the randomly generated password for PAM authentication scheme users. The randomly generated password is now a fixed length.

### Configuration Overview

`native` and `pam_password` authentication configurations can be managed in `R_GRID_CONFIGURATION` with options in the `authentication` namespace. Here are the supported `option_name`s and values:

#### `password_max_time`

The maximum TTL of a randomly generated password in seconds. If a user attempts to authenticate with a TTL value that is greater than `password_max_time`, the TTL is determined to be invalid and an error is returned. If `password_max_time` is configured to a value less than `password_min_time` no passed-in TTL value will satisfy the system. Accepted values: [0..18446744073709552000). If a value outside of the acceptable range is used, a warning message will be logged for the administrator and the default value will be used. The default value is 1209600 (336 hours, or 2 weeks).

#### `password_min_time`

The minimum TTL of a randomly generated password in seconds. If a user attempts to authenticate with a TTL value that is less than `password_min_time`, the TTL is determined to be invalid and an error is returned. If `password_min_time` is configured to a value greater than `password_max_time` no passed-in TTL value will satisfy the system. Accepted values: [0..18446744073709552000). If a value outside of the acceptable range is used, a warning message will be logged for the administrator and the default value will be used. The default value is 121.

!!! Note
    If users are being forced to re-authenticate via PAM frequently, you may need to adjust this option. A high frequency of `CAT_PASSWORD_EXPIRED` appearing in the server log is a good indicator of this. See [Users are forced to re-authenticate after a few minutes](../../system_overview/troubleshooting/#users-are-forced-to-re-authenticate-after-a-few-minutes) for more information.

#### `password_extend_lifetime`

Determines whether to extend the lifetime of the user's randomly generated password when re-authenticating by updating its expiration time. For instance, if a user authenticates and a randomly generated password already exists for the user in the database, the existing password will simply have its lifetime extended and the user will not need to re-authenticate for the full TTL. Accepted values: '0' or '1'. '1' means that the expiration time for the existing random password will be updated each time a user re-authenticates with iRODS. '0' means that the expiration time for the existing random password will not be updated when a user re-authenticates with iRODS. The default value is '1'.

!!! Note
    This configuration is not used with `native` authentication.

### Configuring authentication in `R_GRID_CONFIGURATION`

`R_GRID_CONFIGURATION` can be modified through the `iadmin` subcommand `set_grid_configuration`. The current value can be queried using the `iadmin` subcommand `get_grid_configuration`.

Here is an example of getting the configuration for the `password_max_time`, modifying the value, and checking to see that it updated correctly:
```bash
$ iadmin get_grid_configuration authentication password_max_time
1209600
$ iadmin set_grid_configuration authentication password_max_time 3600
$ iadmin get_grid_configuration authentication password_max_time
3600
```

See [set_grid_configuration](../../icommands/administrator/#set_grid_configuration) and [get_grid_configuration](../../icommands/administrator/#get_grid_configuration) for more details about these subcommands.

## Managing Parallel Transfer Threads

!!! Note
    The high ports are deprecated as of iRODS 4.3.4 and will be removed in a later version. Future versions of iRODS will perform parallel transfers using the zone port _(defaults to 1247)_. See [Parallel Transfer](../../system_overview/data_objects/#parallel-transfer) for more information.

When transferring large amounts of data between the client and server or even between servers, the number of threads used to read and write data can be configured by the administrator.

First, we will go over how to configure what "large amounts of data" means. This is a configurable value that is controlled by the `maximum_size_for_single_buffer_in_megabytes` setting in `server_config.json`. This setting controls the maximum size of a particular file or data object that will be put into an in-memory buffer. If the size of the file or data object to read or write exceeds this size, iRODS will initiate what is known as a "parallel transfer".

In a parallel transfer, a certain number of threads will be instantiated and tasked with reading and/or writing a number of bytes from a source file or data object to a destination file or data object. The number of transfer threads can be manipulated by the client and the server.

Note: If the number of transfer threads is set to 0, this is a special "streaming" mode in which bytes are read and written via a single stream.

### Client: `numThreads` keyword

The way that the client can request the number of threads to use in parallel transfer is via the `numThreads` keyword. For some iCommands, this is provided using the `-N` option. From the [`iput` help text](../../icommands/user/#iput):
```
 -N  numThreads - the number of threads to use for the transfer. A value of
       0 means no threading. By default (-N option not used) the server 
       decides the number of threads to use.
```

### Server: Legacy Static Policy Enforcement Point - `acSetNumThreads`

The server configuration for number of parallel transfer threads can also be controlled through a **legacy** static policy enforcement point called `acSetNumThreads`. This policy can call `msiSetNumThreads` to configure the environment in such a way that the desired number of threads is used in parallel transfers. The policy is configured by default in `core.re` like this:
```c
acSetNumThreads {
	msiSetNumThreads("default", "default", "default");
}
```
It is recommended that the administrator leaves this PEP in its default implementation, providing "default" for the 3 parameters for `msiSetNumThreads`. This will allow the `default_number_of_transfer_threads` configuration in `server_config.json`'s `advanced_settings` to take effect as a default and a maximum.

### Server: `server_config` Advanced Settings

The `server_config.json` file for configuration of the iRODS server has a setting under `advanced_settings` called `default_number_of_transfer_threads`. This is the server's configuration of the number of threads to use by default in parallel transfers. If the client does not provide a number of threads to use for parallel transfer, this is the value used. Note: The server configuration used to determine the number of parallel transfer threads is the server hosting the resource to which the data is being written or from which data is being read. Additionally, if `acSetNumThreads` is left in its default implementation (with "default" used for all parameters), the `default_number_of_transfer_threads` will also ensure that no client-provided number of transfer threads will exceed the value provided.

The administrator may wish to disable parallel transfer threads altogether. This can be done by setting `default_number_of_transfer_threads` to 0 in the `advanced_settings`.

It is recommended that careful consideration be given by the administrator when changing the default value. This will affect available resources on the configured server and could degrade performance if mis-configured. The iRODS Consortium researched the parallel transfer threads as it relates to performance and reached the default value in use today as a result. As such, it is recommended to leave the default value in place for most use cases. For more information on this topic, please see this blog post: [https://irods.org/2016/09/irods-4-1-9-networking-performance-whitepaper](https://irods.org/2016/09/irods-4-1-9-networking-performance-whitepaper)

### How many threads will my transfer use?

The following table shows the number of threads used in parallel transfers of any file which invokes parallel transfer:

| case | client-provided `numThreads` (`-N`) | `default_number_of_transfer_threads` (server configuration) | threads used |
| ---- | ---- | ---- | ---- |
| 0 | - | 4 | 4 |
| 1 | 3 | 4 | 3 |
| 2 | 5 | 4 | 4 |

Case 0 shows that if the client does not provide a number of parallel transfer threads to use, the default configured in the server will be used. Case 1 shows that if the client provides a number of parallel transfer threads to use that is less than or equal to the configured `default_number_of_transfer_threads`, that number of threads will be used. Case 2 shows that if the client provides a number of parallel transfer threads to use that is greater than `default_number_of_transfer_threads`, the value will be set to `default_number_of_transfer_threads` so as to not exceed it. So, the configured `default_number_of_transfer_threads` in `server_config.json` actually functions as a maximum on the number of threads that will be used as well when `acSetNumThreads` is left in its default implementation.

The behavior stays the same regardless of whether the data transfers are to the user's local zone or to a remote zone via federation. For both cases - transferring data to a local zone or a remote zone via federation - the configuration being used on the server side would be the server hosting the resource to which data is being written or from which data is being read.
