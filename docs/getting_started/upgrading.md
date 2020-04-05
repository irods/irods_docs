Upgrading is handled by the host Operating System via the package manager.  Depending on your package manager, your config files will have been preserved with your local changes since the last installation.  Please see [Changing the zone_key and negotiation_key](installation.md#changing-the-zone_key-and-negotiation_key) for information on server-server authentication.

All servers in a Zone must be running the same version of iRODS.  Using inconsistent versions within a Zone may work, but is not rigorously tested.  First, upgrade the iRODS Catalog Provider, then upgrade all the iRODS Catalog Consumers.

It is best practice to stop an iRODS server before upgrading as it will allow the graceful completion of any ongoing transfers or requests.

Upgrades coming from the APT and YUM repositories require only that the server be restarted after upgrade.  The package does not restart the server because any required database schema updates are applied before starting the server.  A database schema update could be a relatively heavy operation and will require an amount of time on large installations (hundreds of millions of records) that should be handled within a declared maintenance window.

### Preserving `VERSION.json` history

Before upgrading from iRODS 4.1.x to 4.2+, copy `/var/lib/irods/VERSION.json` to `/var/lib/irods/VERSION.json.previous`.

With this file in place, the installation history of your deployment will be preserved in the 'previous_version' stanza.

Without this file in place, a dummy stanza will be inserted to allow the upgrade to complete successfully, but any previous deployment history will be lost.

### Temporary swapping of resource host information

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

### Updating stale information in unused catalog columns

Since 4.2.4, iRODS populates no-longer-used database columns with known values. Prior to 4.2.4, the values had been populated or updated inconsistently and may have been empty strings or NULL.

After successfully upgrading from 4.2.3 or earlier, the administrator should manually run the script located at `scripts/update_deprecated_database_columns.py`.

This script updates the following columns in `R_DATA_MAIN` to contain these known values:

 - resc_name: `EMPTY_RESC_NAME`
 - resc_hier: `EMPTY_RESC_HIER`
 - resc_group_name: `EMPTY_RESC_GROUP_NAME`

It skips any rows with an "invalid" `resc_id` value. A `resc_id` is considered invalid if it does not exist in the `R_RESC_MAIN` table or it maps to a known non-storage resource (i.e. coordinating resource).

The script has a `--dry-run` option and can safely be interrupted and run again (it is only querying the database for values to update, and then updating them).

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
