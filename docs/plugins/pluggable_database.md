The iRODS metadata catalog is installed and managed by separate plugins.  iRODS has PostgreSQL, MySQL, and Oracle database plugins available and tested.

The particular type of database is encoded in `/etc/irods/database_config.json` with the following directive:

~~~
"catalog_database_type" : "postgres",
~~~

This is populated by the `setup_irods.py` script on configuration.

The iRODS 3.x icatHighLevelRoutines are, in effect, the API calls for the database plugins.  No changes should be needed to any calls to the icatHighLevelRoutines.

To implement a new database plugin, a developer will need to provide the existing 84 SQL calls (in icatHighLevelRoutines) and an implementation of GenQuery.

