#

The [iRODS Automated Ingest Framework](https://github.com/irods/irods_capability_automated_ingest) is a standalone Python3 iRODS Client.  It uses the [iRODS Python Client Library](https://github.com/irods/python-irodsclient) and coordinates the ingestion of files.  It is designed to be run in parallel.

It uses Celery to coordinate the parallel workers and Redis both as a backend for Celery and for the iRODS namespace cache to prevent unnecessary network traffic with the configured iRODS server.

The ingest framework scales linearly with the number of workers - 1 worker can ingest 20-25 files per second.

Examples:

  - 1M files with 50 workers ~= 15 minutes
  - 5M files with 25 workers ~= 2.5 hours
  - 5M files with 4 workers ~= 16 hours

Of course, if the ingest framework is doing additional processing per file (gathering unix permissions, parsing the file, extracting metadata, attaching metadata), then the rate of ingestion will drop dramatically per worker - but should still scale linearly with additional workers.
