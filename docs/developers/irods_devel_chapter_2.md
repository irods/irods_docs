# Chapter 2 - debugging

## GDB - attach to live server

Using [iRODS Development Environment](http://github.com/irods/irods_development_environment)

Follow README directions there to start a debugger container.

In terminal #1

  - attach to irods server
    ```
    gdb -p PID
    ```

    with PID = the parent (not grandparent) irodsServer
    Note this [info](./appendix_1.md#rr_gdb) if permission errors occur

  - Inside the GDB REPL:
    ```
    set follow-fork-mode child
    b rsApiHandler
    c
    ```

In terminal #2

run the client to invoke the API

