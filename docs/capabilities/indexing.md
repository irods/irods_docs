#

The [iRODS Indexing Capability](https://github.com/irods/irods_capability_indexing) provides a policy framework around both full text and metadata indexing for the purposes of enhanced data discovery. Logical collections are annotated with metadata which indicates that any data objects or nested collections of data objects should be indexed given a particular indexing technology, index type, and index name.

With this set of C++ plugins, an iRODS server can populate an Elasticsearch or OpenSearch database with information from the iRODS Catalog.  This can provide a more efficient and familiar search interface for other existing tools and developers.

When a collection is annotated for indexing, all its subcollections and data objects are queued for indexing.  If a new data object is added, or a data object is modified, it will be queued for indexing.

## Installation

Install the following plugins for the Indexing Capability:

- irods-rule-engine-plugin-indexing
- irods-rule-engine-plugin-elasticsearch

The Elasticsearch plugin is only required if you are using Elasticsearch. Other plugins can be installed as new technologies are implemented.

Packages can also be built from source: [https://github.com/irods/irods_capability_indexing](https://github.com/irods/irods_capability_indexing)

## Configuration

Here's an example configuration to enable the Indexing and Elasticsearch plugins. Comments shown are for purposes of explanation and should not be included in an actual configuration. Values shown are the default values.
```javascript
"rule_engines": [
    {
        "instance_name": "irods_rule_engine_plugin-indexing-instance",
        "plugin_name": "irods_rule_engine_plugin-indexing",
        "plugin_specific_configuration": {
            // The lower limit for randomly generated delay task intervals.
            "minimum_delay_time": 1,

            // The upper limit for randomly generated delay task intervals.
            "maximum_delay_time": 30,

            // The maximum number of delay rules allowed to be scheduled for
            // a particular collection at a time.
            //
            // If set to 0, the limit is disabled.
            "job_limit_per_collection_indexing_operation": 1000
        }
    },
    {
        "instance_name": "irods_rule_engine_plugin-elasticsearch-instance",
        "plugin_name": "irods_rule_engine_plugin-elasticsearch",
        "plugin_specific_configuration": {
            // The list of URLs identifying the elasticsearch service.
            //
            // Important things to keep in mind:
            //
            //   - URLs must contain the port number
            //   - If TLS communication is desired, the URL must begin with "https"
            "hosts": [
                "http://localhost:9200"
            ],

            // The number of text chunks processed at once for elasticsearch
            // full-text indexing.
            "bulk_count": 100,

            // The size of an individual text chunk for elasticsearch full-text
            // indexing.
            "read_size": 4194304,

            // The absolute path to a TLS certificate used for secure communication
            // with elasticsearch. If empty, OS-dependent default paths are used for
            // certificates verification.
            //
            // This option only takes effect for host entries beginning with "https".
            "tls_certificate_file": "",

            // The encoded basic authentication credentials for elasticsearch. The
            // value must match one of the following:
            //
            //   - base64_encode(url_encode(username) + ":" + url_encode(password))
            //   - base64_encode(username + ":" + password)
            //
            // This option is not used when empty. Recommended when using TLS, but
            // not required.
            "authorization_basic_credentials": ""
        }
    },

    // ... Previously installed rule engine plugin configs ...
]
```

## Setting up indexing

### Create an index

To create a full-text index, run the following:
```bash
curl -X PUT -H 'Content-Type: application/json' http://localhost:9200/full_text_index -d '{
  "mappings": {
    "properties": {
      "absolutePath": {"type": "keyword"},
      "data": {"type": "text"}
    }
  }
}'
```

To create a metadata index, run the following:
```bash
curl -X PUT -H 'Content-Type: application/json' http://localhost:9200/metadata_index -d '{
  "mappings": {
    "properties": {
      "url": {"type": "text"},
      "zoneName": {"type": "keyword"},
      "absolutePath": {"type": "keyword"},
      "fileName": {"type": "text" },
      "parentPath": {"type": "text"},
      "isFile": {"type": "boolean"},
      "dataSize": {"type": "long"},
      "mimeType": {"type": "keyword"},
      "lastModifiedDate": {"type": "date", "format": "epoch_second"},
      "metadataEntries": {
        "type": "nested", 
        "properties": {
          "attribute": {"type": "keyword"}, 
          "value": {"type": "text"}, 
          "unit": {"type": "keyword"}
        }
      }
    }
  }
}'
```
Properties shown above represent all the currently supported metadata, but can be excluded as desired.

### Tag a collection for indexing

Indexing operates on specific AVUs annotated to iRODS collections. Indexing metadata takes the following form:

- A: `irods::indexing::index`
- V: `<index_name>::<index_type>`
- U: `<technology`

In order to indicate a collection `full_text_collection` for a `full_text` index with Elasticsearch, you can annotate metadata to it like this:
```bash
imeta set -C full_text_collection irods::indexing::index full_text_index::full_text elasticsearch
```

If any data objects exist in `full_text_collection`, these will immediately be scheduled for indexing; and from this point forward, any new data objects which are created under `full_text_collection` or its sub-collections will be scheduled to be indexed upon creation.

The same process applies to `metadata` indexes or any other `index_type`s which may exist.

### Tag a resource for indexing

An administrator may wish to restrict indexing activities to particular resources, for example when automatically ingesting data.

In order to indicate a resource is available for indexing it may be annotated with metadata like so:
```bash
imeta add -R <resource_name> irods::indexing::index true
```

If no resource has this metadata, it is assumed that all resources are available for indexing. Should the tag exist on *any* resource in the system, it is assumed that all available resources for indexing are tagged.
