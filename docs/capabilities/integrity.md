#

The rule engine framework of iRODS can be leveraged to provide internal confidence that the data under management remains stable and good.

Checking a data object's associated metadata or confirming the presence of a manifest file in the right place could be some of the types of things that an integrity check could perform.

However, integrity checking within an iRODS Zone mostly consists of using checksums to track any changes over time in a data object or during transfer when replicating or uploading or downloading data objects.

iRODS provides a checksum API and makes it available through iCommands and built-in microservices in the rule engine framework.

The [`ichksum` iCommand documentation can be found here](../../icommands/user/#ichksum).

As a fixity check over time, a recurring rule could be placed into the delay queue that recursively walks a Collection and verifies a calculated checksum against the checksum value stored in the catalog:

`recursive_check.r`:
```
main {
    delay("<PLUSET>2s</PLUSET><EF>30s</EF><INST>irods_rule_engine_plugin-irods_rule_language-instance</INST>") {
        writeLine("serverLog", " -- firing fixity check");
        *query = SELECT COLL_NAME, DATA_NAME WHERE COLL_NAME like '/tempZone/home/alice%';
        foreach(*row in *query) {
            *logical_path = *row.COLL_NAME++"/"++*row.DATA_NAME;
            add_checksum_verification_to_queue(*logical_path);
        }
    }
}
INPUT null
OUTPUT ruleExecOut
```

This will require adding `add_checksum_verification_to_queue()` to a rule base on the server (perhaps `integrity.re`):

```
add_checksum_verification_to_queue(*logical_path) {
    delay("<PLUSET>1s</PLUSET><INST>irods_rule_engine_plugin-irods_rule_language-instance</INST>") {
        writeLine("serverLog", " -- verifying *logical_path");
        if (errorcode(msiDataObjChksum(*logical_path, "ChksumAll=++++verifyChksum=", *out_checksum_value)) < 0) {
            writeLine("serverLog", " -- FIXITY FAILED [*logical_path]");
        }
    }
}
```

Running `irule` will add the fixity check to the delay queue:
```
$ irule -r irods_rule_engine_plugin-irods_rule_language-instance -F recursive_check.r
```

The fixity check query and loop will show the rule in the delay queue:
```
$ iqstat
id     name
10529 
        writeLine("serverLog", " -- firing fixity check");
        *query = SELECT COLL_NAME, DATA_NAME WHERE COLL_NAME like '/tempZone/home/alice%';
        foreach(*row in *query) {
            *logical_path = *row.COLL_NAME++"/"++*row.DATA_NAME;
            add_checksum_verification_to_queue(*logical_path);
        }
```

Waiting a few seconds will show the contents of `*logical_path` having been added to the queue as well:
```
10529
        writeLine("serverLog", " -- firing fixity check");
        *query = SELECT COLL_NAME, DATA_NAME WHERE COLL_NAME like '/tempZone/home/alice%';
        foreach(*row in *query) {
            *logical_path = *row.COLL_NAME++"/"++*row.DATA_NAME;
            add_checksum_verification_to_queue(*logical_path);
        }

10531
        writeLine("serverLog", " -- verifying *logical_path");
        if (errorcode(msiDataObjChksum(*logical_path, "ChksumAll=++++verifyChksum=", *out_checksum_value)) < 0) {
            writeLine("serverLog", " -- FIXITY FAILED [*logical_path]");
        }

```

With the contents of `/tempZone/home/alice`:
```
$ ils -L
/tempZone/home/alice:
  alice             0 awesomeResc          893 2022-05-10.09:07 & foo
    sha2:19uRXlq12iqXL93+bxRedZOSrDhaE+k1TueY2cEcA6k=    generic    /var/lib/irods/Vault/home/alice/foo
  alice             1 myroot;replresc;red          893 2022-05-10.09:20 & foo
    sha2:19uRXlq12iqXL93+bxRedZOSrDhaE+k1TueY2cEcA6k=    generic    /tmp/redVault/home/alice/foo
  alice             2 myroot;replresc;green          893 2022-05-10.09:20 & foo
    sha2:19uRXlq12iqXL93+bxRedZOSrDhaE+k1TueY2cEcA6k=    generic    /tmp/greenVault/home/alice/foo
```

The results will appear in the `rodsLog`:
```
May 10 09:21:48 pid:17921 NOTICE: writeLine: inString =  -- firing fixity check
May 10 09:22:03 pid:17965 NOTICE: writeLine: inString =  -- verifying /tempZone/home/alice/foo
```

Note that there is only one line for `foo`, as it is a single data object with three replicas (confirmed consistent due to option `ChksumAll=` passed to `msiDataObjChksum()`).

This is just one example.  Anything that needs to be queried and looped and confirmed against a known value can be performed within the rule engine.  The approach of putting this background work onto the delay queue allows the work to be performed in parallel, potentially across multiple iRODS servers.
