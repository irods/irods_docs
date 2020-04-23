Upgrading is handled by the host Operating System via the package manager.  Depending on your package manager, your config files will have been preserved with your local changes since the last installation.  Please see [Changing the zone_key and negotiation_key](installation.md#changing-the-zone_key-and-negotiation_key) for information on server-server authentication.

All servers in a Zone must be running the same version of iRODS.  Using inconsistent versions within a Zone may work, but is not rigorously tested.  First, upgrade the iRODS Catalog Provider, then upgrade all the iRODS Catalog Consumers.

It is best practice to stop an iRODS server before upgrading as it will allow the graceful completion of any ongoing transfers or requests.

Upgrades coming from the APT and YUM repositories require only that the server be restarted after upgrade.  The package does not restart the server because any required database schema updates are applied before starting the server.  A database schema update could be a relatively heavy operation and will require an amount of time on large installations (hundreds of millions of records) that should be handled within a declared maintenance window.

## Preserving `VERSION.json` history

Before upgrading from iRODS 4.1.x to 4.2+, copy `/var/lib/irods/VERSION.json` to `/var/lib/irods/VERSION.json.previous`.

With this file in place, the installation history of your deployment will be preserved in the 'previous_version' stanza.

Without this file in place, a dummy stanza will be inserted to allow the upgrade to complete successfully, but any previous deployment history will be lost.

## Temporary swapping of resource host information

During an upgrade from 4.1.x to 4.2.x, due to the renaming of the 4.1 `irods-icat` package to `irods-server` in 4.2, the `preremove.sh` script of the old package is run and may perform a dry-run to check if the iRODS resources pinned to that hostname can be removed.  This was an attempt for an iRODS server to cleanup its resources before being uninstalled.  The `preremove.sh` script no longer attempts this removal since 4.2.8, but when upgrading from 4.1.x, the old code will still fire.

iRODS 4.2.8+ includes a script that generates `iadmin modresc` commands for the rodsadmin to perform before and after the Catalog Consumers are upgraded.

Please see `scripts/generate_iadmin_commands_for_41_to_42_upgrade.py`:

```
# This script is designed to be run on a newly upgraded (from 4.1.x to 4.2.x)
# Catalog Provider before upgrading the Catalog Consumers in the same Zone from 4.1.x.
#
# This script makes no changes to the iRODS iCAT itself.
#
# This script generates two sets of iadmin commands to be run on the Catalog Provider.
#
# This script is not required, but provides additional assurance that no
# resources will be deleted due to any confusion associated with the
# packaged preremove.sh script included in 4.1 (including and up to 4.1.12).
```

This is complementary to the [best practice of having the service account for an iRODS server connect as a client to itself](../system_overview/best_practices.md#service-account-as-client-to-local-server).

## Updating stale information in unused catalog columns

Since 4.2.4, iRODS populates no-longer-used database columns with known values. Prior to 4.2.4, the values had been populated or updated inconsistently and may have been empty strings or NULL.

After successfully upgrading from 4.2.3 or earlier, the administrator should manually run the script located at `scripts/update_deprecated_database_columns.py`.

This script updates the following columns in `R_DATA_MAIN` to contain these known values:

 - resc_name: `EMPTY_RESC_NAME`
 - resc_hier: `EMPTY_RESC_HIER`
 - resc_group_name: `EMPTY_RESC_GROUP_NAME`

It skips any rows with an "invalid" `resc_id` value. A `resc_id` is considered invalid if it does not exist in the `R_RESC_MAIN` table or it maps to a known non-storage resource (i.e. coordinating resource).

The script has a `--dry-run` option and can safely be interrupted and run again (it is only querying the database for values to update, and then updating them).

Since 4.2.4, `isysmeta`, `iquest`, and `ils` all present information about resources based on the `resc_id` field.  The `resc_id` is dereferenced and any resource names or hierarchies are then derived and presented to the user.  There is no iRODS code dependent on the values in the no-longer-used database columns.  The columns were scrubbed, rather than removed, out of extreme caution against data loss.

## Migrating from Static PEPs to Dynamic PEPs

The dynamic policy enforcement points (PEPs) represent the most reliable way to interact with the iRODS rule engine plugin framework (REPF).  Migrating from the legacy static policy enforcement points (PEPs) is recommended.

Migrating involves understanding the mapping of the legacy session variables to the dynamic context-based variables.  Please see the examples below for how the REPF provides the full operating context of each dynamic PEP and how they can be used in the rule and policy logic.

### acPostProcForPut()

Using the static PEP
```
acPostProcForPut(){
    writeLine("serverLog",$rescName)
    writeLine("serverLog",$objPath)
    writeLine("serverLog",$userNameClient)
    writeLine("serverLog",$rodsZoneClient)
    writeLine("serverLog",$dataSize)
}
```
produces
```
Apr 19 14:56:44 pid:22819 NOTICE: writeLine: inString = anotherResc
Apr 19 14:56:44 pid:22819 NOTICE: writeLine: inString = /tempZone/home/rods/testfile
Apr 19 14:56:44 pid:22819 NOTICE: writeLine: inString = rods
Apr 19 14:56:44 pid:22819 NOTICE: writeLine: inString = tempZone
Apr 19 14:56:44 pid:22819 NOTICE: writeLine: inString = 12
```

### pep_api_data_obj_put_post()

Moving to the dynamic PEP that fires after a data object is put via the iRODS API
```
pep_api_data_obj_put_post(*INSTANCE_NAME, *COMM, *DATAOBJINP, *BUFFER, *PORTAL_OPR_OUT){
    writeLine("serverLog",*DATAOBJINP)
    writeLine("serverLog",*DATAOBJINP.destRescName)
}
```
produces
```
Apr 19 14:56:44 pid:22819 NOTICE: writeLine: inString = KeyValue[15]:create_mode=0;dataIncluded=;dataType=generic;data_size=12;destRescName=anotherResc;noOpenFlag=;num_threads=0;obj_path=/tempZone/home/rods/testfile;offset=0;openType=1;open_flags=2;opr_type=1;resc_hier=anotherResc;selObjType=dataObj;translatedPath=;
Apr 19 14:56:44 pid:22819 NOTICE: writeLine: inString = anotherResc
```

Note that the legacy `$rescName` can now be seen as `*DATAOBJINP.destRescName`.


### pep_resource_open_post()

In a slightly different scenario, the plugin instance name can be used in the branching logic within a rule.  Within a resource plugin dynamic PEP, the `*INSTANCE` variable holds the name of the instantiated plugin.

```
pep_resource_open_post(*INSTANCE, *CONTEXT, *OUT)  {
    if(*INSTANCE == "anotherResc") {
        writeLine('serverLog', '*INSTANCE -- printing context...');
        writeLine("serverLog", *CONTEXT);
        foreach (*I in *CONTEXT) {
            writeLine("serverLog", *I++"="++*CONTEXT.*I)
        }
        writeLine("serverLog", *CONTEXT.logical_path);
        writeLine("serverLog", *CONTEXT.physical_path);
    }
    else {
        writeLine('serverLog', '*INSTANCE -- DO NOTHING');
    }
}
```

When there are two replicas of `testfile` available, replica `0` on `demoResc` and replica `1` on `anotherResc` under a passthru `pt`, two `iget`s will produce different activity in the server
```
$ ils -L testfile
  rods              0 demoResc           18 2020-04-19.15:33 & testfile
        generic    /var/lib/irods/Vault/rods/home/rods/testfile
  rods              1 pt;anotherResc        18 2020-04-19.15:33 & testfile
        generic    /tmp/anotherRescVault/rods/home/rods/testfile
$ iget -n 0 testfile -
i am the testfile
$ iget -n 1 testfile -
i am the testfile
```

The first `iget` (of replica `0`) produces this in the rodsLog
```
Apr 19 16:03:19 pid:31173 NOTICE: writeLine: inString = demoResc -- DO NOTHING
```

The second `iget` (of replica `1`) produces
```
Apr 19 16:05:29 pid:31437 NOTICE: writeLine: inString = anotherResc -- printing context...
Apr 19 16:05:29 pid:31437 NOTICE: writeLine: inString = KeyValue[45]:auth_scheme=native;client_addr=127.0.0.1;dataId=0;dataType=;file_descriptor=15;file_size=0;flags_kw=0;in_pdmo=;l1_desc_idx=-1;logical_path=/tempZone/home/rods/testfile;mode_kw=384;phyOpenBySize=;physical_path=/tmp/anotherRescVault/rods/home/rods/testfile;proxy_auth_info_auth_flag=5;proxy_auth_info_auth_scheme=;proxy_auth_info_auth_str=;proxy_auth_info_flag=0;proxy_auth_info_host=;proxy_auth_info_ppid=0;proxy_rods_zone=tempZone;proxy_sys_uid=0;proxy_user_name=rods;proxy_user_other_info_user_comments=;proxy_user_other_info_user_create=;proxy_user_other_info_user_info=;proxy_user_other_info_user_modify=;proxy_user_type=;replNum=1;repl_requested=-1;resc_hier=pt;anotherResc;translatedPath=;user_auth_info_auth_flag=5;user_auth_info_auth_scheme=;user_auth_info_auth_str=;user_auth_info_flag=0;user_auth_info_host=;user_auth_info_ppid=0;user_rods_zone=tempZone;user_sys_uid=0;user_user_name=rods;user_user_other_info_user_comments=;user_user_other_info_user_create=;user_user_other_info_user_info=;user_user_
Apr 19 16:05:29 pid:31437 NOTICE: writeLine: inString = auth_scheme=native
Apr 19 16:05:29 pid:31437 NOTICE: writeLine: inString = client_addr=127.0.0.1
Apr 19 16:05:29 pid:31437 NOTICE: writeLine: inString = dataId=0
Apr 19 16:05:29 pid:31437 NOTICE: writeLine: inString = dataType=
Apr 19 16:05:29 pid:31437 NOTICE: writeLine: inString = file_descriptor=15
Apr 19 16:05:29 pid:31437 NOTICE: writeLine: inString = file_size=0
Apr 19 16:05:29 pid:31437 NOTICE: writeLine: inString = flags_kw=0
Apr 19 16:05:29 pid:31437 NOTICE: writeLine: inString = in_pdmo=
Apr 19 16:05:29 pid:31437 NOTICE: writeLine: inString = l1_desc_idx=-1
Apr 19 16:05:29 pid:31437 NOTICE: writeLine: inString = logical_path=/tempZone/home/rods/testfile
Apr 19 16:05:29 pid:31437 NOTICE: writeLine: inString = mode_kw=384
Apr 19 16:05:29 pid:31437 NOTICE: writeLine: inString = phyOpenBySize=
Apr 19 16:05:29 pid:31437 NOTICE: writeLine: inString = physical_path=/tmp/anotherRescVault/rods/home/rods/testfile
Apr 19 16:05:29 pid:31437 NOTICE: writeLine: inString = proxy_auth_info_auth_flag=5
Apr 19 16:05:29 pid:31437 NOTICE: writeLine: inString = proxy_auth_info_auth_scheme=
Apr 19 16:05:29 pid:31437 NOTICE: writeLine: inString = proxy_auth_info_auth_str=
Apr 19 16:05:29 pid:31437 NOTICE: writeLine: inString = proxy_auth_info_flag=0
Apr 19 16:05:29 pid:31437 NOTICE: writeLine: inString = proxy_auth_info_host=
Apr 19 16:05:29 pid:31437 NOTICE: writeLine: inString = proxy_auth_info_ppid=0
Apr 19 16:05:29 pid:31437 NOTICE: writeLine: inString = proxy_rods_zone=tempZone
Apr 19 16:05:29 pid:31437 NOTICE: writeLine: inString = proxy_sys_uid=0
Apr 19 16:05:29 pid:31437 NOTICE: writeLine: inString = proxy_user_name=rods
Apr 19 16:05:29 pid:31437 NOTICE: writeLine: inString = proxy_user_other_info_user_comments=
Apr 19 16:05:29 pid:31437 NOTICE: writeLine: inString = proxy_user_other_info_user_create=
Apr 19 16:05:29 pid:31437 NOTICE: writeLine: inString = proxy_user_other_info_user_info=
Apr 19 16:05:29 pid:31437 NOTICE: writeLine: inString = proxy_user_other_info_user_modify=
Apr 19 16:05:29 pid:31437 NOTICE: writeLine: inString = proxy_user_type=
Apr 19 16:05:29 pid:31437 NOTICE: writeLine: inString = replNum=1
Apr 19 16:05:29 pid:31437 NOTICE: writeLine: inString = repl_requested=-1
Apr 19 16:05:29 pid:31437 NOTICE: writeLine: inString = resc_hier=pt;anotherResc
Apr 19 16:05:29 pid:31437 NOTICE: writeLine: inString = translatedPath=
Apr 19 16:05:29 pid:31437 NOTICE: writeLine: inString = user_auth_info_auth_flag=5
Apr 19 16:05:29 pid:31437 NOTICE: writeLine: inString = user_auth_info_auth_scheme=
Apr 19 16:05:29 pid:31437 NOTICE: writeLine: inString = user_auth_info_auth_str=
Apr 19 16:05:29 pid:31437 NOTICE: writeLine: inString = user_auth_info_flag=0
Apr 19 16:05:29 pid:31437 NOTICE: writeLine: inString = user_auth_info_host=
Apr 19 16:05:29 pid:31437 NOTICE: writeLine: inString = user_auth_info_ppid=0
Apr 19 16:05:29 pid:31437 NOTICE: writeLine: inString = user_rods_zone=tempZone
Apr 19 16:05:29 pid:31437 NOTICE: writeLine: inString = user_sys_uid=0
Apr 19 16:05:29 pid:31437 NOTICE: writeLine: inString = user_user_name=rods
Apr 19 16:05:29 pid:31437 NOTICE: writeLine: inString = user_user_other_info_user_comments=
Apr 19 16:05:29 pid:31437 NOTICE: writeLine: inString = user_user_other_info_user_create=
Apr 19 16:05:29 pid:31437 NOTICE: writeLine: inString = user_user_other_info_user_info=
Apr 19 16:05:29 pid:31437 NOTICE: writeLine: inString = user_user_other_info_user_modify=
Apr 19 16:05:29 pid:31437 NOTICE: writeLine: inString = user_user_type=
Apr 19 16:05:29 pid:31437 NOTICE: writeLine: inString = /tempZone/home/rods/testfile
Apr 19 16:05:29 pid:31437 NOTICE: writeLine: inString = /tmp/anotherRescVault/rods/home/rods/testfile
Apr 19 16:05:29 pid:31437 NOTICE: writeLine: inString = pt -- DO NOTHING
```

Note the full `*CONTEXT` is holding 45 elements, including `logical_path` and `physical_path`.  The `resc_hier` is `pt;anotherResc`.

Also note the last line showing that the `DO NOTHING` branch fired for the `pt` instance of the resource plugin.  These both fired within the same PID, showing that the same `irodsAgent` ran this code twice, once per resource plugin in the resource hierarchy for the replica of `testfile` being retrieved.

### pep_resource_open_pre()

Alternatively, if the goal is to prevent a particular user from accessing replicas from a particular resource, the following dynamic PEP will fire before the file is opened on disk
```
pep_resource_open_pre(*INSTANCE, *CONTEXT, *OUT)  {
    if (*INSTANCE == "anotherResc" && *CONTEXT.user_user_name == "rods") {
        *errorcode = -830000
        *errormsg = "User rods not allowed here"
        failmsg(*errorcode, *errormsg)
    }
}
```
Then, getting replica `0` works fine
```
$ iget -n 0 testfile -
i am the testfile
```
but attempting to get replica `1` generates the error from the rule and is received by the client
```
$ iget -n 1 testfile -
remote addresses: 127.0.1.1 ERROR: getUtil: get error for - status = -830000 CAT_INSUFFICIENT_PRIVILEGE_LEVEL
```

This `ERROR` case would also be logged in the server.

### pep_api_mod_avu_metadata_pre()

The same permission check could be performed prior to allowing updates to metadata on data objects or collections they should not update.

```
pep_api_mod_avu_metadata_pre(*INSTANCE_NAME, *COMM, *MODAVUMETADATAINP) {
    writeLine("serverLog", *MODAVUMETADATAINP)
    if (*COMM.user_user_name == "rods") {
        failmsg(-830000,"rods not allowed to update metadata")
    }
}
```
Attempting to set an AVU on `testfile`
```
$ imeta set -d testfile a v u
remote addresses: 127.0.1.1 ERROR: rcModAVUMetadata failed with error -830000 CAT_INSUFFICIENT_PRIVILEGE_LEVEL
```
produces the error for the client above but also prints the full context to the rodsLog before exiting
```
Apr 19 21:14:34 pid:4025 NOTICE: writeLine: inString = KeyValue[10]:arg0=set;arg1=-d;arg2=/tempZone/home/rods/testfile;arg3=a;arg4=v;arg5=u;arg6=;arg7=;arg8=;arg9=;
```


## Non-Package Installs

Non-package installs have been made available for development, testing, and backwards compatibility.  The lack of managed update scripts, coupled with a growing array of possible plugin combinations, will make sustaining a non-package installation much more challenging.

It is possible that in the 5.0 timeframe, with the plans for a proper plugin registry, managing a non-package installation can be handled more gracefully.

## From iRODS 3.3.x

Migrating from iRODS 3.3.x to iRODS 4.0+ is not supported with an automatic script.  There is no good way to automate setting the new configuration options (resource hierarchies, server_config.json, etc.) based solely on the state of a 3.3.x system.  In addition, with some of the new functionality, a system administrator may choose to implement some existing policies in a different manner with 4.0+.

<span style="color:red">For these reasons, the following manual steps should be carefully studied and understood before beginning the migration process to 4.0.x or 4.1.x.  There is no migration path to 4.2+ without migrating to 4.0.x/4.1.x and then upgrading.</span>

1. Port any existing custom development to plugins: Microservices, Resources, Authentication
2. Make a backup of the iCAT database, and all iRODS configuration files: core.re, core.fnm, core.dvm, server.config, custom rulefiles, server's .irodsEnv
3. Declare a Maintenance Window
4. Remove resources from resource groups
5. Remove resource groups (confirm: `iadmin lrg` returns no results)
6. Shutdown 3.3.x server(s)
7. Make sure existing 3.3.x iCAT database is available (either `irodsctl dbstart`, or externally managed database)
8. Install iRODS 4.0+ packages: irods-icat and a database plugin package (e.g. irods-database-plugin-postgres)
9. Patch existing database with provided upgrade SQL file (psql ICAT < `packaging/upgrade-3.3.xto4.0.0.sql`)
10. If necessary, migrate 3.3.x in-place iCAT database to the system database installation.  It is recommended to dump and restore your database into the system installation.  This will allow the original database to be uninstalled completely, once the iRODS upgrade is confirmed.  If you were already using an externally managed database and want to continue with that arrangement, this step is not necessary.
11. For a new local system database installation, provide a database user 'irods', database password, and owner permissions for that database user to the new iCAT.  If you are using an externally managed database, this step is not necessary as these values should already exist.
12. Manually update any changes to 'core.re' and 'server_config.json'.  Keep in mind immediate replication rules (`acPostProcForPut`, etc.) may be superceded by your new resource composition.
13. Run `./packaging/setup_irods.sh` (recommended) OR Manually update all 4.0+ configuration files given previous 3.3.x configuration (.irodsEnv, .odbc.ini DSN needs to be set to either 'postgres', 'mysql', or 'oracle').  The automatic ``./packaging/setup_irods.sh`` script will work only when targeting the system-installed database server or an externally managed database server (it will not know about the legacy 3.3.x location).
14. Confirm all local at-rest data (any local iRODS Vault paths) have read and write permissions for the new (default) 'irods' unix service account.
15. Start new 4.0+ iCAT server (`irodsctl start`)
16. On all resource servers in the same Zone, install and setup 4.0+.  Existing configuration details should be ported as well ('server.config', 'core.re', Vault permissions).
17. Rebuild Resource Hierarchies from previous Resource Group configurations (`iadmin addchildtoresc`) (See [Composable Resources](../plugins/composable_resources.md))
18. Install any custom plugins (Microservice, Resources, Authentication)
19. Perform your conformance testing
20. Sunset 3.3.x server(s)
21. Close your Maintenance Window
22. Share with your users any relevant changes to their connection credentials (possibly nothing to do here).

!!! Note
    Migrating from in-place 3.3.x to a [non-package production installation of 4.0+](#non-package-installs) is not recommended.
