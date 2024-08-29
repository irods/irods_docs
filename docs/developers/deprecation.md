#

## What is deprecation?

Whenever a feature of iRODS needs to be removed for whatever reason, we follow a process which first deprecates the feature and then removes it. Here are some possible reasons for deprecating a feature...

 - It has some issue which can only be fixed by replacement.
 - It has been or is being replaced by a better alternative.
 - Its purpose is unknown or no longer supported.

In general, users and administrators should expect the following process when a server feature is being deprecated:

 1. A feature can be declared as deprecated in any minor version.
 2. The feature will continue to be supported for all major versions in which it is deprecated (and previous major versions in which the feature exists).
 3. The feature can be removed in the next major version after deprecation, but the Consortium reserves the right to not remove it, leaving it in a deprecated state in the next major version.

These also apply to releases of the iCommands package because they are strictly tied to releases of the server.

## How do I deprecate a feature?

We will now describe the steps which should be taken to deprecate various types of features. In general, we seek to avoid changing or removing runtime functionality.

The following things need to be done whenever a feature is being declared as deprecated:

 1. Update documentation to include alternative, supported way(s) of accomplishing what is now deprecated. If no alternative is available, include a note indicating that use of the deprecated API should be avoided. Updating the documentation includes adding a `\deprecated` tag with the aforementioned notes to the Doxygen for any public declarations associated with the feature.
 2. Add a "deprecated" attribute specifier (`[[deprecated]]` for C++ or `__attribute__(deprecated)` for C) to the C/C++ public declarations specific to this API and include a message that is similar if not identical to the message used in (1). This includes any functions, structs, classes, and type aliases. If a struct, class, or type alias is being used by other APIs which are not being deprecated and the usage is not related to the feature which is being deprecated, do not deprecate these. For example, `DataObjInp` could be used by an API which is being deprecated, but `DataObjInp` is not specific to that API. Therefore, `DataObjInp` would not be a candidate for deprecation.
 3. Add comments to any macros directly related to the API indicating that the feature has been deprecated. This will not have any effect on compilation or usage, but will give the developer pause as they consider whether to use it in an application.
 4. If the feature is used by a client such as the iCommands and has user-facing help text, a note about the feature being deprecated should be included in the help text anywhere the feature is mentioned. If the feature being deprecated *is* an iCommand, a note about its deprecation can be included near the top of the help text.

The following rules should also be followed when deprecating an API:

 - The API should NOT add a deprecation message to the RcComm or RsComm's rError object.
 - The API should NOT emit a deprecation message to the log.

## How do I remove a feature?

Once a feature has been deprecated, it can be removed in the next major release. Please use caution when removing code, as clients and plugins may be depending on it. Be sure to consider this before releasing with removed features.

### Removing APIs

iRODS has tried to remain as backward compatible as possible with each release, but this is exceedingly difficult with the dynamic PEP system and the way APIs are implemented at the time of writing. Given that APIs are ultimately defined by a number, it is difficult to remove an API entirely. For instance, a zone with an older version of iRODS installed could be federated with a newer zone and attempt to invoke an API on the remote zone with the old API number. If that API number is re-used by a new API, this could lead to bad results.
