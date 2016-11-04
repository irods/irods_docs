# Upgrading

Upgrading is handled by the host Operating System via the package manager.  Depending on your package manager, your config files will have been preserved with your local changes since the last installation.  Please see [Changing the zone_key and negotiation_key](installation.md#changing-the-zone_key-and-negotiation_key) for information on server-server authentication.

All servers in a Zone must be running the same version of iRODS.  Using inconsistent versions within a Zone may work, but is not rigorously tested.  First, upgrade the iCAT server, then upgrade all the Resource servers.

Upgrades coming from the APT and YUM repositories require only that the server be restarted after upgrade.  The package does not restart the server because any required database schema updates are applied before starting the server.  A database schema update could be a relatively heavy operation and will require an amount of time on large installations (hundreds of millions of records) that should be handled within a declared maintenance window.

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
