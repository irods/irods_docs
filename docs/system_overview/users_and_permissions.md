#

Users and permissions in iRODS are inspired by, but slightly different from, traditional Unix filesystem permissions.  Access to Data Objects and Collections can be modified using the `ichmod` iCommand.

## Groups

Additionally, permissions can be managed via user groups in iRODS.  A user can belong to more than one group at a time.  The owner of a Data Object has full control of the file and can grant and remove access to other users and groups.  The owner of a Data Object can also give ownership rights to other users, who in turn can grant or revoke access to users.

## Inheritance

Inheritance is a collection-specific setting that determines the permission settings for new Data Objects and sub-Collections.  Data Objects created within Collections with Inheritance set to Disabled do not inherit the parent Collection's permissions.  By default, iRODS has Inheritance set to Disabled.  More can be read from the help provided by `ichmod h`.

Inheritance is especially useful when working with shared projects such as a public Collection to which all users should have read access. With Inheritance set to Enabled, any sub-Collections created under the public Collection will inherit the properties of the public Collection.  Therefore, a user with read access to the public Collection will also have read access to all Data Objects and Collections created in the public Collection.

## StrictACL

The iRODS setting 'StrictACL' is configured on by default in iRODS. This setting can be found in the `/etc/irods/core.re` file under acAclPolicy{}.

The default setting is:

~~~
acAclPolicy {msiAclPolicy("STRICT");}
~~~

To set no policy, change the setting to:

~~~
acAclPolicy {}
~~~

or more explicitly:

~~~
acAclPolicy {msiAclPolicy("REGULAR");}
~~~


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

