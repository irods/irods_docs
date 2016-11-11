The iRODS process model has been updated for 4.2+.

iRODS 4.2+ launches a long-running server process (`/usr/sbin/irodsServer`), which immediately forks another long-running process, known as the Agent Factory.  All incoming API requests are serviced by the Agent Factory, and for every new connection the Agent Factory spawns a new Agent.  Each Agent will service its request as quickly as possible, and then terminate.

Agent processes are listed with the IP address of the connecting client.

    /usr/sbin/irodsServer
    └─ irodsServer: agent factory
       ├─ irodsServer: agent X.X.X.X
       ├─ irodsServer: agent X.X.X.X
       ├─ irodsServer: agent X.X.X.X
       └─ irodsServer: agent X.X.X.X

iRODS uses a dynamic linking model, rather than a static linking model, which adds significant overhead for short running processes (e.g. `ils`).  In order to mitigate this overhead, the irodsServer no longer calls `fork()` and `exec()` as a separate executable (pre-4.2).  In addition, since calling `fork()` within a threaded environment creates undefined behavior, the irodsServer calls `fork()` to spawn the Agent Factory process early, before any threading begins and any configuration is determined.

![iRODS Process Model Diagram](../process_model_diagram.jpg)



