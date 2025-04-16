#

When iRODS starts, it launches the long-running server process `irodsServer`.

This process immediately creates two other processes:

- **Agent Factory**: Handles all incoming client requests
- **Delay Server** (optional): Manages delayed rule execution

## How requests are handled

The **Agent Factory** listens for new client connections. For each new connection, it forks a separate **Agent** process. Each Agent handles the initial client request, completes the work as quickly as possible, and then waits for any additional requests. Agents will continue to service requests until the client disconnects.

## The Delay Server

The **Delay Server** is designed to remain idle most of the time. Every 30 seconds _(by default)_, it wakes up and checks for any delayed rules that need to run. You can adjust this interval using the `delay_server_sleep_time_in_seconds` property in `server_config.json`. See [Configuration](../system_overview/configuration.md#etcirodsserver_configjson) for more information about this property.

## Process Tree

The following is an example showing the process hierarchy when the server is idle.

```bash
irodsServer
  ├─irodsAgent
  └─irodsDelayServer
```

Here is another example showing three Agents handling client requests. From this, we know there are three active connections to the server. Additional information about each connection is available via the [`ips`](../../icommands/user/#ips) iCommand.

```bash
irodsServer
  ├─irodsAgent
  │   ├─irodsAgent
  │   ├─irodsAgent
  │   └─irodsAgent
  └─irodsDelayServer
```

The following table outlines basic expectations for each process.

| Process                | Expected Duration        | Expected Memory Usage           |
| ---------------------- | ------------------------ | ------------------------------- |
| irodsServer            | Long-running             | ~60 MB                          |
| irodsAgent _(factory)_ | Long-running             | ~120 MB                         |
| irodsAgent             | Depends on client        | ~82 MB                          |
| irodsDelayServer       | Long-running             | ~53 MB                          |

Note that the lifetime of an Agent depends on the client. Clients are allowed to manage connections in ways that best suit their needs. Some may use connection pooling, while others may create and tear down connections as required.
