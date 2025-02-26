#

## 4.3.4

Release Date: 2025-03-05

The iRODS Consortium and RENCI are pleased to announce iRODS 4.3.4.

This release primarily focuses on preparing the ground for the initial release of iRODS 5 by introducing more deprecations, fixing bugs, and cleaning up implementations.

The biggest news of this release is that `imiscsvrinfo` has been updated to report SSL/TLS certificate information, if in use. This is made possible due to enhancements to the `rcGetMiscSvrInfo` API endpoint. Keep in mind that this requires the client to have a proper client-side configuration.

This release consists of [94 commits from 6 contributors](https://github.com/irods/irods/compare/4.3.3...4.3.4) and [closed 134 issues marked for 4.3.4](https://github.com/irods/irods/issues?q=milestone%3A4.3.4).

The latest binary packages for AlmaLinux8, RockyLinux9, Ubuntu20, Ubuntu22, Ubuntu24, Debian11, and Debian12 are available at <https://packages.irods.org/>.

### Changed

- Improve documentation (#2600, #7622, #7701, #7784, #7952, #8000).
- Return errors on one-sided encryption in parallel transfer (#4984).
- Improve testing (#6421, #7412, #7491, #7795, #7990, #8046, #8047, #8183, #8185, #8247).
- Clean up code (#5800, #6972).
- Remove unnecessary code - source files, functions, declarations, header includes, etc (#6043, #6234, #6546, #7919, #7942, #8010, #8133, #8201, #8204).
- Replace use of externals-provided libarchive with distro-provided libarchive (#6250, #7286).
- Improve CMake (#6319, #6584).
- Update clang-format / clang-tidy configuration (#6970, #7313, #7751, #7821, #7822).
- Remove ACLs following removal of user (#7778).
- Migrate GitHub workflows to Ubuntu 24.04 (#7823).
- Expand permission levels supported by atomic ACL operations API (#7913).
- Reduce log noise (#7953).
- Remove installation of packedRei directory from CMakeLists.txt (#7993).
- Install msiExecCmd_bin/hello script as a template (#7994).
- Replace stacktrace with user-friendly error message in `itree` (#8082).
- Improve GenQuery2 parser's handling of whitespace sequences (#8182).
- Add json_events.hpp header file to development package (#8200).

### Removed

- Remove CentOS 7 build from GitHub workflows (#7968).

### Deprecated

- Deprecate `ilocate` (#2524).
- Deprecate `igetwild` (#2525).
- Deprecate creation or modification of user having rodsgroup type in GeneralAdmin API (#2978).
- Deprecate modification of ACL policy (#6843).
- Deprecate GeneralRowInsert and GeneralRowPurge (#7608).
- Deprecate update_deprecated_database_columns.py (#7835).
- Deprecate `imeta qu` (#7959).
- Deprecate `imeta` interactive mode (#7961).
- Deprecate server monitoring microservices (#7977).
- Deprecate DataObjLock and DataObjUnlock (#7979).
- Deprecate unused global variables in resource manager implementation. (#8042).
- Deprecate `fillGenQueryInpFromStrCond` (#8088).
- Deprecate `forkAndExec` (#8109).

### Fixed

- Avoid SIGABRT by setting pointers to null after deallocation (#3581).
- Use `ProcessType` to detect server vs pure client (#6684).
- Rework logic in `_cllExecSqlNoResult` to return proper error codes (#7440, #7599).
- Fix flex warning for GenQuery2 lexer rules (#7685).
- Validate and reject invalid zone names (#7722).
- Return non-zero exit code from `iadmin` on failure (#7734).
- Remove undefined reference to variable in exception (#7752).
- Ignore SIGPIPE so agents do not terminate immediately (#7933, #7934).
- Change if-statement so ticket use-count is only updated on first pass (#7967).
- Write client and proxy user info to `ips` data file in correct order (#8001).
- Modify JSON schema file to enforce required attributes of `controlled_user_connection_list` (#8017).
- Use `std::tolower` with `std::transform` correctly (#8045).
- Fix error handling logic for heartbeat operation (#8050).
- Return error on invalid GenQuery1 aggregate function (#8080).
- Return error on nonexistent target for write functions in iRODS Rule Language (#8095).
- Clean up memory in `rsDataObjChksum`, various endpoints, and iCommands (#8106).
- Correct narrowing of floating point values (#8110).
- Remove constructor from `Cache` data type in iRODS Rule Language to allow for `memset` (#8111).
- Avoid segfault in `rcDisconnect` (#8120).
- Fix libstdc++ linker error for `ienv`, `ierror`, and `ipwd` on EL8 (#8122).
- Fix GenQuery2 column mappings for user zone (#8134).
- Use correct GenQuery2 table aliases for permissions (#8135).
- Fix `nullptr` to function argument and unsigned overflow (#8153).
- Fix read/write loop in `istream` (#8166). 
- Clear `rodsPathInp_t` instead of freeing memory (#8221).
- Add support for `order_asc` keyword to GenQuery1 string parser (#8249).

### Added

- Add dedicated keywords for creating groups via GeneralAdmin API (#2978).
- Make checksum buffer size configurable (#7947).
- Provide way for clients to obtain SSL/TLS certificate information (#7986).
- Add support for Undefined Behavior Sanitizer (#8090).

[Full GitHub Listing](https://github.com/irods/irods/issues?q=milestone%3A4.3.4)

## 4.3.3

Release Date: 2024-08-26

The iRODS Consortium and RENCI are pleased to announce iRODS 4.3.3.

This release focuses mostly on adding support for newer compilers, libstdc++, Ubuntu 24.04, and PostgreSQL 15 and newer.

Other notable work includes a fix for a msiServerMonPerf vulnerability and more GenQuery2 readiness before it is promoted to the default query parser in a later release.

Additionally, the package revision and filenames of the plugins have been updated to include the server version they were built against (e.g. irods-rule-engine-plugin-logical-quotas_4.3.3.0-0+4.3.3~jammy_amd64.deb).  Package names and dependencies have not changed.  This semi-decoupling will allow a plugin to be rebuilt for later releases, without having to bump its own version number if no changes have been made to the plugin itself.  This change will affect any local scripts that may be used to install and maintain iRODS installations and deployments.

This release consists of [88 commits from 6 contributors](https://github.com/irods/irods/compare/4.3.2...4.3.3) and [closed 89 issues marked for 4.3.3](https://github.com/irods/irods/issues?q=milestone%3A4.3.3).

The latest binary packages for AlmaLinux8, RockyLinux9, Ubuntu20, Ubuntu22, Ubuntu24, Debian11, and Debian12 are available at <https://packages.irods.org/>.

The release notes include:

### Enhancements

 - Propagate error codes to exception types [#7155]
 - Add support for PostgreSQL 15 [#7382] [#7742] [#7831]
 - Add GenQuery2 support for SQL functions in WHERE and ORDER-BY clauses [#7673]
 - Add GenQuery2 support for multi-argument SQL functions [#7678]
 - Add support for disabling crash signal handlers for debugging [#7750]
 - Update log level for ticket setup [#7820]
 - Add trace level logging to low-level ODBC code [#7907]

### Bug Fixes

 - Marked as resolved/invalid/question [#3455] [#6562] [#6775] [#7123] [#7723] [#7772] [#7788] [#7794] [#7798] [#7799] [#7818] [#7840] [#7872] [#7899] [#7901] [#7910] [#7924] [#7936]
 - Fix for temporary rule files persisting too long [#5210]
 - Fix for atomic ACLs not considering zone of user [#7408]
 - Fix for escaping regular expressions in Python [#7741]
 - Fix for segfaults when built against libstdc++ [#7745] [#7747]
 - Disable the irodsServerMonPerf script by default [#7760]
 - Fix for replication when user has permission only via group [#7816]
 - Fix for MySQL 8.x ODBC driver selection [#7844]
 - Fix for null pointer handling in msiDataObjChksum [#7859]
 - Fix for error message returned by resource administration library [#7877]
 - Fix for replica truncate API to return JSON [#7918]

### Documentation

 - Improve on() documentation within iRODS Rule Language [#7268]
 - Document compatibility with MySQL and MariaDB ODBC connectors [#7495] [#7905]
 - Improve documentation for checksum behavior [#7724]
 - Update short option documentation for itree json output [#7761]
 - Improve documentation for atomic microservices [#7870]
 - Update documentation about 'up/down' resource status [#7903]

### Refactors / Packaging / Build / Test

 - Improve assertions in test_iget_with_purgec [#5593]
 - Fix building with newer compilers [#5795] [#5803] [#5804] [#7729] [#7730] [#7731] [#7732] [#7735] [#7764] [#7766] [#7767] [#7768] [#7769] [#7780] [#7781] [#7808] [#7809]
 - CMake updates [#6258] [#7508] [#7736] [#7740]
 - Add Ubuntu 24.04 support [#7592]
 - Add groupadmin test [#7707]
 - Fix existing tests [#7718] [#7721] [#7725] [#7744] [#7754] [#7755] [#7756]
 - Update package numbering to semi-decoupled [#7759]
 - Enable tests by default more intelligently [#7800] [#7802] [#7803]
 - Improve logger timestamp generation time 10x [#7812]
 - Refactor GenQuery2 parser internals [#7847]
 - Workarounds for CentOS7 EOL [#7865] [#7885]
 - Add tests for GenQuery2 python module [#7909]

### Deprecated

 - Deprecate trimPrefix() and trimSpaces() [#7704]

### Removed

 - Remove icatGlobalsExtern.hpp [#6237]
 - Remove Python2 compatibility module six.py [#7743]

 [Full GitHub Listing](https://github.com/irods/irods/issues?q=milestone%3A4.3.3)

## 4.3.2

Release Date: 2024-05-02

This release represents preparation for work on 5.0.0 and important bug fixes for the 4.3 series.

Most significantly, this release includes the new GenQuery2 parser and new iCommand `iquery`.  For anyone already running the unreleased GenQuery2 API plugin packages, please note that an upgrade will halt and report a conflict with 4.3.2.  Please uninstall the separate package before upgrading to 4.3.2.

Other notable inclusions are fixes for keyword combinations and bad inputs, a number of documentation additions, and a few new deprecation declarations.

This release consists of [125 commits from 7 contributors](https://github.com/irods/irods/compare/4.3.1...4.3.2) and [closed 154 issues marked for 4.3.2](https://github.com/irods/irods/issues?q=milestone%3A4.3.2).

The latest binary packages for CentOS7, AlmaLinux8, RockyLinux9, Ubuntu20, Ubuntu22, Debian11, and Debian12 are available at <https://packages.irods.org/>.

The release notes include:

### Enhancements

 - Add GenQuery2 parser to the server [#3064] [#3886] [#4069] [#5727] [#5734] [#6168] [#6393] [#7570]
 - Add replica_truncate API and microservice [#7104] [#7577] [#7650]
 - Add support for local mariaDB as database [#7345] [#7469] [#7484] [#7528]
 - Add new rule engine serializations [#7413] [#7552] [#7553]

### Bug Fixes

 - Marked as resolved/invalid/question [#2916] [#4125] [#4200] [#5325] [#5635] [#5726] [#5753] [#5912] [#6481] [#6521] [#7121] [#7360] [#7378] [#7407] [#7409] [#7419] [#7420] [#7436] [#7438] [#7441] [#7522] [#7574]  [#7634] [#7647] [#7692] [#7711]
 - Fixes for segfaults [#2932] [#7027] [#7319]
 - Fix for irsync and broken symlinks [#5359]
 - Fix for msiDataObjChksum documentation [#6435]
 - Fix for iscan help text [#6369]
 - Fixes for quota help text [#6369]
 - Fix for icp -f -R when overwriting [#6497]
 - Fix for documentation about symlink support [#6656]
 - Marked as duplicate [#6837]
 - Fixes for setting iCommands spOption for ips [#7376] [#7470]
 - Fix for rmuser and rmgroup entanglement [#7380]
 - Fix for copy_data_object copy_options [#7443]
 - Fixes for resultant intermediate status [#7444] [#7465]
 - Fix to prevent removal of last replica during trim [#7468] [#7515]
 - Fix for tar format to use pax format [#7474]
 - Fix for writes to prefer good replicas [#7476]
 - Fix for double free in rsDataObjRepl [#7540]
 - Fix for proxied groupadmin to be able to make groups [#7576]
 - Fix for consumer setup without local resource [#7590]
 - Fix for parsing bad message during initialization [#7614]
 - Fix for graceful shutdown of agents [#7619]
 - Fix for modifying metadata with both ADMIN_KW and ALL_KW [#7626]
 - Fix for irodsServerMonPerf bad path checking [#7652]
 - Fix for noisy logging for unknown log levels [#7687]
 - Fix for iadmin modrepl syntax documentation [#7695]
 - Fix for icd help text [#7706]

### Documentation

 - Document PAM settings [#4904]
 - Document multiple transfer threads [#5701]
 - Document irule rule text limitation [#6223]
 - Document iRODS error codes [#6631]
 - Document unattended installation's overwrite behavior [#6719]
 - Document voting and resource hierarchy resolution [#6940]
 - Document writeLine [#7388] [#7630]
 - Update dynamic PEPs listing [#7385] [#7575]
 - Document get/set_grid_configuration subcommands [#7503]
 - Document performance paper link [#7391]
 - Document sql logging warnings [#7393]
 - Document force removal option [#7421]
 - Document process for reporting security vulnerabilities [#7618]
 - Document IRODS_ENVIRONMENT_FILE and icd [#7705]

### Refactors / Packaging / Build / Test

 - Update to doxygen dependencies [#2024]
 - Fixes to intermittent tests [#2634] [#6440] [#6441] [#7243] [#7372] [#7373] [#7374] [#7389] [#7390] [#7453] [#7454] [#7455] [#7457] [#7510] [#7511] [#7521]
 - Add test for pam_password_max_time [#3742] [#4198] [#5096]
 - CMake updates [#6214] [#6251] [#6256] [#7398] [#7506] [#7507] [#7509] [#7512] [#7523] [#7524] [#7542] [#7546] [#7549]
 - Fix for deprecated signing key algorithm for packages.irods.org [#7349]
 - Fixes for curl dependencies [#7371] [#7435]
 - Fix for chkconfig in rpm dependencies [#7437]
 - Fix for super in package dependencies [#7525]
 - Update iRODS versioning process [#7531] [#7532] [#7548]
 - Update development package dependencies [#7545]
 - Make find_replica a member function of data_object_proxy [#7556]
 - Add .clang-format file to iCommands repository [#7585]
 - Update naming scheme for feature test macros [#7636]
 - Update clang-tidy configuration [#7637]

### Deprecated

 - Deprecate msiSendMail [#3660] [#7293] [#7562] [#7651]
 - Deprecate support for RBUDP [#6610]
 - Deprecate support backup mode and BACKUP_RESC_NAME_KW [#6953]
 - Deprecate wildcard listing for imeta (lsw) [#7488]
 - Deprecate trim --age keyword (AGE_KW) [#7498]
 - Deprecate trim number of replicas to keep (-N) [#7502]
 - Deprecate --link, add --ignore-symlinks [#7537]
 - Deprecate GeneralUpdate API [#7554]
 - Deprecate rcDataObjTruncate [#7555]
 - Deprecate msiSetResource [#7602]

### Removed

 - Document removal of old irule --test [#6224]
 - Remove resolveHostByDataObjInfo declaration [#7418]
 - Remove recursive pre-scan output [#7516]
 - Remove Ubuntu 18.04 as supported platform [#7519]

 [Full GitHub Listing](https://github.com/irods/irods/issues?q=milestone%3A4.3.2)

## 4.3.1

Release Date: 2023-10-20

This release represents a steady improvement on 4.3.0's significant release last year.  Most significantly, the memory leaks introduced with the new frameworks in 4.3.0 have been fixed alongside internal refactoring.  Additionally, three new operating systems are now supported by our binary packaging.

Detached mode has been added to the unixfilesystem plugin which provides superior performance when working with parallel filesystems.

Additional machinery has been made available to control TCP Keepalive behavior, ticket administration, connection pooling, and authentication configuration.

This release consists of [402 commits from 16 contributors](https://github.com/irods/irods/compare/4.3.0...4.3.1) and [closed 236 issues marked for 4.3.1](https://github.com/irods/irods/issues?q=milestone%3A4.3.1) and [an additional 119 closed issues included in the recent 4.2.12 release](https://github.com/irods/irods/issues?q=milestone%3A4.2.12+closed%3A%3E2022-06-12).

The latest binary packages for CentOS7, AlmaLinux8, RockyLinux9, Ubuntu18, Ubuntu20, Ubuntu22, Debian11, and Debian12 are available at <https://packages.irods.org/>.

The release notes include:

### Enhancements

 - Add TCP keepalive options configuration [#2533] [#3824] [#3986]
 - Prompt for auth scheme and SSL information with iinit [#3164] [#6398]
 - Include resource 'comment' and 'info' in izonereport [#3739]
 - Add detached mode to unixfilesystem plugin [#4421] [#6557]
 - Add connection_pool features [#5060] [#5799] [#7130] [#7145] [#7287] [#7304] [#7314] [#7350]
 - Add ticket administration library [#5716] [#7115] [#7179] [#7185] [#7211]
 - Add server configuration reload on SIGHUP [#5816] [#5821] [#6569]
 - Add client connection information to acPreConnect [#5985]
 - Use boost::process to capture messages better [#6273]
 - Expose CRON task intervals in advanced settings [#6342]
 - Expose delay server and control plane timeout settings [#6370]
 - Improved logging facilities [#6470] [#6493] [#6641] [#6642] [#6818] [#7048] [#7212]
 - Add remote configuration reload to irods-grid [#6529]
 - Add interactive_pam authentication to iinit [#6576]
 - Add initial feature test macros to server [#6588] [#7254]
 - Add new rc_switch_user API plugin [#6591] [#7197]
 - Add support for packaging for Ubuntu 22.04 [#6597]
 - Add zone administration library [#6616]
 - Add checksums to izonereport [#6856]
 - Flatten izonereport list of servers [#6857]
 - Add new rx_check_auth_credentials API endpoint [#7099] [#7290]
 - Determine correct RTLD flags when loading plugins [#7158]
 - Add microservice to remove a user from a group [#7165]
 - Add support for packaging for AlmaLinux 9 and Rocky Linux 9 [#7191] [#7281] [#7312]
 - Add bulk removal to process_stash [#7195] [#7296]
 - Add testing functions to user administration library [#7227]
 - Add new rc_get_resource_info_for_operation API endpoint [#7256]
 - Add support for packaging for Debian 12 [#7266]
 - Add support for PAM configuration to catalog [#7274]
 - Add new iadmin get/set_grid_configuration subcommands [#7283]
 - Add new column for resource modification time in milliseconds [#7303]
 - Add totalRowCount to query iterator [#7310]

### Bug Fixes

 - Marked as resolved/invalid/question/wontfix [#2029] [#3967] [#4401] [#4966] [#5932] [#6157] [#6158] [#6419] [#6447] [#6458] [#6464] [#6471] [#6483] [#6485] [#6500] [#6503] [#6520] [#6535] [#6561] [#6594] [#6603] [#6612] [#6644] [#6686] [#6770] [#6771] [#6772] [#6830] [#6852] [#6855] [#6881] [#6893] [#6902] [#6965] [#6988] [#7040] [#7064] [#7106] [#7111] [#7117] [#7118] [#7122] [#7142] [#7143] [#7144] [#7167] [#7172] [#7175] [#7183] [#7201] [#7320] [#7333] [#7368] [#7369] [#7379]
 - Fix for bypass of permission model in ichmod [#2570] [#6579]
 - Fix for null pointers in serialization functions [#3400]
 - Fix for PAM authentication prompts [#3564]
 - Fix for duplicate server information in izonereport [#3682]
 - Fix for subject alternative name in irods.org cert [#3718]
 - Fix for DOUBLE directive in delay hints parser [#5964]
 - Fix for error message during resource resolution [#6260]
 - Fix for metadata definitions in wrong location [#6445]
 - Fix for unattended installs and default resource [#6459]
 - Update for PAM documentation [#6472]
 - Fix for duplicate AVU add behavior [#6504]
 - Update documentation for PEP and policy reuse [#6528]
 - Fix for openmode flags being mistakenly updated [#6600]
 - Fixes for memory leaks [#6634] [#6672] [#6814] [#6821] [#6931] [#7321]
 - Fix deadlock in MySQL on concurrent inserts [#6670]
 - Fix for delay server migration not consulting host_resolution [#6687]
 - Fix for data race with use of server_properties::map [#6726]
 - Fixes for signal handlers [#6732] [#6819] [#6820]
 - Fix for removed python function for rsZoneReport [#6773]
 - Fix for ichmod help text [#6809]
 - Marked as duplicate [#6747] [#6763] [#6894] [#7133] [#7275]
 - Fix for environment variable bounds check [#6866]
 - Fix for inconsistent role ordering in setup script [#7023]
 - Fix for python rule engine plugin to load libpython.so [#7056]
 - Fix for PAM password length [#7098]
 - Fix for missing headers [#7101]
 - Fix for iticket relative path handling [#7103]
 - Fix for bulk put with overwrites [#7110]
 - Fix for modification time for tickets [#7125]
 - Fix for msiCollRsync noisy logs [#7134]
 - Fix for delay server migration atomicity [#7137]
 - Fix for signed data size behavior in irods::file_object [#7154] [#7160]
 - Fix for rError stack initialization [#7161]
 - Fix for ticket session leaving open a database transaction [#7250]
 - Fix for permissions returned to 4.2 servers [#7327]
 - Fix for minimum privilege level for API plugins [#7338]

### Refactors / Packaging / Build / Test

 - Better declare build dependencies in any CMake errors [#3270]
 - Introduce CMake IrodsRunpathDefaults module [#3397]
 - Updates for non-package installations [#6284] [#6590]
 - Refactor main server logic [#6473] [#6817]
 - Add GitHub Action workflows for clang-tidy and clang-format [#6492] [#6527] [#6573] [#6580] [#6585] [#6586] [#6646] [#6648] [#6681] [#6971] [#6998] [#7058] [#7059] [#7060] [#7108] [#7109] [#7139] [#7140] [#7141] [#7217]
 - Merge filesystem.tpp and filesystem.hpp [#6507] [#6745] [#6746]
 - Remove .gitmodules [#6517]
 - Provide facility for unit tests to link object libraries [#6538]
 - Reorganize to not package private headers [#6545]
 - Update icommands package dependencies [#6564]
 - Update administration libraries [#6592] [#6665]
 - Refactor administration libraries to throw exceptions [#6619] [#6701]
 - Refactor const stringview reference [#6621]
 - Refactor client_api_allowlist interface [#6639]
 - Enabled test_auth suite working with PAM [#6693]
 - Put base64 methods into irods namespace [#6716]
 - Compile server and icommands against the same C++ standard [#6725]
 - Fixes for topology testing [#6956] [#7000]
 - Beginning work on GCC builds [#6974]
 - Refactor getting resource parent name and id [#7029]
 - Fix for unicode in test output [#7063]
 - Fixes for PAM authentication tests [#7102] [#7120]
 - Create C++ project template for resource plugins [#7131]
 - Refactor parameter order for resource functions in lib.py [#7152]
 - Refactor session signature to be stored in RcComm [#7192] [#7193]
 - Fixes for unit tests [#7206] [#7208] [#7289]
 - Refactor apiPackTable.h to api_pack_table.hpp [#7228]
 - Fix for upgrades of older VERSION files [#7239]
 - Upgrade boost dependency to 1.81 [#7247]
 - Restore odbc dependency [#7249]
 - Perform CMake consistency sweep [#7263]
 - Split tests into multiple classes [#7325]
 - Relax CMake iRODS version matching for find_package [#7364]

### Deprecated

 - Deprecated SimpleQuery [#6638]

### Removed

 - Remove unused pyparsing python module [#6536]
 - Remove setup logic for rsyslog and logrotate [#6598]
 - Remove rule_texts_for_tests.py [#6677]
 - Remove logic for log_level from startup script [#6816]
 - Remove Kerberos from documentation [#7357]
 - Remove GSI from documentation [#7358]

 [Full GitHub Listing](https://github.com/irods/irods/issues?q=milestone%3A4.3.1)

## 4.3.0

Release Date: 2022-06-12

This release represents a very significant, five-and-a-half-year effort since our last point-0 release.  4.2.0 was released in November 2016 and included the pluggable rule engine and the CMake build system.  We've done a lot more this time around.

Notable updates include:

 - Python3 Compliance - All control scripts and the Python Rule Engine Plugin are now Python3 only.  Please test any existing Python rules before upgrading.

 - Expanded 10-level Permission Model - Up from the 4-level model (null, read, write, own), this new model exposes additional nuance and provides separate levels for metadata and data objects.

 - New Authentication Plugin Framework - Pushed by the need for an interactive PAM plugin to handle two-factor authentication scenarios, this framework's flow is now plugin driven and flexible.

 - New rsyslog-based Logging Framework - The new structured logs are JSON and can be easily consolidated from many servers through syslog configuration.  Independent log levels exist for different parts of the server and plugin codes.

 - New Delay Server Implementation - The delay server has been refactored with the connection_pool and irods::thread_pool to service the delay queue in both a parallel and distributed manner.  Multiple iRODS servers can be defined as eligible to execute the enqueued rules which will be distributed randomly at runtime. 
 
 - Delay Server Migration - The delay server can be moved from one machine to another within a Zone without any restarts.  This gives administrators flexibility when the system is under continuous load.

 - New support for Ubuntu20, Almalinux8, and Debian11 - Three additional operating systems expand an administrator's options.


This release consists of [1482 commits from 32 contributors](https://github.com/irods/irods/compare/4.2.0...4.3.0)
and [closed 306 issues marked for 4.3.0](https://github.com/irods/irods/issues?q=milestone%3A4.3.0) and [an additional 41 closed issues to be included in the upcoming 4.2.12 release](https://github.com/irods/irods/issues?q=milestone%3A4.2.12%20closed%3A%3C%3D2022-06-12).

The latest binary packages for CentOS7, AlmaLinux8, Ubuntu18, Ubuntu20, and Debian11 are available at <https://packages.irods.org/>.

The release notes include:

### Enhancements

 - Expose 10-level Permission Model [#844] [#3106] [#5276] [#5277]
 - Modify resource tools [#1656]
 - Add Python3 compliance [#2037] [#4951] [#5356] [#5825] [#6069] [#6114] [#6294] [#6310] [#6349] [#6413]
 - Implement Indexing capability [#2065]
 - iexit removes credential file [#2082]
 - Add rsyslog Logging Framework [#2112] [#2684] [#2730] [#3131] [#3132] [#3326] [#3479] [#3483] [#3602] [#4239] [#4295] [#4310] [#4356] [#4365] [#4382] [#4703] [#5225] [#6077] [#6132] [#6308]
 - iCommands run in Windows Subsystem for Linux [#2121]
 - Add recursive option to ireg [#2919]
 - New Delay Server Implementation [#2924] [#3399] [#3993] [#4292] [#4344] [#4736] [#5169] [#5258] [#5893] [#6328] [#6337] [#6425]
 - Consolidate server_config.json [#6315] [#4012] [#5924] [#5930] [#6137] [#6160] [#6288] [#6305] [#6306] [#6307] [#6326] [#6329]
 - Clean up core.re.template and cpp_default_policy [#3373]
 - Implement new Authentication Plugin Framework [#3445] [#5093] [#5479]
 - Change default SSL policy to CS_NEG_REFUSE [#3461]
 - Modernize to C++17 and C++20 [#4074] [#6085] [#6177]
 - Externalize dstream layer [#4316]
 - Add support for High Availability during setup [#4381]
 - Add irodsctl options [#4418] [#4472]
 - Add implicit remote() to delayed rule execution [#4429]
 - Add support for Ubuntu20 [#4883] [#5174] [#5246] [#6080]
 - Add child process monitoring and restart (cron) [#4947] [#4977] [#5007] [#6014] [#6116] [#6117] [#6336] [#6429]
 - Add Delay Server Migration [#5249] [#6357]
 - Add atomic API endpoint for catalog operations [#5324] [#5481]
 - Add server configuration service endpoint [#5602]
 - Add atomic update for parent of resource [#5934]
 - Add support for AlmaLinux8 [#6021] [#6039] [#6079]
 - Add function for setting a client's ips name [#6338]
 - Add support for Debian11 [#6360]

### Bug Fixes

 - Marked as resolved/invalid/question/wontfix [#887] [#1033] [#1147] [#1581] [#2166] [#2205] [#2393] [#2594] [#2938] [#3071] [#3093] [#3107] [#3228] [#3381] [#3410] [#3417] [#3424] [#3456] [#3592] [#3612] [#3797] [#3827] [#3830] [#3836] [#3845] [#4229] [#4482] [#4522] [#4720] [#5482] [#6269] [#6270] [#6303] [#6314] [#6394]
 - Better error messages [#1721] [#2960] [#3035] [#3500] [#5028] [#5975]
 - Fixes for symlink behavior [#2053] [#3061]
 - Fix for imeta [#2390]
 - Fix for iinit [#2590]
 - Fix for restarting a get [#2660]
 - Fix for iCommands return codes [#2822]
 - Fix for imv [#2879]
 - Fix for federation [#3136]
 - Fixes and tests for ichksum [#3322] [#3533]
 - Fix for graceful shutdown [#3333]
 - Fix for _comm before checking PEPs [#3401]
 - Fixes for GenQuery [#3404] [#3406]
 - Fix for ticket usage [#3426]
 - Marked as duplicate [#3443]
 - Fix for unchecked error in resolve_resource_hierarchy [#3655]
 - Fix for RODS_CLERVER macro [#4273]
 - Fix for JSON handling [#4511]
 - Fixes for irods::filesystem [#4525] [#5027]
 - Fix for connection pools [#4834]
 - Fix for triggering the correct PEPs [#5830]
 - Fix for database connection default [#5935]
 - Fix for initial group creation [#6063]
 - Fix for proc files cleanup [#6231]
 - Fix for SQL function sequence error for identical AVU [#6409]

### Refactors / Packaging / Build / Test

 - Use uint64_t [#1703]
 - Add libcurl3-gntls for Debian [#2382]
 - Federation testing [#2599]
 - SSL testing [#2742]
 - Support non-package-install [#3202] [#3394] [#3462] [#3680]
 - Support new testing environment [#3242] [#3959]
 - Update externals [#3266] [#4274] [#4810] [#4856] [#5713] [#6071] [#6076] [#6081] [#6083] [#6084] [#6086] [#6093] [#6147] [#6148] [#6149] [#6173] [#6178] [#6240] [#6322]
 - Refactor shared libraries [#3272] [#6141]
 - Relocate server socket files [#3380]
 - Optimize memory usage [#3423] [#3711] [#3727] [#3743] [#3940] [#4002] [#4213] [#4287] [#4803] [#4805] [#5781] [#5905]
 - Update iCommands builds [#3446] [#6120]
 - Improve CMake usage and packaging [#3469] [#3473] [#4317] [#6065] [#5669] [#5712] [#5875] [#5910] [#5966] [#6054] [#6056] [#6098] [#6103] [#6104] [#6130] [#6211] [#6215] [#6216] [#6217] [#6218] [#6226] [#6236] [#6257] [#6300] [#6309] [#6334] [#6351] [#6352] [#6353] [#6383] [#6386] [#6392] [#6423] [#6432]
 - Setup clang-format [#3917]
 - Improve irods development environment [#4182] [#5300]
 - Move to nlohmann/json, remove jansson library [#4234]
 - Add or improve tests [#4278] [#4283] [#4345] [#4359] [#4531] [#4556] [#6092] [#6228] [#6414]
 - Use more inclusive language [#5926]
 - Reimplement irods_stacktrace with Boost.Stacktrace [#6133]
 - Refactor iCommands tarball packager [#6276]
 - Refactor shared memory functions [#6290] [#6346]
 - Update unattended installation mechanism [#6330]
 - Streamline GitHub Actions [#6362]
 - gitignore removed submodule directory [#6372]
 - Update tests for new platforms [#6437]

### Deprecated

 - Mark as deprecated all static policy enforcement points (PEPs) [#5951]
 - Mark as deprecated imeta adda [#6187]
 - Mark as deprecated imeta addw [#6416]
 - Mark as deprecated imeta rmw [#6417]

### Removed

 - Remove XMsgServer [#1449] [#3728] [#3729]
 - Remove Database Resources [#1981]
 - Remove irodsFs implementation [#2275] [#2680] [#2710] [#3103] [#3363]
 - Remove messaging schema submodule [#2768]
 - Remove support for Ubuntu14 and Ubuntu16 [#3185]
 - Remove resolveHostByDataObjInfo [#3474]
 - Remove iphybun [#3603]
 - Remove roundrobin coordinating resource [#3779]
 - Remove iexecmd [#4186]
 - Handle EOL API numbers [#4202]
 - Remove unused rule submit tags [#4276]
 - Remove audit trails [#4337]
 - Remove msiSetMultiReplPerResc [#4408]
 - Remove msiSetRescSortScheme [#4409]
 - Remove iCommands as installation dependency [#4446]
 - Remove user quota functionality [#4481]
 - Remove deprecated rules and microservices [#4659] [#5441]
 - Remove deprecated -U option from irm [#4681]
 - Remove deprecated num_repl keyword from replication resource [#4775]
 - Remove server dependency on irods-grid [#5978] [#6265]
 - Remove default_log_rotation_in_days from configuration [#6304]
 - Remove deprecated -n option from irm [#6340]
 - Remove plaintext password option for iinit [#6382]

 [Full GitHub Listing](https://github.com/irods/irods/issues?q=milestone%3A4.3.0)

## 4.2.12

Release Date: 2023-05-13

This release represents more than a year and a half of work to finalize the 4.2.x series. 4.2.12 will be the last 4.2.x release.

Focused effort was spent on enhancements that leave 4.2.x in a good place for deployments that are not ready to upgrade to 4.3. These include greater availability of the admin keyword, JSON object and string-manipulation microservices, additional availability of DataObjInfo to rules, and better admin account and password management.

Notable bug fixes include better group and groupadmin support, improved user-input handling, replica status cleanup/locking, database statement management, and improved documentation.

This release consists of [169 commits from 10 contributors](https://github.com/irods/irods/compare/4.2.11...4.2.12)
and [closed 160 issues](https://github.com/irods/irods/issues?q=milestone%3A4.2.12).

The latest binary packages for CentOS7 and Ubuntu18 are available at <https://packages.irods.org/>.

### Enhancements

 - Add ability for user to select rule engine instance during remote execution [#3925]

 - Prevent checksum verification in sync-to-archive operations [#6089]

 - Add support for the admin keyword to msiDataObjChksum [#6118]

 - Add better support for password management in the user_administration library [#6122]

 - Add support for the admin keyword to filesystem metadata API functions [#6124]

 - Add protection from a server's admin account being downgraded [#6128]

 - Add support for the admin keyword to imeta [#6161] [#6185]

 - Add more DataObjInfo members to rule engine framework serialization [#6175]

 - Add support for the admin keyword to filesystem library metadata functions [#6180]

 - Add delay server memory usage default on upgrade [#6193]

 - Add support for the admin keyword to atomic apply acl operations [#6198]

 - Add support for INST_NAME via remote microservice [#6465]

 - Add safe version of at_scope_exit [#6477]

 - Add better itree --pattern and --ignore behavior [#6791] [#6806]

 - Add support for federating all hosts in catalog_provider_hosts [#6827]

 - Add more details to key_value_proxy error messages [#6882]

 - Add microservices for JSON object and string manipulation [#6968]

 - Add process_stash library for managing server memory scratch space [#6999]

### Bug Fixes

 - Fix for core.re cache when updated rapidly [#2279]

 - Fix for password visibility in debug log with PAM and SSL [#2902]

 - Fix for over-quota writing [#3062]

 - Marked as resolved/invalid [#3775] [#5206] [#5837] [#6267] [#6312] [#6402] [#6434] [#6490] [#6558] [#6711] [#6729] [#6738] [#6739] [#6892] [#6914] [#7019]

 - Fix for setting shared AVU to empty [#4063]

 - Fix for correct error message on remote microservice with invalid hostname [#4260]

 - Fix for inconsistent empty result code from iquest [#4745]

 - Fix for substring error in resource hostname [#5410] [#6070]

 - Fix for too small buffer in iinit [#5411]

 - Fix for MySQL 8 GTID replication error [#5729]

 - Fix for allowing tickets to write to collections [#5913]

 - Fix for stacktrace in presence of too long servername [#5916]

 - Fix for msiDataObjRepl in presence of both verifyChksum keyword and catalog value [#5927]

 - Marked as question answered [#6004] [#6278]

 - Fix for cross-federation error message with expired SSL certificate [#6068] [#6365]

 - Fix for itree with relative path [#6075]

 - Fix for 64 bytes usernames [#6091]

 - Fix for iquest results larger than 500 [#6097]

 - Fix for resource hierarchy keywords for dataObjRepl and dataObjPhymv [#6100]

 - Fix for iquest when using 'not like' and a resource hierarchy [#6101]

 - Fix for resc_id serialization within the rule engine framework [#6123]

 - Fix for management of expiration time for tickets [#6126]

 - Fix for user_type management of admin's own account [#6127]

 - Fix for iexit removing a service account's 'session' [#6136]

 - Fix for leftover intermediate/locked state after failed 'close' operation [#6154]

 - Fix for imeta support for relative paths [#6174]

 - Fix for fixed buffer resource unit test [#6176]

 - Fix for admin remove unused metadata permission check [#6183]

 - Fix for icommands using the wrong header file [#6184]

 - Fix for permissions around iadmin lg [#6188]

 - Fix for group permissions with atomic apply metadata operations [#6189]

 - Fix for group permissions with atomic apply acl operations [#6191]

 - Fix for ils -A output for groups [#6200]

 - Fix for setup with existing non-local service account [#6246]

 - Fix for scoped_client_identity for federation [#6268]

 - Fix for rule engine framework fallthrough error handling [#6286]

 - Fix for client API allowlist documentation [#6295]

 - Fix for documentation of service account JSON [#6298]

 - Fix for delay server task race condition [#6323]

 - Fix for delay server logging a stacktrace for default config values [#6327]

 - Fix for ifsck and not-registered files [#6367]

 - Fix for agent stop failure leaving a replica in a locked state [#6378]

 - Fix for missing database_mod_data_obj_meta PEP [#6385]

 - Fix for iCommands not disconnecting on authentication failure [#6390]

 - Fix for irm permissions inconsistency [#6428]

 - Fix for itouch to return correct error codes [#6434]

 - Fix for itouch and non-existent data object [#6479]

 - Fix for ownership of delay rules run by remote users [#6482]

 - Fix for slow imkdir with Postgres due to subquery [#6495]

 - Fix for status after stage-to-cache fails [#6502]

 - Fix for segmentation fault while clearing replica token [#6611]

 - Fix for closing L1desc entries incorrectly calling PEPs [#6622]

 - Fix for missing users from iadmin lu [#6624]

 - Fix for confusing itree errors for missing data objects and collections [#6627]

 - Fix for rstrcpy not logging source string [#6674]

 - Fix for iadmin mkzone missing error message with invalid connection information [#6675]

 - Fix for user_administration library to query information about remote users [#6680]

 - Fix for throwability with client_api_allowlist::enforce [#6708]

 - Fix for hostname maximum length [#6727]

 - Fix for iqstat -a crashing on bad input [#6740]

 - Fix for buffer overflow with extractVarNames [#6743]

 - Fix for password too long errors [#6764]

 - Fix for undefined behavior on std::memcpy() on l1desc object [#6783]

 - Fix for error code reporting [#6794]

 - Fix for assumptions about submitted rule text with unspecified rule instance [#6831]

 - Fix for collection mtime update over federation [#6842]

 - Fix for touch PEPs firing over federation [#6849]

 - Fix for potential ODR violations for API number headers [#6868]

 - Fix for sync-to-archive failure case [#6886]

 - Fix for igroupadmin setting a new user's password [#6887]

 - Fix for itouch leaving S3 replica in a locked state [#6880]

 - Fix for iget not returning specified replica [#6896]

 - Fix for missing GenQuery || operator with DATA_RESC_HIER [#6912]

 - Fix for msiAddKeyValToMspStr handling of empty strings [#6918]

 - Fix for correctly sending stale replica when requested [#6926]

 - Fix for unused header in itree [#6949]

 - Fix for native rule engine plugin list objects integer handling [#6991]

 - Fix for compound resource replica permission behavior [#6997]

 - Fix for SQL statement leaks (too many concurrent statements) [#7050]

### Refactors / Packaging / Build / Test / Wontfix

 - Document imeta syntax for IN queries [#3062]

 - Add new build/test options [#6020]

 - Update documentation for ifsck and multiple paths [#6051] [#6626]

 - Package unit tests [#6164] [#6219]

 - Skip auto-generated tests in test_all_rules [#6169]

 - Rename atomic filesystem API functions [#6171]

 - Split test_catalog suite [#6181]

 - Add tests for tickets with rodsusers [#6189]

 - Update packaging message with CentOS7 [#6192]

 - Improve debian 'provides' definitions [#6261]

 - Add test for irepl -U and stale zero byte replicas [#6285]

 - Skip NREP tests when NREP status is not known [#6344]

 - Update documentation about replica statuses [#6389]

 - Wontfix: reLog files missing timestamps [#6402]

 - Scope error for API constants [#6448]

 - Update for CentOS7 git version [#6455]

 - Update build for CMake Version and LINK_LANGUAGE [#6511]

 - Update documentation for binary package installation [#6559]

 - Update documentation for psqlodbc log files [#6563]

 - Fix memory leak in packstruct unit test [#6645]

 - Update documentation for maximum_size_of_delay_queue_in_bytes [#6661]

 - Add test functionality to detect if files exist [#6690]

 - Fix for duplicate function definition [#6741]

 - Allow client and server-side implementations in same translation unit [#6782] [#6829]

 - Expose filesystem header functions [#6832]

 - Testing replica_exists with a logical path [#6838]

 - Document how to use spLogSql [#6839]

 - Document and test groupadmin capabilities [#6885] [#6888]

 - Document missing specific query DataObjInCollReCur for MySQL [#6900]

 - Update mock archive to use irv::calculate() [#6947]

 - Update iquest documentation for uppercase comparisons [#6948]

 - Update irule documentation of %-separator between multiple variables [#6952]

 - Fix topology tests [#6976]

 - Update compound resource to use replica status rather than voting [#7002]

 - Add unit test for scoped_permission [#7032]

 - Update itree help text with large collection warning [#7041]

### Deprecated

 - Deprecate unused members of l1desc_t [#6754]

### Removed

 - Remove nanodbc library dependency from delay server [#6851]

 [Full GitHub Listing](https://github.com/irods/irods/issues?q=milestone%3A4.2.12)

## 4.2.11

Release Date: 2021-12-18

This release represents a focused effort to fortify the 4.2.x series prior to getting iRODS 4.3.0 out the door next year.  This is highlighted by effort to restrict memory usage by the delay server, reduce leaks in the rule engine plugin framework, specifically when used by the Python rule engine plugin, better ticket support for multiple APIs, and a new iCommand, `itree`.  Edge cases around proxy users and streaming of files to particular resources were better defined and fixed.

Significant build and packaging work helped provide more consistent package names and clearer relationships between the various packages we produce.

Notable bug fixes include correcting voting and sync_to_archive within a compound resource, proper server redirection in a couple cases, and correct behavior when using concurrent connections to the same data object that already has multiple replicas.

Alongside the server, the s3 resource plugin's new 'Glacier' compatibility has been tested with Amazon's S3 and Fujifilm's Object Archive.

This release consists of [120 commits from 9 contributors](https://github.com/irods/irods/compare/4.2.10...4.2.11)
and [closed 124 issues](https://github.com/irods/irods/issues?q=milestone%3A4.2.11).

The latest binary packages for CentOS7, Ubuntu16, and Ubuntu18 are available at <https://packages.irods.org/>.

### Enhancements

 - Mark package conflicts more completely [#5748]

 - Add support for proxy user scenarios to the client_connection library [#5754]

 - Add better itouch error when a non-leaf resource is named [#5771]

 - Add itree iCommand [#5786] [#5824]

 - Add library for temporary permissions [#5814]

 - Add server option to limit memory usage of the delay server [#5822]

 - Add SNI support for remote iRODS server connections [#5832]

 - Add configurable hostnames option to run_tests.py [#5842]

 - Add support for targeting specific replicas while streaming [#5851]

 - Add better reporting of ignored parameters [#5890]

 - Add efficient serialization for KeyValPairs [#5906] [#5931]

 - Add admin flag to ticket API and iticket [#5933]

 - Add missing serializations [#5950]

 - Add case-insensitivity to query iterator [#5974]

 - Add memory alignment for fixed-size buffers [#5982] [#5993] [#6017] [#6019]

### Bug Fixes

 - Fix for honoring inheritance for icp [#3032]

 - Marked as resolved/invalid [#3194] [#3392] [#4113] [#4123] [#4224] [#4332] [#4333] [#5447] [#5625] [#5770] [#5779] [#5841] [#5880] [#5903] [#5922] [#5936] [#6046]

 - Removal of deprecated 'register' keyword [#3857]

 - Fixes for 'ireg --repl' [#4206] [#4622] [#5265]

 - Disallow remote groups [#4231]

 - Fixes for imeta [#4458] [#5316]

 - Marked as question answered [#4590] [#5840] [#5857] [#5867] [#5943] [#5949] [#5979] [#6005] [#6007] [#6041] [#6061]

 - Fix for creating collection in root collection [#4621]

 - Fixes for memory leaks [#4649]

 - Fixes for rebalance [#5110] [#5227]

 - Fix for GenQuery boundary and ilsresc [#5155]

 - Fix for iuserinfo [#5467]

 - Fix for ils with three or more paths [#5502]

 - Fix for parsing delayed execution frequency [#5503]

 - Fix for delay queue test [#5526]

 - Fix for voting and pre-existing replicas [#5548]

 - Fix for GenQuery column indices [#5566]

 - Fix for schema_name inconsistency [#5630]

 - Fix for build options [#5644]

 - Fix for control plane using hosts_config information [#5700]

 - Fix for accidental string concatenation [#5721]

 - Fix for iticket expiration timestamps [#5736]

 - Fixes for filesystem library [#5750] [#5813]

 - Document installation information [#5757]

 - Fix for redirection with apostrophe in data object name [#5759]

 - Fix for iget leaving object in stale state [#5760]

 - Fix for redirection determination API endpoints [#5761]

 - Fix for itouch when connected to catalog consumer [#5774]

 - Fix for icommands incorrectly requiring irods-server [#5776]

 - Fix stderr microservice [#5791]

 - Fix for server-to-server connections [#5838]

 - Fix for ichksum --verify [#5843]

 - Fix for userspace tarball of icommands [#5845]

 - Fix for archive-only retrieval via compound resource [#5847]

 - Fix for opening multi-replica data object with multiple connections [#5848]

 - Fix for dstream [#5850]

 - Fix for irods-externals elasticlient [#5860]

 - Fix for 'iadmin modresc' [#5861]

 - Fix for default_transport library [#5862]

 - Fix for ctime/mtime consistency [#5863]

 - Fix for key_value_proxy library [#5865]

 - Fix for passthru context error [#5883]

 - Fix for copy across federation [#5894]

 - Fixes for negotiation keys [#5917] [#5923]

 - Fix for chkAllowedUser() [#5928]

 - Fix for GenQuery and ticket times [#5929]

 - Document msiSetACL recursive flag better [#5940]

 - Fix for crash when not using irods rule language plugin [#5968]

 - Fixes for delay rule deletion [#5976] [#5977]

 - Fix for shared memory filename collision [#6006]

 - Fix for CI build hook installation order [#6011]

 - Fix for ilsresc -z [#6022]

 - Fixes for univmss [#6023] [#6030]

 - Fix for msisync_to_archive [#6029]

 - Fix for stopping an already stopped server [#6053]

### Refactors / Packaging / Build

 - Consistent package filenames [#3454] [#5937]

 - Delegate more CMake work to irods-dev(el) package [#5250]

 - Replace bzero with memset [#5563]

 - Better separate development dependencies [#5758]

 - Externalize to_bytes_buffer function [#5768]

 - Use CMake more consistently [#5827]

 - Capture path of irods-externals spdlog [#5876] [#5881]

 - Remove libirods_server from icommands userspace packages [#5885]

 - Better declare package relationships [#5909] [#5918]

 - Better package dependencies [#5962] [#5963]

 [Full GitHub Listing](https://github.com/irods/irods/issues?q=milestone%3A4.2.11)

## 4.2.10

Release Date: 2021-07-27

This release includes a few bugfixes, most importantly a fix for a 32bit value which limited downloads to files smaller than 2GB.

This release consists of [11 commits from 5
contributors](https://github.com/irods/irods/compare/4.2.9...4.2.10) and
[closed 14 issues](https://github.com/irods/irods/issues?q=milestone%3A4.2.10).

The latest binary packages for CentOS7, Ubuntu16, and Ubuntu18 are available at <https://packages.irods.org/>.

### Enhancements

 - Updates to CMake build system [#5220]

 - Limit redirection in data_object_finalize [#5689]

### Bug Fixes

 - Marked as resolved/invalid [#2060] [#5171] [#5718] [#5730] [#5747]

 - Fixes for spelling errors [#5698]

 - Fixes for uninitialized bytesBuf structs [#5699]

 - Fix for 32bit limitation in rsDataObjRead() chunking [#5709]

 - Fix for correctly setting buffer length on zero-length gets [#5723]

 - Fix for removing C++ header from C-only API [#5731]

 - Fix to prevent use of already-released L1 descriptor [#5744]

 [Full GitHub Listing](https://github.com/irods/irods/issues?q=milestone%3A4.2.10)

## 4.2.9

Release Date: 2021-06-07

This release represents the single biggest refactorization of internal iRODS server code since
the run up to 4.2.0 more than five years ago.  The main thrust of this work was to provide logical locking
to data objects to increase concurrency support and eliminate race conditions on in-flight
data transfers.  Supplemental work involved new libraries and APIs for parallel transfer,
replicas, users and groups, metadata, checksums, resources, and catalog operations.

Jobs put into the delay queue can now be prioritized and the jobs' context information has been moved into the
iRODS catalog to provide a path forward for more distributed execution of delayed jobs in future releases.

DNS lookups and hostname caching has also been included which significantly reduces DNS traffic from iRODS.

The iCommands can now be more easily installed into HPC and other non-root environments with supported
userspace packaging.

Notable bugfixes include work on the XML protocol, the continuation functionality in the rule engine plugin
framework, and many improvements for istream, imeta, and iphymv.  Two functions have been marked as deprecated.

This release consists of [338 commits from 8
contributors](https://github.com/irods/irods/compare/4.2.8...4.2.9) and
[closed 314 issues](https://github.com/irods/irods/issues?q=milestone%3A4.2.9).

The latest binary packages for CentOS7, Ubuntu16, and Ubuntu18 are available at <https://packages.irods.org/>.

### Enhancements

 - Add rule priority to delayed rules [#2759]

 - Move delay server context into database [#3049] [#4428] [#5153]

 - Add tests for partial copying via istream [#4698]

 - Replication to hierarchies [#3217] [#4686]

 - Refactor iphymv [#3490] [#4212] [#4563] [#4896] [#5070] [#5177] [#5360] [#5446] [#5454]

 - New msiTouch, itouch, and touch API plugin [#4669] [#4694] [#5152]

 - Refactor checksum API [#3091] [#3282] [#3540] [#5251] [#5252] [#5263] [#5285] [#5288] [#5400] [#5401] [#5496]

 - Add SHA1, SHA512, ADLER32 hashing functions [#3800] [#5392]

 - Add logical locking [#1781] [#3848] [#4170] [#4236] [#4433] [#4958] [#5312] [#5421] [#5486] [#5495] [#5542]

 - Add client support for updating mtime of collections [#4190]

 - New data_object_finalize API plugin [#2719] [#4331] [#5672]

 - New parallel transfer library [#4336] [#4969] [#4970]

 - Add intermediate replica status [#4343] [#4464] [#5018] [#5160] [#5314] [#5478] [#5504] [#5675]

 - Add new msiAddRErrorMsg microservice [#4463]

 - Support iget options as directives, not preferences [#4475]

 - Add case-insensitive search to ilocate [#4761]

 - Tie query processor size to the future object [#4902]

 - Unify storage resource voting [#4941]

 - Allow query builder to clear specific query arguments [#4960]

 - Support DATA_SIZE_KW in rsyncUtil and rcDataObjPut [#4987]

 - istream can now target resources/replicas and calculate checksums [#5000]

 - New atomic_apply_acl_operations API plugin [#5001]

 - Give proper names to anonymous C types [#5003]

 - New replica_open API plugin [#5004] [#5418]

 - New replica_close API plugin [#5005] [#5039] [#5195]

 - New msi_atomic_apply_acl_operations microservice [#5006]

 - New catalog operations library [#5011]

 - New resource administration library [#5020]

 - Add RESOURCE_SKIP_VAULT_PATH_CHECK_ON_UNLINK resource property [#5030]

 - Add IRODS_QUERY_ENABLE_SERVER_SIDE_API macro [#5033]

 - Add IRODS_FOR_DOXYGEN macro [#5037]

 - Add error() and state() system microservices [#5043]

 - Improved client-side collection iterator performance [#5049]

 - Make connection_proxy objects default constructible [#5052]

 - Add ability for irods::hierarchy_parser to add parent [#5057]

 - Tightened use of filesystem::last_write_time [#5061]

 - Merge update_collection_mtime rule engine plugin into server [#5063]

 - Can now build iCommands as a portable userspace tarball for deployment [#5082]

 - Document the user group administration library [#5086]

 - Add client_connection class [#5088]

 - Add replica library [#5103] [#5139] [#5142] [#5143] [#5150] [#5151] [#5156] [#5592]

 - Add data_object_proxy and replica_proxy classes [#5104]

 - Streamline filesystem library [#5118]

 - Expose additional columns to GenQuery [#5132]

 - Add registration checking functions to filesystem library [#5133]

 - Add is_special_collection function to filesystem library [#5134]

 - New metadata library [#5137]

 - Serialize additional structures within the Rule Engine [#5164] [#5408]

 - Optimize building the server for speed [#5223]

 - Add resource_manager overloads for easier error handling [#5236]

 - Delay server, istream, itouch report cleanly to ips [#5264] [#5269] [#5272]

 - Migrate from TravisCI to GitHub Actions [#5302]

 - Set FILE_PATH_KW correctly to support decoupled naming in S3 [#5323]

 - Make scripts output more consistent [#5363]

 - Add DNS lookup and hostname caching [#4911] [#5404] [#5406] [#5557]

 - Add replica access table functionality [#5405] [#5412]

 - Isolate public API of packStruct [#5425]

 - Add two file descriptor microservices [#5431]

 - Clean any S3 shared memory on server startup and shutdown [#5451]

 - Refactor CPP default rule engine plugin for policy composition [#5469] [#5515]

 - Remove usage of PHYOPEN_BY_SIZE_KW in server [#5494]

 - Add capability for ils to skip printing contents of a collection [#5506]

 - Add function to check existence of a server property [#5556]

 - Update default install to use max 4 threads [#5654]

 - Update MySQL development default to skip local socket connection [#5668]

### Bug Fixes

 - Fix packaging issues [#826] [#837] [#3654]

 - Document maximum host name length [#2777]

 - Document ils output [#2840] [#4305]

 - Marked as resolved/invalid or wontfix [#3073] [#3074] [#3077] [#3287] [#3288] [#3837] [#3880] [#4887] [#4948] [#4981] [#5029] [#5045] [#5075] [#5078] [#5097] [#5188] [#5235] [#5274] [#5307] [#5351] [#5472] [#5523] [#5527]

 - Fix for --purgec option and bulk transfer [#3094]

 - Document irm, irmtrash and physical directories [#3124]

 - Fix for missing inline keyword [#3396]

 - Fix for ifsck when it does not have enough permissions [#3428] [#5358]

 - Fix for CMake IRODS_LINUX_DISTRIBUTION_VERSION_CODENAME [#3453]

 - Fix for replication to resource with existing replica [#4010]

 - Fix for delay() not honoring suffixes [#4055]

 - Fix for iput to non-existent resource [#4084]

 - Fix for packStruct to follow XML encoding standards [#4132]

 - Fix for resource name substring bug during rebalance [#4135]

 - Fix for reading from disk past catalog data size [#4195]

 - Ignore the update flag for replication [#4462]

 - Fix for unchecked variable [#4550]

 - Fix for running setup_irods.py with existing database tables [#4602]

 - Fix for iscan when it does not have enough permissions [#4613]

 - Fix for iquest when 'select' used in an argument string [#4697] [#5178]

 - Added test for SQL error when writing via ticket [#4744]

 - Fix for unauthorized icp which left unmanaged data in vault [#4748]

 - Fix for zero-length files not triggering replication [#4779] [#5193]

 - Fix for key_value_proxy::handle API [#4903] [#4972]

 - Fix for duplicate access to logging file descriptor [#4943]

 - Fix for testing via logging, move to metadata in catalog [#4949]

 - Include correct headers [#4954]

 - Fix for pluggable_rule_engine documentation [#4967]

 - Update streaming to not require the force flag [#4971]

 - Document federation between 3.x and 4.x [#4974] [#4978]

 - Fixes for istream [#4986] [#5107] [#5112] [#5187] [#5189] [#5279] [#5294] [#5306] [#5422] [#5477]

 - RULE_ENGINE_SKIP_OPERATION should not skip Post-PEPs [#5002]

 - Fix index usage in msiExtractTemplateMDFromBuf [#5010]

 - Fix for missing O_TRUNC flag for puts [#5012]

 - Replaced C header with C++ header [#5014]

 - Add test for except PEP firing across federation [#5017]

 - Fixes for imeta [#5021] [#5081] [#5101] [#5102] [#5111] [#5184] [#5185] [#5186] [#5518] [#5541]

 - Fix for iscan limiting filenames to 256 characters [#5022]

 - Fix for incorrect reuse of session properties [#5046]

 - Fix for missing 'const noexcept' [#5048]

 - Fix for the connection pool [#5053]

 - Fix for duplicate error symbol in rodsErrorTable [#5056]

 - Fix rebalance PEP documentation [#5062]

 - Fix extraneous logging [#5064]

 - Fix for incorrect reuse of logical path on reused connection [#5072]

 - Fix for detecting empty hostnames [#5085]

 - Fix for documentation of client_connection [#5092]

 - Fixes for returning stale column output [#5099] [#5115]

 - Fixes for irods::filesystem return good replica information [#5105] [#5116] [#5117] [#5119] 

 - Fixes for filesystem function signatures [#5140]

 - Fix for dereferencing std::optional [#5141]

 - Fix for opening replicas of existing data objects [#5157]

 - Fix for izonereport not including resc_id information [#5159] [#5170]

 - Fix for rsDataObjRepl not returning errors from rsDataObjClose [#5179]

 - Fixes for build system [#5198] [#5212] [#5213] [#5232] [#5233] [#5301] [#5311] [#5317] [#5354]

 - Fix for iuserinfo use after free [#5214]

 - Fixes for memory leaks [#5216] [#5299] [#5319] [#5337] [#5338] [#5339] [#5340] [#5341] [#5366] [#5367] [#5368] [#5369] [#5370] [#5371] [#5372] [#5373] [#5374] [#5657]

 - Document tcp_keepalive_time usage for long idle connections [#5218]

 - Fix for leftover rulefile pid files [#5224]

 - Fix for iinit [#5239]

 - Fix for updating delayed rule last_exe_time when run by rodsuser [#5257]

 - Fix for setup_irods.py to not start the server, leave it to systemd [#5275]

 - Fix for POSIX semantics in streaming interface [#5315] [#5546]

 - Add test to confirm reading past end of file is prohibited [#5352]

 - Fix for setup_irods.py consistency [#5361]

 - Fix for vault management during trim or remove [#5362]

 - Fixes for irodsctl verbosity [#5383] [#5386]

 - Fix for nanodbc packaging [#5389]

 - Fix for extra logging from rule engine plugin framework [#5413]

 - Quiet logs when interacting with nonexistent data objects [#5419] [#5444]

 - Fix for unchecked input [#5420]

 - Disable Xmsg tests [#5424]

 - Fix for missing force flag when handling bundle files [#5426]

 - Fix for unlimited rError stack size [#5427]

 - Fix for API plugins triggering too much policy [#5437]

 - Fix for irm with force flag [#5438]

 - Fix for renaming local zone [#5445]

 - Fix for msiRenameCollection to only rename collections [#5452]

 - Fix for overwriting within special collections [#5457]

 - Updated HEARTBEAT documentation [#5484]

 - Fix for overwriting large file with smaller file [#5505]

 - Fix for JSON in bytesBuf when using XML protocol [#5520]

 - Clarify iadmin rmresc error message [#5545]

 - Fix for empty pep_database_reg_data_obj_* fields [#5554]

 - Quiet logs for chlSetAVUMetadata [#5570]

 - Fix for put operation being able to create additional replicas [#5575] [#5691]

 - Fix for put-specific checksum code running against tape [#5576]

 - Fix for failure to move packedRei files during upgrade [#5577]

 - Fix for race condition in testing suite [#5605]

 - Fix for potential use-after-free [#5613]

 - Check for empty attribute and values in atomic_apply_metadata_operations [#5618]

 - Fix for filesystem collection iterator [#5660] [#5661]

 - Fixes for using Oracle via nanodbc [#5671] [#5672] [#5673] [#5674]

 - Fix for ibun operation in topology [#5682]

 - Fix for missing PEP calls due to compiler optimization [#5683]

 - Fix for MySQL connection information [#5684]

 - Fix for SSL test assuming CS_NEG_DONT_CARE [#5685]

 - Fix for msiRenameLocalZoneCollection [#5693]

### Deprecated

 - Deprecate msiSetMultiReplPerResc [#4407]

 - Deprecate rxSetRoundRobinContext [#4964]

 [Full GitHub Listing](https://github.com/irods/irods/issues?q=milestone%3A4.2.9)

## 4.2.8

Release Date: 2020-05-22

This release includes many enhancements to iRODS internals and the published C API, a few new C++17-enabled libraries
and iCommands (istream and iunreg), and additional flow control within the rule engine plugin framework (REPF).  Notable
bugfixes include multiple edge cases around file names, better upgrade support from 4.1.x, and a performance improvement
for rebalance.  Two microservices and two flag usages have been marked as deprecated.

This release consists of [127 commits from 8
contributors](https://github.com/irods/irods/compare/4.2.7...4.2.8) and
[closed 122 issues](https://github.com/irods/irods/issues?q=milestone%3A4.2.8).

The latest binary packages for CentOS7, Ubuntu16, and Ubuntu18 are available at <https://packages.irods.org/>.

### Enhancements

 - Define C API in the client library [#2307] [#4768] [#4832] [#4835]

 - Pass connection information everywhere [#3557]

 - Support for Ubuntu 18 packages [#3977]

 - Separate logical file descriptors from physical file descriptors [#4270]

 - Implement fallthrough in rule engine plugin framework [#4299]

 - Refactor delay server as irods::query processor [#4430] [#4616]

 - Add API to atomically manipulate multiple AVUs at once [#4484] [#4809] [#4843] [#4916]

 - Add iunreg iCommand [#4506]

 - New key_value_proxy class [#4585]

 - New lifetime_manager class [#4586] [#4712] [#4840]

 - New istream iCommand [#4626]

 - Enable C++17 [#4627]

 - New irods::administration user and group libraries [#4650]

 - Add delay scheduling to C++ default rule engine plugin [#4668]

 - Add consistency around irods::filesystem exception handling [#4726]

 - New iadmin modrepl subcommand [#4740]

 - Add support for skipping operations in rule engine plugin framework [#4752] [#4800]

 - Add '_finally' PEPs to rule engine plugin framework flow control [#4773]

 - Define error when handling POSIX open(O_RDONLY | O_TRUNC) [#4782]

 - New irods::interprocess library for shared memory objects [#4787]

 - Add support for additional database rows to be updated [#4818]

 - New irods::scoped_privileged_client for safe elevation of privilege [#4819]

 - Add boost::asio::thread_pool in irods::thread_pool [#4824] [#4833]

 - Refactor init_client_api_table() as load_client_api_plugins() [#4827]

 - New irods::scoped_client_identity library for safe user switching [#4836]

 - Never delete, only unregister non-Vault replicas [#4848]

 - New irods::with_durability library [#4867]

 - Add add_metadata function to irods::filesystem [#4890]

 - Refactor and multithread irods::query_processor [#4891]

 - Add atomic bulk metadata operations to irods::filesystem [#4898] [#4901]

### Bug Fixes

 - Fix for phymv into resource hierarchy [#3234]

 - Marked as resolved/invalid [#3235] [#4225] [#4309] [#4663] [#4823]

 - Fix for trailing slash on collections and data objects [#3892]

 - Document migration from static policy enforcement points (PEPs) to Dynamic PEPs [#4054] [#4660]

 - Document msiModAVUMetadata [#4185]

 - Document smoother migration from 4.1.x resource servers [#4307] [#4612]

 - Fix for irmtrash removing non-vault replicas [#4403]

 - Fix for orphan file creation on overwrite over the network [#4410]

 - Fix for imv on non-existent target path [#4414]

 - Fix for imeta qu ignoring the -z option [#4426]

 - Document use of epel-release repository on CentOS [#4450]

 - Fix for irepl in admin mode [#4479]

 - Fix for use of truncation [#4483] [#4628] [#4826]

 - Fix for registration of empty data object names [#4494]

 - Fix for unregistration of in-vault data object as rodsuser [#4510]

 - Fix for structFileBundle message to LOG_DEBUG [#4520]

 - Fix for trailing slash with imeta [#4559]

 - Fix for msiRenameCollection [#4597]

 - Fix for documentation location of example rules [#4625]

 - Fix for collection iterator segfault when empty [#4633]

 - Fix for irods::filesystem fallback when specific query ShowCollAcls is undefined [#4636] [#4648]

 - Fix for missing column mappings for GenQuery [#4640] [#4645]

 - Fix for irods::filesystem missing user and zone information [#4641]

 - Update dependency to avro 1.9.0 [#4642]

 - Fix for debug message during setup [#4651]

 - Update dependency to JSON 3.7.3 [#4652]

 - Fix for recursive iput [#4657]

 - Document removal of extraneous rule_engine_namespaces on upgrade [#4661]

 - Fix for supporting '_except' after upgrade [#4662]

 - Fix for USER_GROUP_NAME with GenQuery [#4672] [#4708]

 - Fix for MySQL database plugin use of 'storage_engine' [#4673]

 - Fix for imeta using relative paths [#4682]

 - Fix for passthrough rule engine plugin callback signature [#4699]

 - Fix for native rule engine plugin when returning parser error [#4700]

 - Fix for inconsistent oracle setup input file [#4706]

 - Fixes for existing tests [#4715] [#4716] [#4719] [#4724] [#4727] [#4797]

 - Fix for irods::filesystem path prefix check [#4721]

 - Fix for irods::filesystem default_transport [#4725]

 - Fix for inefficient query during rebalance [#4731]

 - Fix for icksum with query iterator [#4732]

 - Fix for irods::filesystem to disallow collection named '..' [#4750]

 - Fix for native rule engine plugin to allow positive error codes [#4753]

 - Fix for irmdir [#4788]

 - Fix for iticket [#4790]

 - Fix segfault with relative path in rsDataObjCopy [#4796]

 - Question about locking/disabling user accounts with policy [#4804]

 - Fix for supporting '_finally' after upgrade [#4817]

 - Document INST_NAME (instance name) for delay execution directive in rules [#4822] [#4897]

 - Support for testing with locally built externals [#4828]

 - Fix for substring bug in isInVault [#4839]

 - Update dependency to fmt 6.1.2 [#4846] [#4874]

 - Question about RESC_NAME in isysmeta and GenQuery [#4854]

 - Fix for rsDataObjCopy on failure to create destination replica [#4862]

 - Fix for parallel transfer using hosts_config.json [#4866] [#4875]

 - Document monitoring servers with heartbeat request [#4882]

 - Fix for mysql db plugin build dependency [#4923]

### Deprecated

 - num_repl keyword in replication resource marked as deprecated - to be removed in 4.3.0 [#3548]

 - msiSysChksumDataObj marked as deprecated - to be removed in 4.3.0.  Use msiDataObjChksum instead. [#4615]

 - msiSysReplDataObj marked as deprecated - to be removed in 4.3.0.  Use msiDataObjRepl instead. [#4658]

 - itrim -N marked as deprecated - to be removed in 4.3.0 [#4860]

 [Full GitHub Listing](https://github.com/irods/irods/issues?q=milestone%3A4.2.8)

## 4.2.7

Release Date: 2019-12-19

This release includes a number of enhancements to iRODS internals to lay the groundwork for upcoming refactoring including a new irods::query_builder library, a unit test framework, and a general purpose msiModAVUMetadata() microservice.  The bugfixes include attention to polishing the other recent libraries, large tar and zip file extraction, ticket access, upgrading with Oracle, and the Python Rule Engine Plugin.

This release consists of [46 commits from 9
contributors](https://github.com/irods/irods/compare/4.2.6...4.2.7) and
[closed 58 issues](https://github.com/irods/irods/issues?q=milestone%3A4.2.7).

The latest binary packages for CentOS7 and Ubuntu16 are available at <https://packages.irods.org/>.

### Enhancements

 - Prepare for Dockerized CI [#3475] [#4471] [#4555] [#4579]

 - Update irods::filesystem library [#3973]

 - Add Unit Testing Framework [#4072]

 - Extend irods::hierarchy_parser [#4487]

 - Add support for row offset in irods::query_iterator [#4488]

 - Add S3 error codes [#4517]

 - Add new msiModAVUMetadata() for setting/modifying full AVU [#4521]

 - Add transfer of ownership of connections via irods::connection_pool [#4566]

 - New irods::query_builder library [#4574]

### Bug Fixes

 - Fix for resource listing in ils [#1051]

 - Fix for special handling of characters in logical paths [#3060] [#4060] [#4467]

 - Marked as resolved/invalid [#3623] [#3826] [#4358] [#4427] [#4491] [#4502] [#4536] [#4565] [#4584] [#4593]

 - Fix for itrim exit codes [#4188]

 - Marked as workaround and question answered [#4077] [#4496]

 - Fix for msiTarFileExtract for large files [#4118]

 - Fix for invalid client irodsProt value handling [#4130]

 - Fix for irmdir -p [#4153]

 - Fix for possible cycles in resource hierarchy [#4363]

 - Fix for ticket access for recursive iget [#4387]

 - Fix for irods::io::dstream basic_data_object_buf segfault [#4422]

 - Fix for irods::io::dstream move semantics [#4423]

 - Fix for irods::io::dstream rdbuf() [#4424]

 - Test for fix for python rule engine plugin statement table exhaustion [#4438]

 - Fix for irods::filesystem to allow update to data object mtimes [#4441]

 - Fix for resc_id population when upgrading on oracle [#4459]

 - Fix for ils -A returning empty permissions [#4476]

 - Fix for irods::filesystem returning all permissions [#4492]

 - Fix for irods::query to allow bind arguments for specific queries [#4493]

 - Fix for ibun to unzip large files [#4495]

 - Fix for testing library [#4527]

 - Refactor of irods::filesystem::get_metadata [#4532]

 - Fix for irods::filesystem::lexically_normal to follow C++17 [#4534]

 - Fix for error handling via PASSMSG [#4537]

 - Fix for ilocate to handle spaces [#4540]

 - Fix for irods::filesystem::get_metadata [#4542]

 - Fix for irods::filesystem::parent_path to follow C++17 [#4551]

 - Fix for irods::filesystem::status during ils across federation [#4570]

 - Fix for irods::query to allow zone hint across federation [#4573]

 - Fix for documentation [#4589]

 - Fix for bytesWritten [#4598]

 - Fix for irods::query_processor [#4607]

 - Fix for irods::query_iterator handling CAT_NO_ROWS_FOUND [#4617]

 [Full GitHub Listing](https://github.com/irods/irods/issues?q=milestone%3A4.2.7)

## 4.2.6

Release Date: 2019-06-05

This release includes a few bugfixes, most notably a fix for the optimized irodsReServer introduced in 4.2.5.  It also introduces three new libraries (irods::filesystem, irods::iostreams, and irods::query_processor).

This release consists of [31 commits from 7
contributors](https://github.com/irods/irods/compare/4.2.5...4.2.6) and
[closed 27 issues](https://github.com/irods/irods/issues?q=milestone%3A4.2.6).

The latest binary packages for CentOS7, Ubuntu14, and Ubuntu16 are available at <https://packages.irods.org/>.

### Enhancements

 - New filesystem library [#4267]

 - New iostreams library [#4268]

 - New query processor library [#4369]

### Bug Fixes

 - Fix for removing data objects with certain characters [#3398]

 - Marked as wontfix or duplicate [#3692] [#4245] [#4329]

 - Marked as resolved/invalid [#3873] [#4117] [#4384] [#4402] [#4406]

 - Fix for scope, move into namespace [#3995]

 - Fix for writeLine() handling of stdout/stderr [#4279]

 - Fix for rename when post PEP is defined [#4301]

 - Fix for replication when all target resources are local [#4319]

 - Fix for log level in rodsConnect [#4322]

 - Fix for when a resource plugin should not move the physical file [#4326]

 - Fixes for collection iterator [#4340] [#4346]

 - Fix for irodsReServer exception handling [#4351]

 - Fix for collInp_t serialization into rule languages [#4370]

 - Fix for rule engine plugin framework continuation behavior [#4383]

 - Fix for libxml2 package dependency declaration [#4390]

 - Fix for ifsck for files larger than 2G [#4391]

 - Fix for dynamic pep firing order after parallel transfer [#4404]

 [Full GitHub Listing](https://github.com/irods/irods/issues?q=milestone%3A4.2.6)

## 4.2.5

Release Date: 2019-02-22

This release includes many bugfixes to things found by the community, but also introduces a few new libraries (GenQuery iterator and connection and thread pools) as well as a reimplemented irodsReServer (for delayed rule execution) and improved PEP flow control (via new `_except()` PEPs).

This release consists of [47 commits from 10
contributors](https://github.com/irods/irods/compare/4.2.4...4.2.5) and
[closed 57 issues marked 4.2.5](https://github.com/irods/irods/issues?q=milestone%3A4.2.5)
plus the last [12 closed issues included in 4.1.12](https://github.com/irods/irods/issues?q=milestone%3A4.1.12+closed%3A%3E2018-09-03+).

The latest binary packages for CentOS7, Ubuntu14, and Ubuntu16 are available at <https://packages.irods.org/>.

In addition, a deprecation has been declared for the C API function `isPathSymlink()`.  Use `isPathSymlink_err()` instead.

### Enhancements

 - Release of Oracle database plugin for CentOS7 [#3653]

 - irodsReServer reimplementation [#3782] [#4250] [#4251] [#4266]

 - Add _except() PEPs [#4128]

 - Add support for manually updating mtime of collections [#4144]

 - Add support for plugins to bundle their own tests [#4146]

 - Add support for policy continuation after a successful PEP [#4148]

 - New genquery iterator library [#4171] [#4204] [#4230] [#4240]

 - New passthrough rule engine plugin [#4179] [#4226]

 - Add database indices for resc_id and data_is_dirty [#4181]

 - New connection pool library [#4269] [#4284]

 - New thread pool library [#4271]

### Bug Fixes

 - Marked as resolved/invalid or duplicate [#2927] [#3079] [#3335] [#3645] [#3931] [#4071] [#4086] [#4098] [#4133] [#4136] [#4158] [#4161] [#4191] [#4196] [#4238]

 - Fix for icp across federated zones [#3547] [#4053] [#4057]

 - Fix for double-free in main server [#3776]

 - Fix for iput with --purgec and -k on empty file [#3883]

 - Fix for obfuscation code [#3972]

 - Fix for remote microservice [#3998]

 - Fix for irmdir [#4000]

 - Fix for unnecessary username/groupname lookup [#4040]

 - Fix for missing libxml2 dependency [#4061]

 - Fix for postinstall chown [#4109]

 - Fix for DATA_SIZE_KW in register replica API [#4119]

 - Fix fallthrough behavior for rule engine plugin framework [#4147]

 - Fix boundary condition for GenQuery results [#4157]

 - Present iRODS Error codes to iRODS rule language [#4174]

 - Fix for irule continuation error [#4189]

 - Fix for rule engine memory leak [#4197]

 - Remove OpenID-specific code from clientLogin [#4221]

 - Document REBALANCE_ALREADY_ACTIVE_ON_RESOURCE behavior [#4254]

 - Add missing header file [#4272]

### Deprecated

 - C API function isPathSymlink() marked as deprecated.  Use isPathSymlink_err() instead. [#4005]

 [Full GitHub Listing](https://github.com/irods/irods/issues?q=milestone%3A4.2.5)

 [All issues assigned to 4.1.12 are also included](https://github.com/irods/irods/issues?q=milestone%3A4.1.12).

## 4.2.4

Release Date: 2018-09-03

This is largely a bugfix release focused on irsync/iput/icp consistency and delayed/remote rule behavior.

This release consists of [44 commits from 10
contributors](https://github.com/irods/irods/compare/4.2.3...4.2.4) and
[closed 31 issues marked for 4.2.4](https://github.com/irods/irods/issues?q=milestone%3A4.2.4)
and an additional [6 closed issues to be included in the upcoming 4.1.12 release](https://github.com/irods/irods/issues?utf8=%E2%9C%93&q=milestone%3A4.1.12%20closed%3A2018-06-01..2018-09-03).

The latest binary packages for CentOS7, Ubuntu14, and Ubuntu16 are available at <https://packages.irods.org/>.

In addition, a deprecation has been declared for 'iexecmd'.

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

This is largely a bugfix release, but also adds support for generic and OpenID authentication plugins, larger rulesets, and registration of data objects to non-leaf resources.

This release consists of [122 commits from 17
contributors](https://github.com/irods/irods/compare/4.2.2...4.2.3) and
[closed 76 issues marked for 4.2.3](https://github.com/irods/irods/issues?q=milestone%3A4.2.3)
and an additional [18 closed issues to be included in the upcoming 4.1.12 release](https://github.com/irods/irods/issues?utf8=%E2%9C%93&q=milestone%3A4.1.12%20closed%3A%3C%3D2018-05-31).

The latest binary packages for CentOS7, Ubuntu14, and Ubuntu16 are available at <https://packages.irods.org/>.  Packages have not been released for CentOS6 or Ubuntu12 due to the age of those releases and their own lack of upstream support.

In addition, two deprecations have been declared, one for 'irm -n' and the other for the roundrobin resource plugin.

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

This is largely a bugfix release which addresses a few important use cases
for the community and a stronger foundation for new plugins.

This release includes support for the [iRODS Audit (AMQP) rule engine plugin](https://github.com/irods/irods_rule_engine_plugin_audit_amqp).
The Audit rule engine plugin requires upgrading to 4.2.2.

This release consists of [77 commits from 7
contributors](https://github.com/irods/irods/compare/4.2.1...4.2.2) and
[closed 39 issues marked for 4.2.2](https://github.com/irods/irods/issues?q=milestone%3A4.2.2)
and an additional [56 closed issues included in the recent 4.1.11 release](https://github.com/irods/irods/issues?utf8=%E2%9C%93&q=milestone%3A4.1.11%20closed%3A%3E2017-06-08%20).

The latest binary packages for CentOS6, CentOS7, Ubuntu12, Ubuntu14, and Ubuntu16 are available at <https://packages.irods.org/>.

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

This is largely a bugfix release which addresses many small oversights in the
4.2.0 release last November.

In addition, this release includes support for the Python rule engine plugin
(to be released later this week).  The Python rule engine plugin will require
upgrading to 4.2.1.

This release consists of [108 commits from 10
contributors](https://github.com/irods/irods/compare/4.2.0...4.2.1) and
[closed 34 issues marked for 4.2.1](https://github.com/irods/irods/issues?q=milestone%3A4.2.1)
and includes [36 closed issues marked for inclusion in the upcoming 4.1.11](https://github.com/irods/irods/issues?utf8=%E2%9C%93&q=milestone%3A4.1.11%20closed%3A%3C2017-06-08).

This release fixes [CVE-2017-8799](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-8799).

The latest binary packages are available at <https://packages.irods.org/>.

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

iRODS 4.2.0 is the product of over a year and a half of refactoring and
significant reorganization of the rule engine framework into the seventh
iRODS plugin interface.

This release consists of [951 commits from 9
contributors](https://github.com/irods/irods/compare/4.1.0...4.2.0) and
[closed 275
issues](https://github.com/irods/irods/issues?q=milestone%3A4.2.0).

All the code and current working issues are hosted at GitHub:
<https://github.com/irods/irods>

APT and YUM Repositories are available at <https://packages.irods.org>.

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

This is mainly a bugfix release which addresses various replication and iscan/ifsck issues and provides additional debugging and visibility tooling for administrators.

This release will be the last in the 4.1 series.  The 4-1-stable branch is now EOL.

CentOS6 packages are no longer supported (Our test framework requires Python 2.7+).

This release consists of [39 commits from 3 contributors](https://github.com/irods/irods/compare/4.1.11...4.1.12) and [closed 36 issues](https://github.com/irods/irods/issues?q=milestone%3A4.1.12).

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

This is a bugfix release which addresses checksum and rebalance behavior, continuation for query result sets, maintenance work with ichksum/ifsck/iscan, federation testing, and many other small issues.

In addition, this release fixes [CVE-2017-8799](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-8799).

OpenSUSE13 and POWER8 packages are no longer supported.

This release consists of [83 commits from 9 contributors](https://github.com/irods/irods/compare/4.1.10...4.1.11) and [closed 92 issues](https://github.com/irods/irods/issues?q=milestone%3A4.1.11).

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

This is a bugfix release which addresses free\_space calculation and
updating, izonereport and irods-grid behavior, dynamic PEP behavior, and
other small issues.

This is a required upgrade from 4.1.9 for multi-server Zones. Bug
[\#3306] prevented multi-server Zones from performing the free\_space
check correctly, as the calculation was executed too early (on the wrong
server). iRODS 4.1.8 is not affected by this bug.

This release consists of [42 commits from 4
contributors](https://github.com/irods/irods/compare/4.1.9...4.1.10) and
[closed 24
issues](https://github.com/irods/irods/issues?q=milestone%3A4.1.10).

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

This is mainly a bugfix release which addresses federation behavior,
default resource resolution, disk threshold behavior, and other small
issues.

It also includes support for additional functionality provided by the
libs3 plugin.

This release consists of [58 commits from 6
contributors](https://github.com/irods/irods/compare/4.1.8...4.1.9) and
[closed 38
issues](https://github.com/irods/irods/issues?q=milestone%3A4.1.9).

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

This is mainly a bugfix release which addresses SSL and authentication,
syncing and federation behavior, Oracle detection, and other small
issues.

It also includes a new 'high water mark' capability for the
unixfilesystem resource plugin allowing an administrator to protect the
resource from a 'disk full' event.

This release consists of [108 commits from 5
contributors](https://github.com/irods/irods/compare/4.1.7...4.1.8) and
[closed 60
issues](https://github.com/irods/irods/issues?q=milestone%3A4.1.8).

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

This is a bugfix release which addresses memory leaks, compound resource
behavior, development library organization, and other small issues.

This release consists of [33 commits from 3
contributors](https://github.com/irods/irods/compare/4.1.6...4.1.7) and
[closed 17
issues](https://github.com/irods/irods/issues?q=milestone%3A4.1.7).

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

This is a bugfix release which addresses resource server upgrades,
development and runtime library organization, and other small issues.

This release consists of [33 commits from 7
contributors](https://github.com/irods/irods/compare/4.1.5...4.1.6) and
[closed 24
issues](https://github.com/irods/irods/issues?q=milestone%3A4.1.6).

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

This is a bugfix release which addresses fuse, behavior after failed
queries, and other small issues. CentOS 7 support has been added.

This release consists of [33 commits from 4
contributors](https://github.com/irods/irods/compare/4.1.4...4.1.5) and
[closed 17
issues](https://github.com/irods/irods/issues?q=milestone%3A4.1.5).

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

This is a bugfix release which addresses fuse, irsync, and many small
issues.

This release consists of [63 commits from 6
contributors](https://github.com/irods/irods/compare/4.1.3...4.1.4) and
[closed 38
issues](https://github.com/irods/irods/issues?q=milestone%3A4.1.4).

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

This is a bugfix release which addresses imeta, packaging, and
run-in-place installations.

This release consists of [10 commits from 2
contributors](https://github.com/irods/irods/compare/4.1.2...4.1.3) and
[closed 7
issues](https://github.com/irods/irods/issues?q=milestone%3A4.1.3).

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

This is a quick bugfix release.

This release consists of [9 commits from 3
contributors](https://github.com/irods/irods/compare/4.1.1...4.1.2) and
[closed 4
issues](https://github.com/irods/irods/issues?q=milestone%3A4.1.2).

### Bug Fixes

  - Fix information leakage in izonereport [#2732]

  - Fix misuse of uid for gid in configuration conversion script [#2733] [#2734]

[Full GitHub Listing](https://github.com/irods/irods/issues?q=milestone%3A4.1.2)

## 4.1.1

Release Date: 2015-06-02

This is a quick bugfix release which addresses upgrades and development.

This release consists of [7 commits from 4
contributors](https://github.com/irods/irods/compare/4.1.0...4.1.1) and
[closed 5
issues](https://github.com/irods/irods/issues?q=milestone%3A4.1.1).

### Bug Fixes

  - Hardening of upgrade process against bad input [#2725] [#2727]

  - Fix for incomplete development package [#2724]

  - Fix for removing package-manager-marked config files [#2723]

[Full GitHub Listing](https://github.com/irods/irods/issues?q=milestone%3A4.1.1)

## 4.1.0

Release Date: 2015-05-29

iRODS 4.1.0 represents a significant step forward for iRODS technology
as it incorporates a set of new fundamental features and bug fixes.

This release consists of [1745 commits from 8
contributors](https://github.com/irods/irods/compare/4.0.3...4.1.0) and
[closed 377
issues](https://github.com/irods/irods/issues?q=milestone%3A4.1.0).

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

