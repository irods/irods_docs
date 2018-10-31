## 4.2.4

Release Date: 2018-09-03

### Bug Fixes

 - Fixes for collections named . [#2010] [#3543]

 - Clean up stale hierarchy information in catalog [#3853] [#3981]

 - Fix for rebalancing files created with ibun -x [#3855]

 - Fix for delayed rule behavior [#3906]

 - Fix for imkdir and long paths with spaces [#3913]

 - Fix for parallel delayed rule execution [#3941]

 - Marked as workaround and question answered [#3961] [#4020]

 - Fix for icp [#3962]

 - Fix for internal path behavior [#3964] [#3970]

 - Update documentation about trash policy [#3969]

 - Fix for ireg --repl [#3980]

 - Fix for irepl -Ua [#3982]

 - Marked as resolved/invalid or duplicate [#3984] [#4024]

 - Update sha256sum usage documentation [#3985]

 - Document temporaryStorage with PEPs [#3987]

 - Fixes for irsync -r and iput with symbolic links [#3988] [#4013] [#4016]

 - Fixes for irsync/icp/iput with multiple source directories [#3997] [#4006]

 - Fix for irule and remote calls to support Python Rule Engine Plugin [#4007]

 - Fix for irsync/icp/iput into root collection (/) [#4030]

 - Provide templated univMSSInterface.sh by default [#4045]

 - Fix for irsync into target collection [#4048]

 - Fix for direct registration via keywords [#4066]

### Deprecated

 - Marking iCommand iexecmd as deprecated - to be removed in 4.3.0.  Use irule and a rulefile calling msiExecCmd instead.

 [Full GitHub Listing](https://github.com/irods/irods/issues?q=milestone%3A4.2.4)

 [All closed issues at the time of this release assigned to 4.1.12 are also included](https://github.com/irods/irods/issues?q=milestone%3A4.1.12%20closed%3A2018-06-01..2018-09-03).

## 4.2.3

Release Date: 2018-05-31

### Features

 - Better system metadata for registration of a new replica [#3829]

 - Add introspection option to irods_control.py [#3834]

 - Add generic auth object and OpenID support [#3843] [#3945]

 - Add registration to non-leaf resources [#3844]

 - Speedup for large rulesets loading during startup [#3932]

### Bug Fixes

 - Marked as resolved/invalid or duplicate [#2797] [#3237] [#3318] [#3504] [#3664] [#3825] [#3846] [#3847]

 - Marked as workaround and question answered [#2972] [#3028]

 - Fix for dangling symlinks [#3072]

 - Add test for iscan honoring resource hierarchies [#3081]

 - Fix for ichksum truncating printed filenames [#3085]

 - Better documentation [#3112] [#3747]

 - Allow usernames with "_ts" [#3170]

 - Update libarchive to latest stable release [#3201] [#3291]

 - Fix for msiCheckAccess honoring ownership of collection via group [#3309]

 - Disallow unsupported option combinations [#3346] [#3659] [#3661] [#3926]

 - Fix for ichksum when dynpep involved [#3485]

 - Fixes for stty and ipasswd inconsistencies [#3580]

 - Fixes for imeta regression [#3594] [#3667] [#3787] [#3788] [#3816] [#3866]

 - Fix for iCommand segfault with bad SSL cert [#3609]

 - Fix for trim to use unlink operation [#3615]

 - Fix for memory leak [#3643]

 - Fix for ireg to handle trailing slashes [#3658]

 - Fixes for scanbuild [#3678] [#3679] [#3701] [#3712] [#3769]

 - Fix intermittent test failures [#3689] [#3706]

 - Better logging [#3695] [#3882]

 - Fixes for DATA_ID vs DATA_RESC_HIER since 4.2 [#3705] [#3714]

 - Fix for possible int overflow [#3707]

 - Fix for remote rule execution [#3722]

 - Fix for msiServerMonPerf location since 4.2 [#3736]

 - Remove unused function prototype [#3790]

 - Fix for ireg -CK without permission [#3795]

 - Fix for imeta qu only querying the first condition [#3808]

 - Fix for silent failure of ireg --repl [#3828]

 - Fix for building with pthread [#3833]

 - Fix for modifying dict while iterating through it [#3842]

 - Fix for delay() in rule engine plugin framework [#3849]

 - Fix silent failure of iadmin rmchildfromresc [#3859]

 - Fix for SQL logging to rodsLog [#3865]

 - Fix for dynpeps called around msiExecCmd() [#3867]

 - Fix for control plane [#3878] [#3911]

 - Fix segfault in serialization of rule engine parameters [#3879]

 - Fix for irepl honoring resource name [#3885]

 - Fix for missing linked_list header in development package [#3937]

 - Fix for test using RSA key size for PAM [#3939]

 - Fix for rodsMonPerfLog [#3946]

### Deprecated

 - [#3451] Use of 'irm -n' marked as deprecated - to be removed in 4.3.0.  Use 'itrim' instead.

 - [#3778] Round robin resource marked as deprecated - to be removed in 4.3.0.  Update a round robin resource to a random resource with the following single-row update to the catalog:

    `iadmin modresc rrResc type random`

 [Full GitHub Listing](https://github.com/irods/irods/issues?q=milestone%3A4.2.3)

 [All closed issues at the time of this release assigned to 4.1.12 are also included](https://github.com/irods/irods/issues?q=milestone%3A4.1.12%20closed%3A%3C%3D2018-05-31).

## 4.2.2

Release Date: 2017-11-08

### Features

 - Enable more flexible plugin factory functions [#3703]

 - Generate relocatable RPMs [#3618]

### Bug Fixes

 - Fixes for memory management [#3178] [#3184] [#3587] [#3605] [#3640] [#3641] [#3644] [#3649] [#3656]

 - Questions about REPF, byte range support, and tiny files [#3431] [#3471] [#3521]

 - Better documentation [#3442] [#3597]

 - Fix for REPF writeLine support using expected location [#3477] [#3638]

 - Fix for too-often expensive replication [#3525]

 - Fix for CMake linker flags [#3552]

 - Fix for logs being written to older logfile [#3563]

 - Fix for rebalance batching behavior [#3570]

 - Fix for type checker in iRODS Rule Language [#3575] [#3632]

 - Fixes for test harness [#3577] [#3579]

 - Fix for upgrade process [#3578]

 - Fix for exception handling [#3596]

 - Fix for iadmin modrescdatapaths [#3598]

 - Fixes for imeta output [#3600] [#3606]

 - Fix for logging when environment file is missing [#3608]

 - Fix for REPF start and stop operations [#3619]

 - Fix for detecting changes to rulefiles [#3651]

 - Fix for ireg and recursive checksums [#3662]

 - Fix for irsync with fully qualified paths [#3663]

 - Fix for logging PAM activity too often [#3673]

 - Fix for unattended setup via json file [#3704]

 [Full GitHub Listing](https://github.com/irods/irods/issues?q=milestone%3A4.2.2)

 [All issues assigned to 4.1.11 are also included](https://github.com/irods/irods/issues?q=milestone%3A4.1.11).

## 4.2.1

Release Date: 2017-06-08

### Features

 - New iCommand, irmdir [#3117]

 - Add packaging support for Ubuntu16 [#3190] [#3441]

 - Improved logging [#3502] [#3535]

 - Improved speed of default configuration [#3526] [#3549]

 - Support for Python rule engine plugin [#3555]

### Bug Fixes

 - Fix for tickets [#3299]

 - Fix for ilsresc [#3345]

 - Fix for iRODS rule language parser [#3361]

 - Fixes for the rule engine framework [#3413] [#3511] [#3544]

 - Fixes for the packaging system [#3414] [#3457]

 - General support [#3416] [#3488]

 - Fixes for izonereport [#3421] [#3422]

 - Fixes for installation and upgrade [#3472] [#3538]

 - Fix for json parser [#3484]

 - Fix for quotas [#3508]

 - Fix for documentation [#3527]

 - Fixes for tests [#3534] [#3539] [#3545]

 - Fix for memory management [#3546]

 - Fix for physically moving a replica [#3558] [#3559]

 - Fix for long rulebase names [#3560]

 - Fix for bundling more than 256 data objects [#3571]

!!! Note
    [Manual specific queries may be added to the catalog](plugins/composable_resources.md#replication) to provide insight into large unbalanced replication hierarchies until the inconsistent database behavior is fixed and paging is restored ([#3570]).

 [Full GitHub Listing](https://github.com/irods/irods/issues?q=milestone%3A4.2.1)

 [All closed issues at the time of this release assigned to 4.1.11 are also included](https://github.com/irods/irods/issues?utf8=%E2%9C%93&q=milestone%3A4.1.11%20closed%3A%3C2017-06-08).  The most notable of these is [#3452](https://github.com/irods/irods/issues/3452), the subject of [CVE-2017-8799](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-8799).

## 4.2.0

Release Date: 2016-11-14

### Notable Features

  - [Pluggable Rule Engine](plugins/pluggable_rule_engine.md) - Seventh plugin interface now supports writing rule engines for any language. The iRODS Rule Language has been moved to a plugin, alongside a default policy C++ rule engine.

  - First Class API Plugins - Enabling dynamic policy enforcement points (PEPs) and full parameter serialization for every plugin operation

  - Refactored build system - CMake, Clang, APT/YUM repositories

    - CMake - Now a standard CMake project, much more developer friendly

    - Clang - All supported platforms now building the C++14 codebase

    - Packages separated - Cleaner dependencies, dev and runtime ready for developers

    - APT/YUM Repositories - Packages now hosted at RENCI, making installations and upgrades much easier

  - All control scripts in Python - Reusable module, reduced codepaths

  - New [process model](system_overview/process_model.md) - Two long running processes to amortize dynamic linking startup cost

  - Configuration schemas now included - Default setups will no longer need a public network connection for validation

  - Run-In-Place now a first class citizen - Now called [Non-Package Install](getting_started/installation.md#non-package-install-run-in-place)

### Notes

  - Externalization of code into separate repositories

    - iCommands client

    - Fuse client

    - Microservice objects (MSOs)

  - Consolidation of database plugin connection code to use unixODBC for PostgreSQL, MySQL, and Oracle

  - idbug removed

  - iphybun, ixmsg, irodsXmsgServer marked as deprecated

  - Resource hierarchies refactored to use IDs - Upgrades will experience a one-time full table scan whereby all data objects are updated.  A 10M data object lab test installation took 13 minutes to update.  100M data objects are estimated to take 2-3 hours to update.

  - [Distributing iCommands](system_overview/distributing_icommands.md) to users who do not have root is not yet supported for 4.2. It will be included again in a later release.

  - Quieter rodsLog during normal operations

### Other Issues

 - [Full GitHub Listing](https://github.com/irods/irods/issues?q=milestone%3A4.2.0)

## 4.1.12

Release Date 2018-11-01

### Enhancements

 - Add ichksum admin mode [#3265]

 - Add retry capability to replication resource [#3436] [#3746]

 - Add visibility for active rebalance operations [#3683]

 - Add enhanced_logging=1 option to server_config.json (4.1-only) [#3927]

### Bug Fixes

 - Fix iscan exit code [#3256]

 - Marked as resolved/invalid [#3317] [#3719] [#3773] [#3789] [#3832] [#4106] [#4143]

 - Fix iscan for data in resource hierarchies [#3418] [#3419]

 - Fix ifsck for data in resource hierarchies [#3503] [#4107]

 - Fix rebalance operation to avoid data arriving after invocation [#3665]

 - Fix iscan to report missing zero-length files [#3681]

 - Fix MySQL case errors in group queries [#3717]

 - Marked as wontfix [#3759]

 - Fix uninitialized variables in datetimef() rule [#3767]

 - Documentation for decommissioning a resource [#3821]

 - Add testing for bad/corrupt file systems [#3854]

 - Fix database statement handling [#3862] [#4105]

 - Fix data placement logic with replication resources [#3904] [#3909]

 - Fix behavior in presence of root directory (/) used a vault path [#3928]

 - Fix icommands to report to ips correctly [#3991]

 - Fix iscan to page correctly when missing files detected [#4029]

 - Fix to only trigger replication when data changes [#4085] [#4099] [#4110]

 - Fix zone detection for federated clients [#4100]


!!! Note
    This release will be the last in the 4.1 series.  The 4-1-stable branch is now EOL.

 [Full GitHub Listing](https://github.com/irods/irods/issues?q=milestone%3A4.1.12)

## 4.1.11

Release Date 2017-10-18

### Feature

 - New recursive rebalance context string for replication resource [#3672]

### Bug Fixes

 - Fix memory leaks and corruption [#2934] [#3595] [#3621] [#3627] [#3642] [#3657]

 - Improve documentation [#3008] [#3409] [#3432] [#3448] [#3491] [#3495] [#3514] [#3516] [#3542] [#3550] [#3556]

 - Fixes for iadmin regarding user authentication [#3104] [#3620]

 - Marked as resolved/invalid/duplicate [#3222] [#3285] [#3319] [#3341] [#3374] [#3468] [#3496] [#3586] [#3588] [#3628]

 - Fix for genQuery processing multiples of 256 rows [#3262] [#3405] [#3465] [#3489]

 - Improved/Fixed logging [#3411] [#3450] [#3498] [#3593] [#3626]

 - Fix for duplicate identical metadata [#3434]

 - Fix for restricted characters in resource child context string [#3449]

 - Fix for igetwild CVE-2017-8799 [#3452]

 - Fixes for rebalance operations [#3463] [#3476] [#3486] [#3524] [#3585] [#3665] [#3674]

 - Fix for specific queries across federation [#3466]

 - Fixes for ifsck [#3492] [#3501] [#3512]

 - Fix for irm across federation [#3493] [#3566]

 - Fixes for ichksum [#3499] [#3536] [#3537]

 - Fixes for quotas [#3507] [#3509]

 - Fix for long paths [#3515]

 - Fix for ireg [#3517]

 - Fix for hostname resolution [#3518]

 - Fix for ils and multiple arguments [#3520] [#3562]

 - Fix for PAM passwords [#3528]

 - Fixes for itrim output [#3531] [#3554] [#3589] [#3590] [#3591] [#3633] [#3635] [#3639] [#3669] [#3670]

 - Fixes for unencrypted network traffic [#3551] [#3572] (breaking change, see note below)

 - Fix for tickets [#3553]

 - Marked as wontfix [#3565] [#3584]

 - Addressed in different repository [#3567] [#3613]

 - Fix for inaccessible local files [#3583]

 - Build hook for CI [#3601]

 - Fix iRODS Rule Language parser [#3629] [#3630] [#3631]

 - Fix iRODS Rule Language error code [#3636] [#3637]

 - Fix for postinstall.sh script, chown will now de-reference symlinks [#3677]

 - Fix for checking negotiation results [#3684]

!!! Note
    Breaking Change - Due to the fix for [#3551], iRODS deployments using SSL will need to update clients and servers to 4.1.11 at the same time.

 [Full GitHub Listing](https://github.com/irods/irods/issues?q=milestone%3A4.1.11)

## 4.1.10

Release Date: 2016-11-04

### Feature

 - New microservice, static PEPs to update unixfilesystem resource free_space [#3307] [#3312]

!!! Note
    Upgrading to 4.1.10 will not automatically add the two new static PEPs
    to `core.re`.  To avoid spurious DEBUG messages, add the following two
    empty definitions to core.re:

    - acPostProcForParallelTransferReceived(\*leaf_resource) {}
    - acPostProcForDataCopyReceived(\*leaf_resource) {}

!!! Note
    This updated feature (along with [#3306]) changes the optional
    unixfilesystem context string keyword from 'high_water_mark' to its
    semantic complement 'minimum_free_space_for_create_in_bytes'.  Using
    the deprecated 'high_water_mark' or 'required_free_inodes_for_create'
    will write a LOG_NOTICE to the server log.

### Bug Fixes

 - Fix for microservice parameter limitation [#3092] [#3095]

 - Fixes for unixfilesystem and free_space check [#3247] [#3305] [#3306] [#3311] [#3340]

 - Fix for reading past end of buffer [#3255]

 - Better debugging [#3260] [#3308] [#3313] [#3348] [#3351]

 - Fixes for izonereport [#3294] [#3303]

 - Fix for irods-grid [#3301]

 - Fix for list() microservice in rule engine [#3304]

 - Fix for dynamic PEP documentation [#3314]

 - Fix for random resource hierarchy logic [#3315]

 - Fix for ilocate whitespace in results [#3332]

 - Fix for delay rule in dynamic PEPs [#3342]

 [Full GitHub Listing](https://github.com/irods/irods/issues?q=milestone%3A4.1.10)

## 4.1.9

Release Date: 2016-07-28

### Features

 - Support for libs3 multipart, V4 auth, and non-Amazon datestamps [#3168] [#3174] [#3233]

### Bug Fixes

 - Fix for ACL listings across federation [#2427]

 - Fix for default resource resolution [#2713] [#3212] [#3220] [#3224]

 - Fix for ilsresc [#3054]

 - Fix for high_water_mark threshold handling [#3068] [#3173]

 - Fix for init.d to use service account [#3076]

 - Fix for a unixfilesystem plugin error code [#3080]

 - Fix for iget to stdout [#3097]

 - Fix for iput when both force and metadata flags set [#3114]

 - Fix for iget when both resource and numThreads flags set [#3140]

 - Fix for irodsReServer memory leak [#3146] [#3167] [#3171]

 - Fix to rebalance operation when encountering single bad replica [#3147]

 - Fix for C API freeCollEnt() [#3151]

 - Fix msiDataObjTrim documentation error [#3152]

 - Fix irm orphan catalog entry when using S3 [#3154]

 - Fix buffer size settings on high latency connections [#3156]

 - General support [#3158] [#3165]

 - Fix for older python [#3172]

 - Fix for recursive self icp [#3187]

 - Fix for full resource iput attempts [#3195] [#3226]

 - Fix for max connection regression [#3197]

 - Additional izonereport documentation [#3209]

 - Fix for missing LOG_WARN in rodsLog() [#3214]

 - Fix for connection reuse in federation listing [#3215]

 - Fix for listing the root of a remote zone [#3218]

 - Fix for control plane with newer psutil [#3219]

 - Fix for log level when out of range [#3225]

 [Full GitHub Listing](https://github.com/irods/irods/issues?q=milestone%3A4.1.9)

## 4.1.8

Release Date: 2016-02-22

### Features

 - Added High Water Mark for unixfilesystem resources [#2981]

 - Include msisync_to_archive from contrib repository [#2962] [#2963]

!!! Note
    This inclusion will cause a package conflict with the existing
    'administration' microservices plugin package available from the
    irods/contrib repository.  If you have an ongoing need for any
    of the other microservices from that repository, you will need
    to compile and install them yourself.

### Bug Fixes

 - Fixes for Jargon tests [#2323] [#2341] [#2694] [#2878]

 - Fix for SSL configuration settings [#2564]

 - Fixes for checking error codes properly [#2803] [#2997] [#2998]

 - Update scenario for when to skip schema validation [#2812]

 - Fix for new replica honoring targeted resource [#2847]

 - Update to Kerberos documentation [#2850]

 - Fix for PAM auth output [#2900]

 - Fix for included files in zone report [#2926]

 - Fix for lsof hanging on NFS mounts [#2964]

 - Fixes for run-in-place upgrades [#2965] [#2968] [#2970] [#2971] [#2987]

 - Fixes to JSON documentation [#2973] [#3015] [#3020] [#3021]

 - Fixes for upgrade documentation [#2975] [#2982] [#2989] [#2991] [#2994]

 - Fixes for msiDataObjRsync and msiCollRsync [#2976]

 - Fix for msiDataObjUnlink and unreg keyword [#2983]

 - Fix for irodsctl schema connection warnings [#2984]

 - Fix for replication by admin for another user [#2988]

 - Fix and test for federation rsync [#2993] [#3016]

 - Fix for iphymv by admin for another user [#2995]

 - Fix for default numThreads [#2996]

 - Fixes for federation listings [#3002] [#3013] [#3055]

 - Fix for resource server setup warning [#3003]

 - Fixes for resource reliability [#3004] [#3005]

 - Fixes for C clients [#3006] [#3009]

 - Fixes for OSX 10.11 iCommands [#3011]

 - Fix for rebalance operation [#3022]

 - Fix to restore session variables [#3024]

 - Add missing rule engine functionality, parseMspForDouble [#3033]

 - Fix for database plugin upgrade output [#3034]

 - Fix for Oracle detection [#3038] [#3047]

 - Fix for quotas to use resource hierarchies [#3044] [#3048]

 - Fix for XML response string [#3050] [#3051]

 - Fix for complex hierarchy edge case [#3056]

[Full GitHub Listing](https://github.com/irods/irods/issues?q=milestone%3A4.1.8)

## 4.1.7

Release Date: 2015-11-18

### Bug Fixes

 - Fix for irods-grid --hosts option [#2765]

 - Fixes for memory management [#2928] [#2929] [#2942] [#2954]

 - Fixes for compound resource behavior [#2930] [#2939] [#2941]

 - Fix for iphymv targeting child resource [#2933]

 - Fix for python2.6 compatibility [#2940]

 - Refactoring of development libraries [#2945] [#2959]

 - Fix for documentation [#2947]

 - Fix for connection failure messages [#2948]

 - Release of Oracle database plugin for Ubuntu [#2949]

[Full GitHub Listing](https://github.com/irods/irods/issues?q=milestone%3A4.1.7)

## 4.1.6

Release Date: 2015-10-01

### Bug Fixes

 - Fix for startupPack [#2862]

 - Fix for resource server upgrade [#2863]

 - Fix for inconsistent runtime library links [#2867]

 - Fixes for impostor plugin development use cases [#2868] [#2876]

 - Documentation regarding default ports [#2870]

 - Fix for submodules in source tarball [#2871]

 - Fix for pre-built Debian external packages [#2873]

 - Fix for atomic metadata on empty files [#2875]

 - Fix for int overflow [#2880] [#2881]

 - Fix for recovery from failed installation [#2883]

 - Fix for replication resource voting mechanism [#2884]

 - Fixes for federated remote() microservice call [#2888] [#2903] [#2904]

 - Documentation for delay() and remote() microservices [#2901]

 - Documentation for msiPhyPathReg [#2906]

 - Fixes for edge cases related to rsDataObjClose [#2907] [#2908] [#2909]

 - Fix for hierarchy voting during replication [#2910]

 - Fix for better exception handling [#2914]

[Full GitHub Listing](https://github.com/irods/irods/issues?q=milestone%3A4.1.6)

## 4.1.5

Release Date: 2015-09-02

### Bug Fixes

 - Fixes for fuse [#2830] [#2837] [#2856]

 - Fixes for SQL statement table holding onto failed queries [#2833] [#2843]

 - Finalize CentOS 7 support [#2834] [#2845] [#2853]

 - Fix for PAM passwords [#2835]

 - Fix for invalid key-value string error [#2836]

 - Fix for bulk iput [#2841]

 - Fix for iticket generation [#2854]

 - Fix for rsDataObjOpen [#2855]

 - Fixes for startupPack [#2857] [#2860]

 - Fix for metadata permissions across Zones [#2858]

[Full GitHub Listing](https://github.com/irods/irods/issues?q=milestone%3A4.1.5)

## 4.1.4

Release Date: 2015-08-05

### Bug Fixes

 - Fixes for fuse [#2401] [#2509] [#2783]

 - Fix for imeta addw bind variable problem [#2682]

 - Fix shared memory and mutex file cleanup [#2751] [#2752]

 - Fix for perl warning [#2760]

 - Use single quotes for safety/readability [#2764]

 - Fix for using fuser (not available on MacOSX) - replace with lsof [#2772] [#2775] [#2794]

 - Fix irsync recursion [#2779]

 - Fix run-in-place detection [#2781] [#2784]

 - Fix unitialized values [#2782] [#2788]

 - Fix memory allocation mismatch [#2785]

 - Fix for passthru resource using read=0.0 [#2789]

 - Fix for irods-grid when environment properties are missing [#2792]

 - Fix for extra NULL character written by msiDataObjWrite [#2795]

 - Fix for get_db_schema_version.py stderr [#2799]

 - Fix irods_setup.pl detection [#2800]

 - Fix irsync checksums [#2802] [#2810]

 - Fix for ireg with --exclude-path option [#2804]

 - Fix control plane shutdown on resource server [#2807]

 - Add openssl development package dependency [#2808]

 - Add file:// URIs to schema validation [#2811]

 - Fix for cross zone icp/iput as different users [#2813]

 - Fixes for iphymv [#2815] [#2820] [#2821]

 - Fix for isysmeta output alignment [#2819]

 - Fix for data objects in the root dir (/) [#2823]

 - Fix for custom control plane key and port during setup [#2824]

 - Fix for checksum calculations on MacOSX [#2826]

 - Fix for iget parallel transfer [#2828]

[Full GitHub Listing](https://github.com/irods/irods/issues?q=milestone%3A4.1.4)

## 4.1.3

Release Date: 2015-06-18

### Bug Fixes

  - Fix upgrading with obfuscated password [#2749]

  - Fix imeta query comparison bug [#2748]

  - Fix for cleaning up temporary files during installation [#2745]

  - Run-in-Place installations

    - Fix preflight checks [#2744]

    - Fix for stopping server and killing processes [#2746]

    - Fix for finding database binary tool [#2747]

[Full GitHub Listing](https://github.com/irods/irods/issues?q=milestone%3A4.1.3)

## 4.1.2

Release Date: 2015-06-05

### Bug Fixes

  - Fix information leakage in izonereport [#2732]

  - Fix misuse of uid for gid in configuration conversion script [#2733] [#2734]

[Full GitHub Listing](https://github.com/irods/irods/issues?q=milestone%3A4.1.2)

## 4.1.1

Release Date: 2015-06-02

### Bug Fixes

  - Hardening of upgrade process against bad input [#2725] [#2727]

  - Fix for incomplete development package [#2724]

  - Fix for removing package-manager-marked config files [#2723]

[Full GitHub Listing](https://github.com/irods/irods/issues?q=milestone%3A4.1.1)

## 4.1.0

Release Date: 2015-05-29

### Notable Features

  - Configuration Management - All configuration files are now JSON and schema-backed.

    - Validated Configuration - JSON files are validated against repository of versioned schemas during server startup.

    - Reduced Magic Numbers - Some previously hard coded settings have been moved to server_config.json

    - Integrated izonereport - Produce validated JSON about every server in the Zone.  Useful for debugging and for deployment.

  - Control Plane - New functionality for determining status and grid-wide actions for pause, resume, and graceful shutdown.

  - Weighted Passthru Resource Plugin - A passthru resource can now manipulate its child resource's votes on read and write.

  - Atomic iput with metadata and ACLs - Add metadata and ACLs as soon as data is at rest and registered

  - Key/Value passthru to resource plugins - Can influence resource behavior via user-provided parameters

  - A client hints API to get server configuration information for better user-facing messages

  - Allow only TLS 1.1 and 1.2

  - Dynamic PEP result can halt operation on failure, providing better policy flow control

  - Unified documentation - Markdown-based and automatically generated by MkDocs, hosted at [https://docs.irods.org](https://docs.irods.org)

  - Continuous Testing

    - Automated Ansible-driven python topology suite, including SSL

    - Federation with 3.3.1, 4.0.3, and 4.1.0

    - Well-defined C API for developers

### Notable Bug Fixes

  - Coverity Clean - Fixed over 1100 identified bugs related to memory management, error checking, dead code, and other miscellany.

  - Many permission inconsistencies ironed out

  - Parallel transfer works in multi-homed networked situations, had been resolving IP too early

  - irsync sending only updated files

  - Zip files available via ibun

  - Zero-length file behavior is consistent

  - Delayed rules running correctly

  - Removed built-in PostgreSQL DB Vacuum functionality

  - Removed boot user from install script

  - Removed "run_server_as_root" option

  - Removed roles for storageadmin, domainadmin, and rodscurators

  - Removed obfuscation (SIDKey and DBKey)

### Other Issues

  - [Full GitHub Listing](https://github.com/irods/irods/issues?q=milestone%3A4.1.0)


## 4.0.3

Release Date: 2014-08-20

More flexible installation options (service account name/group), block storage operation fix, impostor resource, memory leak fixes, and security fixes.

[Full GitHub Listing](https://github.com/irods/irods/issues?q=milestone%3A4.0.3)

## 4.0.2

Release Date: 2014-06-17

Random and RoundRobin resource plugin fix, memory leak fixes, microservice fixes, security fixes, large collection recursive operations, and better server-server authentication setup.

[Full GitHub Listing](https://github.com/irods/irods/issues?q=milestone%3A4.0.2)

## 4.0.1

Release Date: 2014-06-05

Memory leak fixes, security fixes, --run-in-place, MacOSX support, schema update mechanism.

[Full GitHub Listing](https://github.com/irods/irods/issues?q=milestone%3A4.0.1)

## 4.0.0

Release Date: 2014-03-28

This is the fourth major release of iRODS and the first merged open source release from RENCI.

[Full GitHub Listing](https://github.com/irods/irods/issues?q=milestone%3A4.0.0)

## 4.0.0rc2

Release Date: 2014-03-25

This is the second release candidate of the merged open source release from RENCI.  It includes support for MySQL and Oracle databases, GSI, Kerberos, NetCDF, and direct access resources.

## 4.0.0rc1

Release Date: 2014-03-08

This is the first release candidate of the merged open source release from RENCI.  It includes support for MySQL and Oracle databases, NetCDF, and direct access resources.

## 4.0.0b2

Release Date: 2014-02-18

This is the second beta of the merged open source release from RENCI.  It includes pluggable API support and external S3 and WOS resource plugin packages.

## 4.0.0b1

Release Date: 2014-01-17

This is the first beta of the merged open source release from RENCI.  It includes pluggable database support and separate packages for the standalone server and its plugins.

## 3.0.1

Release Date: 2013-11-16

This is the second open source release from RENCI. It includes Federation compliance with Community iRODS and signaling for dynamic post-PEPs to know whether their operation failed.

[Full GitHub Listing](https://github.com/irods/irods/issues?q=milestone%3A3.0.1)

## 3.0.1rc1

Release Date: 2013-11-14

This is the first release candidate of the second open source release from RENCI.  It includes a new "--tree" view for `ilsresc` and a more powerful `irodsctl stop`.  In addition, package managers should now be able to handle upgrades more gracefully.

## 3.0.1b2

Release Date: 2013-11-12

This is the second beta of the second open source release from RENCI.  It includes certification work with the Jargon library, more CI testing, and minor fixes.

## 3.0.1b1

Release Date: 2013-10-31

This is the first beta of the second open source release from RENCI. It includes pluggable network and authentication support as well as a rebalance option and migration support for the composable resources.

## 3.0

Release Date: 2013-06-05

This is the first open source release from RENCI. It includes all the features mentioned below and has been both manually and continuously tested.

[Full GitHub Listing](https://github.com/irods/irods/issues?q=milestone%3A3.0)

## 3.0rc1

Release Date: 2013-05-14

This is the first release candidate from RENCI.  It includes PAM support, additional resources (compound, universalMSS, replication, random, and nonblocking), and additional documentation.

## 3.0b3

Release Date: 2013-03-15

This is the third release from RENCI.  It includes a new package for CentOS 6+, support for composable resources, and additional documentation.

## 3.0b2

Release Date: 2012-06-25

This is the second release from RENCI.  It includes packages for iCAT, Resource, iCommands, and development, in both DEB and RPM formats. Also includes more documentation.

## 3.0b1

Release Date: 2012-03-01

This is the first release from RENCI, based on the iRODS 3.0 community codebase.

