#

The resource plugins provide storage abstraction and coordination behavior which can be composed to implement complex data management policies.

## Tree Metaphor

In computer science, a tree is a data structure with a hierarchical representation of linked nodes. These nodes can be named based on where they are in the hierarchy. The node at the top of a tree is the root node. Parent nodes and child nodes are on opposite ends of a connecting link, or edge. Leaf nodes are at the bottom of the tree, and any node that is not a leaf node is a branch node. These positional descriptors are helpful when describing the structure of a tree. Composable resources are best represented using this tree metaphor.

An iRODS composite resource is a tree with one 'root' node.  Nodes that are at the bottom of the tree are 'leaf' nodes.  Nodes that are not leaf nodes are 'branch' nodes and have one or more 'child' nodes.  A child node can have one and only one 'parent' node.

The terms root, leaf, branch, child, and parent represent locations and relationships within the structure of a particular tree.  To represent the functionality of a particular resources within a particular tree, the terms 'coordinating' and 'storage' are used in iRODS.  Coordinating resources coordinate the flow of data to and from other resources.  Storage resources are typically 'leaf' nodes and handle the direct reading and writing of data through a POSIX-like interface.

Any resource node can be a coordinating resource and/or a storage resource.  However, for clarity and reuse, it is generally best practice to separate the two so that a particular resource node is either a coordinating resource or a storage resource.

This powerful tree metaphor is best illustrated with an actual example.  You can now use `ilsresc` to visualize the tree structure of a Zone.

```
irods@hostname:~/ $ ilsresc
demoResc:unixfilesystem
randy:random
├── pt1:passthru
│   └── ufs5:unixfilesystem
├── repl1:replication
│   ├── pt2:passthru
│   │   └── pt3:passthru
│   │       └── pt4:passthru
│   ├── ufs10:unixfilesystem
│   └── ufs11:unixfilesystem
└── ufs1:unixfilesystem
deffy:deferred
├── repl2:replication
│   ├── repl3:replication
│   │   ├── ufs6:unixfilesystem
│   │   ├── ufs7:unixfilesystem
│   │   └── ufs8:unixfilesystem
│   ├── ufs3:unixfilesystem
│   └── ufs4:unixfilesystem
└── ufs2:unixfilesystem
test:unixfilesystem
test1:unixfilesystem
test2:unixfilesystem
test3:unixfilesystem
```

## Virtualization

In iRODS, files are stored as Data Objects on disk and have an associated physical path as well as a virtual path within the iRODS file system. iRODS collections, however, only exist in the iCAT database and do not have an associated physical path (allowing them to exist across all resources, virtually).

Composable resources, both coordinating and storage, introduce the same dichotomy between the virtual and physical.  A coordinating resource has built-in logic that defines how it determines, or coordinates, the flow of data to and from its children. Coordinating resources exist solely in the iCAT and exist virtually across all iRODS servers in a particular Zone. A storage resource has a Vault (physical) path and knows how to speak to a specific type of storage medium (disk, tape, etc.). The encapsulation of resources into a plugin architecture allows iRODS to have a consistent interface to all resources, whether they represent coordination or storage.

This virtualization enables the coordinating resources to manage both the placement and the retrieval of Data Objects independent from the types of resources that are connected as children resources. When iRODS tries to retrieve data, each child resource will "vote", indicating whether it can provide the requested data.  Coordinating resources will then decide which particular storage resource (e.g. physical location) the read should come from. The specific manner of this vote is specific to the logic of the coordinating resource.  A coordinating resource may lean toward a particular vote based on the type of optimization it deems best. For instance, a coordinating resource could decide between child votes by opting for the child that will reduce the number of requests made against each storage resource within a particular time frame or opting for the child that reduces latency in expected data retrieval times. We expect a wide variety of useful optimizations to be developed by the community.

Read more about [Composable Resources](https://irods.org/2013/02/e-irods-composable-resources/):

- [Paper (279kB, PDF)](https://irods.org/uploads/2013/02/eirods-composable-resources.pdf)
- [Slides (321kB, PDF)](https://irods.org/uploads/2013/02/eirods-cr-slides.pdf)
- [Poster (6.4MB, PDF)](https://irods.org/uploads/2013/02/eirods-composable-resources-poster.pdf)

## Coordinating Resources

Coordinating resources contain the flow control logic which determines both how its child resources will be allocated copies of data as well as which copy is returned when a Data Object is requested.  There are several types of coordinating resources: compound, random, replication, passthru, and some additional types that are expected in the future.  Each is discussed in more detail below.

#### Compound

A compound resource has two and only two children.  One must be designated as the 'cache' resource and the other as the 'archive' resource.  This designation is made in the "context string" of the `addchildtoresc` command.

An Example:

~~~
irods@hostname:~/ $ iadmin addchildtoresc parentResc newChildResc1 cache
irods@hostname:~/ $ iadmin addchildtoresc parentResc newChildResc2 archive
~~~

Putting files into the compound resource will first create a replica on the cache resource and then create a second replica on the archive resource.

This compound resource auto-replication policy can be controlled with the context string associated with a compound resource.  The key "auto_repl" can have the value "on" (default), or "off".

For example, to turn off the automatic replication when creating a new compound resource (note the empty host/path parameter):

~~~
irods@hostname:~/ $ iadmin mkresc compResc compound '' auto_repl=off
~~~

When auto-replication is turned off, it may be necessary to replicate on demand.  For this scenario, there is a microservice named `msisync_to_archive()` which will sync (replicate) a data object from the child cache to the child archive of a compound resource.  This creates a new replica within iRODS of the synchronized data object.

By default, the replica from the cache resource will always be returned.  If the cache resource does not have a copy, then a replica is created on the cache resource before being returned.

This compound resource staging policy can be controlled with the policy key-value pair whose keyword is "compound_resource_cache_refresh_policy" and whose values are either "when_necessary" (default), or "always".

From the example near the bottom of the core.re rulebase:

~~~
# =-=-=-=-=-=-=-
# policy controlling when a dataObject is staged to cache from archive in a compound coordinating resource
#  - the default is to stage when cache is not present ("when_necessary")
# =-=-=-=-=-=-=-
# pep_resource_resolve_hierarchy_pre( *OUT ){*OUT="compound_resource_cache_refresh_policy=when_necessary";}  # default
# pep_resource_resolve_hierarchy_pre( *OUT ){*OUT="compound_resource_cache_refresh_policy=always";}
~~~

Replicas within a compound resource can be trimmed.  There is no rebalance activity defined for a compound resource.  When the cache fills up, the administrator will need to take action as they see fit.  This may include physically moving files to other resources, commissioning new storage, or marking certain resources "down" in the iCAT.

The "--purgec" option for `iput`, `iget`, and `irepl` is honored and will always purge the first replica (usually with replica number 0) for that Data Object (regardless of whether it is held within this compound resource).  This is not an optimal use of the compound resource as the behavior will become somewhat nondeterministic with complex resource compositions.

A replica created on an archive resource in a compound resource hierarchy by a sync-to-archive operation will not have its checksum calculated and no checksum will be applied to the replica's entry in the catalog. This is because the resource plugin may not support calculating the checksum or may be extremely expensive. Historically, the server has attempted to calculate the checksum on archive resources and an error is returned and caught interally: `DIRECT_ARCHIVE_ACCESS`. It was then waived away as a non-error and the replica on the archive resource received the checksum from the replica on the cache resource. This is no longer the case as the recorded checksum cannot be trusted. Therefore, no checksum is recorded for replicas synced to archive resources.

### Deferred

The deferred resource is designed to be as simple as possible.  A deferred resource can have one or more children.

A deferred resource provides no implicit data management policy.  It defers to its children with respect to routing both puts and gets.  However they vote, the deferred node decides.

### Load Balanced

The load balanced resource provides equivalent functionality as the "doLoad" option for the `msiSetRescSortScheme` microservice.  This resource plugin will query the `r_server_load_digest` table from the iCAT and select the appropriate child resource based on the load values returned from the table.

The `r_server_load_digest` table is part of the Resource Monitoring System and has been incorporated into iRODS 4.x.  The r_server_load_digest table must be populated with load data for this plugin to function properly.

The load balanced resource has an effect on writes only (it has no effect on reads).

### Random

The random resource provides logic to put a file onto one of its children on a random basis.  A random resource can have one or more children.

If the selected target child resource of a put operation is currently marked "down" in the iCAT, the random resource will move on to another random child and try again.  The random resource will try each of its children, and if still not succeeding, throw an error.

### Replication

The replication resource provides logic to automatically manage replicas to all its children.

Getting files from the replication resource will show a preference for locality.  If the client is connected to one of the child resource servers, then that replica of the file will be returned, minimizing network traffic.

#### read keyword

By default, the replication resource will read the replica that votes highest (usually to provide locality of reference).  This can be overridden by using the `read=random` keyword in the context string.  If this setting is used, a random replica will be selected to be accessed and sent to the client.

#### Rebalance

[Rebalancing](#rebalancing) of the replication node is made available via the "rebalance" subcommand of `iadmin`.  For the replication resource, all Data Objects on all children will be replicated to all other children.  The amount of work done in each iteration as the looping mechanism completes is controlled with the session variable `replication_rebalance_limit`.  The default value is set at 500 Data Objects per loop.

The following rule would set the rebalance limit to 200 Data Objects per loop:
```
pep_resource_rebalance_pre(*INSTANCE_NAME, *CONTEXT, *OUT) {
    *OUT="replication_rebalance_limit=200";
}
```

The replication coordinating resource rebalance implementation gathers only good replicas that need to be replicated to other leaf nodes in the tree.

The total number of replicas that need to be rebalanced is the sum of the stale replicas (first) and the missing replicas (second) in a particular resource hierarchy.

If the rebalance operation is interrupted, then the next time it is run, any unfinished work would still be 'unbalanced' and will appear in the next gathered set.

The behavior is independent of where the command is issued.

#### Replication retry

The replication resource can be configured to retry (or not) a replication upon failure via three settings in the context string. The retry mechanism also applies to replications in a Rebalance operation. Note: The retry will only occur on failure to *replicate* from one sibling to another. If the initial file transfer fails for some reason, the retry mechanism will not be initiated.

The settings are configured via `iadmin modresc`, like the example below (default values used):

```
iadmin modresc <repl name> context="retry_attempts=1;first_retry_delay_in_seconds=1;backoff_multiplier=1.0"
```

 - `retry_attempts` is an non-negative integer representing the number of times the replication resource will retry a replication.
 - `first_retry_delay_in_seconds` is a positive integer representing the number of seconds to wait before attempting the first retry of the replication.
 - `backoff_multiplier` is a positive floating point number >=1.0 which multiplies `first_retry_delay_in_seconds` after each retry. As the multiplier is only applied *after* the first retry, `backoff_multiplier` is only relevant when `retry_attempts` is > 1.

### Passthru

The passthru resource was originally designed as a testing mechanism to exercise the new composable resource hierarchies.  They have proven to be more useful than that in a couple of interesting ways.

1. A passthru can be used as the root node of a resource hierarchy.  This will allow a Zone's users to have a stable default resource, even as an administrator changes out disks or other resource names in the Zone.

2. A passthru resource's contextString can be set to have an effect on its child's votes for both read and/or write.

To create a resource with priority read, use a "read" weight greater than 1 (note the empty host:path parameter):

```
irods@hostname:~/ $ iadmin mkresc newResc passthru '' 'write=1.0;read=2.0'
Creating resource:
Name:           "newResc"
Type:           "passthru"
Host:           ""
Path:           ""
Context:        "write=1.0;read=2.0"
```

To modify an existing passthru resource to be written to only after other eligible resources, use a "write" weight less than 1:

```
irods@hostname:~/ $ iadmin modresc newResc context 'write=0.4;read=1.0'
```

Setting a "read" or "write" weight to zero will prevent that action from occurring on the branch of the resource tree under the passthru (because a zero vote signals that it cannot service the incoming request).  The following will "turn off" the resource `newResc` (and its sub-tree):

```
irods@hostname:~/ $ iadmin modresc newResc context 'write=0.0;read=0.0'
```

A passthru resource can have one and only one child.

Nondeterministic behavior will occur if a passthru resource is configured with more than one child.  The plugin will take action on whichever child is returned by the catalog.

## Storage Resources

Storage resources represent storage interfaces and include the file driver information to talk with different types of storage.

### UnixFileSystem

The unixfilesystem storage resource is the default resource type that can communicate with a device through the standard POSIX interface.

#### Minimum Free Space Configuration

A free_space check capability has been added to the unixfilesystem resource in 4.1.10.  The free_space check can be configured with the context string using the following syntax:

```
irods@hostname:~/ $ iadmin modresc unixResc context 'minimum_free_space_for_create_in_bytes=21474836480'
```

The example requires this unixfilesystem plugin instance (unixResc) to keep 20GiB free when considering whether to accept a create operation.  If a create operation would result in the bytes free on disk being smaller than the set value, then the resource will return `USER_FILE_TOO_LARGE` and the create operation will not occur.  This feature allows administrators to protect their systems from absolute disk full events.  Writing to, or extending, existing file objects is still allowed and not affected by this setting.

The check that is performed by the unixfilesystem plugin instance compares the 'minimum_free_space_for_create_in_bytes' value from the context string to the 'free_space' value stored in the 'R_RESC_MAIN' (resource) table in the iCAT.  The 'free_space' value in the catalog can be updated with 'iadmin modresc &lt;rescName&gt; freespace &lt;value&gt;' or with the 'msi_update_unixfilesystem_resource_free_space(*leaf_resource)' on every server where unixfilesystems are active.

To update the 'free_space' value from the command line (manually) to 1TiB, the following 'iadmin' command can be used:

```
irods@hostname:~/ $ iadmin modresc unixResc freespace 1099511627776
```

To update the 'free_space' value after every large file put and replication (automatically), the following rules can be used:

```
acPostProcForParallelTransferReceived(*leaf_resource) {
    msi_update_unixfilesystem_resource_free_space(*leaf_resource);
}
acPostProcForDataCopyReceived(*leaf_resource) {
    msi_update_unixfilesystem_resource_free_space(*leaf_resource);
}
```

'acPostProcForParallelTransferReceived' is only triggered by parallel transfer, so puts of small files will not cause iRODS to update the free_space entry of a resource.  However, when the small file is replicated (by e.g. a replication resource) the free_space of the resource receiving the replica will be updated, because 'acPostProcForDataCopyReceived' is hit by both large and small files.

To use a blacklist of resources (that you do not want updated), that can be implemented directly in the rule logic:

```
acPostProcForParallelTransferReceived(*leaf_resource) {
    *black_list = list("some", "of", "the", "resources");
    *update_free_space = 1;
    foreach(*resource in *black_list) {
        if (*resource == *leaf_resource) {
            *update_free_space = 0;
            break;
        }
    }
    if (*update_free_space) {
        msi_update_unixfilesystem_resource_free_space(*leaf_resource);
    }
}
acPostProcForDataCopyReceived(*leaf_resource) {
    *black_list = list("some", "of", "the", "resources");
    *update_free_space = 1;
    foreach(*resource in *black_list) {
        if (*resource == *leaf_resource) {
            *update_free_space = 0;
            break;
        }
    }
    if (*update_free_space) {
        msi_update_unixfilesystem_resource_free_space(*leaf_resource);
    }
}
```

#### Detached Mode Configuration

Detached mode was added as a configuration option for UnixFileSystem resources in release 4.3.1.  When detached mode is enabled, any server may serve up requests for the resource as long as all servers share a common mounted vault.

To enable detached mode, the **host_mode** setting in the context string should be set to **detached** as in the following example:

```
irods@hostname:~/ $ iadmin mkresc detached_resc unixfilesystem hostname.example.org:/common/mount/point "host_mode=detached"
```

If **host_mode** is not set to **detached**, the unixfilesystem plugin will default to attached mode.

If an administrator wants to restrict the number of hosts that may serve the request, a **host_list** parameter with a comma separated list of hosts may be added to the context string.

```
irods@hostname:~/ $ iadmin mkresc detached_resc unixfilesystem hostname.example.org:/common/mount/point "host_mode=detached;host_list=host2.example.org,host3.example.org"
```

The host assigned to the host field for the resource is assumed to be able to serve up any request, so in the above case either hostname, host2, or host3 may serve up the request.

The following are some rules around using detached mode:

1. If host_list does not exist, all hosts are assumed to be able to service requests for the resource.
2. If host_list exists, only the hosts in either this list or the host in the resource host field will be able to service requests for the resource.
3. If host_list exists and the client-connected server is not in host_list, the request will be redirected to the host listed in the resource host field as is done in attached mode.
4. The resource vault path must be identical on every host that services requests for the resource. This vault path must be in a mount to a common filesystem.
5. Registrations outside the vault are not allowed.  We can't enforce that the path being registered is shared by all hosts that service requests for the resource.

#### UnixFileSystem Resource Voting

This resource returns vote values based on the type of operation.

For a "create" operation, the following criteria are considered *in order*:

1. If the resource is marked "down", a `SYS_RESC_IS_DOWN` error is returned. The vote value is 0.0.
2. If the size of the data to be created exceeds the configured minimum required free space on the resource, a `USER_FILE_TOO_LARGE` error is returned. The vote value is 0.0. 
3. If the client is connected to the server to which the resource is attached, the vote value is 1.0.
4. Otherwise, the vote value is 0.5.

For a "write" operation, the following criteria are considered *in order*:

1. If the resource is marked "down", a `SYS_RESC_IS_DOWN` error is returned. The vote value is 0.0.
2. If the replica on the resource has a status value of '3' or '4' (read locked or write locked, respectively), the vote value is 0.0.
3. If the replica on the resource has a status value of '2' (intermediate) and the client has not supplied the correct replica access token, the vote value is 0.0.
4. If the client has requested a specific replica number and the replica on the resource has that replica number, the vote value is 1.0. If the client has requested a specific replica number and the replica on the resource does NOT have that replica number, the vote value is 0.25.
5. If the replica on the resource has a replica status value of '0' (stale), the vote value is 0.25.
6. If the client is connected to the server to which the resource is attached, the vote value is 1.0.
7. Otherwise, the vote value is 0.5.

For a "read" operation, the following criteria are considered *in order*:

1. If the resource is marked "down", a `SYS_RESC_IS_DOWN` error is returned. The vote value is 0.0.
2. If the replica on the resource has a status value of '3' or '4' (read locked or write locked, respectively), the vote value is 0.0.
3. If the replica on the resource has a status value of '2' (intermediate), the vote value is 0.0.
4. If the client has requested a specific replica number and the replica on the resource has that replica number, the vote value is 1.0. If the client has requested a specific replica number and the replica on the resource does NOT have that replica number, the vote value is 0.25.
5. If the replica on the resource has a replica status value of '0' (stale), the vote value is 0.25.
6. If the client is connected to the server to which the resource is attached, the vote value is 1.0.
7. Otherwise, the vote value is 0.5.

For an "unlink" operation, the following criteria are considered *in order*:

1. If the resource is marked "down", a `SYS_RESC_IS_DOWN` error is returned. The vote value is 0.0.
2. If the replica on the resource has a status value of '3' or '4' (read locked or write locked, respectively), the vote value is 0.0.
3. If the replica on the resource has a status value of '2' (intermediate), the vote value is 0.0.
4. If the client has requested a specific replica number and the replica on the resource has that replica number, the vote value is 1.0. If the client has requested a specific replica number and the replica on the resource does NOT have that replica number, the vote value is 0.25.
5. If the replica on the resource has a replica status value of '1' (good), the vote value is 0.25.
6. If the client is connected to the server to which the resource is attached, the vote value is 1.0.
7. Otherwise, the vote value is 0.5.

### Structured File Type (tar, zip, gzip, bzip)

The structured file type storage resource is used to interface with files that have a known format.  By default these are used "under the covers" and are not expected to be used directly by users (or administrators).

These are used mainly for mounted collections.

### Amazon S3 (Archive)

The Amazon S3 archive storage resource is used to interface with an S3 bucket.  It is expected to be used as the archive child of a compound resource composition.  The credentials are stored in a file which is referenced by the context string.

Read more at: [https://github.com/irods/irods_resource_plugin_s3](https://github.com/irods/irods_resource_plugin_s3)

### DDN WOS (Archive)

The DataDirect Networks (DDN) WOS archive storage resource is used to interface with a Web Object Scalar (WOS) Appliance.  It is expected to be used as the archive child of a compound resource composition.  It currently references a single WOS endpoint and WOS policy in the context string.

Read more at: [https://github.com/irods/irods_resource_plugin_wos](https://github.com/irods/irods_resource_plugin_wos)

### HPSS

The HPSS storage resource is used to interface with an HPSS storage management system.  It can be used as the archive child of a compound resource composition or as a first class resource in iRODS.  The connection information is referenced in the context string.

Read more at: [https://github.com/irods/irods_resource_plugin_hpss](https://github.com/irods/irods_resource_plugin_hpss)

### Non-Blocking

The non-blocking storage resource behaves exactly like the standard unix file system storage resource except that the "read" and "write" operations do not block (they return immediately while the read and write happen independently).

### Mock Archive

The mock archive storage resource was created mainly for testing purposes to emulate the behavior of object stores (e.g. WOS).  It creates a hash of the file path as the physical name of the Data Object.

### Universal Mass Storage Service

The univMSS storage resource delegates stage_to_cache and sync_to_arch operations to an external script which is located in the `msiExecCmd_bin` directory.  It currently writes to the Vault path of that resource instance, treating it as a unix file system.

When creating a "univmss" resource, the context string provides the location of the Universal MSS script.

Example:

~~~
irods@hostname:~/ $ iadmin mkresc myArchiveResc univmss HOSTNAME:/full/path/to/Vault univMSSInterface.sh
~~~

## Managing Child Resources

There are two new `iadmin` subcommands introduced with this feature.

`addchildtoresc`:

~~~
irods@hostname:~/ $ iadmin h addchildtoresc
 addchildtoresc Parent Child [ContextString] (add child to resource)
Add a child resource to a parent resource.  This creates an 'edge'
between two nodes in a resource tree.

Parent is the name of the parent resource.
Child is the name of the child resource.
ContextString is any relevant information that the parent may need in order
  to manage the child.
~~~

`rmchildfromresc`:

~~~
irods@hostname:~/ $ iadmin h rmchildfromresc
 rmchildfromresc Parent Child (remove child from resource)
Remove a child resource from a parent resource.  This removes an 'edge'
between two nodes in a resource tree.

Parent is the name of the parent resource.
Child is the name of the child resource.
~~~

## Example Usage

Creating a composite resource consists of creating the individual nodes of the desired tree structure and then connecting the parent and children nodes.

![example tree](../images/example1-tree.png)

**Example:** Replicates Data Objects to three locations

A replicating coordinating resource with three unix file system storage resources as children would be composed with seven (7) iadmin commands:

~~~
irods@hostname:~/ $ iadmin mkresc example1 replication
irods@hostname:~/ $ iadmin mkresc repl_resc1 unixfilesystem renci.example.org:/Vault
irods@hostname:~/ $ iadmin mkresc repl_resc2 unixfilesystem sanger.example.org:/Vault
irods@hostname:~/ $ iadmin mkresc repl_resc3 unixfilesystem eudat.example.org:/Vault
irods@hostname:~/ $ iadmin addchildtoresc example1 repl_resc1
irods@hostname:~/ $ iadmin addchildtoresc example1 repl_resc2
irods@hostname:~/ $ iadmin addchildtoresc example1 repl_resc3
~~~

## Rebalancing

A new subcommand for iadmin allows an administrator to rebalance a coordinating resource.  The coordinating resource can be the root of a tree, or anywhere in the middle of a tree.  The rebalance operation will rebalance for all decendents.  For example, the iadmin command `iadmin modresc myReplResc rebalance` would fire the rebalance operation for the replication resource instance named myReplResc.  Any Data Objects on myReplResc that did not exist on all its children would be replicated as expected.

For other coordinating resource types, rebalance can be defined as appropriate.  For coordinating resources with no concept of "balanced", the rebalance operation is a "no op" and performs no work.

Running `iadmin modresc <rescName> rebalance` will check if a rebalance is already running for `<rescName>` by looking for an
AVU on the named resource matching an attribute 'rebalance_operation'.

If it finds a match, it will exit early and return `REBALANCE_ALREADY_ACTIVE_ON_RESOURCE`.

An active (or stale) rebalance will appear in the catalog:

```
$ imeta ls -R demoResc
AVUs defined for resource demoResc:
attribute: rebalance_operation
value: x.x.x.x:7294
units: 20180203T140006Z

$ iquest "select RESC_NAME, META_RESC_ATTR_NAME, META_RESC_ATTR_VALUE, order(META_RESC_ATTR_UNITS) where META_RESC_ATTR_NAME = 'rebalance_operation'"
RESC_NAME = demoResc
META_RESC_ATTR_NAME = rebalance_operation
META_RESC_ATTR_VALUE = x.x.x.x:7294
META_RESC_ATTR_UNITS = 20180203T140006Z
```

When a rebalance completes successfully, the timestamp AVU is removed.
