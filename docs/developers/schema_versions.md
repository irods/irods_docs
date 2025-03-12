#

## Guidelines for managing schema versions

### iRODS 4

Over the course of development, it is necessary to consider whether the schema version for various things should be adjusted. There are a number of files and locations which this applies to. They are as follows:

- irods_environment.json _(file) (service account only)_
- server_config.json _(file)_
- version.json _(file)_
- R_GRID_CONFIGURATION _(database table)_

To aid with this process, the following guidelines are provided:

- Keep the `schema_version` property in alignment across configuration **files**
- Avoid schema version number conflicts across git branches
    - Do not decrement schema version numbers
    - Do not reuse schema version numbers
- Understand the relationship between R_GRID_CONFIGURATION and version.json
    - A catalog schema upgrade is triggered anytime the `catalog_schema_version` _(in version.json)_ is less than the schema version in the catalog
    - The **current** catalog schema version can be retrieved from the catalog using any of the following:
        - SQL: `select * from R_GRID_CONFIGURATION where namespace = 'database' and option_name = 'schema_version'`
        - icommand: `iadmin get_grid_configuration database schema_version`

In general, a schema version should be adjusted if and only if there's a change in the schema's definition. This is typically reserved for major releases _(e.g. upgrading from iRODS 4.2 to iRODS 4.3)_.

A _change in the schema definition_ is defined as the addition, modification, and/or removal of a JSON property or database table/column.

### iRODS 5 and later

Starting with iRODS 5, version numbers consist of three segments, _X.Y.Z_, where _X_ is the major version number, _Y_ is the minor version number, and _Z_ is the patch version number. A major version change consists of the major version number being incremented. For example, upgrading from iRODS 4.3.4 to iRODS 5.0.0 or iRODS 5.1.0 to iRODS 6.0.0.

The guidelines defined for iRODS 4 still apply to iRODS 5, but iRODS 5 reduces the management of schema versions to two CMake variables, defined in the top-level CMakeLists.txt file. They are as follows:

| CMake Variable | Description |
| :--- | :--- |
| IRODS_CATALOG_SCHEMA_VERSION | Defines the schema version of the catalog. |
| IRODS_CONFIGURATION_SCHEMA_VERSION | Defines the schema version of the configuration files. |
