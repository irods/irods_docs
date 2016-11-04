# Process Model

The iRODS process model has been updated for 4.2+.

Starting iRODS 4.2+ launches a long-running server process (/usr/sbin/irodsServer) known as Server Main, which immediately forks another long-running process, known as the Agent Factory.  All incoming API requests are serviced by the Agent Factory, and for every new connection the Agent Factory spawns a new Agent.  Each Agent will service its request as quickly as possible, and then die.

This approach minimizes the penalty of loading shared objects (plugins) by loading them a single time in the Agent Factory.

## Shared Memory

The Agent Factory creates a pool of shared memory where plugins can record information for other plugins to read.
