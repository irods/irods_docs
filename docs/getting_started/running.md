With the release of iRODS 4.3.0 comes two new server options:
- [Standard Output Mode](#standard-output-mode)
- [Test Mode](#test-mode)

## Standard Output Mode
This mode instructs the server and all of it's children to write log messages to **stdout** instead of **rsyslog**. This mode can be enabled in two ways.

### Option 1 (recommended) - Use the control script in the iRODS service account
```bash
$ ./irodsctl start --stdout
```

### Option 2 - Launch the server binary directly
```bash
$ /usr/sbin/irodsServer -u
```

Regardless of the method, it is important to remember that once the server has been launched in this mode, the terminal will not return control until the server is shutdown or killed.


## Test Mode
This mode instructs the server to write all log messages to an additional log file. Messages will still be written to stdout or rsyslog depending on how the server was launched. This secondary log file is located at the following location:
```bash
/var/lib/irods/log/test_mode_output.log
```

This mode was introduced to guarantee that log messages appear in the log file immediately. This mode is only meant to be used for testing. The log file produced by this mode is never rotated.

To enable this mode, you must first define the following environment variable in the iRODS service account like so:
```bash
export IRODS_ENABLE_TEST_MODE=1
```
This environment variable instructs the IrodsController python class to start the server in test mode.

**If you are using the run_tests.py script to run tests, then you can ignore the rest of this section because run_tests.py restarts the server in test mode automatically.**

Next, you'll want to start (or restart) the server in test mode. This can be done using either of the following methods.

### Option 1 (recommended) - Use the control script in the iRODS service account
```bash
$ ./irodsctl start --test
```

### Option 2 - Launch the server binary directly
```bash
$ /usr/sbin/irodsServer -t
```

