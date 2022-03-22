#

In general, iRODS can use SSL in two ways:

 - Encryption of data between iRODS components
 - Encryption of passwords when using PAM for authentication

Since iRODS can be configured with or without general SSL data encryption and with or without PAM, there are four possible scenarios to consider:

1. Default - No data encryption and no PAM
2. Using SSL for data encryption only
3. Using SSL for PAM only
4. Using SSL for both data encryption and PAM

Depending on what configuration you require, you will need different pieces of the following instructions.

## Data Encryption

Please see [Server SSL Setup](../plugins/pluggable_authentication.md#server-ssl-setup) under [PAM Authentication](../plugins/pluggable_authentication.md#pam-pluggable-authentication-module).

## Password Encryption

Please see [Server SSL Setup](../plugins/pluggable_authentication.md#server-ssl-setup) under [PAM Authentication](../plugins/pluggable_authentication.md#pam-pluggable-authentication-module).

## No SSL for 4-to-3 Federation

The iRODS environment variable that defines the negotiation attempt around SSL is `irods_client_server_negotiation`.

Since iRODS 3.x could not use SSL, iRODS 4.x must set the value in `server_config.json` to 'none' when federating with iRODS 3.x:

```
'irods_client_server_negotiation': 'none',
```

If this value is set to anything else, the following errors will occur.

iRODS 4.x client:

```
-1815000 Unknown iRODS error
```

iRODS 4.x server log:

```
-1815000 ADVANCED_NEGOTIATION_NOT_SUPPORTED
```
