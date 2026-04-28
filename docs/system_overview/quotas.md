# Quota Enforcement

iRODS offers two quota enforcement systems, [Physical Quotas](#physical-quotas) and [Logical Quotas](#logical-quotas).

## Physical Quotas

This system is for enforcing quotas at the physical layer (i.e. storage resources). Physical quotas _(sometimes referred to as resource quotas)_ are always associated with a specific group and one or more storage resources.

### How to enable

By default, physical quotas are disabled. To enable, open `/etc/irods/core.re` and change the argument passed to `msiSetRescQuotaPolicy()` from `"off"` to `"on"`. The line you modified should look very similar to the following.

```py
acRescQuotaPolicy { msiSetRescQuotaPolicy("on"); }
```

Reload the server's configuration for the change to take effect. This is currently a per-server setting. If your zone consists of multiple servers, make sure to apply the change to all of them.

### Applying a Quota

!!! Note
    _User_ quotas are not supported by iRODS. However, they can be simulated through the use of _group_ quotas. See [Simulating User Quotas](../../administrators/policy_cookbook/#simulating-user-quotas) in the [Policy Cookbook](../../administrators/policy_cookbook) for more information.

To apply a quota, all that's needed is a group.

The following example sets a _group_ quota of 100000 bytes across all storage resources for the group named "quota_group".

```sh
iadmin sgq quota_group total 100000
```

The `total` keyword instructs iRODS to apply a global quota. Upon successfully setting the quota, all data associated with members of the "quota_group" will be counted toward the quota.

To apply a quota to a specific storage resource, replace the `total` keyword with the name of the storage resource.

See [iadmin sgq](../../icommands/administrator/#sgq) for more information.

### Updating Quota Usage Totals

Quota usage tracking is passive. iRODS does not auto-update quota usage totals as data changes. Administrators must run `iadmin cu` or invoke the necessary API to instruct iRODS to recalculate usage totals.

The most common pattern for handling recalculation of quota usage totals is via a [cron](https://en.wikipedia.org/wiki/Cron) job.

See [iadmin cu](../../icommands/administrator/#cu) for more information.

### Viewing Quota Information

Administrators can view quota information by running `iadmin lq`. `iquota` can be used to view quota information as well.

See [iadmin lq](../../icommands/administrator/#lq) and [iquota](../../icommands/user/#iquota) for more information.

## Logical Quotas

This system is for enforcing quotas at the logical layer (i.e. collections and data objects). This can be achieved through the use of the [Logical Quotas rule engine plugin](https://github.com/irods/irods_rule_engine_plugin_logical_quotas) or, since 5.1.0, the built-in logical quotas system.

For more information on the rule engine plugin, see the [README](https://github.com/irods/irods_rule_engine_plugin_logical_quotas) in the GitHub repository.

Further details about the built-in system can be found below.

### Comparison Versus Plugin

The built-in system offers the following advantages over the plugin:

- Passive system with variable recalculation rates
- No dependence on metadata
- No dependence on rules
- No dependence on PEPs

However, because the built-in system is passive, recalculation frequency affects how quickly crossing the quota threshold is enforced.

### How to Enable Logical Quotas Enforcement

By default, logical quotas are unenforced. To enable enforcement, run the following:

```sh
iadmin set_grid_configuration logical_quotas enabled 1
```

Changes should take effect immediately. This is a zone-wide setting, and catalog consumers for a zone will consult the appropriate catalog provider to fetch enforcement status.

### Applying/Removing Logical Quotas

To apply a logical quota to a collection, use the `set_logical_quota` subcommand of `iadmin`.

The following example sets a logical quota of 100000 bytes for the home collection of user `alice#tempZone`.

```sh
iadmin set_logical_quota /tempZone/home/alice bytes 100000
```

Object limits are set in a similar manner. The following example sets a logical quota of 50 data objects on alice's home collection.

```sh
iadmin set_logical_quota /tempZone/home/alice objects 50
```

An administrator may wish to set both byte and object limits in a single command. The following example sets a logical quota of 300000 bytes and 1000 data objects for the `tempZone` zone collection.

```sh
iadmin set_logical_quota /tempZone 300000 1000
```

Note that it is not allowed to set logical quotas on `/`, nor is it allowed to do so on a remote zone, e.g. `/remoteZone`. Admins may only apply logical quotas policy to zones under their jurisdiction.

To remove a logical quota, set the quota for the collection to a byte and object limit of 0.

The following example removes any logical quotas for the `tempZone` zone collection.

```sh
iadmin set_logical_quota /tempZone 0 0
```

!!! Note 
    Logical quotas will apply to the entire collection tree rooted at the named collection. For example, a quota applied to `/tempZone/home` would apply a single consolidated limit to `/tempZone/home/alice`, `/tempZone/home/rods`, `/tempZone/home/bob`, and so on.

See [iadmin set\_logical\_quota](../../icommands/administrator/#set_logical_quota) for more information.

### Updating Quota Usage Totals

Logical quota usage tracking is passive. iRODS will not auto-update quota usage totals as data changes. Administrators must run `iadmin calculate_logical_usage` or invoke a microservice to instruct iRODS to recalculate logical usage totals.

A common pattern for handling recalculation of quota usage totals is via a [cron](https://en.wikipedia.org/wiki/Cron) job or via the [Rule Engine's Delay Execution](../../plugins/pluggable_rule_engine/#delay-execution).

See [iadmin calculate\_logical\_usage](../../icommands/administrator/#calculate_logical_usage) for more information.

### Viewing Quota Information

Administrators can view quota information by running `iadmin list_logical_quotas`. 

By default, `iadmin list_logical_quotas` will list all logical quotas with no additional arguments.

Optionally, an administrator may issue an additional argument that specifies a collection. Any quotas applied to that collection or its ancestors will be returned.

The following example lists quotas for `/tempZone`, `/tempZone/home`, and `/tempZone/home/alice`, if any such quota exists.

```sh
iadmin list_logical_quotas /tempZone/home/alice
```

See [iadmin list\_logical\_quotas](../../icommands/administrator/#list_logical_quotas) for more information.

## Related Links

- [iadmin sgq](../../icommands/administrator/#sgq)
- [iadmin cu](../../icommands/administrator/#cu)
- [iadmin lq](../../icommands/administrator/#lq)
- [iquota](../../icommands/user/#iquota)
- [Logical Quotas rule engine plugin](https://github.com/irods/irods_rule_engine_plugin_logical_quotas)
- [iadmin set\_logical\_quota](../../icommands/administrator/#set_logical_quota)
- [iadmin calculate\_logical\_usage](../../icommands/administrator/#calculate_logical_usage)
- [iadmin list\_logical\_quotas](../../icommands/administrator/#list_logical_quotas)
- [Policy Cookbook: Simulating User Quotas](../../administrators/policy_cookbook/#simulating-user-quotas)
