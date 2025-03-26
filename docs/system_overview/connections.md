#

## Server-to-Server Connections

iRODS is a distributed system that enables users to manage data stored geographically across disparate storage technologies. iRODS achieves this by redirecting client requests to the appropriate server. This happens automatically and does not require interaction from the client or admin.

The following is true after a redirect of the client request:

    - Server-to-Server connections persist after creation for the lifetime of the agent
    - Server-to-Server connections represent the user who triggered their creation
    - Server-to-Server connections are disconnected on agent shutdown

## Long-Running Connections

- agents do not see ALL changes to policy

## Connection Pooling

- why
    - improve performance by avoiding tcp connection startup/shutdown
    - target audience is developers building irods client which runs as a server
- how
    - create multiple client connections
    - use `rc_switch_user` and optionally `rc_check_auth_credenticals`
