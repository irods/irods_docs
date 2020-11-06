## Monitoring status of iRODS Servers

iRODS servers respond to a `HEARTBEAT` message.  This can be incorporated into monitoring and reporting infrastructure.

From the command line (with `echo` and `netcat`/`nc`):
```bash
$ echo -e "\x00\x00\x00\x33<MsgHeader_PI><type>HEARTBEAT</type></MsgHeader_PI>" | nc localhost 1247
HEARTBEAT
```

This technique is used via Python [in the iRODS controller when starting the local iRODS server](https://github.com/irods/irods/blob/a4c97f8a65bd8d2b5d7a505612f2d9d670d33957/scripts/irods/controller.py#L103-L113).

## Confirming checksums

The value reported by `ils -L` for a sha2 checksum is the base64 encoded sha256 checksum.

This can be reproduced with: `sha256sum ${FILENAME} | awk '{print $1}' | xxd -r -p | base64`.

Example:
~~~bash
$ ls -l foo
-rw-r--r-- 1 irods irods 423 Feb 24 09:54 foo

$ ils -L foo
  rods              0 demoResc          423 2016-02-24.09:54 & foo
    sha2:zE1sR70ZVlbPawuHeN5fat+xNFVY9RB/cO3gULvPfs8=    generic    /var/lib/irods/Vault/home/rods/foo

$ sha256sum foo
cc4d6c47bd195656cf6b0b8778de5f6adfb1345558f5107f70ede050bbcf7ecf  foo

$ sha256sum foo | awk '{print $1}' | xxd -r -p | base64
zE1sR70ZVlbPawuHeN5fat+xNFVY9RB/cO3gULvPfs8=
~~~

## Confirming remote configuration

With a combination of `izonereport` and base64 decoding, it is possible to confirm configuration settings on other servers in a Zone without logging into the other servers directly.

~~~bash
$ izonereport > z.json
$ python -c "import json; d = json.load(open('z.json')); print d['zones'][0]['icat_server']['configuration_directory']['files'][4]['contents']" | base64 --decode
IRODS_SERVICE_ACCOUNT_NAME=irods
IRODS_SERVICE_GROUP_NAME=irods
~~~

This shows the contents of the `/etc/irods/service_account.config` file from the iCAT server.

## Tuning PostgreSQL on SSDs

[From this post](https://amplitude.engineering/how-a-single-postgresql-config-change-improved-slow-query-performance-by-50x-85593b8991b0), when running your database server on a solid state drive, the follow setting can help select a faster query plan.

~~~
random_page_cost = 1
~~~

More general PostgreSQL Tuning information may be found [in this set of slides](https://speakerdeck.com/ongres/postgresql-configuration-for-humans).

## Decommissioning a storage resource

There are multiple reasons that decommissioning an iRODS resource may be necessary.  Two scenarios are covered here.

### Migration to newer hardware

Use the following steps if newer hardware has been purchased and a migration of data has been planned:

1. Determine which iRODS server will host the new device.
2. Create a new iRODS resource that uses the new device.
3. Add the new resource to the appropriate resource hierarchy (could be standalone).
4. Replicate data to the new resource.
5. Trim data from the to-be-retired resource.
6. Remove the to-be-retired resource.
7. Safely disconnect the to-be-retired device.

### Existing storage device failure

Use the following steps if an existing device fails and is not recoverable:

1. Mark the bad resource 'down'

    `iadmin modresc <badRescName> status down`

2. Bring new resource online, alongside good replicas, under a replication resource

    `iadmin mkresc <newResc> ...`

    `iadmin addchildtoresc <replResc> <newResc>`

3. Run rebalance

    `iadmin modresc <replResc> rebalance`

4. Remove all replica listings on the bad resource from the catalog

    `itrim -M -r -S <badRescName> /<zoneName>`


5. Remove the bad resource

    `iadmin rmresc <badRescName>`

These steps allow for:

 - new incoming data to be synchronously redundant and

 - existing data to continue to be read from good resources while the new resource is being populated with good replicas

## Using temporaryStorage in the iRODS Rule Language

It is sometimes necessary or helpful to share a variable value across different PEPs.  This can be achieved through the use of `temporaryStorage`.

`temporaryStorage` is a global variable (of type `keyValPair_t`) available in the iRODS Rule Language Rule Engine Plugin that persists for the life of the `irodsAgent` process.

```
pep_resource_create_pre(*INSTANCE, *CONTEXT, *OUT) {
    temporaryStorage.example_important_variable = "create"
}
pep_resource_open_pre(*INSTANCE, *CONTEXT, *OUT) {
    temporaryStorage.example_important_variable = "open"
}
pep_resource_close_post(*INSTANCE, *CONTEXT, *OUT) {
    if (errorcode(temporaryStorage.example_important_variable) != 0){
        writeLine("serverLog", "temporary variable does not exist")
    } else if (temporaryStorage.example_important_variable == "create"){
        writeLine("serverLog", "this was a create")
    } else if (temporaryStorage.example_important_variable == "open"){
        writeLine("serverLog", "this was an open")
    }
}
```

When a data object is created, the close PEP could now 'know' that it was part of a create-write-close series of file operations, rather than an open-write-close or open-read-close.


`temporaryStorage` is not necessary in the Python Rule Engine Plugin.  To achieve the same effect, just use a Python variable that holds scope across different PEPs in a rule file.

## Cleaning empty directory trees on managed storage

iRODS does not attempt to remove directories in the storage systems it manages, only the physical replicas of data objects.
The storage system could be far away and/or slow to access which could hamper other synchronous operations within iRODS.
In active iRODS deployments, this behavior can leave a large number of 'leftover' empty directories (and therefore, inodes) on the storage system.

The following command will safely 'clean' a directory tree of empty directories:

```
find ROOTDIR -type d -empty -delete
```
