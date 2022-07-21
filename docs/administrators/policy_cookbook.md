# The iRODS Policy Cookbook

This section is all about presenting techniques to various policy-based situations encountered in the iRODS ecosystem.

Over time, we hope this cookbook will grow and become a valuable resource for new and existing users of iRODS.

If you have suggestions on how to improve the cookbook or you've developed solutions that you feel could help others, please reach out to us by creating an issue at [https://github.com/irods/irods_docs](https://github.com/irods/irods_docs).

## Synchronizing Delay Rules using Metadata

This example demonstrates how to synchronize actively running delay rules using metadata.

### How to do it ...

The rules in the example below do the following:

- Sequentially launch _N_ number of delay rules
- Each delay rule waits for a unique piece of metadata to be attached to a collection before doing work
- Assume the user has permission to modify metadata on `/tempZone/home/rods`

Pay close attention to the use of `wait_for_metadata_signal` and `msiModAVUMetadata`. They are what make this technique possible.

```python
# Returns true if "*attribute_name" is attached to "*collection" as metadata.
# Returns false otherwise.
is_metadata_attached_to_collection(*collection, *attribute_name)
{
    *attached = false;

    foreach (*row in select COLL_NAME where COLL_NAME = '*collection' and META_COLL_ATTR_NAME = '*attribute_name') {
        *attached = true;
    }

    *attached;
}

# A convenience rule that acts as a spin-lock.
# This rule also allows us to write clear and maintainable policy.
wait_for_metadata_signal(*collection, *attribute_name)
{
    while (!is_metadata_attached_to_collection(*collection, *attribute_name)) {
        msiSleep('1', '0');
    }
}

launch_synchronized_delay_rules_example
{
    *number_of_delay_rules = 5;

    # Schedule multiple delay rules.
    for (*i = 0; *i < *number_of_delay_rules; *i = *i + 1) {
        *signum = *i;

        delay('<INST_NAME>irods_rule_engine_plugin-irods_rule_language-instance</INST_NAME>') {
            wait_for_metadata_signal('/tempZone/home/rods', 'irods::signal_*signum');

            # Log a message to let the admin know the metadata signal was received.
            writeLine('serverLog', 'Received signal! (irods::signal_*signum)');

            # Let the next delay rule know it's time to do actual work!
            # We do that by attaching the correct metadata to the collection.
            *next_signum = *signum + 1;
            writeLine('serverLog', 'Signaling next delay rule (irods::signal_*next_signum) ...');
            msiModAVUMetadata('-C', '/tempZone/home/rods', 'add', 'irods::signal_*next_signum', 'unused', '');
        }
    }
}
```

### Let's see it in action!

!!! Note
    Remember, this example assumes you can modify metadata on `/tempZone/home/rods`. Feel free to change the collection used throughout the example to one that you can access and manipulate.

If you haven't already, add the rule code above to `/etc/irods/core.re`.

We need to run the example. To do that, run the following commands:
```bash
$ irule -r irods_rule_engine_plugin-irods_rule_language-instance 'launch_synchronized_delay_rules_example' null ruleExecOut
$ imeta -C /tempZone/home/rods 'irods::signal_0' 'unused'
```

Now, inspect the log file at `/var/log/irods/irods.log`. You should see log messages similar to the ones below. Notice the value of **log_message**.
```json
{
  "log_category": "legacy",
  "log_facility": "local0",
  "log_level": "info",
  "log_message": "writeLine: inString = Received signal! (irods::signal_0)\n",
  "request_api_name": "EXEC_RULE_EXPRESSION_AN",
  "request_api_number": 1206,
  "request_api_version": "d",
  "request_client_user": "rods",
  "request_host": "127.0.0.1",
  "request_proxy_user": "rods",
  "request_release_version": "rods4.3.0",
  "server_host": "38832fb94fff",
  "server_pid": 1919951,
  "server_timestamp": "2022-08-23T12:17:50.161Z",
  "server_type": "agent"
}
{
  "log_category": "legacy",
  "log_facility": "local0",
  "log_level": "info",
  "log_message": "writeLine: inString = Signaling next delay rule (irods::signal_1) ...\n",
  "request_api_name": "EXEC_RULE_EXPRESSION_AN",
  "request_api_number": 1206,
  "request_api_version": "d",
  "request_client_user": "rods",
  "request_host": "127.0.0.1",
  "request_proxy_user": "rods",
  "request_release_version": "rods4.3.0",
  "server_host": "38832fb94fff",
  "server_pid": 1919951,
  "server_timestamp": "2022-08-23T12:17:50.162Z",
  "server_type": "agent"
}
{
  "log_category": "legacy",
  "log_facility": "local0",
  "log_level": "info",
  "log_message": "writeLine: inString = Received signal! (irods::signal_1)\n",
  "request_api_name": "EXEC_RULE_EXPRESSION_AN",
  "request_api_number": 1206,
  "request_api_version": "d",
  "request_client_user": "rods",
  "request_host": "127.0.0.1",
  "request_proxy_user": "rods",
  "request_release_version": "rods4.3.0",
  "server_host": "38832fb94fff",
  "server_pid": 1919950,
  "server_timestamp": "2022-08-23T12:17:51.158Z",
  "server_type": "agent"
}
{
  "log_category": "legacy",
  "log_facility": "local0",
  "log_level": "info",
  "log_message": "writeLine: inString = Signaling next delay rule (irods::signal_2) ...\n",
  "request_api_name": "EXEC_RULE_EXPRESSION_AN",
  "request_api_number": 1206,
  "request_api_version": "d",
  "request_client_user": "rods",
  "request_host": "127.0.0.1",
  "request_proxy_user": "rods",
  "request_release_version": "rods4.3.0",
  "server_host": "38832fb94fff",
  "server_pid": 1919950,
  "server_timestamp": "2022-08-23T12:17:51.158Z",
  "server_type": "agent"
}
{
  "log_category": "legacy",
  "log_facility": "local0",
  "log_level": "info",
  "log_message": "writeLine: inString = Received signal! (irods::signal_2)\n",
  "request_api_name": "EXEC_RULE_EXPRESSION_AN",
  "request_api_number": 1206,
  "request_api_version": "d",
  "request_client_user": "rods",
  "request_host": "127.0.0.1",
  "request_proxy_user": "rods",
  "request_release_version": "rods4.3.0",
  "server_host": "38832fb94fff",
  "server_pid": 1920152,
  "server_timestamp": "2022-08-23T12:17:51.402Z",
  "server_type": "agent"
}
{
  "log_category": "legacy",
  "log_facility": "local0",
  "log_level": "info",
  "log_message": "writeLine: inString = Signaling next delay rule (irods::signal_3) ...\n",
  "request_api_name": "EXEC_RULE_EXPRESSION_AN",
  "request_api_number": 1206,
  "request_api_version": "d",
  "request_client_user": "rods",
  "request_host": "127.0.0.1",
  "request_proxy_user": "rods",
  "request_release_version": "rods4.3.0",
  "server_host": "38832fb94fff",
  "server_pid": 1920152,
  "server_timestamp": "2022-08-23T12:17:51.402Z",
  "server_type": "agent"
}
{
  "log_category": "legacy",
  "log_facility": "local0",
  "log_level": "info",
  "log_message": "writeLine: inString = Received signal! (irods::signal_3)\n",
  "request_api_name": "EXEC_RULE_EXPRESSION_AN",
  "request_api_number": 1206,
  "request_api_version": "d",
  "request_client_user": "rods",
  "request_host": "127.0.0.1",
  "request_proxy_user": "rods",
  "request_release_version": "rods4.3.0",
  "server_host": "38832fb94fff",
  "server_pid": 1919952,
  "server_timestamp": "2022-08-23T12:17:52.160Z",
  "server_type": "agent"
}
{
  "log_category": "legacy",
  "log_facility": "local0",
  "log_level": "info",
  "log_message": "writeLine: inString = Signaling next delay rule (irods::signal_4) ...\n",
  "request_api_name": "EXEC_RULE_EXPRESSION_AN",
  "request_api_number": 1206,
  "request_api_version": "d",
  "request_client_user": "rods",
  "request_host": "127.0.0.1",
  "request_proxy_user": "rods",
  "request_release_version": "rods4.3.0",
  "server_host": "38832fb94fff",
  "server_pid": 1919952,
  "server_timestamp": "2022-08-23T12:17:52.160Z",
  "server_type": "agent"
}
{
  "log_category": "legacy",
  "log_facility": "local0",
  "log_level": "info",
  "log_message": "writeLine: inString = Received signal! (irods::signal_4)\n",
  "request_api_name": "EXEC_RULE_EXPRESSION_AN",
  "request_api_number": 1206,
  "request_api_version": "d",
  "request_client_user": "rods",
  "request_host": "127.0.0.1",
  "request_proxy_user": "rods",
  "request_release_version": "rods4.3.0",
  "server_host": "38832fb94fff",
  "server_pid": 1919953,
  "server_timestamp": "2022-08-23T12:17:53.168Z",
  "server_type": "agent"
}
{
  "log_category": "legacy",
  "log_facility": "local0",
  "log_level": "info",
  "log_message": "writeLine: inString = Signaling next delay rule (irods::signal_5) ...\n",
  "request_api_name": "EXEC_RULE_EXPRESSION_AN",
  "request_api_number": 1206,
  "request_api_version": "d",
  "request_client_user": "rods",
  "request_host": "127.0.0.1",
  "request_proxy_user": "rods",
  "request_release_version": "rods4.3.0",
  "server_host": "38832fb94fff",
  "server_pid": 1919953,
  "server_timestamp": "2022-08-23T12:17:53.169Z",
  "server_type": "agent"
}
```

## Naming Schemes and Conventions 

This section covers naming techniques and conventions that help in enforcing naming conventions.

### Metadata Attribute Names

Use prefixes to introduce different namespaces. Below is an example that generates metadata attribute names with a special prefix. The prefix itself isn't special, but it allows implementations to reuse variable names without creating collisions.

```python
FANCY_NAMESPACE = "fancy"; # The "fancy" namespace string.

# A helper rule that returns the input string with a prefix of the fancy namespace string.
make_fancy(*name)
{
    FANCY_NAMESPACE ++ "::*name";
}

generate_and_use_fancy_metadata_attribute_names
{
    # Generate metadata attribute names under the "fancy" namespace.
    *attr_file_path = make_fancy("file_path"); # Creates "fancy::file_path".
    *attr_file_size = make_fancy("file_size"); # Creates "fancy::file_size".

    # Do something with the variables ...
}
```

This can be used to generate keys for `temporaryStorage` as well. See [Sharing data across PEPs](#sharing-data-across-peps) for details about using `temporaryStorage`.

### Rule Names

When a group of rules are related, include a rule name prefix to indicate that. You can find several examples of this in other programming languages.

Below is an example that demonstrates how this may look. The rules presented make up an imaginary Native Rule Language synchronization library. In this example, the rule name prefix, `mutex_` is used to provide signal to the person writing the policy that these rules are related. The body of the rules has been left out to not take away from the primary focus of the example.

```python
#
# Example Synchronization Library
#

# Returns a handle to a newly allocated mutex object.
mutex_create(*mutex_name) {}

# Returns the handle of the mutex identified by *mutex_name.
# Returns zero if the mutex does not exist.
mutex_find(*mutex_name) {}

# Tries to acquire the lock on *mutex.
# Blocks until *mutex is acquired.
mutex_lock(*mutex) {}

# Tries to acquire the lock on *mutex.
# Blocks until *mutex is acquired or *timeout has been exceeded.
mutex_lock(*mutex, *timeout) {}

# Tries to acquire the lock on *mutex.
# Returns true if the lock was acquired.
# Returns false if the lock could not be acquired.
mutex_try_lock(*mutex) {}

# Releases the lock on *mutex.
mutex_unlock(*mutex) {}

# Deallocates OS resources for *mutex.
mutex_destroy(*mutex) {}
```

## Sharing data across PEPs

This example demonstrates how to share information across multiple PEPs within the Native Rule Engine Plugin.

### How to do it ...

Let's say we want to log the logical path of a data object every time a client successfully closes it. This means, we expect the client to invoke the following API operations in order:

1. Open
2. Read/Write
3. Close

To keep things simple, we'll constrain the example to PEPs triggered by the use of `istream`.

Below, you'll find rules that do exactly what we want. They correctly log the logical path of a data object that was successfully closed. Pay close attention to the PEPs and the use of `temporaryStorage`.

```python
# This PEP will always be triggered before "pep_api_replica_close_post".
# This PEP's primary job is to capture the logical path so that "pep_api_replica_close_post" can use it.
# "temporaryStorage" is what allows rules to share information across PEPs in the Native Rule Engine Plugin.
pep_api_replica_open_post(*INSTANCE_NAME, *COMM, *DATA_OBJ_INPUT, *JSON_OUTPUT)
{
    # Attach the logical path to "temporaryStorage" using "logical_path" as the key.
    #
    # In production-level policy, you need to consider the possibility of key name collisions.
    # See "Naming Schemes and Conventions" for tips on how to do that.
    temporaryStorage."logical_path" = *DATA_OBJ_INPUT.objPath;
}

# This PEP will always be triggered after "pep_api_replica_open_post".
pep_api_replica_close_post(*INSTANCE_NAME, *COMM, *JSON_INPUT)
{
    # Notice that this PEP's signature does NOT contain a "*DATA_OBJ_INPUT" parameter.
    # This means the logical path isn't available to us in that way. Luckily, we attached
    # it to the "temporaryStorage" object.
    #
    # Fetch the logical path we captured during the call to "pep_api_replica_open_post".
    *logical_path = temporaryStorage."logical_path";

    # Write a message to the log file containing the full logical path.
    writeLine("serverLog", "Successfully closed [*logical_path].");
}
```

!!! Note
    Understanding the execution order of PEPs and how to use `temporaryStorage` is key to making this work. If you're interested in learning more about PEPs and flow-control, see [Dynamice Policy Enforcement Points](/plugins/dynamic_policy_enforcement_points/#flow-control).

### Let's see it in action!

Assuming you added the rules above to `/etc/irods/core.re`, if you run the following command:
```bash
$ echo 'Sharing data across PEPs is easy!' | istream write foo
```

And inspect the log file at `/var/log/irods/irods.log`, you'd see a log message similar to the following:
```json
{
  "log_category": "legacy",
  "log_facility": "local0",
  "log_level": "info",
  "log_message": "writeLine: inString = Successfully closed [/tempZone/home/rods/foo].\n",
  "request_api_name": "",
  "request_api_number": 20004,
  "request_api_version": "d",
  "request_client_user": "rods",
  "request_host": "127.0.0.1",
  "request_proxy_user": "rods",
  "request_release_version": "rods4.3.0",
  "server_host": "38832fb94fff",
  "server_pid": 1816889,
  "server_timestamp": "2022-08-22T18:49:27.357Z",
  "server_type": "agent"
}
```

The prototype implementation of the Logical Quotas Rule Engine Plugin used this technique. You can find the implementation at [https://github.com/irods/irods_policy_examples/blob/main/irods_policy_logical_quotas.re](https://github.com/irods/irods_policy_examples/blob/main/irods_policy_logical_quotas.re)

Additional documentation can be found at [Using temporaryStorage in the iRODS Rule Language](/system_overview/tips_and_tricks/#using-temporarystorage-in-the-irods-rule-language).

## Simulating User Quotas

This example demonstrates how to simulate user quotas using group quotas.

As of iRODS 4.3.0, support for user quotas has been partially disabled. Please consult [iadmin suq](/icommands/administrator/#suq) and the [release notes](/release_notes) for more information.

### How to do it ...

#### Step 1: Enable Quota Enforcement

First, we have to instruct iRODS to enforce quotas. For historical reasons, we must use `msiSetRescQuotaPolicy()` to do this.

Open `/etc/irods/core.re` and change the argument passed to `msiSetRescQuotaPolicy()` from `"off"` to `"on"`. The line you modified should look very similar to the one below.
```python
acRescQuotaPolicy { msiSetRescQuotaPolicy("on"); }
```

When implementing this policy, we recommend applying this change to all servers in the local zone. That guarantees that all servers enforce the quotas. Keep in mind that this is only a recommendation. You should use a testing environment to verify behavior if you decide not to follow this recommendation.

iRODS does not update the quota information following user interaction. To do that, you're going to need to periodically tell iRODS to update the quota information. One way to do that is by running [iadmin cu](/icommands/administrator/#cu) periodically. How you do that is up to you. You can use **cron** or any other tool you find convenient to use. The important thing is that the command runs.

#### Step 2: Setup the user quota

Given a user named **alice**, all we have to do is create a new group, add the user to it, and set a quota limit on the group.
```bash
$ iadmin mkgroup quota_group_for_alice           # Create the group.
$ iadmin atg quota_group_for_alice alice         # Add user to the group.
$ iadmin sgq quota_group_for_alice total 10000   # Set the group quota.
```

The important thing to remember is that only one user should be in the group. That user being the user you wish to apply the quota to. In a production environment, that may mean each user gets their own group. For that reason, it is recommended that you develop a good naming scheme for your groups. Having a good naming scheme will help other users understand the purpose of that group and allow you to write policy that protects those groups from modification.

### Let's see it in action!

Below are some examples of what you may see when a quota is violated.

Here is an `iput` example.
```bash
$ echo "This violates the quota!" > foo
$ iput foo
remote addresses: 127.0.0.1 ERROR: putUtil: put error for /tempZone/home/alice/foo, status = -110000 status = -110000 SYS_RESC_QUOTA_EXCEEDED
```

Depending on the client, the error information can change. For example, this is what happens when `istream` violates a quota.
```bash
$ echo "This violates the quota!" | istream write other_foo
Error: Cannot open data object.
```

Regardless of the client, the server's log file will always report the error. Notice the value of **log_message**.
```json
{
  "log_category": "legacy",
  "log_facility": "local0",
  "log_level": "error",
  "log_message": "[rsDataObjPut_impl:608] - [SYS_RESC_QUOTA_EXCEEDED: resource quota exceeded\n\n]",
  "request_api_name": "DATA_OBJ_PUT_AN",
  "request_api_number": 606,
  "request_api_version": "d",
  "request_client_user": "alice",
  "request_host": "127.0.0.1",
  "request_proxy_user": "alice",
  "request_release_version": "rods4.3.0",
  "server_host": "38832fb94fff",
  "server_pid": 2178,
  "server_timestamp": "2022-07-21T16:34:35.119Z",
  "server_type": "agent"
}
```
