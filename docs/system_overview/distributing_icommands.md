If your user community does not have root access to their machines, distributing a set of iCommands they can run is very desirable.

As an administrator, you should be able to provide a shared location for the iCommands binaries and client side plugins.

To use the network-installed binaries, the user will need to set the PATH to the iCommands and then set up the iRODS environment before authenticating against their Zone.

The user should make the iRODS environment directory and create an empty environment file:

```
joe_user:~$ mkdir .irods
joe_user:~$ touch .irods/irods_environment.json
```

Once this is done, the irods_environment.json file will need to be pointed at the location of the client-side plugins in order for the `iinit` command to finish the bootstrapping process. Using their favorite editor the user needs to add a few lines to `.irods/irods_environment.json`:

```
{
  "irods_plugins_home" : "/shared/location/to/icommands/plugins/"
}
```

After the location of the plugins is made available to the iCommands, the user can run `iinit` to finish setting up the iRODS client environment:

```
joe_user:~$ iinit
One or more fields in your iRODS environment file (irods_environment.json) are
missing; please enter them.
Enter the host name (DNS) of the server to connect to: joeserver.example.org
Enter the port number: 1247
Enter your irods user name: joe
Enter your irods zone: joeZone
Those values will be added to your environment file (for use by
other iCommands) if the login succeeds.

Enter your current iRODS password:
```

At this point the user has a valid iRODS environment:

```
joe_user:~$ cat .irods/irods_environment.json
{
    "irods_host": "joeserver.example.org",
    "irods_plugins_home" : "/shared/location/to/icommands/plugins/",
    "irods_port": 1247,
    "irods_user_name": "joe",
    "irods_zone_name": "joeZone"
}
```

Joe can now begin using the iCommands:

```
joe_user:~$ ils
/joeZone/home/joe:
```

It is also important to remember there are many other additional parameters available for configuration:

  - [https://github.com/irods/irods_schema_configuration](https://github.com/irods/irods_schema_configuration)


The `irods_plugins_home` can also be set via environment variable by setting the UPPERCASE version:

```
export IRODS_PLUGINS_HOME=/shared/location/to/icommands/plugins/
```
