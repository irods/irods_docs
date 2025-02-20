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

Additional documentation can be found at [Using temporaryStorage in the iRODS Rule Language](../system_overview/tips_and_tricks/#using-temporarystorage-in-the-irods-rule-language).

## Simulating User Quotas

This example demonstrates how to simulate user quotas using group quotas.

As of iRODS 4.3.0, support for user quotas has been partially disabled. Please consult [iadmin suq](../../icommands/administrator/#suq) and the [release notes](../../release_notes) for more information.

### How to do it ...

#### Step 1: Enable Quota Enforcement

First, we have to instruct iRODS to enforce quotas. For historical reasons, we must use `msiSetRescQuotaPolicy()` to do this.

Open `/etc/irods/core.re` and change the argument passed to `msiSetRescQuotaPolicy()` from `"off"` to `"on"`. The line you modified should look very similar to the one below.
```python
acRescQuotaPolicy { msiSetRescQuotaPolicy("on"); }
```

When implementing this policy, we recommend applying this change to all servers in the local zone. That guarantees that all servers enforce the quotas. Keep in mind that this is only a recommendation. You should use a testing environment to verify behavior if you decide not to follow this recommendation.

iRODS does not update the quota information following user interaction. To do that, you're going to need to periodically tell iRODS to update the quota information. One way to do that is by running [iadmin cu](../../icommands/administrator/#cu) periodically. How you do that is up to you. You can use **cron** or any other tool you find convenient to use. The important thing is that the command runs.

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

## Implementing maintainable Policy through reusable rules

When implementing policy, strive for readability and maintainability. This will make it easier for others to contribute and update the policy later. Remember, somebody else will have to manage the policy you write one day.

One way to achieve this is by making your rules reusable. This can be accomplished by identifying duplicate logic and moving it into a separate rule.

Given the following policy, notice how each rule starts with very similar logic. The more this policy grows, the more difficult it will become to manage. Changing the logic means the user maintaining it must touch all rules involved.

```python
pep_api_replica_open_post(*INSTANCE_NAME, *COMM, *DATA_OBJ_INPUT, *JSON_OUTPUT)
{
    *username = get_username(*COMM);
    temporaryStorage."obj_path" = *DATA_OBJ_INPUT.obj_path;
    *results = calculate_very_important_stats(*username, *DATA_OBJ_INPUT.obj_path);
    update_stats(*results);

    # Run logic that is unique to this PEP ...
}

pep_api_replica_close_post(*INSTANCE_NAME, *COMM, *JSON_INPUT)
{
    *username = get_username(*COMM);
    *results = calculate_very_important_stats(*username, temporaryStorage."obj_path");
    update_stats(*results);

    # Run logic that is unique to this PEP ...
}

pep_api_data_obj_open_post(*INSTANCE_NAME, *COMM, *DATA_OBJ_INPUT)
{
    *username = get_username(*COMM);
    temporaryStorage."obj_path" = *DATA_OBJ_INPUT.obj_path;
    *results = calculate_very_important_stats(*username, *DATA_OBJ_INPUT.obj_path);
    update_stats(*results);

    # Run logic that is unique to this PEP ...
}

pep_api_data_obj_close_post(*INSTANCE_NAME, *COMM, *OPENED_DATA_OBJ_INPUT)
{
    *username = get_username(*COMM);
    *results = calculate_very_important_stats(*username, temporaryStorage."obj_path");
    update_stats(*results);

    # Run logic that is unique to this PEP ...
}
```

We can improve the situation by moving the logic at the beginning of each PEP into a separate rule and then calling it with the appropriate arguments.

Now, the policy is easier to maintain and change because the startup logic is captured in a single rule.

```python
# Calculates and updates the stats for a logical path.
#
# @param *comm                 The communication object.
# @param *logical_path         The logical path to calculate stats for.
# @param *capture_logical_path A boolean value instructing the rule to store *logical_path in temporaryStorage.
calculate_and_update_important_stats(*comm, *logical_path, *capture_logical_path)
{
    if (*capture_logical_path) {
        temporaryStorage."obj_path" = *logical_path;
    }

    *username = get_username(*comm);
    *results = calculate_very_important_stats(*username, temporaryStorage."obj_path");
    update_stats(*results);
}

pep_api_replica_open_post(*INSTANCE_NAME, *COMM, *DATA_OBJ_INPUT, *JSON_OUTPUT)
{
    calculate_and_update_important_stats(*COMM, *DATA_OBJ_INPUT.obj_path, true);

    # Run logic that is unique to this PEP ...
}

pep_api_replica_close_post(*INSTANCE_NAME, *COMM, *JSON_INPUT)
{
    calculate_and_update_important_stats(*COMM, "", false);

    # Run logic that is unique to this PEP ...
}

pep_api_data_obj_open_post(*INSTANCE_NAME, *COMM, *DATA_OBJ_INPUT)
{
    calculate_and_update_important_stats(*COMM, *DATA_OBJ_INPUT.obj_path, true);

    # Run logic that is unique to this PEP ...
}

pep_api_data_obj_close_post(*INSTANCE_NAME, *COMM, *OPENED_DATA_OBJ_INPUT)
{
    calculate_and_update_important_stats(*COMM, "", false);

    # Run logic that is unique to this PEP ...
}
```

## Enforcing policy when data transfers complete

It can be helpful to write policy which is enacted at the time data has finished transferring and its catalog information has been finalized; in other words, when it transitions from being in-flight to being at-rest. This section demonstrates how to do this in a couple of different ways.

Before proceeding, it is recommended that one be familiar with how data transfers work in iRODS, and the different states that replicas of a data object can take on. This information can be found in the [System Overview's Data Objects](../../system_overview/data_objects) page.

### Step 1: Decide what to implement

Unlike many policy implementations, which implement API Policy Enforcement Points (PEPs), this policy enforcement implements database and resource PEPs. This is because the process of indicating that data is at rest - known as **finalizing** the data object - is primarily performed by the server. Although finalizing a data object can be done via an API call, the API PEP will only be invoked when the API is called from a client application. However, the mechanism for finalizing the data object uses a database plugin operation. So, the associated database plugin operation PEP - specifically, the "post"-PEP - can be implemented to enforce policy.

There are a couple of ways to implement policy around the completion of a data transfer depending on what you want to do.

After the successful transfer of data, the entire logical representation of the data (data object) is finalized in order that the physical representations (replicas) accurately reflect the state of the data in storage. This is done via the `data_object_finalize` API, which invokes the `data_object_finalize` database plugin operation. This database operation atomically updates the system metadata of the replicas for a given data object.

Once the database operation is complete, depending on policy implemented in the server, additional actions can occur. These additional actions are invoked via the `modified` resource plugin operation (from now on, we will refer to it as `fileModified` for historical reasons). `fileModified` is the operation responsible for enforcing the policy in some coordinating resources such as the replication resource plugin and the compound resource plugin. This can lead to even more replicas being created or modified, which means more data transfers, which means more invocations of the `data_object_finalize` database operation. Once `fileModified` is complete, the overall data object modification is complete.

As you can see, a "complete" data transfer can take on a couple of different meanings. Therefore, we present two policy implementations which can be used for whatever purpose you need. The implementation described in **Step 2a** takes the first definition for data transfer completion: after data transfer has completed for a single replica. The implementation in **Step 2b** takes the second definition for data transfer completion: after an overall data object creation or modification operation has completed, including any policy which occurs after the initial replica has been finalized. These options are not mutually exclusive, so both can be implemented at the same time in a single deployment.

### Step 2a: Implementing `data_object_finalize`

In this example, we will implement a policy which ensures that every newly created replica has a checksum. The implementation uses the [iRODS Rule Language](../../plugins/irods_rule_language) and demonstrates usage of the JSON microservices.

#### How to do it ...

We should implement the database operation PEP `pep_database_data_object_finalize_post`. Referencing the [Dynamic Policy Enforcement Points](../../plugins/dynamic_policy_enforcement_points) page, one can see that the database PEP has the plugin context available and, more importantly, a string called `_json_input` which holds a JSON object containing replica information. This JSON object has the following form:
```javascript
{
    "replicas": [
        {
            "before": {
                "data_id": <string>,
                "coll_id": <string>,
                "data_repl_num": <string>,
                "data_version": <string>,
                "data_type_name": <string>,
                "data_size": <string>,
                "data_path": <string>,
                "data_owner_name": <string>,
                "data_owner_zone": <string>,
                "data_is_dirty": <string>,
                "data_status": <string>,
                "data_checksum": <string>,
                "data_expiry_ts": <string>,
                "data_map_id": <string>,
                "data_mode": <string>,
                "r_comment": <string>,
                "create_ts": <string>,
                "modify_ts": <string>,
                "resc_id": <string>
            },
            "after": {
                "data_id": <string>,
                "coll_id": <string>,
                "data_repl_num": <string>,
                "data_version": <string>,
                "data_type_name": <string>,
                "data_size": <string>,
                "data_path": <string>,
                "data_owner_name": <string>,
                "data_owner_zone": <string>,
                "data_is_dirty": <string>,
                "data_status": <string>,
                "data_checksum": <string>,
                "data_expiry_ts": <string>,
                "data_map_id": <string>,
                "data_mode": <string>,
                "r_comment": <string>,
                "create_ts": <string>,
                "modify_ts": <string>,
                "resc_id": <string>
            },
            "file_modified": {
                <string>: <string>,
                ...
            }
        },
        ...
    ]
}
```
Each entry in the list of replicas is a "before" and "after" view of the row in `R_DATA_MAIN` representing that replica, complete with the column names. In order to check that the replica has a checksum, we want to find the replica which was modified in the list, and ensure that the "after" entry's "data_checksum" entry has a value. If not, we will calculate a checksum and register it in the catalog.

The `data_object_finalize` database PEP is invoked twice per data transfer: once on open in order to lock the data object, and once on close in order to finalize the system metadata. We are only interested in the invocation on close. The example implementation contains checks which can detect whether the PEP was invoked by an open or a close. You might consider abstracting this into a separate function for more readable code.

Here is the PEP implementation for the example policy:
```python
pep_database_data_object_finalize_post(*instance, *ctx, *out, *json_input)
{
    # This PEP calculates the checksum of newly created replicas if one does not already exist.

    # Get a JSON handle so we can work with the json_input.
    msiStrlen(*json_input, *size);
    msi_json_parse(*json_input, int(*size), *handle);

    # Get the logical path based on the data ID using Language Integrated GenQuery.
    msi_json_value(*handle, "/replicas/0/before/data_id", *data_id);
    *logical_path = "null";
    foreach (*result in select COLL_NAME, DATA_NAME where DATA_ID = '*data_id') {
        *logical_path = *result.COLL_NAME ++ '/' ++ *result.DATA_NAME;
        break;
    }

    # If, somehow, the data ID does not correspond to a data object, return an error.
    if ("null" == *logical_path) {
        *DOES_NOT_EXIST = -176000;
        failmsg(*DOES_NOT_EXIST, "Data object with ID [*data_id] does not exist.");
    }

    # We are interested in getting the checksum value for the replica. Initialize the value to "null" to indicate
    # whether we were able to find the newly created replica at all.
    *replica_checksum = "null";
    *replica_number = "null";

    # Loop over the replicas and find the one which was just created based on "before" replica status.
    # The "before" replica status should be '2' (intermediate) for a newly created replica because it did not exist
    # previously and so did not have an at-rest replica status before.
    # In order to traverse the "replicas" array in the json_input, we need to get the size.
    msi_json_size(*handle, "/replicas", *array_len);
    for (*i = 0; *i < *array_len; *i = *i + 1) {
        msi_json_value(*handle, "/replicas/*i/before/data_is_dirty", *status_before);
        # If you are not only concerned with new replicas, but any data transfers, this check is not necessary.
        if ('2' == *status_before) {
            msi_json_value(*handle, "/replicas/*i/after/data_repl_num", *replica_number);
            msi_json_value(*handle, "/replicas/*i/after/data_checksum", *replica_checksum);
            break;
        }
    }

    # Free the JSON handle because we don't need it anymore.
    msi_json_free(*handle);

    # If replica_number is "null", then no replica was found with replica status of intermediate in its "before"
    # object. This database operation is invoked both when locking the data object on open and when finalizing the data
    # object on close. In that case, the new replica would not have been created yet, so it will not be found in the
    # list of replicas above. For this example, we only want to calculate the checksum when the object was newly created
    # (i.e. its "before" replica status is intermediate) and is being closed. Objects opened for appending or
    # overwriting will not have a "before" replica status of intermediate.
    if ("null" != *replica_number && "" == *replica_checksum) {
        # Calculate the replica checksum and register it in the catalog. This policy can be replaced with whatever you
        # need to do after a new replica is created.
        msiDataObjChksum("*logical_path", "replNum=*replica_number", *checksum_value);
    }
}
```

#### Let's see it in action!

Before implementing this PEP, we might expect to see something like this when data is transferred to iRODS by a client user named `alice`:
```
$ echo "my cool data" | istream write /tempZone/home/alice/cooldata
$ ils -L /tempZone/home/alice/cooldata
  alice             0 demoResc           13 XXXX-XX-XX.XX:XX & cooldata
        generic    /var/lib/irods/Vault/home/alice/cooldata
```

With the policy configured, we can now see that a checksum is being registered in the catalog for the newly created replica:
```
$ echo "my cool data" | istream write /tempZone/home/alice/cooldata
$ ils -L /tempZone/home/alice/cooldata
  alice             0 demoResc           13 XXXX-XX-XX.XX:XX & cooldata
    sha2:TJqKyIY7GEqbGxvNKhsUHO9q8Y8YZPeX1l53dHASlSc=    generic    /var/lib/irods/Vault/home/alice/cooldata
```

### Step 2b: Implementing `fileModified`

In this example, we will implement a policy which ensures that every replica on a data object has a checksum after all other server policy has been invoked. The implementation uses the [iRODS Rule Language](../../plugins/irods_rule_language).

#### How to do it ...

We should implement the resource operation PEP `pep_resource_modified_post`. Referencing the [Dynamic Policy Enforcement Points](../../plugins/dynamic_policy_enforcement_points) page, one can see that the only input available for this resource plugin operation PEP is the plugin context.

`fileModified` is only invoked after the initial data transfer is complete. As such, the information in the plugin context `ctx` will be referring to the original replica which caused the `fileModified` operation to be invoked.

Here is the PEP implementation for the example policy:
```python
pep_resource_modified_post(*instance, *ctx, *output)
{
    # Due to how GenQuery works, we need to split the data object name and collection name apart in the logical path.
    *logical_path = *ctx.logical_path
    msiSplitPath(*logical_path, *collection_name, *data_object_name);

    # This query fetches the checksums for each individual replica of the data object.
    foreach (*result in select DATA_REPL_NUM, DATA_CHECKSUM where COLL_NAME = '*collection_name' and DATA_NAME = '*data_object_name') {
        *replica_checksum = *result.DATA_CHECKSUM;
        # If a replica is found to not have a checksum, calculate and register it. This particular example could be
        # achieved with the "ChksumAll" option for this microservice, but the example is meant to demonstrate that
        # we can take any kind of action on all of the replicas after a logical-level operation has completed.
        if (*replica_checksum == "") {
            *replica_number = *result.DATA_REPL_NUM;
            msiDataObjChksum("*logical_path", "replNum=*replica_number", *checksum_value);
        }
    }
}
```

#### Let's see it in action!

In this example, a user named `alice` will `iput` a data object into a replication hierarchy which looks like this:
```
$ ilsresc
repl:replication
├── ufs0:unixfilesystem
└── ufs1:unixfilesystem
```

Without the policy configured, we might expect to see something like this when the `iput` completes:
```
$ iput -R repl cooldata
$ ils -L cooldata
  alice             0 repl;ufs0           13 XXXX-XX-XX.XX:XX & cooldata
        generic    /var/lib/irods/irods/ufs0vault/home/alice/cooldata
  alice             1 repl;ufs1           13 XXXX-XX-XX.XX:XX & cooldata
        generic    /var/lib/irods/irods/ufs1vault/home/alice/cooldata
```

With the checksum in place, we can now see that a checksum is being registered in the catalog for every replica:
```
$ iput -R repl cooldata
$ ils -L cooldata
  alice             0 repl;ufs0           13 XXXX-XX-XX.XX:XX & cooldata
    sha2:TJqKyIY7GEqbGxvNKhsUHO9q8Y8YZPeX1l53dHASlSc=    generic    /var/lib/irods/irods/ufs0vault/home/alice/cooldata
  alice             1 repl;ufs1           13 XXXX-XX-XX.XX:XX & cooldata
    sha2:TJqKyIY7GEqbGxvNKhsUHO9q8Y8YZPeX1l53dHASlSc=    generic    /var/lib/irods/irods/ufs1vault/home/alice/cooldata
```

The implementation can be modified to apply only to specific resources, collections, or whatever your policy requires.

### A note about servers before 4.2.9

The 4.2.9 release of iRODS introduced dramatic changes to the way internal data transfers and data object finalization occur, and could behave differently from what is documented here. **Step 2b** should be available in servers with version 4.2.8 and older, and should behave similarly to what is documented here. A database operation similar to `data_object_finalize` which is no longer used called `mod_data_obj_meta` can also be leveraged to implement similar policy (although it uses a different, non-JSON interface).

## Retrieve information about opened replicas from `R_DATA_MAIN`

When implementing policy or a rule which deals with opened replicas, you may need more information about the opened replica from the `R_DATA_MAIN` table in the catalog such as size, host resource, or mtime.

This can be achieved by querying the iRODS Catalog using [Language-Integrated GenQuery](../../plugins/irods_rule_language/#language-integrated-general-query) or [GenQuery2 microservices](../../doxygen/msi__genquery2_8hpp.html). However, all the information in the catalog pertaining to an opened replica with a valid L1 file descriptor is already available in memory in the connected iRODS agent - all you have to do is ask.

Note: This recipe only pertains to system metadata for replica information found in `R_DATA_MAIN`. This does not give access to metadata AVUs annotated to the data object of the opened replica.

### How to do it ...

The key to accessing the in-memory information about the opened replica is in the [`msi_get_file_descriptor_info` microservice](../../doxygen/microservices_2src_2get__file__descriptor__info_8cpp.html). This microservice returns a string representing a JSON object containing a `DataObjInfo` with information about the opened replica, and the `DataObjInp` structure which was used to open the data object in the first place.

Here is an example of what this structure looks like:
```javascript
{
  "bytes_written": -1,
  "checksum": "",
  "checksum_flag": 0,
  "copies_needed": 0,
  "create_mode": 384,
  "data_object_info": {
    "backup_resource_name": "",
    "checksum": "",
    "collection_id": 10010,
    "condition_input": [
      {
        "key": "resc_hier",
        "value": "demoResc"
      },
      {
        "key": "selected_hierarchy",
        "value": "demoResc"
      }
    ],
    "data_access": "",
    "data_access_index": 0,
    "data_comments": "",
    "data_create": "01740005951",
    "data_expiry": "00000000000",
    "data_id": 10015,
    "data_map_id": 0,
    "data_mode": "384",
    "data_modify": "01740006513",
    "data_owner_name": "rods",
    "data_owner_zone": "tempZone",
    "data_size": 12,
    "data_type": "generic",
    "destination_resource_name": "",
    "file_path": "/var/lib/irods/Vault/home/rods/foo",
    "flags": 0,
    "in_pdmo": "",
    "is_replica_current": true,
    "next": null,
    "object_path": "/tempZone/home/rods/foo",
    "other_flags": 0,
    "registering_user_id": 0,
    "replica_number": 0,
    "replica_status": 1,
    "resource_hierarchy": "demoResc",
    "resource_id": 10013,
    "resource_name": "demoResc",
    "special_collection": null,
    "status_string": "",
    "sub_path": "",
    "version": "",
    "write_flag": 0
  },
  "data_object_input_replica_flag": 1,
  "data_object_input": {
    "condition_input": [
      {
        "key": "resc_hier",
        "value": "demoResc"
      },
      {
        "key": "selected_hierarchy",
        "value": "demoResc"
      }
    ],
    "data_size": -1,
    "in_pdmo": "",
    "in_use": true,
    "l3descInx": 3,
    "lock_file_descriptor": 0,
    "number_of_threads": 0,
    "object_path": "/tempZone/home/rods/foo",
    "offset": 0,
    "open_flags": 0,
    "open_type": 2,
    "operation_status": 0,
    "operation_type": 0,
    "other_data_object_info": null,
    "plugin_data": null,
    "purge_cache_flag": 0,
    "remote_l1_descriptor_index": 0,
    "remote_zone_host": null,
    "replica_status": 1,
    "replica_token": "",
    "replication_data_object_info": null,
    "source_l1_descriptor_index": 0,
    "special_collection": null
  },
  "stage_flag": 0
}
```

In order to access this information via the microservice, we need a handle to a JSON structure and a JSON pointer indicating which key's value we want. For example, if we wanted to know the creation time of the replica, we would use `"/data_object_info/data_create"`.

In this example, we will implement a dynamic PEP for the DataObjRead API, which uses an `OpenedDataObjInp` structure as part of its signature. In this PEP, we do not know the logical path of the data object which is being read and the `OpenedDataObjInp` structure does not have this information. However, it does give us access to an L1 file descriptor. Using this, we can access information about the opened replica which already resides in the iRODS agent's memory. Here is the implementation:
```python
pep_api_data_obj_read_pre(*instance_name, *comm, *opened_data_obj_inp, *data_obj_read_out_bbuf)
{
    # Extract the L1 descriptor from the OpenedDataObjInp.
    *fd = *opened_data_obj_inp.l1descInx;

    # Get the file descriptor information using the L1 descriptor as a string representing a JSON object.
    msi_get_file_descriptor_info(int(*fd), *json_output_str);

    # Specify a JSON pointer to the desired information.
    *object_path_json_ptr = "/data_object_info/object_path"

    # Parse the JSON string to get a handle to a proper JSON object.
    msiStrlen(*json_output_str, *json_output_strlen);
    msi_json_parse(*json_output_str, int(*json_output_strlen), *json_handle);

    # Use the JSON pointer in the JSON handle to obtain the value therein.
    msi_json_value(*json_handle, *object_path_json_ptr, *object_path);

    # Don't forget to free the JSON handle before exiting. Failing to do so may result in memory leaks.
    msi_json_free(*json_handle);

    # ... Use the value which was retrieved above ...
    writeLine("serverLog", "[*object_path] is about to be read!");
}
```

### Let's see it in action!

The above dynamic PEP is not terribly interesting as it just prints a message to the server log. Here is one way to trigger this PEP:
```bash
$ istream read /tempZone/home/rods/foo
hello everyone
```

In the server log should be a message like this:
```bash
$ tail -n1 /var/log/irods/irods.log | jq '.log_message'
"writeLine: inString = [/tempZone/home/rods/foo] is about to be read!\n"
```
