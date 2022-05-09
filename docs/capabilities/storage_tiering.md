#

The [iRODS Storage Tiering Framework](https://github.com/irods/irods_capability_storage_tiering) provides iRODS the capability of automatically moving data between any number of identified tiers of heterogeneous storage within a configured tiering group.

The storage tiers are configured via metadata and move violating data objects based on age, by default.

The violating query for each tier, however, can be overridden to be as flexible as desired.  Data objects could be moved based on group membership, file size, file type, or any other metadata annotation that has been attached as an AVU triple (Attribute-Value-Unit).

The flexibility in the framework allows for a number of possibilities:

 - Different tier groups and tiering behavior for different laboratories with specific data types
 - Multiple departments with different tier groups, but which share a common archive (tape)
 - Hybrid deployments with fast on-premise storage until criteria are met to push to S3 or Glacier.
 - Marking a minimum restage tier so that restage operations do not replica back to the source instrument's local storage

