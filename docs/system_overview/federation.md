#

iRODS zones are independent administrative units.  When federated, users of one zone may grant access to authenticated users from the other zone on some of their data objects, collections, and metadata.  Each zone will authenticate its own users before a federated zone will allow access.  User passwords are never exchanged between zones.

Primary reasons for using zone federation include:

1. Local control. Some iRODS sites want to share resources and collections, yet maintain more local control over those resources, data objects, and collections. Rather than a single iRODS zone managed by one administrator, they may need two (or more) cooperating iRODS systems managed locally, primarily for security and/or authorization reasons.
2. iCAT WAN performance. In world-wide networks, the network latency may cause significant iRODS performance degradation. For example, in the United States, the latency between the east coast and the west coast is often 1-2 seconds for a simple query. Many iRODS operations require multiple interactions with the iCAT database, which compounds any delays.

## Setup

To federate ZoneA and ZoneB, administrators in each zone must:

1. Coordinate and share their `catalog_provider_hosts`, `negotiation_key`, `zone_key`, `zone_name`, and `zone_port` information.
2. Verify that the remote host name can be resolved.
3. Define the remote zone in their respective iCAT.
4. Define any remote users in their respective iCAT before any access permissions can be granted.

### Example

Let ZoneA have the following properties:
~~~
host name: zoneA-provider.example.org
zone name: ZoneA
zone key : ZONE_KEY_FOR_ALL_OF_ZONE_A
zone port: 1247
~~~

and ZoneB have the following properties:
~~~
host name: zoneB-provider.example.org
zone name: ZoneB
zone key : ZONE_KEY_FOR_ALL_OF_ZONE_B
zone port: 2247
~~~

To federate these zones, the following must be done:

For each zone, add an object to the `federation` array in `server_config.json`. The object must contain the remote zone's information.

#### ZoneA's server_config.json
~~~
"federation": [
    {
        "catalog_provider_hosts": ["zoneB-provider.example.org"], 
        "negotiation_key": "_____32_byte_pre_shared_key_____",
        "zone_key": "ZONE_KEY_FOR_ALL_OF_ZONE_B", 
        "zone_name": "ZoneB", 
        "zone_port": 2247
    }
]
~~~

#### ZoneB's server_config.json
~~~
"federation": [
    {
        "catalog_provider_hosts": ["zoneA-provider.example.org"], 
        "negotiation_key": "_____32_byte_pre_shared_key_____",
        "zone_key": "ZONE_KEY_FOR_ALL_OF_ZONE_A", 
        "zone_name": "ZoneA", 
        "zone_port": 1247
    }
]
~~~

For more information, see [Server Authentication](#server-authentication).

It is important that the servers are able to resolve the host name(s) in the federated zone. This can be handled in many ways. The resolution could come from this account's `hosts_config.json` file, this server's `/etc/hosts` file, or DNS in priority order, respectively.

With the server configuration and networking complete, the final step is to define the remote zone and users in the catalog.

In ZoneA, add ZoneB and define a remote user:

~~~
ZoneA $ iadmin mkzone ZoneB remote zoneB-provider.example.org:2247
ZoneA $ iadmin mkuser bobby#ZoneB rodsuser
~~~

In ZoneB, add ZoneA, but skip adding any remote users at this time:

~~~
ZoneB $ iadmin mkzone ZoneA remote zoneA-provider.example.org:1247
~~~

Then, any user of ZoneA will be able to grant permissions to `bobby#ZoneB`:

~~~
ZoneA $ ichmod read bobby#ZoneB myFile
~~~

Once permission is granted, it will appear like any other ACL:

~~~
ZoneA $ ils -A myFile
  /ZoneA/home/rods/myFile
        ACL - bobby#ZoneB:read_object   rods#ZoneA:own
~~~

If all the [Server Authentication](#server-authentication) and the networking is set up correctly, Bobby can now `iget` the shared ZoneA file from ZoneB:

~~~
ZoneB $ iget /ZoneA/home/rods/myFile
~~~

## Server Authentication

### Within A Zone

When a client connects to a consumer server and then authenticates, the consumer server connects to the provider server to perform the authentication. To make this more secure, you must configure the `zone_key` to cause the iRODS system to authenticate the servers themselves. This is normally done during installation and setup.  This `zone_key` is required and should be a unique and arbitrary string (maximum alphanumeric length of 49), one for your whole zone:

~~~
"zone_key": "SomeChosenKeyString",
~~~

This allows the consumer servers to verify the identity of the provider server beyond just relying on DNS.

Mutual authentication between servers is always on.

### Between Two Zones

When a user from a remote zone connects to the local zone, the iRODS server will check with the iCAT in the user's home zone to authenticate the user (confirm their password).  Passwords are never sent across federated zones, they always remain in their home zone.

To make this more secure, the iRODS system uses both the `zone_key` and the `negotiation_key` to authenticate the servers in `server_config.json`, via a similar method as iRODS passwords. The `zone_key` must match the remote zone's `zone_key` (the value specified during installation and setup).  The `negotiation_key` should be a shared key only for this pairing of two zones.

To configure this, open the `/etc/irods/server_config.json` file and add an object to the `federation` array for each remote zone, for example:

~~~
"federation": [
    {
        "catalog_provider_hosts": ["hostname_or_ip_of.remoteZone.org"],
        "negotiation_key": "_____32_byte_pre_shared_key_____",
        "zone_key": "ZONE_KEY_FOR_ALL_OF_REMOTEZONE",
        "zone_name": "remoteZone",
        "zone_port": 1247
    }
]
~~~

When remoteZone users connect, the system will then confirm that remoteZone's `zone_key` is 'ZONE_KEY_FOR_ALL_OF_REMOTEZONE'.

Mutual authentication between servers is always on across Federations.

### Catalog Service Consumers and Federation

If a local zone's user needs to connect to a Catalog Service Consumer, rather than the local zone's Catalog Service Provider, then the server in the consumer role will also need to have a federation stanza defined in its own `server_config.json`.  It will need to be identical to the stanza on the Catalog Service Provider.

Both servers will then be able to service local zone user connections that will be redirected across the Federation into the defined remote zone.

Not having this required additional stanza will likely result in a `REMOTE_SERVER_SID_NOT_DEFINED` error.

## Limitations

If a policy ever requires a data object- or catalog-level operation to be performed as part of an rcDataObjPut (put) or rcDataObjGet (get)'s dynamic post-PEPs, the implementation must take remote zones into account.

Recommendation: Only perform the required operations in the case of a local put or get. Policy implementers should also pay careful attention to where policy is being placed in their deployments.

If the put or get is going to or coming from the remote zone, any data object- or catalog-level operations performed as part of the post-PEP will reuse the connection to the remote zone. In the case of a parallel transfer, the put/get will return before any data is transferred because a separate portal operation will be performed between the client and server hosting the data. The post-PEP will fire on the local server to which the client is connected and will block returning to the client as it attempts to perform its operation. During this time, the remote server will time out and the portal will be shut down. The incoming request from the post-PEP will then be serviced, control returned to the local federating server, and then back to the client. The connection to the remote server will fail as the portal is no longer accepting connections.

This is an architectural limitation between dynamic PEPs, federation, and the current parallel transfer implementation for puts and gets.

Here are two sample implementations for detecting a local zone put (the logic is very similar for gets):

#### Native Rule Engine Plugin
```sh
path_is_in_local_zone(*obj_path) {
    *obj_path like "/"++$rodsZoneProxy++"/*"; # return true or false
}

pep_api_data_obj_put_post(*INSTANCE_NAME, *COMM, *DATAOBJINP, *BUFFER, *PORTAL_OPR_OUT) {
    *obj_path = *DATAOBJINP.obj_path;
    if (path_is_in_local_zone(*obj_path)) {
        # local policy here...
    }
}
```

#### Python Rule Engine Plugin
```python
import json

def path_is_in_local_zone(obj_path):
    # cannot access the same globals as NREP at this time
    # access zone name from the local server configuration
    server_config_path = '/etc/irods/server_config.json'
    with open(server_config_path, 'r') as f:
        zone_name = json.load(f)['zone_name']
        return obj_path.startswith('/' + zone_name + '/')

def pep_api_data_obj_put_post(rule_args, callback, rei):
    obj_path = str(rule_args[2].objPath)
    if path_is_in_local_zone(obj_path):
        # local policy here...
```

If the operation is still required for remote puts, consider leveraging the delayed execution server for asynchronous execution (warning: this will involve timing logic and detecting the status of the data transfer - not easy to get right!).
