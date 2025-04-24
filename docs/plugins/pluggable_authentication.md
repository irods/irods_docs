#

By default, iRODS uses a secure password system for user authentication.  The user passwords are scrambled and stored in the iCAT database.  Additionally, iRODS supports user authentication via PAM (Pluggable Authentication Modules), which can be configured to support many things, including the LDAP or Active Directory (AD) authentication systems.  PAM and TLS have been configured 'available' out of the box with iRODS, but there is still some setup required to configure an installation to communicate with your external authentication server of choice.

The iRODS administrator can 'force' a particular authentication scheme for a rodsuser by 'blanking' the native password for the rodsuser.  There is currently no way to signal to a particular login attempt that it is using an incorrect scheme ([GitHub Issue #2005](https://github.com/irods/irods/issues/2005)).

## PAM (Pluggable Authentication Module)

### User Setup

PAM can be configured to to support various authentication systems; however the iRODS administrator still needs to add the users to the iRODS database:

~~~
irods@hostname:~/ $ iadmin mkuser newuser rodsuser
~~~

If the user's credentials will be exclusively authenticated with PAM, a password need not be assigned.

For PAM Authentication, the iRODS user selects the new iRODS PAM authentication choice (instead of Native) via an `irods_environment.json` property:

~~~
"irods_authentication_scheme": "pam_password",
~~~

Then, the user runs 'iinit' and enters their system password.  To protect the system password, TLS (via OpenSSL) is used to encrypt the `iinit` session.

Configuring the operating system, the service name used for PAM is 'irods'.  An addition to /etc/pam.d/ is required if the fall-through behavior is not desired.

For example:
~~~
$ cat /etc/pam.d/irods
auth        required      pam_env.so
auth        sufficient    pam_unix.so
auth        requisite     pam_succeed_if.so uid >= 500 quiet
auth        required      pam_deny.so
~~~

For more information on the syntax of the pam.d configuration please refer to [The Linux Documentation Project](http://tldp.org/HOWTO/User-Authentication-HOWTO/x115.html)

### Testing basic authentication with irodsPamAuthCheck

A quick test for the basic authentication mechanism for PAM is to run the `/usr/sbin/irodsPamAuthCheck` tool. irodsPamAuthCheck takes one argument (the username to check) and then reads the password from stdin (without any prompting). Please note that this checks only for **basic authentication**, not **authorization**.

```
$ /usr/sbin/irodsPamAuthCheck bob
asdfasdf
Authenticated
$
```

If irodsPamAuthCheck returns `Not Authenticated`, that suggests that PAM is not set up correctly. You will need to configure PAM correctly (and therefore get irodsPamAuthCheck returning Authenticated) before using PAM through iRODS.

The tool takes the very first argument provided and assumes that it is the username to authenticate. If *any* argument is provided -- including `bash`-style hyphenated options such as `-h` -- that argument will be taken to mean the username to authenticate. Once executed, the tool awaits input on stdin and expects the user's PAM password to be supplied. There is no prompt for the user's password, so the program will appear to be hung until some text is entered and return/enter is pressed.

If any additional argument is passed after the username argument, the tool enters "debug" mode and prints extra messages to the output. The output below demonstrates what this looks like when the string "debug" is supplied as an additional argument:
```bash
$ irodsPamAuthCheck bob debug
asdfasdf
password bytes: 8
retval_pam_start: 0
null_conv: num_msg: 1
  null_conv: msg index: 0
    null_conv: msg_style: 1 -> PAM_PROMPT_ECHO_OFF
    null_conv: msg: Password: 
retval_pam_authenticate: 0
Authenticated
```

A simple way to check that you are using irodsPamAuthCheck correctly, and that it is the PAM settings that need updated, is to create a fully permissive PAM setup with the following command.

~~~
sudo su - root -c 'echo "auth sufficient pam_permit.so" > /etc/pam.d/irods'
~~~

This will allow any username/password combination to successfully authenticate with the irods PAM service, meaning that any username/password combination should cause irodsPamAuthCheck to return `Authenticated`.

With the permissive configuration working with irodsPamAuthCheck, the next step is to adjust your PAM configuration to your desired settings (LDAP, in this case). You will know that is correct when irodsPamAuthCheck behaves as you would expect when using LDAP username/passwords. iRODS uses irodsPamAuthCheck directly, so if it is working on the command line, it should work when run by iRODS.

### Setting up TLS

Since PAM requires the user's password in plaintext, iRODS relies on TLS encryption to protect these credentials. PAM authentication requires TLS communications. If TLS is not configured and enabled, PAM authentication will fail, and an error will be returned to the client.

See [TLS Documentation](../../system_overview/tls) for instructions to set up TLS communications between iRODS clients and servers.

## Legacy Authentication Plugin Migration Guide

The legacy authentication plugins have been deprecated in 5.0. This section exists to help developers and administrators migrate away from using these plugins and avoid system disruptions as these are being phased out.

### History of authentication in iRODS

iRODS authentication plugins were introduced in iRODS 4.0 to give a plugin interface to the existing authentication mechanisms in iRODS 3.3 and earlier. The supported authentication plugins included iRODS native authentication, Pluggable Authentication Module (PAM), Grid Security Infrastructure (GSI), Kerberos, and more.

The [iRODS Authentication Working Group](https://github.com/irods-contrib/irods_working_group_authentication) produced a highly flexible authentication plugin framework which allows for complex authentication flows driven by client-side plugin operations. This plugin framework became the default authentication mechanism for the iCommands in iRODS 4.3. The existing authentication plugins became known as the legacy authentication plugins and were left in the server in order to maintain compatibility with existing clients.

Over time, the legacy authentication plugins fell out of use in the Consortium and larger iRODS community. In 4.3, the only supported legacy authentication plugins were iRODS native authentication and PAM.

In iRODS 5, the legacy authentication plugins were declared deprecated. The legacy authentication plugins will be removed in iRODS 6.

### How to know if a client is using legacy authentication plugins

!!! Note
    iCommands with version 4.3.0 or later do NOT use the deprecated legacy authentication plugins.

In iRODS 5, the server-side legacy authentication plugin operations for the only remaining supported legacy authentication plugins return a message on the `rError` stack as well as a `DEPRECATED_AUTHENTICATION_PLUGIN` error code (-3002000). The error code is not indicative of an error occurring with the authentication, but is used to signal to the caller that the deprecated legacy authentication plugins are being used. If your client supports the `rError` stack, you should see a message like this:

> The legacy authentication plugin interface has been deprecated. Please update client to not use legacy authentication plugins.

If your client does not support the `rError` stack, or you are not sure how to see its contents, we will need to examine the source code. The legacy authentication API endpoints have been deprecated as well. If any of the following API numbers are used by your client library for authentication, it is using legacy authentication plugins:

- `AUTH_REQUEST_AN` (703)
- `AUTH_RESPONSE_AN` (704)
- `PAM_AUTH_REQUEST_AN` (725)
- `AUTH_PLUG_REQ_AN` (1201)
- `AUTH_PLUG_RESP_AN` (1202)

### Implementing the authentication plugin framework

!!! Note
    This section will likely only be of interest to client library developers.

The authentication plugin framework is client-driven, so each client library must maintain an implementation of the client-side plugin operations for each authentication scheme. The legacy authentication plugins also required each client library to implement all client-side operations for each authentication scheme, so this is no different in principle.

Client libraries are free to implement client-side authentication operations in whatever way they please. However, in order to use the authentication schemes supported by a given server, the server-side authentication operations must be called with the expected data payload at the expected times. Below, we will explain how the supported authentication schemes operate in turn.

#### Client-driven authentication flow

The C++ implementation for the authentication plugin framework follows these steps to authenticate a client:

1. Load the shared object for the appropriate plugin based on the authentication scheme in the client environment.
2. Call the "start" client operation for that plugin.
3. If the plugin has declared that the client is authenticated, the authentication flow is complete.
4. If not, get the "next operation" from the returned JSON payload and call that operation in the plugin.
5. Repeat 3 and 4 until the client has authenticated or an error occurs.

How the plugin determines whether the client is authenticated (step 3) is dependent on the authentication scheme. These will be described in detail below.

#### Anatomy of a client-side authentication plugin

At a minimum, client-side authentication operations need to invoke the appropriate server-side authentication operations in the correct order with the expected data. What these operations are, when they are called, and what data to send will depend on the plugin.

In order to invoke a server-side authentication operation, the client should call API number `AUTHENTICATION_APN` (110000; or, `authenticate`). The API takes a string - the *request* - which is parsed as JSON and returns a string - the *response* - which can be parsed as JSON. Depending on the plugin and the operation, certain keys will be required in the request payload.

#### How to deal with errors

If an error occurs such that the correct inputs cannot be provided from the client side to the server side operation, the authentication should be considered failed and the flow should be aborted. If the `authenticate` API returns a non-zero return value, the authentication should be considered a failure and the flow should be aborted.

### Implementing authentication plugins

!!! Note
    This section will likely only be of interest to client library developers.

#### Native authentication

The native authentication plugin has two server-side operations which must be called in order. The inputs and outputs from each are described below.

**Step 1: `auth_agent_auth_request`**

This operation - like all server-side plugin operations - requires a "scheme" in the request payload so that the server knows which authentication plugin to load. Otherwise, this operation has no requirements in terms of keys to include in the request payload. The request payload should minimally contain the following:
```json
{
    "scheme": "native"
}
```

The response payload from the server will minimally contain the following:
```json
{
    "scheme": "native",
    "request_result": "64_random_bytes_encoded_as_a_string____________________________"
}
```
The `request_result` is a randomly-generated byte-string that the server also preserves and uses to verify the client with which it is communicating.

**Step 2: `auth_agent_auth_response`**

This operation requires 3 keys: `digest`, `user_name`, and `zone_name`.

`user_name` and `zone_name` are the username and zone name for the user being authenticated. A user of the specified name belonging to the specified zone must exist in the local zone's catalog in order for authentication to succeed.

`digest` is a base64-encoded MD5 hash of the user's password. The client should construct the MD5 hash by concatenating two strings:

1. The randomly-generated string from the server stored in `request_result`
2. The user's plaintext password

How the plugin gets the user's password is entirely up to the library developer. For reference, the C++ client-side authentication plugin has a few ways of obtaining the password:

- The `a_pw` key in the request payload
- Prompting the user and receiving a password from `stdin`
- Reading from a `.irodsA` file

For example, if the user's password is "apass", the string to hash looks like this:
```
64_random_bytes_encoded_as_a_string____________________________apass
```
The concatenated string should be used as input to a MD5 hashing function, and the resulting byte-string should be base64-encoded. The resulting string should be stored in the `digest` key.

The request payload should minimally contain the following:
```json
{
    "scheme": "native",
    "user_name": "<user name>",
    "zone_name": "<zone name>",
    "digest": "<base64-encoded string of MD5 hash>"
}
```

The response payload from the server will be identical to the request as the server-side operation does not add or remove anything.

After `auth_agent_auth_response` completes, the `RsComm` in the connected agent has all of the appropriate values set and should be ready to perform regular requests.

#### PAM (`pam_password`) authentication

The `pam_password` authentication plugin has one server-side operation which must be called. The inputs and outputs are described below.

After this server-side operation returns, the client is expected to authenticate again using a randomly-generated iRODS native authentication password.

**Step 1: `auth_agent_auth_request`**

This operation requires 3 keys: `a_pw`, `user_name`, and `zone_name`.

`user_name` and `zone_name` are the username and zone name for the user being authenticated. A user of the specified name belonging the specified zone must exist in the local zone's catalog in order for authentication to succeed.

`a_pw` is the user's **plaintext PAM password** which is going to be checked by the configured server-side PAM service. This is why communication between client and server requires TLS to be enabled.

The request payload should minimally contain the following:
```json
{
    "scheme": "pam_password",
    "user_name": "<user name>",
    "zone_name": "<zone name>",
    "a_pw": "<plaintext PAM password>"
}
```

The response payload from the server will minimally contain the following:
```json
{
    "scheme": "pam_password",
    "user_name": "<user name>",
    "zone_name": "<zone name>",
    "request_result": "<randomly-generated iRODS password>"
}
```

The `request_result` key contains a time-limited, randomly-generated iRODS password. This password should be used to authenticate using the native authentication scheme. How the client implements this authentication is entirely up to the developer. For reference, the C++ `pam_password` client-side authentication plugin saves the randomly-generated password to a `.irodsA` file and then starts the authentication process from the "start" operation using the native authentication scheme and the password in that `.irodsA` file.
