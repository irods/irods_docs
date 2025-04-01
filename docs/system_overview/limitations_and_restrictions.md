#

## Maximum FQDN Hostname Length

iRODS servers use hostnames to determine whether a request coming into the system has arrived at the correct iRODS server.  If the hostname does not match, then the request will be forwarded on to another iRODS server for processing.

[RFC1035](https://tools.ietf.org/html/rfc1035#section-3.3) specifies that fully qualified domain names (FQDN) can be up to 255 characters, while individual components of a DNS name are limited to 63 characters.

However, the hostnames used by iRODS are limited to 63 characters (plus null) due to a [definition of AuthInfo in the iRODS packing instructions](https://github.com/irods/irods/blob/5c60095959ec44f6b06817f33cee67e65995eee6/lib/core/include/rodsPackInstruct.h#L80) for the iRODS protocol which uses `NAME_LEN`.

This behavior cannot be changed until packstruct is updated, and packstruct cannot be changed until Federation with iRODS versions using these packing instructions is deemed unsupported.
