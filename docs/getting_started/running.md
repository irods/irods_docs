#

## Starting the Server

The iRODS server can be started in several ways, but the most common form is as a daemon process. This is accomplished by running the following as the service account user.

```bash
irodsServer -d
```

The server will perform various checks during startup to make sure it is safe to accept client requests. The most important check is validation of `server_config.json`. Failing validation will result in the server terminating immediately. All validation errors are reported via stderr.

Logs are written to syslog. See [The Server Log](../../system_overview/server_log/#the-server-log) for information regarding syslog.

### Server PID File

By default, the server writes its process ID (PID) to `/run/irods/irods-server.pid`.

Use the `--pid-file` option to specify a different location. This is useful when running multiple iRODS servers on the same host or to get around permission-related problems. For example:

```sh
# Create the directory which will hold the PID file.
mkdir pid_dir

# Always provide the absolute path to the PID file.
irodsServer --pid-file $(pwd)/pid_dir/irods-server.pid -d
```

On an OS where `/run` is mounted as tmpfs, the iRODS PID file directory (`/run/irods`) may not persist across reboots. Administrators can resolve the problem through the use of a service manager (e.g. systemd), a tmpfiles configuration, or the `--pid-file` option.

!!! Warning
    These approaches are NOT mutually exclusive. Care must be taken when using a service manager and tmpfiles configuration for PID file directory management.

See [Managing iRODS via the Service Manager](#managing-irods-via-the-service-manager) for information regarding service manager support.

Below is an example tmpfiles configuration. The "User" and "Group" values must match the user and group of the iRODS service account.

```
# Create the irods location to hold PID files
#
# Type Path        Mode User  Group
d     /run/irods   0755 irods irods
```

## Stopping the Server

iRODS supports two modes of shutdown.

### Fast Shutdown

A fast shutdown is triggered by sending a `SIGTERM` or `SIGINT` to the main server process. For example:

```bash
kill -TERM $(cat /var/run/irods/irods-server.pid)
```

This signal instructs agents to complete their current client request and terminate immediately (and cleanly), ending communication with the client.

### Graceful Shutdown

A graceful shutdown is triggered by sending a `SIGQUIT` to the main server process. For example:

```bash
kill -QUIT $(cat /var/run/irods/irods-server.pid)
```

This signal instructs agents to wait a limited amount of time before entering the [fast shutdown](#fast-shutdown) phase. During a graceful shutdown, agents will continue servicing client requests until the timeout. The timeout can be modified via the `graceful_shutdown_timeout_in_seconds` configuration property in `server_config.json`. See the section about [configuration](../../system_overview/configuration/#etcirodsserver_configjson) to learn more.

## Reloading Server Configuration

Unlike iRODS 4, iRODS 5 does not automatically load changes to `server_config.json`. Reloading the server's configuration requires sending a `SIGHUP` to the server. For example:

```bash
kill -HUP $(cat /var/run/irods/irods-server.pid)
```

On receiving `SIGHUP`, the server:

1. Validates `server_config.json` against its schema.
2. If validation **fails**, the reload is **rejected** and the server continues running with the previous configuration.
3. If validation **succeeds**, the server:

    - Updates its in-memory configuration
    - Sends `SIGTERM` to the Delay Server _(if running)_
    - Sends `SIGQUIT` to the Agent Factory
    - Waits for the Agent Factory to close its listening socket
    - Launches a new Agent Factory
    - Launches a new Delay Server _(if designated by the administrator)_

## Managing iRODS via the Service Manager

iRODS 5 has full compatibility with the service manager.

Given that systemd is the most widely used service manager, iRODS provides a service file template which should prove helpful to users looking to manage their iRODS server via systemd.

The service file template is located at `/var/lib/irods/packaging/irods.service.template`.

!!! Note
    As a best practice, modify a copy of the template file. Doing that will help with avoiding issues with upgrades. Template files should always be treated as read-only.

Configuring systemd to use the service file is out of scope for this documentation and is left as an exercise for the reader. Below are a few links which you may find helpful.

- <https://systemd.io>
- <https://www.freedesktop.org/software/systemd/man/latest/systemd.html>

## Test Mode

!!! Note
    This section is primarily for developers working on the server, plugins, and/or clients.

This mode instructs the server to write all log messages to an additional log file. Messages will still be written to stdout or syslog depending on how the server was launched. This secondary log file is located at the following location:

```bash
/var/lib/irods/log/test_mode_output.log
```

This mode was introduced to guarantee that log messages appear in the log file immediately. This mode is only meant to be used for testing. **The log file produced by this mode is never rotated.**

To enable this mode, you must first define the following environment variable in the iRODS service account:

```bash
export IRODS_ENABLE_TEST_MODE=1
```

This environment variable makes various components (e.g. `IrodsController`) aware that the server is to be operated in test mode. This is very important for tests which restart the server.

**If you are using the run_tests.py script to run tests, then you can ignore the rest of this section because run_tests.py restarts the server in test mode automatically.**

Next, you'll want to start (or restart) the server in test mode.

```bash
irodsServer -t
```

## Additional Information

For more options and information, see the server's built-in help:

```bash
irodsServer --help
```
