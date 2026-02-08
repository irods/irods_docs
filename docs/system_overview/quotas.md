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

This system is for enforcing quotas at the logical layer (i.e. collections and data objects). This is achieved through the use of the [Logical Quotas rule engine plugin](https://github.com/irods/irods_rule_engine_plugin_logical_quotas).

See the [README](https://github.com/irods/irods_rule_engine_plugin_logical_quotas) in the GitHub repository for more information.

## Related Links

- [iadmin sgq](../../icommands/administrator/#sgq)
- [iadmin cu](../../icommands/administrator/#cu)
- [iadmin lq](../../icommands/administrator/#lq)
- [iquota](../../icommands/user/#iquota)
- [Logical Quotas rule engine plugin](https://github.com/irods/irods_rule_engine_plugin_logical_quotas)
- [Policy Cookbook: Simulating User Quotas](../../administrators/policy_cookbook/#simulating-user-quotas)
