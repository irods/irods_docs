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

Since PAM requires the user's password in plaintext, iRODS relies on TLS encryption to protect these credentials.  PAM authentication makes use of TLS regardless of the iRODS Zone TLS configuration (meaning even if iRODS explicitly does *not* encrypt data traffic, PAM will use TLS during authentication).

In order to use the iRODS PAM support, you also need to have TLS working between the iRODS client and server.

See [TLS Documentation](../../system_overview/tls) for instructions to set up TLS communications between iRODS clients and servers.
