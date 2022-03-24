#

iRODS 4.2+ launches a long-running server process (`/usr/sbin/irodsServer`), which immediately forks the Agent Factory and spawns the Delay Server (`/usr/sbin/irodsDelayServer`).  All incoming API requests are serviced by the Agent Factory, and for every new connection the Agent Factory spawns a new Agent.  Each Agent will service its request as quickly as possible, and then terminate.

The iRODS Delay Server sleeps most of the time, but spawns an Agent every 30 seconds to check the delay queue for any delayed rules that need to be run.

Agent processes are listed with the IP address of the connecting client.

    /usr/sbin/irodsServer
    ├─ irodsDelayServer
    └─ irodsAgentFactory
       ├─ irodsAgent
       ├─ irodsAgent
       ├─ irodsAgent
       └─ irodsAgent

| iRODS Process         | Expected Duration        | Expected Resident Memory Usage  |
| --------------------- | ------------------------ | ------------------------------- |
| irodsServer           | long-running             | 126M                            |
| irodsDelayServer      | long-running             | 17M                             |
| irodsAgentFactory     | long-running             | 5M                              |
| irodsAgent            | single client connection | 20M to 100M                     |

iRODS uses a dynamic linking model, rather than a static linking model, which adds significant overhead for short running processes (e.g. `ils`).  In order to mitigate this overhead, the irodsServer no longer calls `fork()` and `exec()` as a separate executable (pre-4.2).  In addition, since calling `fork()` within a threaded environment creates undefined behavior, the irodsServer calls `fork()` to spawn the Agent Factory process early, before any threading begins and any configuration is determined.

![iRODS Process Model Diagram](../images/process_model_diagram.jpg)



