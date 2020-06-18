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
        ACL - bobby#ZoneB:read object   rods#ZoneA:own
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

Mutual authentication between servers is always on.  Note that this applies to iRODS passwords and PAM, and some other interactions, but not GSI or Kerberos.

For GSI, users can set the `irodsServerDn` variable to do mutual authentication.

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

## Federation with iRODS 3.x

iRODS 4.0+ has made some additions to the database tables for the resources (`r_resc_main`) and data objects (`r_data_main`) for the purposes of tracking resource hierarchy, children, parents, and other relationships.  These changes would have caused a cross-zone query to fail when the target zone is iRODS 3.x.

In order to support commands such as `ils` and `ilsresc` across a 3.x to 4.0+ federation, iRODS 4.0+ detects the cross zone query and subsequently strip out any requests for columns which do not exist in the iRODS 3.x table structure in order to allow the query to succeed.

### irods_environment.json for Service Account

`irods_client_server_negotiation` needs to be changed (set it to "none") as 3.x does not support this feature.

The effect of turning this negotiation off is a lack of SSL encryption when talking with a 3.x zone.  All clients that connect to this 4.0+ zone will also need to disable the Advanced Negotiation in their own 'irods_environment.json' files.

### How to enable federation between 3.x and 4.x:

The steps required for enabling federation between a 3.x zone and a 4.x zone will be described through an example.

Let ZoneA be the 4.x zone and have the following properties:
~~~
host name: zoneA.example.org
zone name: ZoneA
zone key : ZONE_KEY_FOR_ALL_OF_ZONE_A
zone port: 1247
~~~
and let ZoneB be the 3.x zone and have the following properties:
~~~
host name: zoneB.example.org
zone name: ZoneB
zone server ID : ZONEB_LOCAL_ZONE_SID
zone port: 1247
~~~
The zone server ID (SID) is similar to a `zone_key` in 4.x.

#### Configuring 4.x zone
The `federation` stanza needs to be added to the `server_config.json` as usual:
~~~
"federation": [
    {
        "catalog_provider_hosts": ["zoneB.example.org"], 
        "negotiation_key": "_____32_byte_pre_shared_key_____",
        "zone_key": "ZONEB_LOCAL_ZONE_SID", 
        "zone_name": "ZoneB", 
        "zone_port": 1247
    }
]
~~~
Note: `negotiation_key` has no effect, but is required by the server configuration json schema.
The `zone_key` member of the struct held by `federation` in this case acts as the `RemoteZoneSID` and must match the `LocalZoneSID` configured in the 3.x server.

#### Configuring 3.x zone
The 3.x zone only requires two things in its `server.config`:
~~~
LocalZoneSID ZONEB_LOCAL_ZONE_SID
RemoteZoneSID ZoneA-ZONE_KEY_FOR_ALL_OF_ZONE_A
~~~
The `LocalZoneSID` is equivalent to the `zone_key` shared in 4.x federated environments.
The `RemoteZoneSID` is a string of the form `remoteZoneName-remoteZoneSID`. In this example, `remoteZoneName` is `ZoneA` and the `remoteZoneSID` is the `zone_key` for the remote zone. Multiple `RemoteZoneSID`s can be defined in `server.config` to simultaneously federate with multiple zones.

Information such as the remote zone's hostname and port are stored in the catalog in 3.x rather than in the server's configuration.

As 3.x is built and run in-place by the zone maintainer(s), the following diff can be applied to require SIDs be configured on the local server:
```diff
diff --git a/iRODS/server/api/src/rsAuthResponse.c b/iRODS/server/api/src/rsAuthResponse.c
index 05e3553..53cc440 100644
--- a/iRODS/server/api/src/rsAuthResponse.c
+++ b/iRODS/server/api/src/rsAuthResponse.c
@@ -16,7 +16,7 @@
 
 /* If set, then SIDs are always required, errors will be return if a SID
    is not locally set for a remote server */
-#define requireSIDs 0
+#define requireSIDs 1
```

The rest of the setup is similar to the steps above (creating the remote zones and users in each zone).
