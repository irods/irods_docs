# iRODS Process Model

When iRODS starts, it launches a long-running server process:  
`/usr/sbin/irodsServer`

This process immediately creates two other processes:

- **Agent Factory**: Handles all incoming API requests
- **Delay Server** (optional): Manages delayed rule execution

## How requests are handled

The **Agent Factory** listens for new client connections. For each new connection, it forks a separate **Agent** process. Each Agent handles one client request, completes the work as quickly as possible, and then waits for the next request. Agents will continue to service requests until the client disconnects.

## The Delay Server

The **Delay Server** is designed to remain idle most of the time. Every 30 seconds _(by default)_, it wakes up and spawns an Agent to check for any delayed rules that need to run. You can adjust this interval using the `delay_server_sleep_time_in_seconds` property in server_config.json. See [Configuration](../system_overview/configuration.md#etcirodsserver_configjson) for more information about this property.

## Example Process Tree

    irodsServer
      ├─irodsAgent
      │   ├─irodsAgent
      │   ├─irodsAgent
      │   └─irodsAgent
      └─irodsDelayServer

| iRODS Process         | Expected Duration        | Expected Memory Usage           |
| --------------------- | ------------------------ | ------------------------------- |
| irodsServer           | Long-running             | ~34 MB                          |
| irodsDelayServer      | Long-running             | ~33 MB                          |
| irodsAgent (factory)  | Long-running             | ~92 MB                          |
| irodsAgent            | Depends on client        | ~92 MB (minimum)                |

TODO: Update or remove graphic.
![iRODS Process Model Diagram](../images/process_model_diagram.jpg)
