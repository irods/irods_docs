Some of the commonly encountered iRODS errors along with troubleshooting steps are discussed below.

## The Server Log (rodsLog)

The iRODS server log (rodsLog) is the best place to find a history of what has happened and any error codes and file paths that may explain unexpected behavior.  The rodsLog is found at `/var/lib/irods/server/log/rodsLog*`.  The rodsLog is rotated every few days, so make sure you're looking at the latest file for recent error messages.  The debugging level (below) affects how many messages are written to the rodsLog.

## Debugging Levels

Some settings within iRODS can be useful when developing for iRODS or when working through diagnosing unexpected server-side behavior.  The following environment variables can be set in the service account and require a server restart to take effect (`./irodsctl restart`):

- `spLogLevel=N` - This will send to the rodsLog all log messages of `N` or more severe (`1`, or `LOG_SYS_FATAL` is most severe).  Increasing the log level will increase the number of messages written to rodsLog.  Setting `spLogLevel` to `8` or more will show the wireline XML packing instructions.  This can also be set in the service account's `irods_environment.json` file as `irods_log_level` (and not require a server restart, as each rodsAgent reads this environment file on standup, per incoming iRODS connection).

 | Verbosity       | spLogLevel   |
 | --------------- | ------------ |
 | LOG_DEBUG10     | 10           |
 | LOG_DEBUG9      |  9           |
 | LOG_DEBUG8      |  8 (XML)     |
 | LOG_DEBUG       |  7           |
 | LOG_DEBUG6      |  6           |
 | LOG_NOTICE      |  5 (default) |
 | LOG_WARNING     |  4           |
 | LOG_ERROR       |  3           |
 | LOG_SYS_WARNING |  2           |
 | LOG_SYS_FATAL   |  1           |

- `spLogSql=1` - This will send to the rodsLog the bind variables, the SQL query, and the return values going to and coming from the database.  This needs to be set on the iCAT server.  Setting this on a resource server will have no effect.

Additionally, client side environment variables will affect all new connections without a server restart:

- `irodsProt=1` - This client side environment variable will request the client and server both use the iRODS XML protocol for the entire connection.  Note that the initial iRODS handshake is always XML, so even without `irodsProt` set, a high `spLogLevel` setting on the server will cause some messages to be displayed.

## iRODS Server is down

!!! error
    USER_SOCK_CONNECT_TIMEDOUT -347000

!!! error
    CROSS_ZONE_SOCK_CONNECT_ERR -92110

!!! error
    USER_SOCK_CONNECT_ERR -305000

Common areas to check for this error include:

**ienv**

- The ienv command displays the iRODS environment in use.  This may help debug the obvious error of trying to connect to the wrong machine or to the wrong Zone name.

**Networking issues**

- Verify that a firewall is not blocking the connection on the iRODS ports in use (default 1247 and 1248) (or the higher ports for parallel transfer).

- Check for network connectivity problems by pinging the server in question.

**iRODS server logs**

If the iRODS environment issues and networking issues have been ruled out, the iRODS server/client logs may provide additional information with regards to the specifics of the error in question.

## Routing issue and/or an accidental use of localhost

!!! error
    SYS_EXCEED_CONNECT_CNT -9000

This error occurs when one of the iRODS servers fails to recognize itself as localhost (and probably the target of the request) and subsequently routes the request to another server (with its hostname).  This usually occurs because of a configuration error in /etc/hosts possibly due to:

1. DHCP lease renewal
2. shortnames used instead of fully qualified domain names
3. a simple typo

Every iRODS server in a Zone needs to be fully routable to and from every other iRODS server in the Zone.

There are two networking requirements for iRODS:

1. Each server in the Zone will be referred to by exactly one hostname, this is the hostname returned by `hostname`.

2. Each server in the Zone must be able to resolve the hostnames of all servers, including itself, to a routable IP address.


!!! error
    USER_RODS_HOSTNAME_ERR -303000

This error could occur if the gethostname() function is not returning the expected value on every machine in the Zone.  The values in the iCAT must match the values returned by gethostname() on each machine.

## No such file or directory

Common areas to check for this error include:

1. Permissions - Verify that the iRODS user has 'write' access to the directory in question
2. FUSE error
3. Zero byte files


## No rows found in the iRODS Catalog

!!! error
    CAT_NO_ROWS_FOUND -808000

This error is occurs when there are no results for the database query that was executed. This usually happens when either:

1. the query itself is not well-formed (e.g. syntax error), or
2. the well-formed query produced no actual results (i.e. there is no data corresponding to the specified criteria).

## Access Control and Permissions

!!! error
    CAT_NO_ACCESS_PERMISSION -818000

This error can occur when an iRODS user tries to access an iRODS Data Object or Collection that belongs to another iRODS user without the owner having granted the appropriate permission (usually simply read or write).

With the more restrictive "StrictACL" policy being turned "on" by default in iRODS 4.0+, this may occur more often than expected with iRODS 3.x.  Check the permissions carefully and use `ils -AL` to help diagnose what permissions *are* set for the Data Objects and Collections of interest.

Modifying the "StrictACL" setting in the iRODS server's `core.re` file will apply the policy permanently; applying the policy via `irule` will have an impact only during the execution of that particular rule.

## Credentials

!!! error
    CAT_INVALID_USER -827000

This error can occur when the iRODS user is unknown or invalid in some way (for instance, no password has been defined for the user, or the user does not exist in that Zone).  This error is most common while debugging configuration issues with Zone Federation.

## Rule Engine Plugin Framework Error

!!! error
    RULE_ENGINE_ERROR -1828000

This error can occur when a user sends a rule to the wrong rule engine plugin instance.

In the following case, the Python rule engine plugin is invoked (because it is listed first
in `server_config.json`), tries to interpret the iRODS Rule Language rule text it is given,
and then returns a `SyntaxError` since it is not valid Python:

```
$ irule -vF goodrule.r
rcExecMyRule: goodrule{
 writeLine("serverLog","testing...")
}

outParamDesc:
ERROR: rcExecMyRule error.  status = -1828000 RULE_ENGINE_ERROR
```

```
$ tail -n16 /var/lib/irods/log/rodsLog*
Oct 21 22:40:35 pid:21170 ERROR: caught python exception:   File "<string>", line 1
    goodrule{
            ^
SyntaxError: invalid syntax
Oct 21 22:40:35 pid:21170 ERROR: rsExecMyRule : -1828000, [-]   ../irods_rule_engine_plugin-python.cxx:999:irods::error exec_rule_text(irods::default_re_ctx &, std::string, std::list<boost::any> &, irods::callback) :  status [RULE_ENGINE_ERROR]  errno [] -- message [irods_rule_engine_plugin_python::irods::error exec_rule_text(irods::default_re_ctx &, std::string, std::list<boost::any> &, irods::callback) Caught Python exception.
  File "<string>", line 1
    goodrule{
            ^
SyntaxError: invalid syntax
]

Oct 21 22:40:35 pid:21170 NOTICE: readAndProcClientMsg: received disconnect msg from client
```

## iRODS Rule Language Rule Engine Variables

The iRODS Rule Language rule engine variable scoping rules are summarized as:

  1. All input and output variables have global scope
  2. All local variables have rule scope
  3. Except:
    1. The iterator variables of `foreach()` have the scope of the `foreach()` block
    2. Variables assigned by an assignment in a `let` expression have the scope of the `let` expression
    3. Variables assigned by a pattern match in a match expression have the scope of the corresponding alternative of match expression

## Parallel Transfer Port Contention

The iRODS Server will issue a LOG_NOTICE when it unsuccessfully attempts to claim an available port while setting up a parallel transfer portal.

```
Nov  1 11:20:24 pid:16308 NOTICE: setupSrvPortal: listen failed, errno: 98
Nov  1 11:23:11 pid:4482 NOTICE: setupSrvPortal: listen failed, errno: 98
Nov  1 11:24:58 pid:5328 NOTICE: setupSrvPortal: listen failed, errno: 98
Nov  1 11:27:10 pid:15614 NOTICE: setupSrvPortal: listen failed, errno: 98
Nov  1 11:30:25 pid:11650 NOTICE: setupSrvPortal: listen failed, errno: 98
```

This occurs when the server is hitting resource contention and may indicate that the server needs a larger parallel transfer port range defined in `server_config.json` (the default is 20000-20199).

## Schema Validation Warnings

To enable validation on Ubuntu 12, install the `jsonschema` module via Python's pip:

```
sudo pip install jsonschema
```

## Dynamic PEP Signature Mismatches

When writing dynamic PEPs, getting the signature wrong will provide a hint in the rodsLog:

```
Nov 12 09:57:30 pid:25245 DEBUG: error: cannot find rule for action "pep_resource_resolve_hierarchy_pre" available: 103.
line 0, col 0
pep_resource_resolve_hierarchy_pre(*ARG0,*ARG1,*ARG2,*ARG3,*ARG4,*ARG5,*ARG6)
^
```

This explains that `pep_resource_resolve_hierarchy_pre` expects exactly seven arguments.  Please check the [Available Dynamic PEP](../plugins/dynamic_policy_enforcement_points.md#available-dynamic-peps) tables to see what those arguments should be for the PEP you are trying to implement.

## Using 3.x iCommands with a 4.0+ iRODS Server

3.x iCommands retain basic functionality when speaking with a 4.0+ iRODS Server.

However, operations much more complicated than simple puts and gets are likely to hit cases where the 3.x iCommands do not have sufficient information to continue or they do not recognize the results returned by the Server.

This is largely due to the SSL handshaking and resource hierarchies in 4.0+.

It is recommended to use the supported iCommands from 4.0+.

