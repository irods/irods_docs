
## Service account as client to local server

While it is true that any iRODS client can connect to any iRODS Server within a Zone,
to reduce surprise when debugging, the service account of an iRODS server should be
configured to connect as a client to the iRODS server running on its own host.

On host `consumer.example.org`, the service account (by default, `irods`) should
have `/var/lib/irods/.irods/irods_environment.json` with the following entry:

```
    "irods_host": "consumer.example.org",
```

## Naming conventions

When debugging a distributed, multi-layered system, it is very helpful to have
things named well.  The iRODS convention has been to name things in the
following format, `adjectiveNoun`.

Specific examples of this might include:

 - demoResc
 - replResc
 - rootResc
 - tempZone
 - renciZone

## Passthru resource as root node

Once a Zone has multiple users, changing certain Zone-wide settings becomes
more difficult as every user must update their connection information before
they can do any work with iRODS.  One of the ways to mitigate this difficulty
is to use a passthru resource as the root node of the Zone's default resource.

By doing this, administrative changes to disks, server names, and resources can
be handled out of view of the users and without the users needing to change any
configuration in their client(s).

```
irods $ iadmin mkresc rootResc passthru
irods $ iadmin addchildtoresc rootResc unix1Resc
irods $ ilsresc
rootResc:passthru
└── unix1Resc
```

```
irods $ grep "^acSetRescSch" /etc/irods/core.re
acSetRescSchemeForCreate {msiSetDefaultResc("rootResc","null"); }
acSetRescSchemeForRepl {msiSetDefaultResc("rootResc","null"); }

```

## Do not use demoResc in production

iRODS is initially configured with the motivation of having a usable system.  To prepare a new installation for production, `demoResc` should be removed and replaced with a resource backed by a suitable production-quality storage system.  The Vault for `demoResc` is, by default, in the iRODS service account home directory (`/var/lib/irods/Vault`) and not ready for production use.


## Adding custom rulebases rather than editing core.re

Each iRODS server in a Zone has its own policy.  This policy is comprised of the active rulebases on each server (possibly from multiple rule engine plugins and in different languages).  Different servers may have different policies in force.  [Deploying custom policy in the iRODS Rule Language to a particular server is best done by creating additional rulebases](../plugins/pluggable_rule_engine/#example), rather than editing the existing default `core.re`.

By adding a new `.re` file and adding it to the correct `re_rulebase_set` array within `/etc/irods/server_config.json`, an administrator can more easily keep track of customizations to a particular server.

This approach is also easier to deploy using configuration management solutions like Ansible, Chef, or Puppet.

## Removing extra rule_engine_namespaces

Early installations of the pluggable rule engines may leave behind extra `rule_engine_namespaces`, namely `audit_` and `indexing_`.

Including these, when unnecessary, will slow down a deployment as the server must search an extra number of times to find eligible PEPs to fire.

If these are not needed, please remove them from `server_config.json` and use the minimal configuration:

```
    "rule_engine_namespaces": [
        ""
    ], 
```

## Using free_space check on unixfilesystem resources

Since 4.1.10, the unixfilesystem resource context string can set 'minimum_free_space_for_create_in_bytes" which will be checked against the 'free_space' value set in the iCAT catalog for that resource before voting to accept any create operations.

To update the 'free_space' value automatically, add the following two rules to an active rulebase on each server:

```
acPostProcForParallelTransferReceived(*leaf_resource) {
    msi_update_unixfilesystem_resource_free_space(*leaf_resource);
}
acPostProcForDataCopyReceived(*leaf_resource) {
    msi_update_unixfilesystem_resource_free_space(*leaf_resource);
}
```

This will set the 'free_space' for the active resource (the one that just performed the create) in the database.  The value will then be used in the routing calculations for the next create operation.


## Using both delay and remote execution

Normally, since the `remote()` microservice is a synchronous call, it should be included in the chain of microservices that is scheduled for delayed execution:

```c
delay( "<PLUSET>30s</PLUSET><EF>1m REPEAT 3 TIMES</EF>" ) {
    remote( "resource.example.org", "" ) {
        writeLine("serverLog", " -- Remote Execution in the Local Zone");
    }
}
```

However, when scheduling delayed execution in a remote Zone (on the remote iCAT server), the opposite pattern should be employed.  It is best to get the delayed microservices into the remote execution queue immediately:

```c
remote( "farawayicat.example.org", "DifferentZone" ) {
    delay( "<PLUSET>30s</PLUSET>" ) {
        writeLine("serverLog", " -- Delayed Execution in the Remote Zone");
    }
}
```

To execute microservices on a Resource Server in a remote Zone, an additional `remote()` must be employed:

```c
remote( "farawayicat.example.org", "DifferentZone" ) {
    delay( "<PLUSET>30s</PLUSET>" ) {
        remote( "resource.example.org", "" ) {
            writeLine("serverLog", " -- Delayed Execution on Resource Server in the Remote Zone");
    }
}
```



<!--
..
.. - tickets
.. - quota management
-->

