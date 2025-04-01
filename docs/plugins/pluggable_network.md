#

iRODS provides both TCP and TLS network plugins.

!!! Note
    The TLS network plugin is named the "SSL" plugin for legacy reasons. This documentation will use the term "TLS".

The TLS mechanism is provided via OpenSSL and wraps the activity from the TCP plugin.

The TLS parameters are tunable via the following `irods_environment.json` variables:

~~~
"irods_client_server_negotiation": "request_server_negotiation",
"irods_client_server_policy": "CS_NEG_REQUIRE",
"irods_encryption_key_size": 32,
"irods_encryption_salt_size": 8,
"irods_encryption_num_hash_rounds": 16,
"irods_encryption_algorithm": "AES-256-CBC",
~~~

The only valid value for 'irods_client_server_negotiation' at this time is 'request_server_negotiation'.  Anything else will not begin the negotiation stage and default to using a TCP connection.

The possible values for 'irods_client_server_policy' include:

- CS_NEG_REQUIRE: This side of the connection requires a TLS connection
- CS_NEG_DONT_CARE: This side of the connection will connect either with or without TLS
- CS_NEG_REFUSE: (default) This side of the connection refuses to connect via TLS

On the server side, the `core.re` has a default value of `CS_NEG_REFUSE` in the acPreConnect() rule:

```
acPreConnect(*OUT) { *OUT="CS_NEG_REFUSE"; }
```

In order for a connection to be made, the client and server have to agree on the type of connection they will share.  When both sides choose `CS_NEG_DONT_CARE`, iRODS shows an affinity for security by connecting via TLS.  Additionally, it is important to note that all servers in an iRODS Zone are required to share the same TLS credentials (certificates, keys, etc.).  Maintaining per-route certificates is not supported at this time.

The remaining parameters are standard TLS parameters and made available through the EVP library included with OpenSSL.  You can read more about these remaining parameters at [https://www.openssl.org/docs/crypto/evp.html](https://www.openssl.org/docs/crypto/evp.html).

