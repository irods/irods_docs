#

Users and permissions in iRODS are inspired by, but slightly different from, traditional Unix filesystem permissions.  Access to Data Objects and Collections can be modified using the `ichmod` iCommand.

## Groups

Additionally, permissions can be managed via user groups in iRODS.  A user can belong to more than one group at a time.  The owner of a Data Object has full control of the file and can grant and remove access to other users and groups.  The owner of a Data Object can also give ownership rights to other users, who in turn can grant or revoke access to users.

## Inheritance

Inheritance is a collection-specific setting that determines the permission settings for new Data Objects and sub-Collections.  Data Objects created within Collections with Inheritance set to Disabled do not inherit the parent Collection's permissions.  By default, iRODS has Inheritance set to Disabled.  More can be read from the help provided by `ichmod h`.

Inheritance is especially useful when working with shared projects such as a public Collection to which all users should have read access. With Inheritance set to Enabled, any sub-Collections created under the public Collection will inherit the properties of the public Collection.  Therefore, a user with read access to the public Collection will also have read access to all Data Objects and Collections created in the public Collection.

## Tickets (Guest Access)

Users are able to create tickets and associate them (one to one) with a Data Object or Collection. These are either system-generated 15-character pseudo-random strings, composed of upper and lower case characters 'A-Z' and '0-9'; or optionally specified by the user creating the ticket.

Only users with 'own' permission on objects are allowed to create tickets for those objects (and modify or delete them). When the ticket is used, this will be rechecked and access denied if the original user no longer has 'own' permission.

Each ticket is associated with one Data Object or Collection, although multiple tickets can be defined that refer to the same Data Object or Collection.

Users are able to access Data Objects or Collections using tickets even if they do not have regular access permissions (the regular access is set via 'ichmod' or equivalent, giving users or groups read, write, or own permission). In the case of tickets on collections, all data-objects under that collection (including those in sub-collections) are accessible (readable) via that ticket.

Users can either be normally logged into iRODS (as a regular, specific user) or not (connected as user 'anonymous', with no password).

Tickets can be set to last indefinitely or to expire at a certain time.

Tickets can be set to be usable any number of times, or to only be valid for a specified number of uses.

Tickets can be set to allow a certain amount of data to be written (in bytes).

Tickets can be associated with specific users or groups, in which case access will be granted only if the valid ticket is presented from those users or users in those groups.

Tickets can be set to be valid only from specific computers (DNS host names), in which case ticket-based access will be denied when iRODS clients are connecting from other hosts.

The ticket policy is controlled by 'acTicketPolicy{}' in `/etc/irods/core.re`.  With this policy, the administrator can limit which users may use tickets to access the iRODS Zone.  The default empty policy allows access to all users with valid tickets (including 'anonymous').

## iRODS Permission Levels

The iRODS permission model has ten levels, listed here in ascending order each with its corresponding value in the catalog:

| permission name | catalog value |
| --------------- | ------------- |
| `null` | 1000 |
| `execute` | 1010 |
| `read_metadata` | 1040 |
| `read_object` | 1050 |
| `create_metadata` | 1070 |
| `modify_metadata` | 1080 |
| `delete_metadata` | 1090 |
| `create_object` | 1110 |
| `modify_object` | 1120 |
| `delete_object` | 1130 |
| `own` | 1200 |

The iRODS permissions model is linear, which means that if a user has a certain permission level, the user also has all the permissions under that permission level. For example, any user with `modify_object` permissions on a data object also has `read_object` permissions on that data object.

Historically, 4 of these permission levels have been used throughout iRODS with the others remaining largely unused:

 - `null`
 - `read_object` (i.e. `read`)
 - `modify_object` (i.e. `write`)
 - `own`

### `null`

`null` means that a user has no permissions on the data object or collection. The user cannot change permissions for, read, modify, delete, or even query for a data object or collection or its metadata on which the user has no permissions.

Administrators can grant themselves permissions even on data objects and collections for which they have `null` permissions.

### `read_object` / `read`

`read_object` means that a user has permission to view the catalog entry, contents, and annotated AVU metadata on the data object or collection. The user cannot change permissions for, modify, or delete a data object or collection or its metadata on which the user has `read_object` permissions.

If a user has `read_object` permissions on a collection, the user will only be able to see that collection. The user will not be able to see any of the data objects or collections inside that collection without first granting `read_object` or higher permissions to the user on those individual data objects and collections.

In order to read a data object, the user must have `read_object` permissions on the data object as well as `read_object` permissions on the parent collection where the data object resides.

### `modify_object` / `write`

`modify_object` means that a user has permission to modify the contents of a data object *in addition to* having `read_object` permissions on the data object or collection. The user cannot change permissions for or delete a data object or collection on which the user has `modify_object` permissions.

If a user has `modify_object` permissions on a collection, that means that the user is able to create new data objects and collections inside that collection. In order to modify or delete objects and collections in the collection for which the user has `modify_object` permissions, the user must first be granted the appropriate permissions on those individual data objects and collections.

In order to modify a data object, the user must have `modify_object` permissions on the data object as well as `read_object` permissions on the parent collection where the data object resides.

### `own`

`own` means that the user has permission to do anything with the given data object or collection. *In addition to* the abilities granted by `read_object` and `modify_object`, users can change permissions for and delete data objects or collections for which they have `own` permissions.

If a user has `own` permissions on a collection, the user will only be able to delete the collection if the user has sufficient permissions to delete each individual data object and collection within that collection.

If a user has `own` permissions on a data object or collection, the user can grant permissions (including `own` permissions) on that data object or collection to other users. The user can also modify its own permissions on the data object or collection. Note that if the user modifies its `own` permissions on a data object or collection to a permission level lower than `own`, that user will no longer be able to modify permissions on that data object or collection. If the user sets its own permissions on a data object or collection from `own` to some other level, and that user was the only user with `own` permissions on the data object, then only an administrator will be able to modify permissions on that data object or collection.
