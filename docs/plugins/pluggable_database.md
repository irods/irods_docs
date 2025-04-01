#

The iRODS metadata catalog is installed and managed by separate plugins.  iRODS has PostgreSQL, MySQL, and Oracle database plugins available and tested.

The particular type of database is encoded in `/etc/irods/database_config.json` with the following directive:

~~~
"catalog_database_type" : "postgres",
~~~

This is populated by the `setup_irods.py` script on configuration.

To implement a new database plugin, a developer will need to provide implementations for all of the plugin operations and GenQuery.
