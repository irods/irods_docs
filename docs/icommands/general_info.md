#

iCommands are a set of binaries which allow users to interact with an iRODS server via the command line. iCommands are available for all supported platforms.

## Server Version Compatibility

Starting with iRODS 5.1.0, the iCommands now perform a version check to verify compatibility with the connected server. If the major version number of the iCommands and server are not identical, a warning will be written to **stderr**. Users are strongly encouraged to keep these values in sync.

The check can be disabled for all iCommands by setting the environment variable `ICOMMANDS_DETECT_SERVER_VERSION_MISMATCH` to `0`, as shown below.

```sh
export ICOMMANDS_DETECT_SERVER_VERSION_MISMATCH=0
```
