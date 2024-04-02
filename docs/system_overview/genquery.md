#

## iRODS General Query (GenQuery)

GenQuery is the SQL-like syntax used to query the iRODS catalog. It is used throughout the server to accomplish everything required of the system from resource hierarchy resolution to enforcing permissions, as well as directly by users via `iquest` and other clients.

This page describes syntax for **GenQuery** because it has existed for almost as long as iRODS has existed and is used extensively throughout existing iRODS clients and servers. A more modern solution is now available in the iRODS server called **GenQuery2** which will eventually replace the legacy GenQuery implementation.

## GenQuery Syntax

### Selection syntax

The general form for selecting attributes in a query is:
```
select ATTRIBUTE[, ATTRIBUTE]*
```
...where ATTRIBUTE is a GenQuery attribute. Additional selected attributes are appended via a comma-delimited list. See [GenQuery Attributes](#genquery-attributes) for a list of attributes.

#### Order-by operators

Results can be ordered by using one of these operators:
 - ORDER: Returns the results in ascending order.
 - ORDER_DESC: Returns the results in descending order.

The order-by operators can be applied to any selected ATTRIBUTE and order-by operators can be applied to multiple ATTRIBUTEs. If multiple ATTRIBUTEs have an order-by operator applied, they are executed in order as they appear and the first operator to have any effect on the order of the results will be the effective order of the results. Any order-by operators which follow the first effective order-by operator will have no effect on the ordering of the results.

Here is an example:
```
"select order_desc(DATA_SIZE), order(DATA_MODIFY_TIME), order_desc(DATA_NAME), order_desc(DATA_RESC_NAME)"
```

If all of the replicas of all of the data objects have an identical `DATA_SIZE`, the order of the results will not change. If the replicas of the data objects have unique `DATA_MODIFY_TIME`s, the results will be ordered by `DATA_MODIFY_TIME`. If the data objects have unique `DATA_NAME`s, the order of the result set will not change because the results have alredy been ordered by `DATA_MODIFY_TIME`. If the data objects have multiple replicas which necessarily means that there are different `DATA_RESC_NAME`s in the result set, the order of the result set will not change because the results have alredy been ordered by `DATA_MODIFY_TIME`. So, the result set is ordered only by the first *effective* order-by operator.

Here is what the result set looks like when this query is run with `iquest` in a test environment:
```
DATA_SIZE = 241
DATA_MODIFY_TIME = 01712336391
DATA_NAME = foo
DATA_RESC_NAME = demoResc
------------------------------------------------------------
DATA_SIZE = 241
DATA_MODIFY_TIME = 01712336457
DATA_NAME = goo
DATA_RESC_NAME = demoResc
------------------------------------------------------------
DATA_SIZE = 241
DATA_MODIFY_TIME = 01712336823
DATA_NAME = foo
DATA_RESC_NAME = otherresc
------------------------------------------------------------
DATA_SIZE = 241
DATA_MODIFY_TIME = 01712336825
DATA_NAME = goo
DATA_RESC_NAME = otherresc
------------------------------------------------------------
```

#### Aggregation operators

GenQuery also supports a few "aggregation operators" which return a variety of information generated from the results rather than the results themselves:
 - SUM: Returns the sum of the results.
 - COUNT: Returns a count of the number of unique results from the selected attributes.
 - MIN: Returns the minimum value from the set of results.
 - MAX: Returns the maximum value from the set of results.
 - AVG: Returns the average value of the set of results.

These operators are case-sensitive, but can be supplied in all-caps or all-lowercase (i.e. `SUM` and `sum` are acceptable, but `Sum` is not).

The aggregation operators change behavior depending on how results are grouped. This will be demonstrated by way of an example. Take the following query:
```
select sum(DATA_SIZE)
```

This will return the total size of all the replicas of all the data objects in the zone. Here is what this looks like when this query is run with `iquest` in a test environment:
```
DATA_SIZE = 964
------------------------------------------------------------
```

If an additional ATTRIBUTE is selected...
```
select sum(DATA_SIZE), DATA_NAME
```

This will return the total size of all the replicas for each data object in the zone:
```
DATA_SIZE = 482
DATA_NAME = foo
------------------------------------------------------------
DATA_SIZE = 482
DATA_NAME = goo
------------------------------------------------------------
```

If yet another ATTRIBUTE is selected...
```
select sum(DATA_SIZE), DATA_NAME, DATA_RESC_NAME
```

This is equivalent to:
```
select DATA_SIZE, DATA_NAME, DATA_RESC_NAME
```

This will return the total size of each replica for each data object in the zone:
```
DATA_SIZE = 241
DATA_NAME = foo
DATA_RESC_NAME = demoResc
------------------------------------------------------------
DATA_SIZE = 241
DATA_NAME = foo
DATA_RESC_NAME = otherresc
------------------------------------------------------------
DATA_SIZE = 241
DATA_NAME = goo
DATA_RESC_NAME = demoResc
------------------------------------------------------------
DATA_SIZE = 241
DATA_NAME = goo
DATA_RESC_NAME = otherresc
------------------------------------------------------------
```

### Conditional syntax

Results can be selected conditionally by using the `where` clause. The general form for conditional arguments is:
```
where CONDITION [and CONDITION]*
```
...where CONDITION is the condition for the result set. Additional conditions can be appended with "and".

In general, CONDITION will have the following form:
```
ATTRIBUTE OPERATOR 'VALUE'[ || OPERATOR 'VALUE']*
```

ATTRIBUTE is a GenQuery attribute. See [GenQuery Attributes](#genquery-attributes) for a list of attributes.

OPERATOR can be one of a few different relational operators, most of which will be familiar to traditional SQL users:
 - '=': ATTRIBUTE must exactly match VALUE.
 - '<>'/'!=': ATTRIBUTE must not match VALUE.
 - '>'/'>=': ATTRIBUTE must be greater than (or greater than or equal to) VALUE.
 - '<'/'<=': ATTRIBUTE must be less than (or less than or equal to) VALUE.
 - 'like': ATTRIBUTE must match the wildcard expression in VALUE. See [Wildcard Expressions](#wildcard-expressions) for more information.
 - 'not like': ATTRIBUTE must not match the wildcard expression in VALUE. See [Wildcard Expressions](#wildcard-expressions) for more information.
 - 'between': ATTRIBUTE must be between two VALUEs, separated by a space. For example: `DATA_SIZE between '100' '1000'`
 - 'in': ATTRIBUTE must exactly match at least one VALUE in a comma-delimited list of VALUEs, which may be in parentheses (but does not need to be in parentheses). For example: `RESC_NAME in ('resc_a', 'resc_b')`

CONDITION can also be composed of multiple sub-conditions on the same ATTRIBUTE via logical-or operators, expressed by `||`. The `||` operator effectively expands the set of results allowed by the conditional clause by matching results which meet at least one of the individual sub-conditions. Here is an example usage of logical-or to demonstrate:
```
DATA_NAME like '%ooo%' || like 'goo%' || = 'very-special-case'
```
Any results with `DATA_NAME` values that match any of the 3 conditions will be returned. Note that these conditions are checked in order, so it is recommended to use ascending order of specificity for efficiency.

### Wildcard Expressions

VALUE must be surrounded by single-quotes and should be a constant value or wildcard expression. The following wildcard operators are supported:
 - '%': Matches on any number of any characters (including nothing). This is equivalent to '.\*' in traditional regular expressions.
 - '\_': Matches on any single character. This is equivalent to '.' in traditional regular expressions.

If a literal '%' or '\_' must be used as part of the value for the query (rather than in a wildcard expression), these can be escaped using a backslash (\\).

### Other options

There are a few other options that can be used with GenQuery to affect how the results are generated:
 - no-distinct: Instructs GenQuery to return all results, even repeating identical results where applicable.
 - uppercase: When specified, all VALUEs should be supplied in UPPERCASE and the query will be made case-insensitive.

## GenQuery Attributes

GenQuery attributes can be used in concert to retrieve information about an entity or category of entities from multiple different tables. If the attributes are not related in some way that will allow for table joinery, an error will occur, so make sure the query makes logical sense. Attempting a query where the selected ATTRIBUTEs cannot be logically linked together will result in the error `CAT_FAILED_TO_LINK_TABLES` (iRODS error code -825000). If this problem occurs, consider splitting the query into multiple queries or finding another ATTRIBUTE which will accomplish the task.

Here is the complete list of GenQuery attributes available for use anywhere an ATTRIBUTE is used. The attributes have been ordered alphabetically. Some attributes are unused in recent iRODS releases and will likely map to database columns which are no longer populated.

 - AUDIT_ACTION_ID
 - AUDIT_COMMENT
 - AUDIT_CREATE_TIME
 - AUDIT_MODIFY_TIME
 - AUDIT_OBJ_ID
 - AUDIT_USER_ID
 - COLL_ACCESS_COLL_ID
 - COLL_ACCESS_NAME
 - COLL_ACCESS_TYPE
 - COLL_ACCESS_USER_ID
 - COLL_COMMENTS
 - COLL_CREATE_TIME
 - COLL_ID
 - COLL_INFO_1
 - COLL_INFO_2
 - COLL_INHERITANCE
 - COLL_MAP_ID
 - COLL_MODIFY_TIME
 - COLL_NAME
 - COLL_OWNER_NAME
 - COLL_OWNER_ZONE
 - COLL_PARENT_NAME
 - COLL_TOKEN_NAMESPACE
 - COLL_TYPE
 - COLL_USER_NAME
 - COLL_ZONE_NAME
 - DATA_ACCESS_DATA_ID
 - DATA_ACCESS_NAME
 - DATA_ACCESS_TYPE
 - DATA_ACCESS_USER_ID
 - DATA_CHECKSUM
 - DATA_COLL_ID
 - DATA_COMMENTS
 - DATA_CREATE_TIME
 - DATA_EXPIRY
 - DATA_ID
 - DATA_MAP_ID
 - DATA_MODE
 - DATA_MODIFY_TIME
 - DATA_NAME
 - DATA_OWNER_NAME
 - DATA_OWNER_ZONE
 - DATA_PATH
 - DATA_REPL_NUM
 - DATA_REPL_STATUS
 - DATA_RESC_HIER
 - DATA_RESC_ID
 - DATA_RESC_NAME
 - DATA_SIZE
 - DATA_STATUS
 - DATA_TOKEN_NAMESPACE
 - DATA_TYPE_NAME
 - DATA_USER_NAME
 - DATA_VERSION
 - DATA_ZONE_NAME
 - DVM_BASE_MAP_BASE_NAME
 - DVM_BASE_MAP_COMMENT
 - DVM_BASE_MAP_CREATE_TIME
 - DVM_BASE_MAP_MODIFY_TIME
 - DVM_BASE_MAP_OWNER_NAME
 - DVM_BASE_MAP_OWNER_ZONE
 - DVM_BASE_MAP_VERSION
 - DVM_BASE_NAME
 - DVM_COMMENT
 - DVM_CONDITION
 - DVM_CREATE_TIME
 - DVM_EXT_VAR_NAME
 - DVM_ID
 - DVM_INT_MAP_PATH
 - DVM_MODIFY_TIME
 - DVM_OWNER_NAME
 - DVM_OWNER_ZONE
 - DVM_STATUS
 - DVM_VERSION
 - FNM_BASE_MAP_BASE_NAME
 - FNM_BASE_MAP_COMMENT
 - FNM_BASE_MAP_CREATE_TIME
 - FNM_BASE_MAP_MODIFY_TIME
 - FNM_BASE_MAP_OWNER_NAME
 - FNM_BASE_MAP_OWNER_ZONE
 - FNM_BASE_MAP_VERSION
 - FNM_BASE_NAME
 - FNM_COMMENT
 - FNM_CREATE_TIME
 - FNM_EXT_FUNC_NAME
 - FNM_ID
 - FNM_INT_FUNC_NAME
 - FNM_MODIFY_TIME
 - FNM_OWNER_NAME
 - FNM_OWNER_ZONE
 - FNM_STATUS
 - FNM_VERSION
 - META_ACCESS_META_ID
 - META_ACCESS_NAME
 - META_ACCESS_TYPE
 - META_ACCESS_USER_ID
 - META_COLL_ATTR_ID
 - META_COLL_ATTR_NAME
 - META_COLL_ATTR_UNITS
 - META_COLL_ATTR_VALUE
 - META_COLL_CREATE_TIME
 - META_COLL_MODIFY_TIME
 - META_DATA_ATTR_ID
 - META_DATA_ATTR_NAME
 - META_DATA_ATTR_UNITS
 - META_DATA_ATTR_VALUE
 - META_DATA_CREATE_TIME
 - META_DATA_MODIFY_TIME
 - META_MET2_ATTR_ID
 - META_MET2_ATTR_NAME
 - META_MET2_ATTR_UNITS
 - META_MET2_ATTR_VALUE
 - META_MET2_CREATE_TIME
 - META_MET2_MODIFY_TIME
 - META_MSRVC_ATTR_ID
 - META_MSRVC_ATTR_NAME
 - META_MSRVC_ATTR_UNITS
 - META_MSRVC_ATTR_VALUE
 - META_MSRVC_CREATE_TIME
 - META_MSRVC_MODIFY_TIME
 - META_NAMESPACE_COLL
 - META_NAMESPACE_DATA
 - META_NAMESPACE_MET2
 - META_NAMESPACE_MSRVC
 - META_NAMESPACE_RESC
 - META_NAMESPACE_RESC_GROUP
 - META_NAMESPACE_RULE
 - META_NAMESPACE_USER
 - META_RESC_ATTR_ID
 - META_RESC_ATTR_NAME
 - META_RESC_ATTR_UNITS
 - META_RESC_ATTR_VALUE
 - META_RESC_CREATE_TIME
 - META_RESC_GROUP_ATTR_ID
 - META_RESC_GROUP_ATTR_NAME
 - META_RESC_GROUP_ATTR_UNITS
 - META_RESC_GROUP_ATTR_VALUE
 - META_RESC_GROUP_CREATE_TIME
 - META_RESC_GROUP_MODIFY_TIME
 - META_RESC_MODIFY_TIME
 - META_RULE_ATTR_ID
 - META_RULE_ATTR_NAME
 - META_RULE_ATTR_UNITS
 - META_RULE_ATTR_VALUE
 - META_RULE_CREATE_TIME
 - META_RULE_MODIFY_TIME
 - META_TOKEN_NAMESPACE
 - META_USER_ATTR_ID
 - META_USER_ATTR_NAME
 - META_USER_ATTR_UNITS
 - META_USER_ATTR_VALUE
 - META_USER_CREATE_TIME
 - META_USER_MODIFY_TIME
 - MSRVC_ACCESS_MSRVC_ID
 - MSRVC_ACCESS_NAME
 - MSRVC_ACCESS_TYPE
 - MSRVC_ACCESS_USER_ID
 - MSRVC_COMMENT
 - MSRVC_CREATE_TIME
 - MSRVC_DOXYGEN
 - MSRVC_HOST
 - MSRVC_ID
 - MSRVC_LANGUAGE
 - MSRVC_LOCATION
 - MSRVC_MODIFY_TIME
 - MSRVC_MODULE_NAME
 - MSRVC_NAME
 - MSRVC_OWNER_NAME
 - MSRVC_OWNER_ZONE
 - MSRVC_SIGNATURE
 - MSRVC_STATUS
 - MSRVC_TOKEN_NAMESPACE
 - MSRVC_TYPE_NAME
 - MSRVC_VARIATIONS
 - MSRVC_VERSION
 - MSRVC_VER_COMMENT
 - MSRVC_VER_CREATE_TIME
 - MSRVC_VER_MODIFY_TIME
 - MSRVC_VER_OWNER_NAME
 - MSRVC_VER_OWNER_ZONE
 - QUOTA_LIMIT
 - QUOTA_MODIFY_TIME
 - QUOTA_OVER
 - QUOTA_RESC_ID
 - QUOTA_RESC_NAME
 - QUOTA_USAGE
 - QUOTA_USAGE_MODIFY_TIME
 - QUOTA_USAGE_RESC_ID
 - QUOTA_USAGE_USER_ID
 - QUOTA_USER_ID
 - QUOTA_USER_NAME
 - QUOTA_USER_TYPE
 - QUOTA_USER_ZONE
 - RESC_ACCESS_NAME
 - RESC_ACCESS_RESC_ID
 - RESC_ACCESS_TYPE
 - RESC_ACCESS_USER_ID
 - RESC_CHILDREN
 - RESC_CLASS_NAME
 - RESC_COMMENT
 - RESC_CONTEXT
 - RESC_CREATE_TIME
 - RESC_FREE_SPACE
 - RESC_FREE_SPACE_TIME
 - RESC_ID
 - RESC_INFO
 - RESC_LOC
 - RESC_MODIFY_TIME
 - RESC_MODIFY_TIME_MILLIS
 - RESC_NAME
 - RESC_PARENT
 - RESC_PARENT_CONTEXT
 - RESC_STATUS
 - RESC_TOKEN_NAMESPACE
 - RESC_TYPE_NAME
 - RESC_VAULT_PATH
 - RESC_ZONE_NAME
 - RULE_ACCESS_NAME
 - RULE_ACCESS_RULE_ID
 - RULE_ACCESS_TYPE
 - RULE_ACCESS_USER_ID
 - RULE_BASE_MAP_BASE_NAME
 - RULE_BASE_MAP_COMMENT
 - RULE_BASE_MAP_CREATE_TIME
 - RULE_BASE_MAP_MODIFY_TIME
 - RULE_BASE_MAP_OWNER_NAME
 - RULE_BASE_MAP_OWNER_ZONE
 - RULE_BASE_MAP_PRIORITY
 - RULE_BASE_MAP_VERSION
 - RULE_BASE_NAME
 - RULE_BODY
 - RULE_COMMENT
 - RULE_CONDITION
 - RULE_CREATE_TIME
 - RULE_DESCR_1
 - RULE_DESCR_2
 - RULE_DOLLAR_VARS
 - RULE_EVENT
 - RULE_EXEC_ADDRESS
 - RULE_EXEC_CONTEXT
 - RULE_EXEC_ESTIMATED_EXE_TIME
 - RULE_EXEC_FREQUENCY
 - RULE_EXEC_ID
 - RULE_EXEC_LAST_EXE_TIME
 - RULE_EXEC_NAME
 - RULE_EXEC_NOTIFICATION_ADDR
 - RULE_EXEC_PRIORITY
 - RULE_EXEC_REI_FILE_PATH
 - RULE_EXEC_STATUS
 - RULE_EXEC_TIME
 - RULE_EXEC_USER_NAME
 - RULE_ICAT_ELEMENTS
 - RULE_ID
 - RULE_INPUT_PARAMS
 - RULE_MODIFY_TIME
 - RULE_NAME
 - RULE_OUTPUT_PARAMS
 - RULE_OWNER_NAME
 - RULE_OWNER_ZONE
 - RULE_RECOVERY
 - RULE_SIDEEFFECTS
 - RULE_STATUS
 - RULE_TOKEN_NAMESPACE
 - RULE_VERSION
 - SLD_CREATE_TIME
 - SLD_LOAD_FACTOR
 - SLD_RESC_NAME
 - SL_CPU_USED
 - SL_CREATE_TIME
 - SL_DISK_SPACE
 - SL_HOST_NAME
 - SL_MEM_USED
 - SL_NET_INPUT
 - SL_NET_OUTPUT
 - SL_RESC_NAME
 - SL_RUNQ_LOAD
 - SL_SWAP_USED
 - TICKET_ALLOWED_GROUP_NAME
 - TICKET_ALLOWED_GROUP_TICKET_ID
 - TICKET_ALLOWED_HOST
 - TICKET_ALLOWED_HOST_TICKET_ID
 - TICKET_ALLOWED_USER_NAME
 - TICKET_ALLOWED_USER_TICKET_ID
 - TICKET_COLL_NAME
 - TICKET_CREATE_TIME
 - TICKET_DATA_COLL_NAME
 - TICKET_DATA_NAME
 - TICKET_EXPIRY
 - TICKET_ID
 - TICKET_MODIFY_TIME
 - TICKET_OBJECT_ID
 - TICKET_OBJECT_TYPE
 - TICKET_OWNER_NAME
 - TICKET_OWNER_ZONE
 - TICKET_STRING
 - TICKET_TYPE
 - TICKET_USER_ID
 - TICKET_USES_COUNT
 - TICKET_USES_LIMIT
 - TICKET_WRITE_BYTE_COUNT
 - TICKET_WRITE_BYTE_LIMIT
 - TICKET_WRITE_FILE_COUNT
 - TICKET_WRITE_FILE_LIMIT
 - TOKEN_COMMENT
 - TOKEN_CREATE_TIME
 - TOKEN_ID
 - TOKEN_MODIFY_TIME
 - TOKEN_NAME
 - TOKEN_NAMESPACE
 - TOKEN_VALUE
 - TOKEN_VALUE2
 - TOKEN_VALUE3
 - USER_COMMENT
 - USER_CREATE_TIME
 - USER_DN
 - USER_GROUP_ID
 - USER_GROUP_NAME
 - USER_ID
 - USER_INFO
 - USER_MODIFY_TIME
 - USER_NAME
 - USER_TYPE
 - USER_ZONE
 - ZONE_COMMENT
 - ZONE_CONNECTION
 - ZONE_CREATE_TIME
 - ZONE_ID
 - ZONE_MODIFY_TIME
 - ZONE_NAME
 - ZONE_TYPE

## Example Queries

Here is a list of example GenQueries for a variety of situations to demonstrate the different ways it can be used. These are also listed in the help text for `iquest`.

Get data object names and checksums for objects in all resources which start with "demo":
```
SELECT DATA_NAME, DATA_CHECKSUM WHERE DATA_RESC_NAME LIKE 'demo%'
```
Get all sub-collections of `/tempZone/home`:
```
SELECT COLL_NAME WHERE COLL_NAME LIKE '/tempZone/home/%'
```
Get ACLs for all data objects in collection `/tempZone/home/rods` (not subcollections):
```
SELECT USER_NAME, DATA_ACCESS_NAME, DATA_NAME WHERE COLL_NAME = '/tempZone/home/rods'
```
Find the resource names, hosts, and physical paths for all replicas of a particular data object at `/tempZone/home/rods/t2`:
```
SELECT RESC_NAME, RESC_LOC, RESC_VAULT_PATH, DATA_PATH WHERE DATA_NAME = 't2' AND COLL_NAME = '/tempZone/home/rods'
```
Find the number of data objects and amount of storage (in bytes) used by each user for each resource in the zone:
```
SELECT USER_NAME, SUM(DATA_SIZE), COUNT(DATA_NAME), RESC_NAME
```
Find the aggregate size of the data objects in `/tempZone/home/rods` and all of its subcollections for each resource:
```
SELECT SUM(DATA_SIZE), RESC_NAME WHERE COLL_NAME LIKE '/tempZone/home/rods%'
```
Get a list of data object names and IDs in `/tempZone/home/rods` and all of its subcollections, ordered from highest ID value to lowest ID value:
```
SELECT DATA_NAME, ORDER_DESC(DATA_ID) WHERE COLL_NAME LIKE '/tempZone/home/rods%'
```
Find all data objects with sizes between 100000 and 100200 bytes:
```
SELECT DATA_NAME, DATA_SIZE WHERE DATA_SIZE BETWEEN '100000' '100200'
```
Find data objects in `/tempZone/home/rods` and its subcollections created in a certain time window by using a wildcard pattern for the epoch time stored for `DATA_CREATE_TIME`:
```
SELECT COLL_NAME, DATA_NAME, DATA_CREATE_TIME WHERE COLL_NAME LIKE '/tempZone/home/rods%' AND DATA_CREATE_TIME LIKE '01508165%'
```
Find all data objects with replicas on resource `replResc` which are not marked "good":
```
SELECT COLL_NAME, DATA_NAME WHERE DATA_RESC_NAME = 'replResc' and DATA_REPL_STATUS != '1'
```
