#

!!! Note
    The TLS network plugin is named the "SSL" plugin for legacy reasons. This documentation will use the term "TLS".

The TLS communication between client and iRODS server needs some basic setup in order to function properly.

## Server TLS Setup

Much of the setup concerns getting a proper X.509 certificate setup on the server side, and setting up the trust for the server certificate on the client side. You can use either a self-signed certificate (best for testing) or a certificate from a trusted CA.

Here are the basic steps to configure the server:

### Generate a new RSA key

Make sure it does not have a passphrase (i.e. do not use the -des, -des3 or -idea options to genrsa):

~~~
irods@hostname:~/ $ openssl genrsa -out server.key
~~~

### Acquire a certificate for the server

The certificate can be either from a trusted CA (internal or external), or can be self-signed (common for development and testing). To request a certificate from a CA, create your certificate signing request, and then follow the instructions given by the CA. When running the 'openssl req' command, some questions will be asked about what to put in the certificate. The locality fields do not really matter from the point of view of verification, but you probably want to try to be accurate. What is important, especially since this is a certificate for a server host, is to make sure to use the FQDN of the server as the "common name" for the certificate (should be the same name that clients use as their `irods_host`), and do not add an email address. If you are working with a CA, you can also put host aliases that users might use to access the host in the 'subjectAltName' X.509 extension field if the CA offers this capability.

To generate a Certificate Signing Request that can be sent to a CA, run the 'openssl req' command using the previously generated key:

~~~
irods@hostname:~/ $ openssl req -new -key server.key -out server.csr
~~~

To generate a self-signed certificate, also run 'openssl req', but with slightly different parameters. In the openssl command, you can put as many days as you wish:

~~~
irods@hostname:~/ $ openssl req -new -x509 -key server.key -out server.crt -days 365
~~~

### Create the certificate chain file

If you are using a self-signed certificate, the chain file is just the same as the file with the certificate (server.crt).  If you have received a certificate from a CA, this file contains all the certificates that together can be used to verify the certificate, from the host certificate through the chain of intermediate CAs to the ultimate root CA.

An example best illustrates how to create this file. A certificate for a host 'irods.example.org' is requested from the proper domain registrar. Three files are received from the CA: irods.crt, PositiveSSLCA2.crt and AddTrustExternalCARoot.crt. The certificates have the following 'subjects' and 'issuers':

~~~
openssl x509 -noout -subject -issuer -in irods.crt
subject= /OU=Domain Control Validated/OU=PositiveSSL/CN=irods.example.org
issuer= /C=GB/ST=Greater Manchester/L=Salford/O=COMODO CA Limited/CN=PositiveSSL CA 2
openssl x509 -noout -subject -issuer -in PositiveSSLCA2.crt
subject= /C=GB/ST=Greater Manchester/L=Salford/O=COMODO CA Limited/CN=PositiveSSL CA 2
issuer= /C=SE/O=AddTrust AB/OU=AddTrust External TTP Network/CN=AddTrust External CA Root
openssl x509 -noout -subject -issuer -in AddTrustExternalCARoot.crt
subject= /C=SE/O=AddTrust AB/OU=AddTrust External TTP Network/CN=AddTrust External CA Root
issuer= /C=SE/O=AddTrust AB/OU=AddTrust External TTP Network/CN=AddTrust External CA Root
~~~

The irods.example.org cert was signed by the PositiveSSL CA 2, and that the PositiveSSL CA 2 cert was signed by the AddTrust External CA Root, and that the AddTrust External CA Root cert was self-signed, indicating that it is the root CA (and the end of the chain).

To create the chain file for irods.example.org:

~~~
irods@hostname:~/ $ cat irods.crt PositiveSSLCA2.crt AddTrustExternalCARoot.crt > chain.pem
~~~

### Generate OpenSSL parameters

Generate some Diffie-Hellman parameters for OpenSSL:

~~~
irods@hostname:~/ $ openssl dhparam -2 -out dhparams.pem 2048
~~~

### Place files within accessible area

Put the dhparams.pem, server.key and chain.pem files somewhere that the iRODS server can access them (e.g. in /etc/irods).  Make sure that the irods unix user can read the files (although you also want to make sure that the key file is only readable by the irods user).

### Configure iRODS server for TLS

The server expects to have the following properties set in `server_config.json` when loading configuration at startup:

~~~
"tls_server": {
    "certificate_chain_file": "/etc/irods/chain.pem",
    "certificate_key_file": "/etc/irods/server.key",
    "dh_params_file": "/etc/irods/dhparams.pem"
}
~~~

These properties configure TLS in the server for incoming client connections. Here, we define what each of these configuration options means:

certificate_chain_file
:       Absolute path to the file containing the server's certificate chain. The certificates must be in PEM format and must be sorted starting with the subject's certificate (actual client or server certificate), followed by intermediate CA certificates if applicable, and ending at the highest level (root) CA.

certificate_key_file
:       Absolute path to the file containing the private key corresponding to the server's certificate in the certificate chain file.

dh_params_file
:       Absolute path to the Diffie-Hellman parameter file.

Outgoing connections (i.e. server-to-server connections) use a TLS configuration in a separate stanza which looks like this:

~~~
"tls_client": {
    "ca_certificate_file": "/etc/irods/server.crt",
    "ca_certificate_path": "/etc/ssl/certs",
    "verify_server": "cert"
}
~~~

Here, we define what each of these configuration options means:

ca_certificate_file
:       Location of a file of trusted CA certificates in PEM format. Note that the certificates in this file are used in conjunction with the system default trusted certificates. This configuration is optional.

ca_certificate_path
:       Location of a directory containing CA certificates in PEM format. The files each contain one CA certificate. The files are looked up by the CA subject name hash value, which must hence be available. If more than one CA certificate with the same name hash value exist, the extension must be different (e.g. 9d66eef0.0, 9d66eef0.1 etc). The search is performed in the ordering of the extension number, regardless of other properties of the certificates. Use the ‘c_rehash’ utility to create the necessary links. This configuration is optional.

verify_server
:       Defines the level of server certificate authentication to perform. The following values are supported: none, cert, hostname. When set to "none", authentication is skipped. When set to "cert", the server will verify that the certificate was signed by a trusted CA. When set to "hostname", the server will do everything defined by the "cert" level and then verify that the FQDN of the iRODS server matches either the common name or one of the subjectAltNames in the certificate.

In order for the configuration to take effect, the iRODS server configuration must be reloaded. This can be done by sending a `SIGHUP` to the main iRODS server process:

~~~
irods@hostname:~/ $ kill -HUP $(cat /var/run/irods/irods-server.pid)
~~~

## Client TLS Setup

The client may or may not require configuration at the TLS level, but there are a few parameters that can be set via `irods_environment.json` properties to customize the client TLS interaction if necessary. In many cases, if the server's certificate comes from a common CA, your system might already be configured to accept certificates from that CA, and you will not have to adjust the client configuration at all. For example, on Debian-based systems, the `/etc/ssl/certs` directory is used as a repository for system trusted certificates installed via an Ubuntu package. Many of the commercial certificate vendors such as VeriSign and AddTrust have their certificates already installed.

### Server Verification Settings

Server verification can be turned off using the `irods_ssl_verify_server` `irods_environment.json` property. If this variable is set to 'none', then any certificate (or none) is accepted by the client. This means that your connection will be encrypted, but you cannot be sure to what server (i.e. there is no server authentication). For that reason, this mode is discouraged.

It is much better to set up trust for the server's certificate, even if it is a self-signed certificate. The easiest way is to use the irods_ssl_ca_certificate_file `irods_environment.json` property to contain all the certificates of either hosts or CAs that you trust. If you configured the server as described above, you could just set the following property in your `irods_environment.json`:

~~~
"irods_ssl_ca_certificate_file": "/etc/irods/chain.pem"
~~~

Or this file could just contain the root CA certificate for a CA-signed server certificate. Another potential issue is that the server certificate does not contain the proper FQDN (in either the Common Name field or the subjectAltName field) to match the client's 'irods_host' property. If this situation cannot be corrected on the server side, the client can set:

~~~
"irods_ssl_verify_server": "cert"
~~~

Then, the client library will only require certificate validation, but will not check that the hostname of the iRODS server matches the hostname(s) embedded within the certificate.

### Encryption Settings

The following TLS encryption settings are required in `irods_environment.json` on both sides of the connection (client and server) and the values must match:

 - `irods_encryption_algorithm` (required) - EVP-supplied encryption algorithm for parallel transfer encryption
 - `irods_encryption_key_size` (required) - Key size for parallel transfer encryption
 - `irods_encryption_num_hash_rounds` (required) - Number of hash rounds for parallel transfer encryption
 - `irods_encryption_salt_size` (required) - Salt size for parallel transfer encryption

### Client Environment Configuration

All the `irods_environment.json` properties used for TLS support are listed below:

irods_ssl_verify_server
:       What level of server certificate based authentication to perform. 'none' means not to perform any authentication at all. 'cert' means to verify the certificate validity (i.e. that it was signed by a trusted CA). 'hostname' means to validate the certificate and to verify that the irods_host's FQDN matches either the common name or one of the subjectAltNames of the certificate. 'hostname' is the default setting.

irods_ssl_ca_certificate_file
:       Location of a file of trusted CA certificates in PEM format. Note that the certificates in this file are used in conjunction with the system default trusted certificates.

irods_ssl_ca_certificate_path
:       Location of a directory containing CA certificates in PEM format. The files each contain one CA certificate. The files are looked up by the CA subject name hash value, which must be available. If more than one CA certificate with the same name hash value exist, the extension must be different (e.g. 9d66eef0.0, 9d66eef0.1, etc.).  The search is performed based on the ordering of the extension number, regardless of other properties of the certificates.  Use the 'c_rehash' utility to create the necessary links.

### Debugging and verification of connected server TLS information

One can view TLS information from the server via `imiscsvrinfo`. Here is an example of the output from a client/server using certs generated using the instructions above:
~~~
SSL/TLS Info:
    enabled: true
    issuer_name: C=US, ST=North Carolina, L=Chapel Hill, O=iRODS Consortium
    not_after: 2026-04-01 13:26:35 UTC
    not_before: 2025-04-01 13:26:35 UTC
    public_key: Public-Key: (2048 bit)
    Modulus:
        00:a6:10:cd:91:99:8b:37:91:86:11:0b:ed:4e:72:
        2b:cc:15:65:e7:df:0a:1d:21:62:a6:50:48:4d:60:
        af:e2:2b:9a:34:de:e6:65:f7:fd:60:40:eb:ac:21:
        23:95:33:cd:34:e6:45:df:da:27:71:9b:95:05:1c:
        b1:4d:72:09:08:8e:64:2e:2b:61:1f:18:cc:e5:91:
        89:64:3d:69:3e:4f:1f:3b:b0:7d:3b:70:3c:7a:a0:
        65:cd:80:01:05:1c:0b:71:29:80:c7:e1:fa:65:38:
        ea:13:42:9e:0d:65:c1:9b:b4:0b:cc:bc:16:47:f0:
        94:05:01:ae:22:b8:39:f1:d0:36:52:cc:e2:fa:5f:
        72:a7:cb:b0:26:39:0a:4a:d6:ea:6e:fd:8b:4d:db:
        ca:59:9d:a3:bb:1a:f3:b8:52:05:7a:e2:35:3a:af:
        f7:61:38:6f:6f:f0:62:a0:34:1b:5d:78:a6:de:02:
        21:00:8a:c5:cc:b3:7e:81:76:d7:3a:1b:4a:88:c1:
        86:dd:4c:a6:9b:98:b6:a9:ed:f0:48:10:7c:af:7c:
        d6:50:b2:89:65:99:1c:dc:3a:77:91:6f:e3:92:9e:
        c5:98:76:05:64:00:aa:e1:db:86:68:03:b0:89:f5:
        cb:de:3d:8f:b4:7b:4c:39:59:27:4a:d5:37:b5:05:
        e6:09
    Exponent: 65537 (0x10001)
    signature_algorithm: sha256WithRSAEncryption
    subject_alternative_names: ["DNS:localhost"]
    subject_name: C=US, ST=North Carolina, L=Chapel Hill, O=iRODS Consortium
~~~

### Debugging and verification of client TLS information

The client can verify which certificate is in use by checking the iRODS client environment file (typically found in `~/.irods/irods_environment.json`) and looking for the `irods_ssl_ca_certificate_file` and `irods_ssl_ca_certificate_path` configurations. These settings refer to a specific cert file on the host, and the path to a directory on the host where at least one usable cert file exists, respectively.

If neither of these are specified, then a CA certificate location has been specified by the client some other way, or is using one of the default locations for certs. The OpenSSL library - which the iRODS server and C/C++ clients use - has a few default locations which one can investigate to deduce which certificate might be in use. From the [OpenSSL documentation](https://docs.openssl.org/3.0/man3/SSL_CTX_load_verify_locations/):

> "There is one default directory, one default file and one default store. The default CA certificates directory is called `certs` in the default OpenSSL directory, and this is also the default store. Alternatively the `SSL_CERT_DIR` environment variable can be defined to override this location. The default CA certificates file is called `cert.pem` in the default OpenSSL directory. Alternatively the `SSL_CERT_FILE` environment variable can be defined to override this location."
