## 3.3.1

Release Date: 2014-02-24

The following is a brief summary of the additions and improvements made to iRODS 3.3.1 compared to the previous version, 3.3.

As usual, this release contains many new features developed in response to needs expressed by the user community and which supplement the base iRODS functionality in various ways. Each is very important to some sites but may be unneeded by others and can be configured and used as needed.

### New Features

 - **Security Vulnerabilities Fixed.** A related set of security vulnerabilities have been analysed and various fixes applied. A work-around for 3.3 and earlier versions of iRODS is described on the the irod-chat thread 'Configuration change needed for secure operation' but installing 3.3.1 is recommended as a more complete solution. As is best practice for vulnerability responses, details were kept confidential and response information carefully disseminated. Also see the Secure_Installation page that was developed as part of this. Thanks to the NASA NCCS computer security team for finding and reporting these problems and making some recommendations.
 - **SHA2 File Hashes** SHA2 (SHA256) can now optionally be used for the iRODS data-object (file) hashes, informally called 'checksums'. MD5 is still the default and is available for backward compatibility. The File_Hashes page describes command-line options and the build procedure to enable. This was SVN revision r5612 and many others.
 - **FUSE symlink** The FUSE client now supports symlinks. iRODS provides the capablity of symlinks but was not supported by FUSE in previous releases. So the FUSE command for creating symlink would not work. In this release this feature is supported.
 - **Add simple json parsing microservices, requires jansson** Microservices for parsing JSON objects are added to the URL module. This feature requires jansson.
 - **Rule language** Support for looping over keyValPair_t is added to foreach. Variables or expressions can now be used as keys in the dot expression. A "temporaryStorage" object is added to the rule language. It is a keyValPair_t which is valid throughout the whole irodsAgent process. Language integrated gen query now supports the "order" keyword.
 - **Much improved performance of 'ichmod -r' at scale.** The ICAT code now uses SQL that creates and uses a temporary table to significantly improve the performance of the recursive ichmod command. Previously, these operations could be quite slow for iRODS instances where large numbers of access-control rows, users, and data-objects were being used. This is implemented for Postgres only, for now, but this approach is likely to benefit MySQL and Oracle too and it is hoped that testing with them can be done soon. Thanks to iPlants staff for providing a copy of their ICAT DB (minus the password table, of course) for extensive testing at DICE-UCSD. Also see the Postgresql Tuning page for an introduction to Posgresql tuning developed as part of this. Also see the SVN log message (r5640) for more information.
 - **Improved performance for some 'ticket' operations at scale.** Three SQL statements in the ICAT component (in icatMidLevelRoutines.c) used in handling tickets have greatly improved performance now. A subtle problem with cross joins is now avoided by using some sub-queries on 3 SQL statements. Without these there could be significant memory and processor loads when run in large ICAT instances. Thanks to Tony Edgin of iPlant for these improvements. See svn commit r5537 and r5438 for more.
 - **New igroupadmin mkgroup sub-command.** Groupadmins can now create and manage new groups. To perform other groupadmin operations, the restrictions are as they were before, the user must be of type 'groupadmin' and be a member of the group. But with these changes, the groupadmin is allowed to create a group and there's a 'igroupadmin mkgroup' command to do so. Also, a user of type 'groupadmin' is allowed to add themselves to a group as long as that group currently has no members. Thus the groupadmin still has fairly limited powers but can now create and manage new groups. This was requested by Sanger. See irod-chat thread 'Group administrator' for the discussion.
 - **Easier setup for interzone server authentication.** The logic was modified so that when a SID (server ID) is defined (LocalZoneSID or RemoteZoneSID) it will, by default, require that the remote server authenticate itself (also have the LocalZoneSID defined). This makes it easier to enable server authentication as you no longer need to also update a define (requireServerAuth 0) and rebuild to make sure that the remote server authenticates itself. This was recommended in email discussion with Michael Keller of the U of Canterbury. Also see recent updates to the Server Authentication page on irods.org. This was SVN revision r5591.
 - **Mods for Hadoop File System 1.2.1.** The HDFS driver has been tested with the new hadoop release and is now compatible with version 1.2.1. Testing was also done to confirm that more than one HDFS system can be used and that they can be used for moving files between each other. These were SVN revsions r5607-r5611.
 - **Workflow Structured Object (WSO) driver extensions.** Extensions have been made to the Workflow Structured Object (WSO) driver to handle workflows calling other workflows. Sample tests are available in the icommands/test/rules3.0 directory.
 - **Software Defined Networking support.** Two policy enforcement points are added to pre and post parallel transfer. As demonstrated at SC'13, iRODS can be configured to make use of SDNs. See the Software Defined Networks page for more.
 - **acPreProcForExecCmd parameter changes.** acPreProcForExecCmd now has extra parameters which match those of msiExecCmd. Rules written for the previous releases should be upgraded in core.re. See the core.re file for details.
 - **ac(Pre)PostProcForModifyAVUMetadata refactored.** acPreProcForModifyAVUMetadata and acPostProcForModifyAVUMetadata have been refactored into three rules for different imeta commands and to make sure that the arguments align with the parameters, based on Tony Edgin's suggestions. Rules written for the previous releases should be upgraded in core.re. See the core.re file for details.
 - **FUSE Client bug fixes.** Several bugs have been fixed for the FUSE client.

### Bug Fixes and Other Features

 - **Improved 'iinit' handling of missing environment variables.** If PAM or GSI is enabled and iinit creates some missing .irodsEnv information (perhaps the whole file), it now also prompts for and sets irodsAuthScheme. Since password is default, it will not prompt if the auth scheme is the only setting that is missing, but otherwise, if GSI and/or PAM is enabled it will prompt for the ones available and set the authentication scheme in the user's .irodsEnv file for them. This was suggested by Andreas Lindqvist and Giacomo on irods-chat, This was SVN revision r5581.
 - **GSI fixes for Mac Installation.** For Macs, when GSI is enabled, irodssetup will now use 'lib' as the Globus directory even on 64-bit hosts. For other OSes, it continues to use lib or lib64. This was suggested by Petr Danecek on irods-chat. This was SVN revision r5584.
 - **rsModAccessControl.** rsModAccessControl was changed to call acPostProcForModifyAccessControl only if the chlModAccessControl call succeeds. This was recommended by Tony Edgin of iPlant on irods-chat. r5585
 - **New Error Message for missing acCheckPasswordStrength.** A more specific error message is now returned to the user when the acCheckPasswordStrength rule does not exist. This was suggested by Pete Clapham of Sanger. This was SVN revision r5587.
 - **ModAVUMetadata rule called only on success.** rsModAVUMetadata was changed to call acPostProcForModifyAVUMetadata only if the chlSetAVUMetadata call succeeds. This was recommended by Tony Edgin of iPlant on irods-chat and matches a recent change for rsModAccessControl. A correction to the initial DICE update was provided by Dennis Roberts also of iPlant. These were SVN revisions r5588 and r5593.
 - **irodsctl.pl fix for logging intervals.** A check was added for the environment variable set for LOGFILE_INT/logfileInt in irodsctl.pl so that the interval days for log files works. There's a 'define LOGFILE_INT "logfileInt"' which is used in the server C code so this script needs to set environment variable 'logfileInt', not 'LOGFILE_INT'. It looks like this was never working properly in irodsctl.pl when implemented (r3878 mwan 2011-03-28). The logfileInt feature was implemented long before that and so was likely working fine, it was just the irodsctl.pl setting that failed. Thanks to Robert Verkerk of surfsara.nl for finding, reporting, and providing a fix for this problem. This was SVN revision r5595.
 - **Updated Databook Rules.** An update to datebook rules was done, to change the message format to be consistent to the new Databook Java code. This was SVN revision 5467.
 - **irodssetup now handles additional ODBC installation locations.** A subscript in 'irodssetup' will now look for and use a system-installed (package manager) ODBC library (.odbc.ini Driver) in additional places as needed for certain platforms and postgresql/odbc versions. The case in question was on CentOS 6.4. See the irod-chat thread 'irods 3.3 and external postgres 9.2 database' for more information. This was SVN revisions r5519 and r5520.
 - **Bug fix for when there are large numbers of temporary passwords.** Logic was extended to handle more than a preset limit of temporary passwords better. If this now happens, the temporary passwords will get removed on a later iteration. These were SVN revisions r5550 and r5596.
 - **imeta exit code improvements.** Changes were made to imeta so it will not exit with 0 when the user asks for metadata of a non-existent object. This also included some bug fixes where the code is determining if the object exists or not. Tests were also updated to cover this. This exit code change was requested by Sanger. This was SVN revision r5551.
 - **Change iquest so it will exit with 0 (success) when the user's query results in no rows but is otherwise OK.** This was also requested by Sanger staff. This was SVN revision r5552.
 - **A fix for building with GSI on MAC OSX.** Thanks to Peter Danecek of the National Institute of Geophysics and Volcanology (INGV) of Italy for this fix. This was SVN revision r5553.
 - **Fix a double-free agent segfault when the user tries to replicate a data-object to a resource that already has a valid copy.** This was discovered by RENCI and a fix was provided which was then improved by DICE. This was SVN revision r5571.
 - **Additional iadmin mkresc check.** For 'iadmin mkresc' if the user enters an empty string as the resource name, it will now return an error. Once created, it's difficult to remove. This was reported in email from a site.
 - **Safer PATH recommendation.** Changes were made to the irodssetup recommendation on setting the PATH to put the new i-commands directory at the end of the PATH.
 - **Addition to clientLoginWithPassword.** Code was added to clientLoginWithPassword, matching that in clientLogin, to save a signature of the session challenge for use in changing another's password. This signature is needed for the administrative function of changing another user's password. The problem is not seen in iadmin since it uses clientLogin. The clientLoginWithPassword code, including this change, is exercised via one of the ICAT tests under 'devtest' but only to confirm that it can successfully log in. To verify that this change works, I made a temporary change to iadmin.c to call clientLoginWithPassword instead of clientLoging and I verified that without this fix it does fail (gets a CAT_PASSWORD_ENCODING_ERROR error) and with this fix it seems to work fine. This was reported in bugzilla item 167 and was SVN revision r5626.
 - **irods_completion.bash script fix.** The irods_completion.bash script was converted to Unix format as somehow it was DOS (CRLF). Thanks to Giacomo for noticing and reporting this. This was SVN revision r5628.
 - **Documented a problem in imv where moving and renaming in a single imv command is not always allowed.** The 'imv -h' help text now explains the problem and workaround. This is Bugzilla item 165 and SVN revision r5594.
 - **iadmin changes for interzone setup.** iadmin help text was updated to explain that a remote zone definition needs to specify the IES, not a non-IES. When a non-ICAT-Enabled-Server is used, the error returned to remote zone users trying to connect is CAT_INVALID_USER (even if they have a valid local user account defined). This is inaccurate and misleading but it would be difficult to do better (to determine if this is caused by a non-IES remote zone definition). What happens to the server is non-fatal, but prevents proper authentication. Hopefully, this warning in the iadmin help text for mkzone and modzone will be sufficient. This was SVN revision r5639.
 - **Tests updated** The 'devtest' and related test suites have been updated to cover many of the new 3.3.1 capabilities and bug fixes. The DICE Tinderbox continuous build/test system has been extended to include a daily sha2 file hash build/test. See the revised Testing iRods for more. Although not part of the release itself, this is closely related.
 - **Other bugs.** As usual, a number of additional bugs were fixed.
 - **Compiler warnings fixed.** As usual, some fixes were made in avoid compiler warnings on some platforms.

**Upgrading from 3.3 to 3.3.1:** Note that no patch to the iCAT database is required in support of the new features but server/icat/patches/patch3.3to3.3.1.sh should be run to define some new specific-queries (see the script for more information). The 'irodssetup --upgrade' (equivalent to 'irodsupgrade') script will warn and prompt you about this. The 3.3.1 clients will work properly with a 3.3 server except, of course, when a new feature is involved. To install, unpack the tar file, cd iRODS and run './irodssetup' or './irodsupgrade'.

### Additional Credits
Some of the development done for the iRODS 3.3.1 release was supported by the DataNet Federation Consortium, NSF grant #0940841 "DataNet Federation Consortium". The development support included:

 - Much improved performance of 'ichmod -r' at scale
 - Improved performance for some 'ticket' operations at scale
 - Updated DataBook rules
 - Hadoop File System upgrade
 - Part of the enhancements for SHA2 file hashes
 - FUSE symlink and bug fixes
 - json parsing micro-services
 - Software Defined Networks support
 - Rule Language updates
 - acPreProcForExecCmd and ac(Pre)PostProcForModifyAVUMetadata changes

The other items in the iRODS 3.3.1 release that were developed by the DICE group were supported by the NSF grant #1032732, "SDCI Data Improvement: Improvement and Sustainability of iRODS Data Grid Software for Multi-Disciplinary Community Driven Application".

### Future Releases

This is likely to be the last release of iRODS from the DICE group. The next planned release is iRODS 4.0 which will be a merger of the E-iRODS branch with iRODS 3.3.1 which will be released by the RENCI iRODS team and supported by both RENCI and DICE. See the iRODS_and_E-iRODS_Merger_Plan for more information.

## 3.3

Release Date: 2013-07-17

The following is a brief summary of the additions and improvements made to iRODS 3.3 compared to the previous version, 3.2.

As usual, this release contains many new features developed in response to needs expressed by the user community and which supplement the base iRODS functionality in various ways. Each is very important to some sites but may be unneeded by others and can be configured and used as needed.

### New Features

 - **Additional NetCDF support** There is now a new 'incarch' command for NETCDF continuously-updated open-ended time-series data on Opendap servers such as Thredds Data Server (TDS) and ERDDAP, which aggregate multiple NETCDF files in a time series. 'incarch' incrementally archives this time series data to an iRODS 'aggregate collection'. For additional information see the 'incarch -h' help text.
 - **Hadoop Distributed File System (HDFS)** An iRODS driver for the Hadoop Distributed File System (HDFS) is now available. HDFS is a distributed, scalable, and portable filesystem written in Java for the Hadoop framework. See this brief RENCI Hadoop driver paper (pdf) for installation and other information. This is an initial (beta) version that we hope to improve for subsequent releases. Thanks to RENCI for this implementation.
 - **PAM/LDAP Authentication extensions.** There is now a --ttl option on iinit for PAM mode to set the time to live of the pam-derived irods password (within limits set by the admin). There's a config option, PAM_AUTH_NO_EXTEND, to disallow extensions to the time that an existing pam-derived password is valid; without this set they can still be extended but only before they expire (previously, they were not usable but could be extended). Pam-derived passwords are removed when expired (for all users) when one is added (this is especially useful when the PAM_AUTH_NO_EXTEND is enabled as each user can create multiple passwords.) There is a change in a protocol message to include the TTL, but it is only for iinit in PAM mode. This was done in collaboration with Andreas Lindqvist of the Swedish National Supercomputer Centre.
 - **Time-Limited Credentials for regular iRODS passwords.** The --ttl option as mentioned above for PAM/LDAP is also now available for regular iRODS passords. The user specifies the time-to-live (--ttl) on the iinit command line, which causes a time-limited password to be generated and saved in the authentication file (.irodsA) used by other i-commands (and in the ICAT). The ttl is specified in hours and must be within the limits set by the admin (see icatHighLevelRoutines.c), by default 1 hour to two weeks. The exchange is secure as the time-limited password is actually a hash of the returned value and the user's primary password. The admin can build iinit to require a ttl (see iinit.c) although users can always build their own clients. This was a requested feature from the last iRODS user group meeting (Garching).
 - **Extensions to Workflow Structure Objects (WSO).** The WSO feature has been extended with the capability to call other workflows from inside a workflow. One can call a workflow execution in two ways, either by calling the msiDataObjOpen micro-service (followed by micro-services for reads an close) or by calling the rule acRunWorkFlow to run the workflow and return a buffer with the output of the run. The first open-based option is useful when dealing with a very large file resulting from running the internal workflow, and the rule-base option is useful when dealing with files less than 32MB. More information on WSO and this extension can be found in Workflow Objects (WSO).
 - **Support for building with HPSS again.** At least in some cases, with a change made for 3.0 (to build with g++ instead of gcc), building an HPSS driver would fail. A number of small changes and the configuration of the make environment to build with gcc in this situation, resolves this problem. This is for HPSS 7.3.x. For more recent versions of HPSS, 7.4.x, we expect we will need to change the iRODS interface to use the HPSS PIO API.
 - **Optional use of SHA-1 instead of MD5 in authentication.** The one-way hash used in various aspects of authentication and obfuscation can now be configured to preferentially use SHA-1 instead of MD5. This is to meet the security requirements of certain organizations due to recently determined MD5 limitations but MD5, the way it is used in these aspects of iRODS is actually fine. To maintain backward and inter-zone compatibility, the system recognizes which is being used and will use MD5 when the client or stored value was using MD5.
 - **Ticket-based access for ils.** Read, or write, tickets can now be used in 'ils' to read and display collection information. This is not needed in default ACL mode, but in 'strict' mode a ticket can now be used to provide access to collection information. This operates in a similar manner as other ticket-based access.
 - **New 'irodsflickr'/oauth module.** There is a new module called 'irodsflickr' which contains microservices and helper functions to authenticate to flickr (oauth) and download photosets into iRODS. This was commissioned specifically for SILS Lifetime Library but the code is there and can serve as template/example for someone who would want to implement the oauth authentication flow to another service. In particular the helper functions to sign oauth requests can probably be reused as-is.
 - **libcurl micro-services.** The module 'URL' now contains a set of microservices that wrap libcurl calls to make GET (to buffer or iRODS object) and POST requests. This is used for DFC and EarthCube to run remote RESTful based workflows from iRODS rules.
 - **InCommon/CILogon** iRODS GSI authentication is compatible with CILogon and is now documented. CILogon allows users to authenticate with their home organization (many universities, Gmail, etc) and obtain a certificate for secure access to CyberInfrastructure (CI).

### Bug fixes and other features

 - **Much better performance at scale when quota-enforcement is enabled.** Two SQL statements that are used when quota enforcement (not just monitoring) is enabled have been significantly reworked to perform much better on large-scale iRODS instances. See SVN revision r5465 for details. Thanks to Giacomo Mariani and colleagues at SuperComputing Applications and Innovation Department CINECA, Bologna, Italy, for these improvements.
 - **GSI builds.** Problems in configuring/building with GSI have been resolved. Extensions were also made to support GSI on 64-bit platforms. This was issued as a 3.2 patch.
 - **msiSendMail and UnixSendMail.** Valid email addresses would fail. This was issued as a 3.2 patch.
 - **TDS (Thredds Data Server).** Compilation with TDS (Thredds Data Server) would fail. This was issued as a 3.2 patch.
 - **storageadmin and Slave ICAT.** Fixes for when 'storageadmin' is used and a Slave ICAT is configured. This was noted as patch needed and to contact us if needed.
 - **Boost supported again.** Problems in compatibility between some of the iRODS Boost calls and the version of Boost included in the release have been resovled by supporting the use of system-installed Boost. The use of Boost is an option that is disabled by default, and not typically required.
 - **A new policy enforcement point acPreProcForExecCmd** has been added. Thanks to Jean-Yves for initiating and contributing to this feature.
 - **Improvements to Language integrated general-query (LIGQ)** has been added with support for more gen query features, better error handling.
 - **A dot operator** for accessing key value pairs has been added.
 - **Foreach loop over collections** has been added, based on msiCollectionSpider and path literals.
 - **Example rules and python scripts for sending and receiving AMQP messages** have been added, see amqp.re in the source distribution.
 - **New iphybun -s option and -R and -s in corresponding msi** A new iphybun -s (size) option has been added to specify the maximum size for the tar bundle file, in MB, with a default of 4. The corresponding msiPhyBundleColl micro-service has also been extended to support the -R (resource) and -s options. This is svn revision r5116. Thanks to Jean-Yves Nief for these features.
 - **DICE Tinderbox test suite improved** The continuous build/test system has been extended to, on a daily basis, run a FUSE test, to enable and test in the new SHA-1 mode, and to build with a C instead of C++ compiler (as is needed in some cases). The Boost test is now working properly (it had been failing to notice the failure when Boost was used). The Tinderbox administrator environment has also been improved. See the revised Testing iRods for more. Although not part of the release itself, this is closely related.
 - **Compatibility with OpenSSL on CentOS5 has been added.** This is OpenSSL previous to version 1.0 on Enterprise Linux 5. There is now a build-time option in config.mk for EL5_SSL (see the comments in config.mk for more). Thanks to by Andreas Lindqvist of the Swedish NSC-SNIC for this fix.
 - **New scripts for working with tickets.** New i-command scripts, iTicket, iGet, and iDel have been added which work-around some ticket limitations when working with directory trees. The idea is to, when needed, generate a ticket for each subdirectory and use them instead of the top-level collection ticket. See the scripts, their help text, and the README.txt for more (clients/icommands/scripts). Thanks to Giacomo Mariani of the SuperComputing Applications and Innovation Department CINECA, Bologna, Italy, for these.
 - **Potential DOS attack fixed.** A bug that could be triggered remotely putting an iRODS agent into an infinite loop has been fixed. This was noticed in internal testing.
 - **A new iadmin sub-command for / strict.** There's a new 'iadmin modzonecollacl' sub-command to allow 'ils /' to work properly even when strict ACLs are enabled. This is used to set the local ICAT ACLs for the collection that corresponds to the zone at the root ('/') level. See the iadmin help text fot this sub-command, 'iadmin h modzonecollacl', for more information.
 - **iquest/gen-query fix.** General-queries, as used by iquest, can now handle the case where the client is requesting both uppercase (case insensitive) and numeric compares at the same time.
 - **Access check correction for collections.** A check was added to ensure that a user has write (or better) permission on a source collection before allowing a move out of it. This comes into play with the 'irm -r COLLECTION_NAME' command, where the agent code is doing a move into the trash collection. This also fixes the case where users could remove their home collections (and not be able to restore them) and where users could remove /zone/home/public collection (they own 'public' but do not have write access to /zone/home). Thanks to Michael Keller of the University of Canterbury New Zealand for finding, reporting, and tracking this problem. See the SVN log (revision r5432) for more.
 - **Better restriction on general-query results in ACL strict mode.** Checks are now made on items being checked, not just returned. See SRV log for revision r5428 for more.
 - **ICAT SQL performance improvement for very large scale sets of ACLs/users with Postgresql.** Changes were made to two SQL statements for ichmod (chlModAccessControl) when recursively updating the access-permissions rows (informally, 'ACL's) on collections. These changes were found to signficantly improve peformance of these two statements in the iPlant instance where these became slow due to there being a very large number of users and many individual ACLs (rows) per collection. Thanks to Nirav Merchant and other iPlant staff for these improvements. See SVN log for revision r5424 for more.
 - **ICAT performance improvements when one row expected.** The change is to add a 'limit 1' when one row is expected, when Postgres or MySQL is being used. Thomas Ledoux found this analysing a findAVU call which took several minutes on his large Postgres instance but with this change took only 36ms! In addition to that, this change applies to other cases where one row is expected so there are likely other performance improvements associated with. See SVN log for revision r5418 for more. Thanks to Thomas Ledoux of the French National Library for this.
 - **Improved handling of an ICAT user metadata concurrency case** In versions prior to 3.3, when setting user-defined meta-data (AVUs), if two agents tried to modify the the same metadata (which exists with different values in R_META_MAIN), one of the chlSetAVUMetadata would fail, but now the agent will retry. Thanks to Thomas Ledoux of the National Library of France for these improvements (svn r5350).
 - **Multiple hosts for WOS resources.** Additions were made so that admins can insert multiple host names for WOS resources (WOS). There are new iadmin sub-options to 'modresc': host-add and host-rm to add or remove hosts from the list. This was in support development being done at RENCI for DDN WOS resources which have multiple network addresses (svn r5265).
 - **Admin can now alias as other users when using GSI.** Similar to how this can be done via iRODS password authentication, the admin can set clientUserName environment variable to alias as another user. See SVN log for revision r5420 for more.
 - **The default Postgres in 'irodssetup' changed from from 9.0.3 to 9.2.4.** Besides being the latest (prior to the 3.3 release), this also includes some security patches (see their web site).
 - **msiChkHostAccessControl fix.** And apparent bug in msiChkHostAccessControl has been corrected by setting the error status so the Agent will exit if the check fails (user/host not configured).
 - **Option to Syslog to alternative.** There is now a configuration option, when using SYSLOG instead of logging to a file (IRODS_SYSLOG), to optionally set an alternative facility code to replace LOG_DAEMON (svn r5344).
 - **iphymv -G destRescGrp.** A "-G destRescGrp" option has been added to iphymv to allow the specification of a target resource group to make it easier to phymv between compound resources (svn r5329).
 - **irepl -N numThreads.** A "-N numThreads" option has been added to irepl to allow the specification of the number of threads for the replication. A fix was also applied to the server replication handler to allow numThreads==0 to transfer large files (> 32 MB) (r5311).
 - **iphybun -S srcResource** There is now an -S srcResource option in iphybun to bundle only files stored in the specified resource (svn r5333).
 - **New password strength check** A new rule has been added to check on the strength of a new password, with an example rule to check the length (but default is still to have no checks). Micro-services could also be written to make more checks. This is called for users setting passwords (ipasswd) and when the admin sets user passwords.
 - **icd max limit handled.** An 'icd' stack corruption problem as the current directory approaches the maximum length has been fixed.
 - **irodssetup show UNICODE option correctly** The indication as to if UNICODE is selected or not was not properly displayed.
 - **ichmod -M (admin) mode for multiple files** would fail.
 - **iadmin mkuser or mkgroup** with a blank or null name will now return an error.
 - **Improvements with compiler warnings** If gcc 4.6 or greater is being used, the compile line will now include -Wno-unused-but-set-variable to avoid a set of warnings, which the newer compiler issues by default now. iRODS code was also updated to avoid other compiler warnings (as is typically done).
 - **Better handling of concurrent access from FUSE client** The FUSE client has been partially rewritten to better handle concurrent accesses.
 - **The execCmdArg microservice** has been added for converting a string to an argument for msiExecCmd.
 - **PamAuthCheck location fix.** A bug in the location of the PamAuthCheck program in config.mk[.in] has been corrected. SVN version r5401.
 - **Additional imeta input checks.** Additional checks are made on user input to return errors for unrecognized input (extraneous) and avoid an array overrun. These are bugzilla items 162 and 163, svn revisions r5508 and r5514.
 - Various documentation bug fixes/improvements.
 - Various other small bugs fixes.

**Upgrading from 3.2 to 3.3:** Note that no patch to the iCAT database is required in support of the new features but server/icat/patches/patch3.2to3.3.sh should be run to define some new specific-queries (see the script for more informaion). The 'irodssetup --upgrade' (equivalent to 'irodsupgrade') script will warn and prompt you about this. The 3.3 clients will work properly with a 3.2 server except, of course, when a new feature is involved. To install, unpack the tar file, cd iRODS and run './irodssetup' or './irodsupgrade'.

### Additional Credits

Some of the development done for the iRODS 3.3 release was supported by the DataNet Federation Consortium, NSF grant #0940841 “DataNet Federation Consortium”. The development support included:

 - Pluggable authentication modules
 - Time-to-live enforcement on authentication proxy (.auth files)
 - NetCDF routines
 - Routines to support archiving of sensor data streams
 - Micro-services for invoking web service
 - Policy for AMQP message queue interaction
 - Updates to the rule engine to simplify rule creation (foreach loop extensions, row structure reference)
 - HIVE integration
 - VIVO integration

The other items in the iRODS 3.3 release that were developed by the DICE group were supported by the NSF grant #1032732, “SDCI Data Improvement: Improvement and Sustainability of iRODS Data Grid Software for Multi-Disciplinary Community Driven Application”.

## 3.2

Release Date: 2012-10-03

The following is a brief summary of the additions and improvements made to iRODS 3.2 compared to the previous version, 3.1.

As usual, this release contains many new features developed in response to needs expressed by the user community and which supplement the base iRODS functionality in various ways. Each is very important to some sites but may be unneeded by others and can be configured and used as needed.

### Major New Features

 - **Workflow Objects (Workflow Structured Objects (WSO)).** This feature provides a means to execute an iRODS workflow and realize the results of the execution as an active object. This elevates the workflow to an object-level and 'igetting' a workflow results in its automatic execution. The execution is based on a parameter file which has directives about the input files and parameters and output objects that are created during the execution. It also provides directives about caching files (including the workflow file and executables if needed) into iRODS and for versioning earlier execution results from the same parameter file. More information about this feature can be found at Workflow Objects (WSO).
 - **PAM/LDAP Authentication.** System passwords can now be used for iRODS authentication via PAM (Pluggable Authentication Modules). PAM can be configured to interact with various authentication systems, including LDAP (Lightweight Directory Access Protocol). In this mode, for additional security SSL is enabled to protect the password exchange ('iinit') and subsequent to that an iRODS-generated short term (2 week) password is used (for other i-commands). See PAM Authentication for more information. Thanks to Chris Smith of Distrbuted Bio for collaboration in the design and development of this.
 - **Additional NETCDF development.** The integration of NETCDF/Opendap functionality into iRODS continued under the DCF project where it is being used to access Ocean Observatories Initiative (OOI) data. In iRODS 3.1, we had added 7 API functions and 12 micro-services to wrap most read-only type NETCDF API calls. In iRODS 3.2, the following have been added:
     - More API functions and micro-services including API calls to handle "groups", subsetting, etc.
     - Two new iCommands:
         - inc - print NETCDF header info (attributions, dimension and variables); subsetting operation.
         - incattr - extract attributions from NETCDF files and register them in the iCAT as AVU; list AVU; query for files using AVU.
     - Three new drivers have been added to allow iRODS to register and access NETCDF data served by Thredds Data Server (TDS), ERDDAP and Pydap servers using Opendap protocol.

### Other Improvements

 - **Direct Access Resources.** Direct access resources refer to iRODS data resources that are accessible both through iRODS and through the filesystem. A typical usage scenario would be an environment in which there is a shared high performance file system mounted on a compute cluster via NFS, and on which iRODS has the files from this file system registered in order to provide meta-data annotation for the files in this file system (i.e. iRODS acts as an "overlay" for the UNIX file system). Thanks to Chris Smith for this extension.
 - **File System Meta-data collection.** This feature, when enabled, collects file system meta-data (i.e. 'stat' system call information) to be stored alongside the collection and data object information (in a new ICAT table). This information is then available via general-query calls. Currently this feature is only supported on UNIX/Linux type systems. Thanks to Chris Smith for this extension.
 - **New storageadmin role** This mode is best used when you want to let somebody add a storage server to your zone, but don't want to give them rodsadmin privilege. It allows a site to run an iRODS data server (non-ICAT server) with very limited privilege by running the server using user credentials for a user of type 'storageadmin'. When running a server with this privilege level, a user can connect to the server to perform operations of data objects (i.e. put and get), but the server can only relay client connections to the zone's ICAT server with NO_USER_AUTH privilege level, except for limited operations (GEN_QUERY_AN). Users need to connect to the ICAT-Enabled Server as their irodsHost. Thanks to Chris Smith for this feature (done in close collaboration with DICE).
 - **Language integrated general-query** Support for has been added for general-query syntax in the rule language. A gen query expression evaluates to an object of type genQueryInp_t * qenQueryOut_t.
 - **Optional use of system-installed PostgreSQL/ODBC.** The 'irodssetup' script can now optionally use system-installed Postgresql and ODBC (i.e. installed via a package manager). See System-installed Postgres/ODBC for more information.
 - **'ils -A' groups not expanded.** The listing of ACLs (ils -A) will now optionally no longer expand user-groups to individual users in those groups too (and 'g:' prepended to the group names). This can be important to sites at are using large numbers of user ACLs (such as 'iPlant'). To enable this, a particular specific-query needs to be defined via an 'iadmin' command. See Non-expanding Group ACLs for more information.
 - **Case-insensitive Queries.** ICAT queries (via the general-query API call) can now optionally be done in a case-insensitive manner, converting columns contents to upper case. See 'imeta -h' and 'iquest -h' for information on how to utilize this in those clients.
 - **iadmin modrescdatapath** There is a new iadmin sub-command to update data-obj paths. This is sometimes needed after a resource path is updated (if a resource has been moved). See the 'iadmin h modrescdatapath' for more information.
 - **Better 'ichmod -r' performance** Changes were made in the SQL used for 'ichmod' operations to improve performance in instances where large numbers of access control items (ACLs) are being used (users/groups). Logic was modified to make use of SQL 'like' instead of 'substr' which allows the DBMS to utilize the indexes. (svn revision r5164)
 - **Support for Postgres 9.1+** Additions were made to the installation scripts to handle Postgres 9.1.0 and later. The logic updates the postgres config file if the default setting is not the way iRODS needs it (that is, it is version 9.1.0 or later). The 'standard_conforming_strings' needs to be off but is on by default in 9.1+. (r4941)
 - **Support for newer GSI versions and untyped installs** irodssetup will now allow 'none' as an GSI installation type and then use the globus library names without a trailing '_' and type. For example, globus_gss_assist instead of globus_gss_assist_$(GSI_INSTALL_TYPE) (e.g. globus_gss_assist_gcc32dbg). There's also a change in a variable type that may be needed in newer GSI versions. (r5209)
 - **Rule Engine log files (reLog) files renewed.** An extension has been made that allows reLog files to be renewed every 7 days, closing the existing one and opening a new one with a refreshed name (based on the date). Thanks to Thomas Ledoux of the French National Library for this.
 - **irmtrash --age option.** A new option has been added to allow irmtrash to only remove data-objects older than a specified age (similar to itrim --age). In support of this, when a collection or data-object is moved, its modify-time is updated. See 'irmtrash -h' for more information.
 - **irsync --age option.** A new option has been added to allow irsync to synchronize only files younger than the specified age. See 'irsync -h' for more information.
 - **Error stack printed by all i-commands.** All i-commands will now print the error stack (specific error messages returned by the server), if present. This allows the showing of customized error messages that are added with msiExit, or in other ways added to the stack. Previously, only some i-commands did this, for example 'iadmin', which allowed more detailed error messages from the server (ICAT) to be displayed. Thanks to Jean-Yves Nief for this extension.
 - **Universal MSS Driver handles blanks in file names** The Universal Mass Storage System driver was extended to handle file names that contain special characters such as blanks. Thanks to Jean-Yves for this extension.
 - **irodssetup for Kerberos.** Extensions were made so that irodssetup will ask and optionally enable Kerberos and set the Kerberos location (previously this was done by editing make-config files) and also eliminate some compiler warnings for format specifiers in ikrb.c. These were provided by Martin Pollard of the Wellcome Trust Sanger Institute (thanks!).
 - **irodssetup for UNICODE.** An advanced option was added to the irodssetup/configure system to enable UNICODE (previously done manually) as well as various advice messages concerning upgrades and manual options.
 - **Retries of large file transfers supported.** Extensions were made so that --retries to work with the --lfrestart option of iput/iget so that large file transfers can be retried until they are finished.
 - **unregister option added to msiDataObjUnlink.** An 'unregister" option to msiDataObjUnlink was added. This allows it to function like 'irm -U' and remove a data-object without attempting to remove the physical file.
 - **irysnc -K option.** A '-K' option was added to irsync to verify the checksum value.
 - **Implementation of exclude patterns for ireg -C** There is a new option to ireg, '--exclude-from', which takes as an argument a file of pathname pattern matches evaluated by fnmatch(3). During a recursive registration, any pathname that matches one of the patterns will not be registered. The --exclude-from file must be readable on the data server where the files will be registered , and the file format is one pattern per line. Lines starting with '#' are treated as comments. This to Chris Smith for this extension.
 - **Timestamp added to rule engine audit xmessages** The format of the message header will now be 'iaudit:<timestamp>:<call label>'. Thanks to Chris Smith for this enhancement.
 - **Test suite improvmements and more platforms tested/supported.** Various improvements and bug fixes were made to test scripts and more platforms tested on the new NMI BaTLab and elsewhere (see Testing iRods). Fixes were made for FreeBSD, Solaris, and Solaris_PC and for using Oracle_Xe as the ICAT DBMS. A test script bug was fixed that was found on a Mac OSX 10.8 platform.
 - **New scan server log script** There is now a script that can be executed remotely to return lines from server log files bounded by input start and end times. See the help text in server/bin/cmd/readRodsLog.py for more. Thanks to Adil Hasan/KEK for this enhancement. (r5017)
 - **Pluggable modules started.** In collaboration with RENCI, the pluggable modules features of E-iRODS are being integrated, starting with the pluggable micro-services. Some of this is now part of the iRODS source code but disabled (ifdef'ed out) by default. The next release will have some of this functionality available.

### Bug Fixes (partial list) and Additional Improvements

 - **Fix for deleted rules.** A bug was fixed that was causing the reServer to delete delayed repeated rules even though the rule executed successfully (svn revision r4893).
 - **msiStoreVersionWithTS.** The msiStoreVersionWithTS micro-service was added, which can be used to create a timestamped backup version of a DataObj. (r4898)
 - **ichksum -a on compound resource** A problem was corrected in 'icksum -a' (all replicas) where the checksum calculation was not performed for copies on the compound resource.
 - **imeta mod bug fix.** A bug was fixed in handling 'imeta mod' where a new null value for units was not taken as new and so was defaulted to the old value. This was noticed in some new tests developed by DICE. This bug probably existed since 'imeta mod' was added in 2.3. (r4900).
 - **KEEPALIVE.** KEEPALIVE was added to setsockopt for iRODS sockets so the system will periodically send a message on the connection even when idle. (r4908)
 - **symlink checks.** Additional symlink checks were added for handling mounted collections. (r4910 and r4906).
 - **iput/iget --lfrestart bug fixed.** A problem was corrected related to the use of the --lfrestart option of iput/iget where the transfer could fail even when the transfer was 100% complete. icp now works when the source and target are in different remote zones. The problem was due to proxy a user privilege issue and was resolved by adding a new singleL1Copy function to copy at the L1 level. (r4909)
 - **msiSysMetaModify bug fix** A bug was fixed in msiSysMetaModify where comparisons on input options could fail due to extra characters in a temporary variable, avoiding a failure in certain cases.
 - **msiSendMail bug fix** A correction was made to avoid a segfault when a subject line is very long.
 - **data_mode duplicated in replicas** chlRegReplica was corrected to duplicate the data_mode field when a replica is created. Thanks to Howard Lander of RENCI for this fix.
 - **cross-zone icp** icp now works when the source and target are in different remote zones. The problem was due to proxy a user privilege issue and was resolved by adding a new singleL1Copy function to copy at the L1 level.
 - **Administrator Suicide Prevented** A check is now made disallowing the admin from deleting their own user account as it is probably unintended and likely problematic. Admins can still delete each other, but there will always be one left standing.
 - **More checks in msiSendMail and related** msiSendMail and msiAutoReplicateService (UnixSendEmail) now more carefully check the input strings before performing the call to execute 'mail' (r5162).
 - **Timestamps corrected for 'iput -f', etc.** An ICAT function (chlModDataObjMeta) now ensures that the modify-time value is the iRODS-standard 11 digits in length so that comparisons will work properly. This was a problem in 'iput -f' (overwriting a data-object), and perhaps other cases, where a numerically correct but 10-digit value was inserted. (r4989)
 - **imeta mod with a new null unit field handled.** A bug was fixed in handling 'imeta mod' where a new null string for units was not taken as new and so was defaulted to the old value (r4900)
 - **irsync/icp mounted-collection over-write.** A bug in dealing with mounted-collections when over-writing existing files was fixed. The error would prevent the writing of the data-object and return an CAT_UNKNOWN_FILE error. (r5191)
 - **parseRodsPath.** A problem with overlapping rstrcpy strings was corrected. This could cause occasional errors (incorrect strings converted from user input), at least on scientific linux and perhaps in other environments. (r5195)

Note: a long-standing issue has been discovered in the use of Boost libraries in iRODS which will be resolved in a subsequent release.

See the Release Notes for a history of iRODS via descriptions of each release.

**Upgrading from 3.1 to 3.2:** Note that a patch to the iCAT database is required in support of the new features. The 'irodssetup --upgrade' (equivalent to 'irodsupgrade') script will warn and prompt you about this. The 3.2 clients will work properly with a 3.1 server except, of course, when a new feature is involved. To install, unpack the tar file, cd iRODS and run './irodssetup' or './irodsupgrade'.

Added well after the release (May 24): For all releases, we recommend you upgrade all servers in your zone when you do the upgrade. For most releases, mixing of Server/Agents with previous versions will interoperate fine, but for 3.2 if part of your zone will be running 3.2, we recommend you upgrade the ICAT-Enabled Server (IES) to 3.2. If you attempt to install a new 3.2 non-IES (a resource server) while still using an 3.1 IES, it will fail due to some changes in the way certain types of structures are encoded (packed) in the protocol messages (Native and XML). We believe the 3.2 servers are backward compatible with pervious versions, but not, for 3.2, when a new Server/Agent is communicating with an old one (3.1 or earlier).

## 3.1

Release Date: 2012-03-16

The following is a brief summary of the additions and improvements made to iRODS 3.1 compared to the previous version, 3.0.

As usual, this release contains many new features developed in response to needs expressed by the user community and which supplement the base iRODS functionality in various ways. Each is very important to some sites but may be unneeded by others and can be configured and used as needed.

### Major New Features

 - **Ticket-based Access.** Tickets are strings that can be used to provide access to iRODS collections and data-objects, either in conjunction with other authentication or without. They can be for read or write access, and can be limited in time, usage counts, client hosts, users, groups, write-uses, and written-bytes counts. They can be created by owners and the attributes (maintained in the ICAT) can be modified at any time. The ticket strings are passed to users as plain-text, but in combination with restrictions, can be fairly secure. Use iticket to create tickets and the new -T option in iget and iput. See Ticket-based_Access and 'iticket -h'. Interfaces via Jargon are also available.
 - **Initial phase of NetCDF integration.** NetCDF is a set of software libraries and self-describing, machine-independent data formats that support the creation, access, and sharing of array-oriented scientific data. For this initial integration, NETCDF API calls were wrapped into new iRODS API calls and micro-services so that NETCDF operations can be performed on the iRODS servers for NETCDF data stored in iRODS. Seven iRODS API (client/server) calls were added to wrap 16 basic NETCDF API functions (nc_open, nc_inq_var, nc_get_vars, etc) and one higher level libcf subsetting function (nccf_get_vara). This initial set was selected for basic inquiry and subsetting functionalities. In addition, 12 micro-services were added to allow NETCDF workflows to be performed on the iRODS servers through the rule engine. Examples of using the APIs and the micro-services can be found in nctest.c and netcdfTest.r.
 - **Security Patches.** In an additional collaboration with the security team at the University of Wisconsin-Madison (Barton Miller, James Kupsch, and Henry Abbey), a security audit of the iRODS system identified a few important vulnerabilities and improvements and bug fixes have been made for the 3.1 release to address these. There have been no reported exploits, but all sites are urged to upgrade as soon as possible. As is standard practice for vulnerabilities, details will be held confidential for a time.
 - **ibun/iphybun compression via zip, gzip and bzip2.** Compression capability was added to ibun and iphybun using gzip, bzip2 and zip to create and extract compressed archives. In addition, a --add option was added to ibun to enable adding files to an existing compressed or uncompressed tar file.
 - **Read and Write Locks.** A --wlock/--rlock option was added to iput, iget and irepl to lock data objects while the operation is in progress. A new API call, rcDataObjLock, for server-server locking was added to support this option. Also, an irodsServer thread was added to purge unused lock files every 2 hours.
 - **More group-admin capabilities.** A new igroupadmin command has been added which can be used by users of type 'groupadmin' to create new iRODS users and set their initial passwords, and to list group membership. As before, groupadmins can add and remove users to/from the groups that the group-admin is a member of.

### Other Improvements

 - **Doxygen documentation of the iRODS C API functions.** A large number of the iRODS client/server API calls are now documented via Doxygen. See lib/api/doc/README for information on generating these. This is also available on irods.org at: Doxygen API Documents.
 - **Improved code coverage via internal test scripts.** New scripts and many additions to existing scripts have been developed to more comprehensively test the iRODS system. Some of this has been added to the continuous tests run at DICE-UCSD and some additional tests are performed as part of a new iRODS testbed at RENCI. This includes measures of the coverage of the iRODS source code, which has been significantly improved. It is not possible to test all features, on all platforms, or all configurations, but this is significant improvement and an ongoing process.
 - **Corrections via static-analysis.** Using the RENCI infrastructure, a statis-analysis tool, cppcheck, was used to make various source code improvements and find and correct a number of minor problems, primarily small memory leaks.
 - **New 'imeta set' feature.** User-defined meta-data (Attribute Value Unit (AVU) triplets), can now be set. The 'set' operation modifies an AVU for the object if it exists, or creates one if it does not. If the Attribute name is used only by this one object, the AVU (row) is modified with the new values, reducing the database overhead (unused rows). There are also a micro-service (msiSetKeyValuePairsToObj) that can be used for this. See 'imeta h set' for more information. Thanks to Thomas Ledoux for this feature.
 - **Agent kill script.** There is now killAgent.pl script which can be run to kill irodsAgent processes older than a certain wall clock time (default: 7 days). This is useful to clean up irodsAgents which have been idle for a long time (eg: dead or interrupted client...). For more information, please refer to the script itself, the help menu and the config file under scripts/admin. Thanks to Jean-Yves Nief for this feature.
 - **Progress in using system Postgresql/ODBC.** Some long-standing issues have been resolved concerning incompatibilities between Postgresql and unixODBC built from source (via irodssetup) and the system-installed versions (via Ubuntu Software Center or similar) and in a near-future release we hope to be able to support the use of these system-installed components via the installation scripts. Code updates include changing calls from the deprecated SQLColAttributes to SQLColAttribute and using a NULL last argument to SQLBindColl (the resultDataSize). Thanks to Jason Coposky of RENCI for these improvements.
 - **Compound object checksums.** A checksum computation for compound class objects was added. This is done by staging data-objects to cache and then computing the checksum of the staged object.
 - **iphybun -K checksums.** A -K option was added to iphybun to compute and register checksum values for the bundled subfiles and the bundle files.
 - **ils --bundle option.** A --bundle option was added to ils to list subfiles in a bundle file.
 - **iget/iput --purgec option.** A --purgec option was added to purge the cache (the staged file) immediately after an iget download or iput upload.
 - **irm --empty.** An --empty option was added to irm to remove bundle files only when they are empty.
 - **Multiple single-host federated IES servers.** Extensions were made so that multiple federated ICAT Enabled Servers can now run on a single host.
 - **acSetRescSchemeForRepl.** A new rule, acSetRescSchemeForRepl, was added for selecting a resource for replication.
 - **acPostProcForRepl.** A new rule, acPostProcForRepl, was added for post replication processing.
 - **Amazon S3 driver upgrade.** The S3 driver has been upgraded to support the latest libs3 library (libs3-2.0). The libs3 library must be upgraded to this version because of some differences in data structure between the old and new libs3.
 - **Support for FreeBSD.** Enhancements were made in the iRODS installation, configuration, and control scripts to allow the iRODS system to install and operate under the FreeBSD operating system.
 - **Configurable Server log file names.** Changes were made so that environment variable logfilePattern can be set to change the server log file name pattern via strftime. Default is as it has been: "%Y.%m.%d". Another pattern example is: 'export logfilePattern="%Y_%m_%d.log"'. See 'man strftime' for more options. Thanks to Thomas Ledoux for this enhancement.
 - **Remote ICAT setup** Changes were made to 'irodssetup' allow it to configure a remote (to the iCAT-Enabled Server) Postgres or MySQL DBMS system in addition the the typical local, to the IES, setup. The ODBC and remote Postgres need to be set up separately.
 - **Auto-completion script.** There is now an auto-completion script for Bash, irods_completion.bash in the iRODS directory. Thanks to Bruno Bzeznik of the French CIMENT project OAR Team for this contribution.
 - **PostgreSQL download site.** The default ftp site and directory for Postgres and ODBC downloads via 'irodssetup' has been changed to reflect changes at those sites.
 - **New temporary password call.** A new client/server call and ICAT support was added to allow an admin user to create a temporary one-time password for another user, which can then be used to log in as that user. This is needed by the iPlant project where their web interface needs to spawn a sub-process to operate as the authenticated (at their level) user.
 - **msiSysMetaModify update.** The msiSysMetaModify micro-service was updated to allow the possibility of choosing the replica number for the data-object for which the system metadata is to be modified. Thanks to Jean-Yves Nief for this extension.
 - **iscan improved performance.** An ICAT index was added to improve performance for the iscan command. For an particular iRODS instance, with 400,000 entries, a "iscan -r" on a given directory without the index took 30 minutes and with this index goes down to 2 seconds. Thanks to Jean-Yves Nief for this too.
 - **iphybun '-N' option added.** A -N numOfSubFiles option was added to iphybun to specify the maximum number of subfiles that are contained in the tar file. If this option is not given, the default value will be 5120. Some warning messages about the drawbacks of using this option are given in the iphybun help. Thanks to Jean-Yves Nief for this too.
 - **Admin warning for some resource host names.** The admin is now given a warning message if they use 'localhost' as the hostname for the DNS host name when creating or modifying a resource, as this is probably not valid. Similarly, it the host is not a valid DNS entry (lookup fails) a warning is issued.
 - **Testing ICAT case sensitivity.** A test was added in the 'devtest' suite to verify that names used for iRODS objects are case sensitive. Documentation was updated for MySQL to show how to configure MySQL to be case sensitive.
 - **irodsupgrade preserve control setting.** The irodsupgrade script was improved to preserve the site's setting for the "start/stop the DB question" so that all the settings will now be preserved. This should allow sites to run irodsupgrade without prompts. This was bugzilla item 141.
 - **Safer management of 'bundleResc'.** Additional special handling of the 'bundleResc', which is a built-in pseudo-resource, has been added. 'iadmin' has been modified to no longer allow the removal of 'bundleResc' and 'ilsresc' no longer displays it ('iadmin lr' still does).
 - **iquest order and order_desc.** iquest queries can now include an option to order results in either ascending or descending order, for example: iquest "select order_desc(DATA_ID) where COLL_NAME like '/tempZone/home/rods%'"
 - **irule '-s' option added.** A -s option was added to irule for the string mode. In the string mode, command line arguments are processed as string, not code, even without quotes. Note: if the shell you are using requires quotes, you still need quotes for the shell, but you don't need to add quotes within those quotes any more in the string mode.

### Bug Fixes (partial list) and Additional Improvements

 - **Support for Ubuntu 11.10.** A bug was fixed allowing iRODS to install correctly on Ubuntu 11.10. This was specific to this distribution. All versions of Ubuntu (and many other Linux and Unix distributions) are supported.
 - **iphybun zero length files.** A bug was fixed that was causing iphybun to fail if a subfile to be bundled was zero length.
 - **iphybun hang fix.** A iphybun hang problem was fixed for handling a specific error.
 - **irodsReServer handle failed processes.** The irodsReServer modified to handle segfault of forked processes so that the jobs that caused the segfault will not be rerun.
 - **iget mounted collection error fixed.** A problem was fixed in which an iget of a mounted collection when the number of sub-collections in a given collection was greater than 100 would fail with a BAD_INPUT_DESC_INDEX error.
 - **chlGeneralUpdate error handling.** chlGeneralUpdate was updated to perform a rollback after an error so the transaction is closed out and subsequent updates can succeed.
 - **Resource group multi-copy fix.** A problem was fixed which when writing to a resource group a data-object could be overwritten producing 2 copies in the same resource. This included some ICAT SQL changes to avoid duplicates.
 - **ils -A to a remote zone.** A problem was corrected in showing access control lists (ACLs, ils -A) in a different zone. The printDataObjACL and the printCollACL queries were made to use the previous hint to connect to the correct zone ICAT.
 - **Oracle Rule-Engine reconnect.** A change was made for the REServer with Oracle ICATs to disconnect after repeated failures so that a subsequent attempt can succeed. With Oracle, we do not typically disconnect to avoid a memory leak problem in the OCI library.
 - **imeta stack smashing errors fixed.** Working string sizes were increased to avoid a problem, in unusual cases, with some rstrcat 'not enough space' and 'stack smashing detected' errors.
 - **Solaris PC configure problem fixed.** A configure problem on some solaris PCs has been fixed. Some change in the environment was causing configure.pl to not correctly set the platform type to solaris_pc_platform. Thanks to Jean-Yves for help on this.
 - **ifsck handles missing '/'.** An update was made to prevent a core dump in the ifsck command if the source path doesn't have '/'. Thanks to Jean-Yves for this.
 - **rule engine bug fixes.** Several bugs were fixed in the rule engine.
 - **iCAT AVU bug fix.** A bug in an ICAT function was fixed to improve the efficiency of user-defined meta-data (Attribute, Value, Unit (AVU) triplets) handling. The problem prevented the reuse of some existing AVUs (rows) for additional objects with matching Attributes and Values and a null Unit. Having these extra rows reduces performance slightly but all AVU operations still function properly.
 - **Resource Monitor System handles non-english instances.** An improvement was made to RMS code to take into account server hosts running a Unix OS installed in a language other than english. Before the fix, the amount of disk space left was not reported correctly for non-english OSes.
 - **ICAT source limits extended for ireg.** Deeper directory trees can now be registered ('ireg') as limits were extended in the ICAT source on the size of general-query SQL strings and the number of bind variables.
 - **Compile errors fixed.** There were a few cases of build failures that have been fixed. Some portions of the iRODS system would fail to build using the C++ compiler, which is used on most platform starting in iRODS 3.0.

See the Release Notes for a history of iRODS via descriptions of each release.

**Upgrading from 3.0 to 3.1:** Note that a patch to the iCAT database is required in support of the new features. The 'irodssetup --upgrade' (equivalent to 'irodsupgrade') script will warn and prompt you about this. The 3.1 clients will work properly with a 3.0 server except, of course, when a new feature is involved. To install, unpack the tar file, cd iRODS and run './irodssetup' or './irodsupgrade'.

## 3.0

Release Date: 2011-09-30

This completed 3.0 version includes a few bug fixes and other improvements over the 3.0 beta that was released for testing September 2nd.

The following is a brief summary of the additions and improvements made to iRODS 3.0 compared to the previous version, 2.5.

As usual, this release contains many new features developed in response to needs expressed by the user community and which supplement the base iRODS functionality in various ways. Each is very important to some sites but may be unneeded by others and can be configured and used as needed.

### Major New Features

 - **New Rule Engine.** The iRODS Rule Engine has been completely re-written. It supports the old rule syntax as well as a new rule language which is more expressive and easier to work with. The new rule language is parsed directly by the rule engine, eliminating the need to run the rulegen program. Features include strong typing of parameters, support for integer and double type parameters, indexing of the rules for faster execution. Examples are provided for use of each micro-service in the new rule syntax. System rules are now defined in the core.re file instead of the core.irb and can also be stored in the iCAT (see Rules in the iCAT below). See the rule engine document and the backward compatibility section of that for more information. The old rule engine can still be configured-in (enabled), if needed, via settings in config.mk.
 - **Using Boost - Improved Windows Support Soon.** The Boost library, which is included in the release, can now be optionally utilized on Linux/Unix hosts and will be used on Windows. To build with it run 'buildboost.sh' and then update config.mk to have USE_BOOST set and run make. By using Boost, the Windows version will be immediately available, unlike past versions, where iRODS developers needed to port changes into the Windows environment and Windows releases would lag. Related features also under development at RENCI are the ability to install on Windows via irodssetup and support for an iCAT-Enabled Server on Windows. All of these Windows features are scheduled for the release following 3.0. Thanks to the iRODS@RENCI team for the primary development of these features (in collaboration with DICE).
 - **Building with C++** In support of the above feature, on most platforms, iRODS is now compiled with the C++ compiler, g++. This is largely invisible but did require minor source changes in most of the iRODS .c files. Most of the iRODS code has been tested, via the various configuration options, but contact the iRODS team if some aspect fails to build.
 - **Rules in the iCAT.** Rules can now be registered into the iCAT catalog for central administration. When utilized, all changes to rules are stored as rule versions. The rules can be read from the iCAT into an in-memory rule structure. Rules can be written to a file from the in-memory rule structure. The rules can then be distributed to each local rule base to ensure a uniform rule environment. This mode is controlled by a set of micro-services as described in the Rule Base in iCAT page. By default, system rules are managed in a manner similar to previous versions, being read at start up from a file (core.re now instead of core.irb).
 - **OS-level authentication.** The purpose of OS authentication is to allow iRODS to authorize users who have already logged into an iRODS client system using some form of OS-configured authentication and authorization scheme (e.g. logged in using PAM, or via ssh authentication). See OS authentication for more information. Thanks to Chris Smith of Distributed Bio for this extension.
 - **Rule debugger.** The xMessage system has been substantially extended and now supports debugging of rules. It is possible to single step through each action, listing the rules and micro-services that are invoked in the distributed environment. See the 'idbug' i-command.
 - **Realizable Objects.** Queries on information resources can be registered into iRODS collections. Clicking on the realizable object instantiates the request, which is stored as a replica of the realizable object. Realizable objects can be used as soft links that integrate remote resources into an iRODS collection. Drivers have been written for accessing Z39.50, web pages, anonymous ftp sites, public data in SRB data grids, and public data in an iRODS data grid. This makes it possible to build a collection that spans unfederated iRODS and SRB data grids as well as other data management systems. These are a module, msoDrivers, which, when enabled, creates a set of micro-services.

### Other Improvements

 - **Run server as root mode.** The "run server as root" operational mode allows one to run the iRODS servers with root privilege. This mode can help enable some behavior and features that are not possible when running iRODS as a normal, unprivileged user, although in most situations the non-root mode is still preferred and recommended. See Run server as root. Thanks to Chris Smith of Distributed Bio for this.
 - **Large file restart.** The new iput and iget --lfrestart option (specifying a restart info file) allows the transfer to continue where it left off if interrupted. This can be used with -X to be part of an overall directory uploads restart. Files larger than 32 Mbytes can be restarted.
 - **--retries** option for iput and iget to specify the number of times to retry. This can be used in conjunction with -X option to automatically restart the operation in case of failure.
 - **itrim --age and --dryrun.** There is now an option to trim only files older than a specified age and also an option to display what would be done without actually trimming the files.
 - **Tracking and deleting orphan files** - Orphan files created by deleting data objects when the resource of the physical files was down are now tracked and can be deleted with a new --orphan option of irmtrash.
 - **Auditing Extensions.** SQL extensions are now available for enhanced auditing. A SQL script is included which can be configured and run by 'irodssetup' (or run manually) which adds tables, triggers, etc. See the server/icat/auditingExtensions directory for more information. Thanks to the NASA Center for Climate Simulation (NCCS) for this.

### Bug Fixes (partial list) and Additional Improvements

 - Server infinite loop fixed. A problem was fixed where the child of the irodsServer could get into an infinite loop and use up large amount of CPU time due to a request queue problem. This was patch iRODS_2.5_Patch_1.
 - An irsync irods to irods fix. Fix was added to resolve problem in irsync where iRODS to iRODS (i:x i:y) sync did not work. This was patch iRODS_2.5_Patch_2.
 - Fix for iRODS FUSE (irodsFs) occasional hang - A fix was added to address a occasional hang caused by the overflow of connection requests by adding a wait queue. Also added the handling of socket timeout by reconnecting.
 - Support for newer ODBC. A change was needed for newer versions of ODBC, in particular on Ubuntu 11.04 64-bit hosts, using MySQL. This was patch iRODS_2.5_Patch_3.
 - $userNameClient is now available for the acAclPolicy rule
 - A rsFileRmdir problem on Solaris was fixed.
 - Fixed bug 133 - "iput command crashes if progress report is requested" using fix given by Gene Soudlenkov.
 - A cross-zone error message (authentication) is now properly returned to the client.
 - A chmod problem (octal not integer) in the univMSSDriver.c was fixed.
 - iqmod can now accept dates in the YYYY-MM-DD.hh:mm:ss format.
 - Longer strings are now allowed for the 'iadmin' 'asq' (add specific query)
 - A possible division by zero is avoided in irodsGuiProgressCallbak.
 - Replace the transStat_t with transferStat_t to align 64 bit integer to 64 bit address boundary
 - iqstat optional rule indicator is now a RuleID (as in iqdel and iqmod) instead of a rule name.
 - Add a "fork and exec" mode to the irodsReServer since the Windows platform does not support "fork" only operation.
 - ireg now has an option to calculate a checksum (thanks to Chris Smith for this).
 - The irodsServer now checks and uses spLogLevel environment variable like the agent does.
 - iscan was fixed to handle larger collections, avoiding 'too many concurrent statements' by closing additional queries.
 - The irodsctl script system now sets the LD_LIBRARY_PATH in the GLOBUS_LOCATION (in irods.config).
 - The irepl help now includes comments about using irsync for cross-zone operations.
 - The msiExecGenQuery and msiExecStrCondQuery micro-services now allow "No Rows Found" as a valid response.
 - ichmod on remote-zone users, "username#zonename", is now possible, via an extension to the msiSetAcl. Thanks to Jean-Yves Nief of IN2P3 for this.
 - Changed logic to only call acPostProcForCollCreate, acPostProcForPut, and acPostProc, if the associated operation succeeded.
 - The "rename" function has been added to the universal MSS driver. Thanks to Jean-Yves Nief of IN2P3 for this.
 - The general-query and iquest and other clients can now handle a user-provided 'IN' or 'BETWEEN' condition on a general-query call, for example: iquest "SELECT RESC_NAME WHERE RESC_CLASS_NAME IN ('bundle','archive') and iquest "SELECT DATA_NAME WHERE DATA_ID BETWEEN '10000' '10020'".
 - A timestamp has been added to the iput/iget -P option.
 - iqdel now has a -a (all) and -u (user) option to allow deletion of all jobs and jobs belonging to a user.
 - Memory leaks associated with applyRuleForPostProcForWrite and applyRuleForPostProcForRead have been fixed.
 - Queries (iquest, etc) with mixed 'AND' and 'and' conditions are now handled correctly.
 - A problem writing database object execution results objects (DBORs) into iRODS has been fixed.
 - An ICAT database index on (data_type_name) was added so that 'idbo ls' will continue to perform well at scale.
 - A problem was fixed that had prevented msiDataObjPutWithOptions from overwriting existing copies.
 - The temporary password mechanism was modified for use by iDrop and iDrop-lite.
 - irodsctl now checks that the server/log directory exists and is writable and gives specific error messages for these cases.
 - Support was added for orphan files, including a irmtrash --orphan option.
 - The -G option for registering replicas is now supported.
 - A change was made to log the correct process-id in server log files in all cases. Previously, there were rare situations where the pid could be incorrect.
 - Limits were increased so that very long strings can be piped into 'imeta'.
 - Kerberos libraries will now be linked into the FUSE client if KRB_AUTH set. Thanks to Chris Smith for this.
 - A fix was made to prevent a core dump in scanUtil if the local source path doesn't have '/'. Thanks to Chris Smith for this.
 - A new client/server call (API), rcDataObjFsync was added. Thanks to John Knutson of the University of Texas for this.
 - A bug was fixed avoiding an unneeded redundant internal query, slightly improving performance in some cases.
 - A problem in moving ('imv') certain collections was fixed. If a collection contained a data-object that was not writable by the owner of the collection, the physical move would fail. Now, this is handled as a special case and allowed if the user is the owner of the collection.
 - A fix to avoid getting the SYS_COPY_LEN_ERR error by iget and icp when the data content has been modified by some micro-services.
 - A 'notify.pl' script was developed which can be run periodically to check specified (configured) collections and send email notifications when data-objects are added or removed. See the scripts/notify directory for more information.
 - The 'irsync' command can now accept a blank i: argument. The command 'irsync fileName i:' now stores the file (if needed) into the current iRODS collection.

### Additional Items

 - The copyright and license text files have been updated to include the University of North Carolina at Chapel Hill and the Data Intensive Cyberinfrastructure Foundation in addition to the Regents of the University of California. Of course, the iRODS license continues to be a fully Open Source (BSD style).

See the Release Notes for a history of iRODS via descriptions of each release.

**Upgrading from 2.5 to 3.0:** Note that a patch to the iCAT database is required in support of the new features (new tables, tokens, and an index). The 'irodssetup --upgrade' (equivalent to 'irodsupgrade') script will warn and prompt you about this. The 3.0 clients will work properly with a 2.5 server except, of course, when a new feature is involved. To install, unpack the tar file, cd iRODS and run './irodssetup' or './irodsupgrade'.

## 2.5

Release Date: 2011-02-24

The following is a brief summary of the additions and improvements made to iRODS 2.5 compared to the previous version, 2.4.1.

As usual, this release contains many new features developed in response to needs expressed by the user community and which supplement the base iRODS functionality in various ways. Each is very important to some sites but may be unneeded by others and can be configured and used as needed.

### New Features

 - **Database Resources (table-driven resources, external databases), initial version.** This initial version of the Database Resources feature provides some of the foundational functionality for accessing external databases (a.k.a. table driven resources), including multi-tiered access control, SQL based queries and updates, data-object SQL definitions, XML-like result streams, and server-side redirection of result streams to data-objects. See the Database Resources page for more information.
 - **SQL-Based Queries (specific query).** A new SQL-based query mechanism is now available, for those cases where the main iRODS query mechanisms are insufficient. The iRODS administrator presets (with care) SQL statements that are allowed. The 'iquest' client program can execute these types of queries via the --sql option. There is a new client/server call to invoke this, rcSpecificQuery. See 'iquest -h', 'iadmin h asq', and SQL-Based Queries for more information.
 - **DDN WOS Support.** A new resource driver has been developed which interfaces to the Web Object Scaler (WOS) storage system of Data Direct Networks (DDN).
 - **Nonblocking driver for UNIX FS.** A new resource driver has been developed to allow the read/write operations to timeout after one minute. This feature was implemented primarily for archival storage systems such as SAM-FS so that tape read/writes will not block forever.
 - **Fortran I/O library.** A new basic interface library allowing FORTRAN applications can do direct (thru the network) iRODS I/O via the iRODS C client library. See lib/fortran/README.txt for more information.

### Other Improvements

 - XMsg. The XMsg system was improved to take care of problems identified by Jean-Yves. More modifications will be made to the next release.
 - Improvements were made to Resource Monitoring System to allow it to handle servers with hundreds of registered physical resources. Thanks to Jean-Yves Nief of IN2P3 for this contribution.
 - A -I option was added to iget to redirect connections to the best resource server for data transfer. A new client/server call, rcGetHostForGet, was added to support the implementation.
 - A -f option was added to ireg to allow the registration of new files in an existing collection already populated with files and subcollections.
 - A "--repl" option was added to ireg to allow the registration of files as a replica.
 - A -G option was added to irepl to only replicate data objects stored in the given resource group.
 - The Resource Information (resource status, resource addition/deletion, etc.) in the irodsReServer (delay exec) is now updated every 1 minute.
 - Streaming of the stdout output of the rcExecCmd API (iexecmd) was added. Previously, the stdout output of rcExecCmd was returned in a single buffer with a maximum size of 64 MBytes. With streaming, the output size can be unlimited. Three new client/server calls: rcExecCmd, rcStreamRead and rcStreamClose, were added to support the implementation. The old rcExecCmd API has been renamed to rcExecCmd241 for backward compatibility.
 - A new session parameter, $clientAddr, was added which represents the IP address of the client.
 - Modifications were made to allow the ireg and iget of files with UNKNOWN size.
 - Modifications were made to set the number of threads to 0 if the calculated number of threads is 1 and the resource is on the local host.
 - A problem with the format of the data-expiry field has been fixed, changing it to the iRODS standard time-stamp form so it can be readily used in comparisons (via micro-services and imeta).
 - imeta and the ICAT code were updated to support queries on multiple collection user-defined attributes (AVUs). Previously, queries on only one Collection AVU were handled properly.
 - Resource free-space can now be incremented and decremented when the input string is prepended with '+' or '-'. See 'iadmin help modresc'.
 - General-Query auto-close. There is now a new AUTO_CLOSE option to the rcGenQuery call in which the agent, after returning the initial set of rows, will close the ODBC 'statement' to the ICAT DB even if there are additional rows that could be returned. This may simplify some client interactions when it is known that only the first 'N' rows are needed.
 - ichmod administrator mode. There is now an administrator mode (-M) to ichmod. If you are the irods administrator, you can include the -M option to set the permissions on the collection(s) and/or data-object(s) as if you were the owner. This is sometimes much more convenient than aliasing as the user.
 - Two new micro-services were added. msiExit exits with a customized error number and error message and msiSysMetaModify modifies system metadata in a manner similar to 'isysmeta'. Thanks to Jean-Yves Nief of IN2P3 for these.
 - The syntax for inputs to msiLoadMetadataFromXml has been extended to support optional multiple targets. A schema is provided to validate input XML files. New AVUs are not created with a numeric prefix anymore. Another micro-service (msiStripAVUs) is now available to remove all metadata from a given object.

### Bug Fixes

 - A compile error in iRODS FUSE (irodsFs) was fixed by replacing the function getUnixErrno with getErrno. This had been released as a patch: iRODS_2.4.1_Patch_1.
 - An intermittent iphybun problem was fixed when the bundle overflows with the number of files exceeding 512 or the bundle size exceeding 2 GB. This had been released as a patch: iRODS_2.4.1_Patch_2.
 - A logic error in string param parsing was fixed and also in applyAllRule execution.
 - A bug was fixed in the Universal MSS driver which was preventing the registration of files larger than 2 GB, using ireg for example, and improvements were made in the management of the ACLs of the files and directories on the remote system (if any ACLs are available on it). Thanks to Jean-Yves Nief of IN2P3 for these.
 - A fix was made to prevent Agent aborts when using Kerberos in some host environments. A string size was corrected for cases where the system clears it. Thanks to Christopher Smith for this fix.
 - ichmod and iadmin help text was added to clarify how the multiple 'owner' fields are used. For example, if you remove your own access to an object (set your access to 'null'), you will not be able to read the file, but you can restore access via another 'ichmod' because for ichmod, you are still the owner.
 - A control-D entered to 'iadmin' is now handled properly instead of going into an infinite prompting loop. A check on the fgets return code was added.
 - A bug was fixed in ICAT code used via rcModAccessControl (ichmod) so that setting access, recursive, will work even if the collection is empty of data-objects.
 - A bug was fixed which had prevented delay-exec with "REPEAT UNTIL SUCCESS" to work as expected (jobs did not repeat). This was due to a string compare problem.
 - A problem was fixed that caused an intermittent segfault when "iput -a" was used.
 - An intermittent segfault problem was fixed involving file replication from the micro-service msiDataObjRepl when the target resource was a resource group with more than 2 resources.
 - A problem was fixed with irm moving a file to the trash bin failing when the target physical path already exists.
 - A irodsReServer bug was fixed where it would run out of genQuery descriptors. This problem only showed up when the number of jobs in the queue was consistently greater than 256. The solution was to close the outstanding genQuery session after it was done, in getReInfo.
 - Unneeded error logging was corrected in rsRuleExecSubmit when the name of a rei file to be saved for delayed execution collided with an existing file.
 - Virtually an unlimited number of resources and resource groups can now be supported.

### Additional Items

 - icat-based rule system has been partially added to the release. The next release will contain the first version of icat-based rule system.
 - Doxygen documentation was updated in several micro-services.
 - Various help text and examples were improved.

See Jargon Release Notes 2.5 for Jargon release notes.

See the Release Notes for a history of iRODS via descriptions of each release.

**Upgrading from 2.4.1 to 2.5:** Note that a patch to the iCAT database is required in support of the new DBR and specific-query features (a new table, new tokens, etc). The 'irodssetup --upgrade' (equivalent to 'irodsupgrade') script will warn and prompt you about this. The 2.4.1 clients will function properly with the 2.5 server. The 2.5 clients will work properly with a 2.4.1 server except, of course, when a new feature is involved. To install, unpack the tar file, cd iRODS and run './irodssetup' or './irodsupgrade'.

## 2.4.1

Release Date: 2010-10-08

The following is a brief summary of the additions and improvements made to iRODS 2.4.1 compared to the previous version, 2.4.

Although technically a 'minor' release done soon after the previous release (2.4 July 23rd), this release contains some important bug fixes and quite a few new features. These are, as always, based on requests from the user community.

### Bug Fixes
 - **An irodsServer segfault fix.** An update was made to avoid a segfault in the irodsServer when a bad request queue was not properly freed. This was iRODS_2.4_Patch_1.
 - **Socket reconnection fix.** A correction was made concerning that socket reconnection. The 'iput -T' command could fail randomly because the length parameter of the accept call was not initialized. This was iRODS_2.4_Patch_2.
 - **Double & in iRODS file names supported.** An iCAT bug was fixed so that iRODS data-objects with '&&' in the name can be queried properly. Without this fix, 'ils -l' of such a file, or similar queries, would fail to find the file.
 - **Other bug fixes.** A number of other specific bugs have also been fixed. The 'svn' log contains a complete list.

### New Features

 - **iRODS FUSE is multi-threaded.** The iRODS interface to the FUSE (Filesystem in User Space) has been extended to be multi-threaded now (matching recent versions of FUSE), so that when one access is delayed (for example to a tape), others are not blocked. This was requested by the Australian Research Collaboration Service (ARCS).
 - **New ifsck command.** A new 'ifsck' command, somewhat like the Unix fsck, detects iRODS files which have been corrupted or modified outside the iRODS framework on the local filesystem. Thanks to Jean-Yves Nief of IN2P3 for this.
 - **Detecting missing physical files via 'iscan'.** New functionality has been added to the 'iscan' icommand such that it can scan iRODS collections and check if the corresponding physical files exist on the iRODS data server. Thanks to Jean-Yves Nief of IN2P3 for this.
 - **The HPSS resource driver now supports Kerberos** authentication, thanks to help from Danko Antolovic and Jeff Russ of Indiana U.
 - **ichksum improvements.** When a resource is specified (-R), only copies on that resource are checked (via a more qualified query), greatly improving the 'ichksum' performance. Also, a '--silent' option was added which limits the 'ichksum' output to error messages only, instead of listing each iRODS file and its checksum.
 - **iput and irsync --link option.** A new option, '--link', has been added to 'iput' and 'irsync' to ignore symbolic links when uploading local files or directories.
 - **imeta long option for data-objects.** There is a new long option, -ld, for the ls and lsw sub-commands to display the time that the user-defined metadata (AVU) was assigned to the data-object. The format is 'imeta ls -ld Name'.
 - **New acPostProcForPhymv rule.** Code was added to invoke a new rule, acPostProcForPhymv, after a physical move operation and an example for this rule (a no-op) was added to the core rule set (core.irb).

### Other Improvements
 - **Help text and other documentation.** Various corrections and additions were made to some of the i-command help text (-h) and other documentation files.
 - **iexecmd fix.** Fixed a problem where the irodsAgent segfaulted when the script output to stdout/stderr is large.
 - **Error message improvements.** An error message was eliminated in _rsDataObjClose when iphybun has an empty collection.
 - **Bundle deletion fix.** A modification was made to allow deletion of a bundle data object if the physical file does not exist or if the server has a problem unbundling it.
 - **Directory mode fix.** Fixed a problem where the directory mode in a resource does not match the one specified in the config file.
 - **PhyBun fixes.** Fixed a problem where PhyBun failed when ran by the irodsReServer; fixed problems with error codes SYS_OUT_OF_FILE_DESC and UNIX_FILE_LINK_ERR.
 - **Rule Engine test mode described.** Comments were added in irodsctl.pl to explain that when RETESTFLAG is set, some micro-services will not perform their normal function (it is a test-only mode). Log messages were added to some administration micro-services to also indicate this.
 - **Latest PostgreSQL supported.** iRODS has been successfully tested with the latest version of PostgreSQL, 9.0.0. This is now the default recommended version in the iRODS installation sub-system.
 - **Compiler warnings on 64-bit hosts fixed.** Source updates were made to avoid warning messages from the 'C' compiler on platforms that have 64-bit addressing.

### Internal Changes

 - **Source code refactoring/documentation.** Some of the server source code was refactored, unused code removed, and additional documentation added.

See Jargon Release Notes 2.4.1 for Jargon release notes.

See the Release Notes for a history of iRODS via descriptions of each release.

**Upgrading from 2.4 to 2.4.1:** There are no required patches to the ICAT database when upgrading from 2.4, but you should apply the server/icat/patches/all-patch-v2.4tov2.4.1.sql patch sometime to recreate a minor index that was inadvertently dropped as part of the 2.3 to 2.4 patches. This may provide a slight performance improvement in some rule operations.

## 2.4

Release Date: 2010-07-23

The following is a brief summary of the additions and improvements made to iRODS 2.4 compared to the previous version, 2.3.

As usual, this release contains many new features developed in response to needs expressed by the user community and which supplement the base iRODS functionality in various ways. Each is very important to some sites but may be unneeded by others and can be configured and used as needed.

### Major New Features

 - **Bulk upload/registration.** A -b option was added to iput to allow uploading up to 50 files in a single operation to significantly improve performance with large numbers of small files. A bulk registration API was also added as part of the implementation to optimize registration speed. The bulk option also works when the target collection is in a mounted collection which may represent the quickest way to upload a large number of small files. The acBulkPutPostProcPolicy rule and the msiSetBulkPutPostProcPolicy micro-service were added to allow sites to set policy for executing postprocessing for bulk 'put' operations.
 - **Connection Control and Monitoring System (CCMS).** CCMS provides a more robust handling and control of client connections to the iRODS servers. Features include:
     - **Multi-threading the iRODS Servers** to better handle denial of service type attacks. The iRODS server now has one main thread listening continuously on a well known port, 5 Read Worker threads for reading and processing Startup Packets and one Spawn Manager thread.
     - **The iRODS administrator can now limit the total number of connections** to a server and/or disallow connections by particular iRODS users. See the server/config/connectControl.config.template file for more information.
     - **Users can now monitor all connections to the iRODS Servers in the federation.** A new iCommand 'ips' was implemented for this purpose.
 - **Improved XMessage System.** The XMessage System (introduced in iRODS 1.0) has been extended with new micro-services, command-line support (the ixmsg command), a sample application for auditing rules and micro-service execution, and a testing harness for the new micro-services. See the XMessage System page for more information.

### Improvements / Fixes

 - **Memory leak fixes.** Several memory leak fixes were made for the irodsAgent and irodsServer. With these improvments all known memory leaks have been fixed. In a related improvement, the memory footprint of some recursive routines have been greatly reduced so that the total memory footprint of the expected recursion depth can be accommodated. With these fixes, the iRODS server and agent can operate long-term and under heavy load without significantly increasing in memory size.
 - **Can now move data from mounted to regular collections.** A capability was added to the imv command and the rsDataObjRename API to move data and collections from a mounted collection to a regular collection. Together with the new bulk upload capability, data can be bulk uploaded to a mounted collection quickly and then moved to the final place and registered with the iCAT at a later time (a drop box type implementation).
 - **A new IRODS_TO_COLLECTION option for the msiDataObjRsync micro-service.** IRODS_TO_COLLECTION option was added to the msiDataObjRsync micro-service to allow the specification of a top level target collection to make the micro-service easier to use by internal rules.
 - **User defined meta-data on resource groups.** User-defined meta-data (Attribute, Value, Unit triplets (AVUs)) can now be associated with Resource Groups in addition to the previous data-objects, collections, users, and resources. See 'imeta help' for more information. Thanks to Thomas Ledoux of the French National Library for this extension.
 - **'imeta' queries perform well at scale now.** Searches and other user-defined meta-data (AVU) operations now perform well at larger scales (tested with ~50 million data-objects and about 300 million AVUs) with the addition of five new DBMS indexes and corrections for some memory leaks (noted above). Thanks to Scott Sinno of NCCS/NASA for collaborations in this development.
 - **iCAT performance (more indices).** Based on further review, six additional indexes have been added to the iCAT schema which will likely further improve performance in other cases as well. Previously, performance was very good in most cases (and better than SRB) but these additions should improve it further, particularly at larger scales. We plan to revise these further for the next release after more more analysis and testing.
 - **Script for iRODS tcsh path completion for standard icommands and associated scripts.** See the irods_completion.tcsh script at the root of the release directory for more information. Thanks to Jean-Yves Nief of IN2P3 for this.
 - **Resource Monitoring System improvement.** Handle in a more efficient way the use cases where several physical resources are hosted on the same server: the RMS only launches one monitoring probe per server, instead of potentially several before. Thanks to Jean-Yves/IN2P3 for this also.
 - **Fixes for a AVU deletion problem with moderate or more number AVUs defined (very slow completion).** The cleanup of unused AVUs is now done asynchronously via an iadmin command or rule. See 'iadmin help rum' (remove unused metadata). This is also more efficient via the addition of some additional DBMS indexes.
 - **Renaming a resource is now supported.** See 'iadmin h modresc' for usage information. The iCAT software updates the various iCAT tables where the resource name exists.
 - **'imeta addw' wildcard.** AVU associations can now be added to multiple data-objects in a single command (or micro-service call) using wildcard characters to match collection and/or data-object names. Access checks are performed in an efficient manner. Updates are handled efficiently via SQL (i.e. via the iCAT DBMS) and should scale well.
 - **SRB to iCAT catalog conversion enhancement.** A portion of the m2icat.pl script was written in C to very significantly improve the performance of data-object catalog conversion at somewhat larger scales. This is still experimental but has proven useful at one site. See m2icatd.c for details.
 - **Support for GSI authentication to non-IES without a preset irodsUserName.** The server to server connection/authentication logic was adjusted, a query re-performed, and environment variable set, to allow this mode of authentication. Thanks to Vladimir Mencl of ARCS-NZ for collaborations in this development.
 - **Support for non-IES inter-zone connections.** Logic was also extended to allow connections to a remote zone to connect to one of that zone's non-iCAT-Enabled-Servers instead of requiring it to be to the IES. This can be needed in certain firewall situations.
 - **Bug fix for Oracle iCAT bind-variables.** Fixes were made to the iCAT Oracle interface software to function with many more bind-variables being used. This was needed for recovery in a situation where an inadvertent deeply-recursive iput (a recursive symbolic link) created very large sub-trees.
 - **New ilocate command.** Similar to GNU mlocate, finds data-objects or collections by name (via iquery). Thanks to Scott Sinno for providing this convenience script.
 - **irsync -l option.** A new -l option has been added to irsync to list what needs to be synchronized without actually doing it. Thanks to Jean-Yves for this.
 - **Solaric ireg fix.** An ireg problem was fixed where registering a collection on the Solaris platform would fail.
 - **Recursive rsync micro-service.** A new micro-service, msiCollRsync, was added which recursively rsync's two collections.
 - **Parent collection auto-create.** Support for creating the parent collection of the target file in the rsDataObjCopy API if it does not already exist was added. This new feature makes it easier to use the msiDataObjCopy micro-service by internal rules.
 - **Cross-zone irsync fix.** A problem was fixed which caused the cross zone irsync of mounted collections to fail.
 - **irepl -a enhancement.** 'irepl -a' of a data object stored in a resource group now makes a copy for each resource in the resource group if no input resource is specified.
 - **OSX problem fixed**A file overwrite problem was fixed, which would occur when 2 servers were involved and one of the servers is on an OSX platform and the other is not. This problem was caused by fact that the O_TRUNC bit is defined differently on OSX.
 - **msiSetReServerNumProc enhancement.** These is now support for differentiating between setting the number of iRodsReServer processes in the msiSetReServerNumProc micro-service to 0 to mean no forking and 1 to mean forking one process at a time. Also the default number of processes has been changed to 1 (vs 0 before). Thanks to Luke Tontonflingueur of the French library for this modification.
 - **Replication timestamp fix.** The "modified date" is now updated when a copy is updated by replication. Thanks to Luke Tontonflingueur of the French library for this modification too.
 - **icp/irepl threading fix.** A problem was fixed where, under certain conditions, icp and irepl would ignore the input number of threads.
 - **Better handling of RBUDP broken connections.** There is now more graceful handling of a broken connection for RBUDP transfer.
 - **PostgreSQL 8.4.4 default.** The installation scripts now defaults (and suggests) Postgres version 8.4.4 for download and installation instead of 8.4.2 which is no longer available due to a security concern. See this PostgreSQL posting for more information.
 - **iRODS Doxygen Documentation of Micro-Services revised.** The Doxygen descriptions of many micro-services have been updated to be much more complete. Missing items for many micro-services have been added. The on-line Doxygen pages will be updated to 2.4 soon after the release.
 - **Jargon Bug Fixes and Enhancements.** The Jargon Release Notes 2.4.0 contain notes on the Jargon Java library, which has been compatibility tested with iRODS2.4.

### Work In Progress

 - **Core Rules stored in the iCAT.** We are currently developing a new feature where the rule bases will be stored in the iCAT. Facilities for synchronizing the bases will be provided in the release after 2.4. A few micro-services are already available for reading and writing into the iCAT-based rulebase. The main idea with this development is to provide administrative support for uniform maintenance for the rules, but more importantly to provide a versioning system for rules.
 - **Access to External Databases/Database_Resources.** The release contains some initial development for this feature, but nothing available for use yet. There are new client/server calls, some 'make' changes, a draft client utility, etc. We expect to have an initial version of this available in the next release.

### Bug fixes/Small improvements

 - **'imeta' 'like' syntax documented.** The imeta help text for query ('imeta h qu') now includes a description of using 'like' in comparing attributes values (for example, 'qu -d a like b%'). This was supported previously but not well documented.
 - **iquest --no-page option.** There is now an option to avoid the prompt to continue or not after 500 items are listed.
 - **Internal authentication enhancement.** A function used in the authentication system has been updated to use 'urandom' on hosts that support it in order to provide a more significantly random challenge pattern in the challenge-response protocol. In the context in which this was used the previous algorithm was sufficient but 'urandom' is more standard.
 - **Rule environment differentiation.** The "execCmdRule" environment variable is now set if execCmd is called from internal rule (core.irb) vs called by clients using irule or the iexecmd API.
 - **64-bit HDF problem fixed.** A problem was fixed with running the hdf5 micro-services on a 64 bit platform. This problem was caused by the fact that a "long" integer is 64 bits on a 64 bits platform.

#### Bugzilla items fixed:

 - **Bugzilla item 15.** iput on windows for large files
 - **Bugzilla item 22.** The iCAT code now consistently refers to table names in upper case, so for new installations with MySQL the ignore case option is no longer needed.
 - **Bugzilla item 106.** The mounted collections are not displayed in tree.
 - **Bugzilla item 107.** the $ for INPUT variable prompts get ignored by rulegen.

Other bugzilla items were evaluated and determined to be invalid: Bugzilla item 51, separate client from server configuration files.

As always, a number of other improvements and fixes were made. Details on these are available in the 'svn' logs, which are mirrored at http://github.com/trel/iRODS

See Jargon Release Notes 2.4.0 for Jargon release notes.

See the Release Notes for a history of iRODS via descriptions of each release.

**Upgrading from 2.3 to 2.4:** Note that a patch to the iCAT database is required. The 'irodssetup --upgrade' (equivalent to 'irodsupgrade') script will warn and prompt you about this. The 2.3 clients will function properly with the 2.4 server. The 2.4 clients, except for 'iadmin', will work properly with a 2.3 server except, of course, when a new feature is involved. For 'iadmin', the 2.4 server will work with the 2.3 iadmin, but the 2.4 iadmin will not work with the 2.3 (or earlier) server (due to a simpleQuery change, an error will be returned). To install, unpack the tar file, cd iRODS and run './irodssetup' or './irodsupgrade'.

## 2.3

Release Date: 2010-03-12

The following is a brief summary of the additions and improvements made to iRODS 2.3 compared to the previous version, 2.2.

As usual, this release contains many new features which were developed in response to needs expressed by the user community and supplement the base iRODS functionality in various ways. Each is very important to some sites but may be unneeded by others and can be configured and used as needed.

### Improvements to iRODS

 - **Extensible ICAT** This is a system to make it easier for sites to add tables into the ICAT database and make use of those tables via standard irods-client capabilities. The Extended ICAT module allows sites to add their own tables into the iRODS ICAT system, making those tables queryable via the general-query (rc/rsGenQuery) and update-able (insert or delete) via the general-update (rc/rsGeneralUpdate). 'iquest' will also be aware of the new columns for this user interface to the general-query. See modules/ExtendedIcat/README.txt for more.
 - **Quotas** This is an optional system to maintain and enforce quotas on how much storage users and/or groups can store into iRODS as a whole or on specific resources. The enforcement is enabled via a rule (acRescQuotaPolicy) and micro-service (msiSetRescQuotaPolicy). When enforced, users over quota will get an error when trying to store additional data.
 - **Support for GSI and Kerberos at the same time** In addition to the previous ability to build iRODS using GSI or Kerberos authentication (in addition to the iRODS secure password system), the system can now support both at the same time. Users can then select either Kerberos, GSI, or iRODS-password authentication. Since GSI and Kerberos use the same function names (following the GSSAPI standard) special DLL processing is needed. Thanks to Roger Downing of the UK e-Science project for providing these extensions.
 - **ICAT performance improvement for large numbers of collections** A new DBMS index significantly improves performance for instances with large numbers of collections. This was found with PostgreSQL but most likely applies to Oracle and MySQL too. Without this index the system did not scale properly.
 - **Groupadmin support.** Users who have the user type 'groupadmin' can add and remove other users to groups the groupadmin belongs to.
 - **Progress statistics** A -P option was added to iput/iget/irepl/icp to report the progress of operations. For iput and iget, the progress of transferring a large file will also be reported. The implementation will also be used by the Windows iRODS explorer to report the progress of operations.
 - **Collection Soft Links** A soft link can now be made from one collection to another via a new -mlink option in imcoll command. This new feature also supports links across zones and multiple links in a path.
 - **Jargon improvements** For a description of Jargon improvements and bug fixes related to this release, see Jargon Release Notes 2.3.0 or jargon/RELEASE_NOTES.txt in the source tree.

### Bug fixes/Small improvements

 - Various fixes/improvements to the irodssetup system. Environment variable LOCAL_HOST_NAME can now be set to bypass DNS issues. The default version of Postgres is now 8.4.2 (the previous, 8.3.5, is no longer available). Etc.
 - ICAT 'begin' changes. By changing the way SQL 'begin' statements are issued, avoid having many open connections to the DBMS.
 - iquest option to bypass 'distinct'. The general-query includes 'distinct' in the SQL to avoid duplications but in some cases it is better to not include it. The option, 'no-distinct' is described in 'iquest -h'.
 - A update-AVU capability. This internally does an AVU remove and add and a single commit, but simplifies the the interaction with the client. The new 'mod' sub-command of 'imeta' makes use of this.
 - Other ICAT fixes. A number of issues with ICAT operations in specialized situations have been discovered and fixed. For example, a problem with collection names with blanks or single quotes (due to the IN clause optimization in 2.2) has been fixed (by using 'bind variables;').
 - A new i-command, 'iscan', was added which checks if a local data object or the contents of a local directory is registered in irods. Thanks to Jean-Yves of IN2P3 for the development of this command and for some other improvements listed below (noted via 'Contributed by Jean-Yves/IN2P3').
 - The Resource Monitoring System was changed so that if the config file (irodsMonPerf.config) does not exist, RMS will monitor all the resources in the zone. This matches what was previously described on the iRODS web site. Contributed by Jean-Yves/IN2P3.
 - The "byLoad" scheme for the RMS msiSetRescSortScheme micro-service was added. This will put the least loaded resource at the top of the list of resources selected. In order to run properly, RMS should be configured to pick up the load information for each server in the resource group list. Contributed by Jean-Yves/IN2P3.
 - The Universal MSS driver updated; a stat function was added. Contributed by Jean-Yves/IN2P3.
 - msiSetACL added. This sets the ACLs (access control) of an object or collection. Contributed by Jean-Yves/IN2P3.
 - isysmeta ldt. The 'isysmeta' now has an 'ldt' option to list the data types.
 - Add [-G rescGroup] option to the ireg command allow the specification of a Resource Group when registering a file.
 - Add an -I option to iput to redirect the connection to the resource server to improve the performance of uploading a large number of small files.
 - Add a new parameter "reHost" to server.config to allow the the irodsReServer to run on a server other than the default location (the IES server).
 - For sequential put, try other resources in the resource group if the initial put failed. Previously, this retry feature only works for parallel put.
 - Enhance the the HPSS driver authentication by calling hpss_GetConfiguration and hpss_SetConfiguration as recommended by the HPSS folks.
 - Enable a connection timeout for parallel I/O to avoid long hang time because of firewall issue.
 - Enable a idle irodsAgent process timeout to reduce the number of idle irodsAgent processes.
 - Modify the behavior of itrim such that if no trim condition is specified, the replicas will be trimmed until there are numCopies left instead of just trimming the old copies.
 - Add 2 configurable parameters DefFileMode and DefDirMode to the irodsctl.pl file to allow admins to set the create modes of file and directory differently than the default values.
 - Fix a problem of the irodsServer process occasionally dying caused by receiving a SIGPIPE signal.
 - Fix a bug that irepl in parallel I/O mode or iget of an old copy result with a SYS_COPY_LEN_ERR.
 - Fix a irm bug where name collision in the trash collections could occurred under certain conditions causing an error.
 - Fix a irsync permission problem where the command would fail if the client has only a "read" permission because the registration of the newly computed checksum value would fail.
 - Fix a ibun problem on Mac OS caused by the path for the tar executable on the MAC is different than other OS.
 - Add a generic microservice msiOprDisallowed to disallow the execution of certain actions.
 - Add the "updateRepl" flag to msiSysReplDataObj to allow the update of replica automatically whenever one copy is modified.
 - The acSetNumThreads rule in core.irb now supports condition based on $rescName so that different policies can be set for different resources.
 - Modify the server-to-server copy to support sequential I/O only (e.g., a value of 0 for maxNumThr in msiSetNumThreads can be supported) .This can be helpful to get around firewall issues on the servers.
 - Fix a problem with the "all" option of msiSysReplDataObj where the replication is not always done to all the resources in a resource group.
 - Fix a segfault problem in the addAVUMetadataFromKVPairs microservice caused by the modAVUMetadataInp struct not initialized.
 - Fix a problem with the msiDataObjRsync microservice where iRods type to iRods type rsync fails because the FORCE_FLAG has not been turned on.
 - Add options to msiPhyPathReg to mount and link collections.

#### Bugzilla items fixed:

 - 25 iphymv -r problem on v2.2 (sefault)
 - 53 Wrong size used in _rsGeneralAdmin
 - 54 icatHighLevelRoutines.c has wrong sizes in snprintf's
 - 66 iRODS install cannot install Postgres (by default, download Postgres 8.4.2 as 8.3.5 is no longer available)
 - Increase the length of the rule accepted by irule (META_STR_LEN) from 2704 to (20*1024).
 - 70 Microservices can't take long strings; irule can't take long argument strings

See Jargon Release Notes 2.3.0 for Jargon release notes

Other bugzilla items were evaluated and determined to be invalid. In some cases these were bugs in components external to iRODS, for example Postgres (bug 67) or Globus (bug 21). See bugzilla for details.

### Other small improvements and bug fixes

As always, a number of other improvements and fixes were made. Details on these are available in the 'svn' logs, which are mirrored at http://github.com/trel/iRODS

**Upgrading from 2.2 to 2.3:** Note that a patch to the iCAT database is required. The 'irodssetup --upgrade' (equivalent to 'irodsupgrade') script will warn and prompt you about this. The 2.2 clients will function properly with the 2.3 server for most operations, but some are not completely compatible and will return errors in these cases. To install, unpack the tar file, cd iRODS and run './irodssetup' or './irodsupgrade'.

## 2.2

Release Date: 2009-10-01

The following is a brief summary of the additions and improvements made to iRODS 2.2 compared to the previous version, 2.1.

As usual, this release contains many new features which were developed in response to needs expressed by the user community and supplement the base iRODS functionality in various ways. Each is very important to some sites but may be unneeded by others and can be configured and used as needed.

Improvements to iRODS

 - **HPSS Resources** A driver for the HPSS archival storage system has been developed, making it possible for iRODS to store and retrive files from HPSS (iRODS Resources of type HPSS). This makes use of the HPSS parallel I/O interface for high performance transfers. More information can be found in HPSS Resource.
 - **Amazon S3 Resources** A driver of Amazon Simple Storage Service (S3) has been developed, allowing iRODS to store and retrieve files in Amazon S3 (iRODS Resources of type S3). More information can be found in S3 Resource.
 - **Universal Mass Storage System driver** This driver provides an interface between iRODS with any kind of Mass Storage System via shell command lines (e.g: pftp, rfio, gridftp, hpss, etc), and caching the data on an associated disk resource. This is very flexible and highly configurable system. Thanks to Jean-Yves of IN2P3 for the development of this driver.
 - **Resource can be set "down"** Resources can now be declared down, either manually (via iadmin) or automatically via the Resource Monitoring System. When down, the iRODS system will not attempt to use that resource. If available, replicas on other resources will be used. The Resource Monitoring System (RMS) can also be configured to automatically set resources 'down' as well as determining resource load. (In a future release, it will be possibly to dynamically select resources based on load, via rules/microservices.) Thanks to Jean-Yves of IN2P3 for the primary development of RMS and for additional infrastructure which was done in collaboration with the DICE team.
 - **ICAT Performance Fix** A performance problem in some situations was noticed in 2.1 and a fix for this is now included in 2.2. This was noticed on a MySQL instance, but may affect Postgresql and Oracle to some degree too. Thanks to Andy Salnikov for noticing this and suggesting a solution. See the iRODS-Chat discussion thread
 - **Multiple GSI and/or Kerberos names per user** Admins can now enter more than one GSI Distinguished Name or Kerberos Principal Name for each user. There are new iadmin sub-commands to manage these, 'aua' (add user authentication-name), 'rua' (remove), 'lua' (list), and luan (list by auth-name). See iadmin -h.
 - **Zone Summary Script** A new script, 'scripts/izoneinfo.sh', was developed which creates a summary generic description of your iRODS instance and optionally emails it to the IRODS team. The overview of your iRODS Zone produced by this script can be very useful for you, and we'd appreciate it if you would also help iRODS development by sending the results to the iRODS team, so we can have better information on how people are setting up and using iRODS environments. This can also be useful in troubleshooting. Thanks.
 - **Compound Resource Access** The logic for accessing a compound resource has been modified to make it easier to use. Previously, a user could not iput to a compound resource directly, it had to be be done through a resource group. Now, the server will figure out the resource group of the compound resource, upload the data to a cache resource in this group, and then replicate the copy to the compound resource. More information can be found in resource.
 - **Automatic Replication Microservice** There is a new microservice, msiAutoReplicateService, which will automatically replicate data-objects to multiple resources when run periodically. See the descriptions in reAutoReplicateService.c for more information.
 - **ibun -x improvement** ibun -x no longer requires the target collection to be empty. If a subfile already exists in the target collection, the ingestion of this subfile will fail (unless the -f flag is set) but the process will continue.
 - **Numeric imeta queries** imeta can now do queries in numeric mode (instead of as strings), by adding 'n' in front of the test condition. See 'imeta h qu' for more information.

### Bug fixes/Small improvements

 - Resources are now automatically removed from resource-groups when the resource is being removed (mentioned on the RoadMap page after the 2.1 release).
 - An auto-commit-on-error problem when auditing is enabled was resolved (also mentioned on RoadMap page).
 - One can now do integer comparisons on some AVU metadata (also mentioned on RoadMap page). See the imeta help for queries, 'imeta h qu'.
 - Additional User-defined metadata (AVU) information is now removed from ICAT tables when possible. When AVUs are disassociated with an object (r_objt_metamap) unused AVUs (r_meta_main) are now also removed. When objects are deleted that have associated AVUs, both steps are now included. If you have a large number of AVUs and are removing many, you can disable the r_meta_main cleanup and then perform it once at the end (see comments near the top in catHighLevelRoutines.c for additional information).
 - A number of new query items (table columns) were added as needed by various projects.
 - A new script, igetwild.sh, lets you 'iget' sets of data-objects using wildcard-like matching of the names. For example, 'iget.sh /tempZone/home/rods .txt e' will get all files in the collection with names that end with ".txt". This is just a interim partial solution while we develop a more comprehensive approach, but may be useful to some. igetwild.sh is under clients/icommands/bin.
 - Testing. As with previous releases, the IRODS development version is continually built and tested on local DICE hosts and periodically on various platforms at the NMI Build & Test Lab. The test suite is updated as we add new features; ICAT functionality in particular (all SQL forms).
 - Fix a problem with 'ibun -cDtar' where some files may not be staged to the target resource under some circumstances.
 - Fix a problem where ils returns a BAD_INPUT_DESC_INDEX error when the target is a mounted collection with a large number of files and subdirectories.
 - Fix a problem with the rcDataObjTruncate where the wrong size may be truncated.
 - Fix a problem where ibun cannot handle paths with spaces and other unusual characters.
 - Fix a server seq fault problem when icp to a mounted collection.
 - Fix a server memory leak when icp to a mounted collection.
 - Fix an intermittent problem with "ibun -c" where the server may not find the source collection path.
 - Fix a problem where icp of a zero length file into a mounted collection may appear successful, but no file was copied.
 - Fix a problem where "ibun -x" does not work if the untar collection is not in the path of the user's home collection.
 - Fix a problem the new file length is not registered if a file is overwritten with a 0 len file.
 - Add function to enforce deletion policy for files with muliple copies.

### Other small improvements and bug fixes

As always, a number of other improvements and fixes were made. Details on these are available in the 'svn' logs.

### Other Noteworthy Improvements/Events

**Development version downloadable** The current version of the iRODS source code is available via a subversion version control system (svn). These versions often have incomplete changes and/or other bugs, as they are the developers' branch, and support is limited. When our changes are complete and tested, this becomes the official iRODS release. So you should use the release in almost all cases. But you can anonymously check out a copy via: svn co svn://irodssvn.ucsd.edu/trunk [PATH]

**You can update our web-based documentation (Wiki)** As always, our documentation on our IRODS web site (www.irods.org) has been updated for this release in various ways. This is a Wiki system, which has also been updated -- users and contributors are invited to register an iRODS wiki account to help maintain and improve these pages.

**Recent Major Demos to White House/NSF/NARA** Also worth noting, the DICE team, in collaboration with SHAMAN staff, prepared and gave two major demonstrations/presentations recently. The first was at NSF to the Networking and Information Technology Research and Development subcommittee for the White House, NSF and NARA (about 50 attendees, lasting 3 1/2 hours), August 4th. The second was a DICE/SHAMAN presentation/demonstation at ARA (about 2 1/2 hours). Slides and audio/video recordings are available from our web site.

**Upgrading from 2.1 to 2.2: Note that a patch to the iCAT database is required** The 'irodssetup --upgrade' (equivalent to 'irodsupgrade') script will warn and prompt you about this. The 2.1 clients will function properly with the 2.2 server for most operations, but some are not completely compatible and will return errors in these cases. For example, the 2.1 'ilsresc', 'iuserinfo', and some of the'iadmin' sub-commands will get errors (CAT_SQL_ERROR, usually) instead of being able to complete a function (due primarily ICAT tables changes). To install, unpack the tar file, cd iRODS and run './irodssetup' or './irodsupgrade'.

**RECOMMENDED:** Update your iRODS Servers first, then 'iadmin' and the other clients soon thereafter.

**Reminder:** after you upgrade to 2.2, please run scripts/izoneinfo.sh and email the IRODS team with this basic information about your iRODS instance. This contains only generic information and will help us understand iRODS environments and use and improve the system for all. Thank you.

## 2.1

Release Date: 2009-07-10

The following is a brief summary of the additions and improvements made to iRODS 2.1 compared to the previous version, 2.0.1.

As usual, this release contains many new features which were developed in response to needs expressed by the user community and supplement the base iRODS functionality in various ways. Each is very important to some sites but may be unneeded by others and can be configured and used as needed.

### Improvements to iRODS

 - **MySQL can now be used for the iCAT** In addition to PostgreSQL and Oracle, iRODS can now use MySQL for the iRODS database (iCAT). See the 'MySQL' page on the iRODS web site (https://www.irods.org/index.php/MySQL) for installation instructions. Thanks to Andy Salnikov of SLAC for developing the MySQL interface software.
 - **Kerberos authentication** In addition to the iRODS secure password and GSI, Kerberos can now be used as an authentication mechanism. As with GSI, when you enable Kerberos the IRODS secure password system also continues to be available. If you need both GSI and Kerberos at the same time, let us know and we will try to develop a solution to some issues with naming conflicts in dynamic libraries. See the 'Kerberos' page on the iRODS web site (https://www.irods.org/index.php/Kerberos) for installation instructions.
 - **A physical bundling system** This is based on tar and allows system administrators to bundle existing files in user collections into tar files for efficient file transfer, storage, and retrieval. See the new 'iphybun' command and Bundling for more information.
 - **Using the tar executable for bundling** By default, the server now uses the "tar executable" that normally comes with the OS instead of "libtar" for bundling type operations. "libtar" can still be used by configuring the "tarDir" parameter in the config.mk file.
 - **The "ibun -c" function** has been enhanced such that if a copy of a file to be bundled does not already exist on the target resource, a replica will automatically be made on the target resource before bundling. Previously, an error was returned instead.
 - **New Compound resource class** A Compound Resource is now defined for resources that support only the put/get type of functions instead of the full posix file I/O functions (open, read, write, close, etc). The implementation makes it easier to integrate HPSS, FTP and ADS type resources into iRODS. See resource for more info.
 - **Better support for using and writing micro-services:**
    - Documentation of Session Variables Available for Rules can be found in https://www.irods.org/index.php/Attributes.
    - Unused Session Variables have been removed from the ruleExecInfo_t (rei) structure and alternative Session Variable definitions have been added for some Session Variables.
    - Data structures used by micro-services were consolidated and more helper routines developed.
    - Implemented the msKeyValStr input type which allows multiple keywork/value pairs to be input in one string. This addresses the issue that many input parameters available to the client/server API are not available to the associated micro-services. Many micro-services including msiDataObjChksum, msiDataObjCreate and msiDataObjOpen, etc, have been modified to use this input type. In addition, the modifications were made backward compatible with existing input.
 - **The Resource Monitoring System** This system monitors the load on iRODS servers (CPU, runq, memory, swap, paging, network, and disk) and can be used in load balancing. See the Resource Monitoring System web page ( https://www.irods.org/index.php/Resource_Monitoring_System) for additional descriptions and operational instructions. This is an initial version but is highly functional. Thanks to Jean-Yves of IN2P3 for the primary development of this system in collaboration with DICE.
 - **Many new system level rules called in iRODS processing** A large number of new rules are now invoked at various points in the normal processing of iRODS events. By default, these are no-ops but can be configured to call other rules and microservices for site-specific processing. These were requested by the European SHAMAN project (Sustaining Heritage Access through Multivalent ArchiviNg). A list of new Rules for Release 2.1 can be found in Rel2.1_Rules.
 - **Many new user level micro-services** These include micro-services by our collaborators such as the French National Library and IN2P3. A list of new micro-services for Release 2.1 can be found in Rel2.1_Micro_Services
 - **Multitasking the batch server (irodsReServer)** for more robust job execution. e.g., a problem with executing one task will not affect the execution of other tasks. A new Rule - acSetReServerNumProc and a new micro-service - msiSetReServerNumProc to allow the admin to specify the maximum number of processes to use in irodsReServer.
 - **Additional Doxygen Microservice documentation** Additional Doxygen documentation (comments at the head of each function) has been added. Thanks to Terrell Russell, Jewel Ward, and Ketan Palshikar of UNC-CH for this.
 - **Jargon improvements** The Java interface includes many new features and other improvements since the previous iRODS release, most notably: Parallel put/get for better transfer performance; User defined metadata queries, and other new metadata; put/get using the rules; MD5 checksums; GridFTP protocol put/get (beta); Proxy commands; Improved efficiency, bugfixes and internationalization.
 - **ERA Microservice Extensions** Additions and refinements were made to some of the microservices used in some Electronic Records Archives Program (ERA/NARA) environments. Additions include the following micro-services and related material: msiStructFileBundle; a collection spider (which crawls a collection recursively and applies a sequence of actions/microservices for each object found, with the object as a possible input); micro-services for the consolidation of NARA's legacy collections; and a msiListEnabledMS and .ir file. Small bugs were fixed in xmlMS.c and xsltMS and the XML parser was improved to handle non null-terminated buffers. ERA micro-services were updated to reflect changes in the iRODS Server API. A small script, switchuser.py, was added which easily switches between multiple iRODS environments.
 - **Better support for restricted listing of collections (ACLs, Access Control Lists)** Previously controlled at build time (via a GEN_QUERY_AC flag in config.mk), a Rule and micro-service (acAclPolicy/msiAclPolicy) are now used to set the policy on access to certain metadata. When set to STRICT, the General Query Access Control is applied on collections and dataobject metadata, which means that ils, etc, will need 'read' access or better to the collection to return the collection contents (name of data-objects, sub-collections, etc). For more information, see the Rule and comments in core.irb.
 - **iRODS Standard I/O** Applications using Unix Standard I/O (fopen, fread, fwrite, etc) can use this library to also access iRODS files. You add an include statement and rebuild the application, and then files with names starting with a prefix ('irods:') will be handled as iRODS files. Like the Unix standard I/O library, the ISIO library caches data to avoid issuing numerous small I/O (network) operations, greatly improving performance. This is an initial version, but handles the primary features of fopen, fread, fclose, fwrite, fseek, fflush, fputc, fgetc, and exit under some versions of Unix/Linux. More can be added as needed. See the lib/isio subdirectory for more information.
 - **Syslog support** Instead of the regular logging into files under server/log, the iRODS Server and agents can be configured to log to syslog. See config.mk[.in] on how to enable this. Thanks to Roger Downing of the UK e-Science project for these mods.
 - **Doxygen script** There is now a script that can be run to generate Doxygen output of the IRODS source tree. See runDoxygen.rb in the release for more information. Thanks to Adil Hasan of the University of Liverpool for this.
 - **Unregistration of files and collections** Added -U option to irm to unregister data objects and collections without deleting the physical files.
 - **Additional Extensions** Various modifications/extensions were provided by Romain Guinot of Technologies et services de l'information, France, and those that were generally useful were integrated or modified/integrated by the DICE team.

### Contributed External Extensions to iRODS

 - **WebDAV** The Davis (WebDAV-iRODS/SRB) WebDAV gateway is a Java-based web interface to iRODS that was developed and contributed to iRODS by the Australian Research Collaboration Service (ARCS) after iRODS version 2.0.1. For more information and download access see https://projects.arcs.org.au/trac/davis/wiki/WikiStart.

### Bug Fixes/Minor Extensions

As always, the release includes many bug fixes and other improvements, including the following:

 - A bug where irepl or icp to/from a i86 Solaris platform may fail was fixed.
 - A problem was fixed in Windows iExplorer, so it can now handle more than 500 items when querying sub-collections and datasets.
 - 'iquest attrs' now prints the available attributes (see -h)
 - iquest can now return more than 500 rows (after asking).
 - 'irule -F showRules.ir' (in the clients/icommands/bin directory) will list the current rules (from core.irb).
 - 'irodsctl test' option is changed and now warns before running
 - The DICE test system now includes some Jargon tests and some concurrent iput/iget (load/pound) tests.
 - Non-admin users running iqdel can now delete their own queued Rules.
 - An inheritance bug when using Oracle iCAT has been fixed.
 - A problem in setting the user-level thru non-IES servers was fixed.
 - A permissions problem with multiple fileOpens was fixed.
 - icommands -h text now includes the iRODS release version/date.
 - A new command, ihelp, has been added which lists the i-commands and their help.
 - irodssetup (with advanced option) can now set the port range (svrPortRangeStart and svrPortRangeEnd variables), for firewall configurations.
 - There is an improved obfuscation scheme used when setting passwords ('ipasswd' and 'iadmin moduser password'), backward compatible.
 - There is a new query to return ACLs, used by Jargon.
 - Fixes were made so that users who are not the original owner, but who have group-based access, can delete collections; this works for trash and non-trash configurations.
 - Fixes were made for GSI authentication, to handle the case where no iRODS zone is specified.
 - A fix was made for certain cases of cross zone authentication.
 - Added -R option to ichksum to specify the resource of the replica to chksum
 - Added "byRescClass" option to the msiSortDataObj micro-service.
 - Fixed a problem in iRODS FUSE where ls of a file in a mounted collection always succeeds even if the file does not exist.
 - Fixed a problem in iRODS FUSE with renaming newly created files.
 - Configure/build changes were made for additional GSI installation types.
 - Fix a problem of ending up with the wrong file length in iCat when overwriting an existing irods file with a zero length file.

#### Bugzilla items fixed:

 - 16 ichmod -r doesn't set ACLs on the top or sub-collections
 - 19 iquest core dumps when given invalid command
 - 17 Parentheses around a single condition returns true even when false
 - 3 iput -r has differnt behaviour with a extra / at the end
 - 14 ils output
 - 6 Large recursive ichksum fails with 'broken pipe'
 - 9 irepl fails

**Testing:** As before, the IRODS development version is continually built and tested on local DICE hosts and periodically on various platforms at the NMI Build & Test Lab.

**Upgrading from 2.0.1 to 2.1: Note that a patch to the iCAT database is required when converting from 2.0.1 to 2.1.** The 'irodssetup --upgrade' (equivalent to 'irodsupgrade') script will warn and prompt you about this. The 2.0.1 clients are compatible with 2.1 servers; the protocol version is the same. To install, unpack the tar file, cd iRODS and run './irodssetup' or './irodsupgrade'.

## 2.0.1

Release Date: 2009-01-26

iRODS 2.0.1 is primarily a stability release, as it includes a number of bug fixes and smaller improvements over our fairly recent 2.0 release (December 1). It also includes a new capability for Windows, the ability to run Windows servers.

The following is a brief summary of the additions and improvements made to iRODS 2.0.1 compared to the previous version, 2.0.

### Major Extension

 - **Storage Resources on Windows Servers** Microsoft Windows systems can now be used as a storage resource host. A binary version of Windows servers can be downloaded from the iRODS web site. Or, as with Unix systems, it can be built from the 2.0.1 released source. For installation instructions see the server section of the windows page on the iRODS web site. You will need to install the 2.0.1 version of the ICAT-Enabled Server too.

### Improvements

 - **iput to replica behavior improved.** The behavior iput has been changed, in the case where a copy of the file exists but not on the iput target resource. Now, the file is uploaded into the target resource and registered as a replica. Previously, one of the existing physical copies of the file was overwritten even though it was not stored in the target resource.
 - **Processing rule for 'ireg' added.** A rule has been added, "acPostProcForFilePathReg", which is executed after the registration of a file path (ireg). Admins can update this rule for site-specific post-processing. Default is a no-op.
 - **Avoiding postgreSQL errors in log.** irodssetup will now add an option in a configuration file ("Ksqo=0" in the ~/.odbc.ini) to avoid a warning error (ERROR: unrecognized configuration parameter "ksqo", STATEMENT: set ksqo to 'ON') in the postgres log (pgsql.log) with each connection. Without this, pgsql.log could grow quite large on busy iRODS systems. Thanks to Graham Jenkins of the Australian Research Collaboration Service for this.
 - **GSI libraries added.** Makefiles were updated to include two additional libraries needed for certain versions of GSI. These are globus_callout_$(GSI_INSTALL_TYPE) and ltdl_$(GSI_INSTALL_TYPE). This fix was provided by Jean-Yves Nief of IN2P3, France.
 - **GSI irodsServerDn added.** An iRODS variable, irodsServerDn can be defined to specify the server's GSI Distinguished Name (DN). When irodsServerDn, or SERVER_DN, is defined the client will authenticate the server (making sure it's talking to the real server). irodsServerDn takes precedence over SERVER_DN. Like others iRODS variables, irodsServerDn can be defined in the user .irodsEnv file or as an environment variable.
 - **GSI authentication can be without irodsUserName.** Clients can now connect to iRODS and authenticate with GSI without first setting the irodsUserName. If the client's irodsUserName is blank, the server, during the authentication sequence, will check the iCAT for users matching the authenticated DN. If one, and only one, irods user matches, the current session will be established as that user.
 - **Additional GSI DN-processing configurations.** If, as above, no irodsUserName is provided during GSI authentication, but if no matching DN is found, a rule, 'acGetUserByDN', will be executed. By default this is a no-op but the rule can be configured to run a command (or Micro-service). If that command returns an iRODS user name in stdout, that user name will be used for the session. If not, a check will be made again in the ICAT. So the external command can either return an iRODS user name to use, or it can create the new user itself (via iadmin). This is useful for Virtual Organizations. See the acGetUserByDN section in core.irb for an example. This was developed in collaboration with Shunde Zhang and Graham Jenkins of the Australian Research Collaboration Services (ARCS).
 - **remoteExec port number.** A port number can now be included on the remoteExec call.

### Bug fixes

 - **ils bug fix.** A bug in ils was fixed where with no command-line options, it would show the same file multiple times if the file had multiple copies (replica).
 - **irsync memory leak fixed.** An a irsync memory leak was fixed which could cause the process to run out of memory and died after synchronizing a few hundred files.
 - **ibun -x bug fixed for large numbers of files.** A bug was fixed where 'ibun -x' would fail when the number of files in the tar file was larger than 500 (MAX_SQL_ROWS).
 - **iRODS Fuse deadlocks fixed.** A couple of deadlock problems were fixed in the iRods Fuse interface where the iRODS connection lock was not being released. Now users can use the normal Unix file browser ("finder" for mac) to browse files stored in iRODS.
 - **GSI segfault bug fix.** A bug was fixed in the iRODS-GSI interface code where, when using GSI authentication and the environment variable SERVER_DN was not defined, the i-command would die (segfault).
 - **m2icat.pl bug fix (SRB to IRODS migration tool).** A problem was fixed in handling some versions of th SRB MCAT. Logic was added to parse and use the header in the Spullmeta-data log file to get the indexes of the various fields, since they can vary.

## 2.0

Release Date: 2008-12-01

As always, iRODS 2.0 builds on the previous versions, and introduces important new functionalities including iRODS Zone Federation (see below) as well as a large number of other significant improvements. For a description of iRODS functionality, see the Introduction to iRODS and iRODS V1.0.

The following is a brief summary of the additions and improvements made to iRODS 2.0 compared to the previous version, 1.1.

 - **Federation.** Zone Federation has been added which provides facilities for two or more independent iRods systems to interact with each other and allow for seamless access of data and metadata across these iRods systems. These systems are called iRODS Zones, with each Zone running its own iCat and administrative domain. iRODS Federation requires less synchronization between zones than the similar SRB Federation system. See Federation and Federation Administration for more information.
 - **Master/Slave iCat with Oracle.** An iRods installation or Zone can be configured to run with a single Master iCat plus zero or more Slave iCats. The purpose of the Slave iCat is to improve responsiveness of queries across a Wide-Area-Network. The Slave iCats are used for "read only" type queries. The following icommands have been converted to use the Slave iCat by default: icd, iget, ils, ilsresc and iqstat. This makes use of RDBMS functionality to sychronize the ICAT databases and so is available when using Oracle as the ICAT RDBMS.
 - **Initial SRB to iRODS Migration tool.** There is now a preliminary version of a tool to help convert an SRB Instance to an iRods one. The 'm2icat.pl' script uses Spullmeta to get SRB-MCAT information and creates and executes sets of commands for iadmin, psql, and imeta to create resources, collections, dataObjects, and users in the iRods instance. The iRODS system can then access former-SRB data without moving the physical files. This is still incomplete and cannot handle many of the features of SRB, but you may wish to experiment with it. See the script for more information and contact us to help us plan additional extensions.
 - **Grid Security Infrastructure (GSI) Improvements.** A significant problem in the iRODS interface to GSI was corrected, allowing regular iRODS users to authenctiate with GSI. Users can also now set the environment variable SERVER_DN to authenticate the server via the GSI system (perform mutual authentication).
 - **iRods FUSE improvements.** iRods FUSE now works with the latest versions of FUSE instead of only version 2.7.0. Caching files and directories query results to improve the performance of the getattri call which is call frequently by FUSE. Small files are cached to improve the I/O performance on small files. File modes of files has been enabled so that chmod of files now works. You should see noticeable performance improvement in commands such as ls or cp of small files.
 - **iRODS Explorer for Windows.** The new iRODS Explorer for Windows has been available since mid-September. As described on the windows page, this is an iRODS browser that runs as a native Windows binary and provides a rich Graphical User Interface and a fast navigation of the hierarchical collection-file structure inside iRODS. In addition, users can add, modify, and view metadata with long string values through a user-friendly metadata dialog.
 - **DataMode preserved.** A "dataMode" metadata item was added so that the file mode of files uploaded to iRods and downloaded from iRods, can be preserved. "dataMode" is the Read-Write-Execute status for user, group, other, of a file.
 - **New bundling.** A new 'ibun' command is used to handle the bundling of small files into structured files such as tar files. It can be used for the uploading, downloading, and archival of a large number of small files. For example, to upload a large number of small files, a user can use the normal UNIX tar command to tar these files into a single tar file. This single tar file can then be uploaded to iRods using the iput command. The "ibun -x" command can be used to request the iRods server to untar this file into many small files and register these small files with the iCat. Similarly the "ibun -c" command can be used to efficiently download a large number of small files.
 - **New 'ipasswd' Command.** 'ipasswd' allows users to change their iRODS password. As with the corresponding iadmin command, the password is obfuscated for network transfer.
 - **Rule-oriented Data Access (RDA) ported to Oracle.** RDA is now supported on Oracle as well as the previous PostgreSQL. RDA provides access to arbitrary databases through the iRODS system, somewhat like the SRB DAI (Database Access Interface) but implemented via rules and micro-services.
 - **Other RDA improvements.** A msiRdaRollback micro-service was implemented; some memory leaks were fixed; and an obfuscated form of the RDA password can be set in the RDA configuration file.
 - **Rule-language 'break'.** A 'break' statement is now accepted in the iRODS Rule language to break out of for, while, and foreach loops.
 - **Federation User and Administrative Changes.** In the iadmin and imeta commands, users are now represented with an optional Zone name (user[#zone]), where the local Zone is default. iadmin has mkzone, modzone, and rmzone subcommands to manipulate remote-zone information. ilsresc, imeta, and irmtrash now have '-z zoneName' options to work with remote Zones. Internally, user authentication uses an optional Zone name.
 - **Federation Server Authentication.** A capability was added where the iRODS Server which is authenticating a Client for a remote Zone, is itself authenticated. This is optional, but highly recommended for Federated Zones to improve security. See -- for additional information.
 - **Zone Renaming.** The iadmin tool can now be used to rename your local Zone, handling the conversion of the Zone and user information and renaming user home collections (via a new Rule and micro-services). This may be useful with iRODS Zone Federation.
 - **Timed connection -T option.** A new -T option was added to the iput, iget, irepl and icp commands which renews the socket connection between the client and server after 10 minutes of connection. This gets around the problem of sockets getting timed out by the firewall as reported by some users.
 - **New RBUDP data transfer mode.** A new data transfer mode - RBUDP (Reliable Blast UDP) was added, in addition to the existing the sequential (single TCP stream) and parallel (multi TCP streams) modes currently supported by iRODS. RBUDP is developed by Eric He, Jason Leigh, Oliver Yu and Thomas Defanti of U of Ill at Chicago. http://www.evl.uic.edu/cavern/RBUDP/Reliable%20Blast%20UDP.html It uses the UDP protocol for high performance data transfer. A new option -Q has been added to the iput, iget,irepl and icp command to specify the use of the RBUDP protocol.
 - **HDF5/iRods Improvements.** The HDF5/iRods client can now be built without linking to the HDF5 library. A JNI capability for JAVA client such a hdfView, was added. A memory leak was fixed.
 - **Inherited Access Permissions.** An inheritance attribute can be set on a collection to cause new data-Objects and sub-collections created under it to acquire the access rights (ACLs) of the collection. See 'ichmod -h' and 'ils -A' for more information.
 - **ICAT Improvements.** The iRODS Metadata Catalog interface software (ICAT) was improved in various ways, in addition to changes for iRODS Zone Federation. Access to the Audit tables via queries is now restricted by default. A bug was fixed dealing with recursively setting access control on replicated data-objects. Problems in getting the totalRowCount (when requested) were resolved (for both Oracle and Postgres). In the General-Query, any number of compound conditions (separated by || or &&) can now be handled (instead of just two). After various errors, the ICAT functions (when using PostgreSQL) will do an automatic rollback to allow subsequent SQL to function. Some ICAT-Oracle memory leaks were found and fixed. imeta and the ICAT AVU queries can now accept multiple conditions separated by 'and' and a single 'or'. 'isysmeta' can now set the data-type of a data-object. For improved long-term maintenance, internal changes were made in the way that the ICAT general queries are structured.
 - **Additional Micro-services.** A number of new micro-services have been added to enable new functionality, including some of the features described in these release notes. These can also be used in your own rules and as examples for developing your own micro-services. See Released Micro Services for the current list. Special thanks to Romain Guinot of the Open Source Center - Atos Origin (http://www.portaildulibre.fr) for providing some of the new micro-services, both for the core and as a separate module ('guinot').
 - **Testing Improvements.** As before, the IRODS development version is continually built and tested on local DICE hosts and occasionally on various platforms at the NMI Build & Test facility. ICAT tests were expanded to cover new ICAT functionality. Some heavy-load tests were developed.
 - **Installation/Control Improvements.** A variety of changes were made to the iRODS installation and control scripts to handle specific error situations; also, finishSetup.pl will now update ~/.odbc.ini to include the [PostgreSQL] section that is also stored in the .../pgsql/etc/odbc.ini file, to avoid problems on some hosts, etc. Also, the Make scripts will now automatically re-link modules that have updated source files. And 'iinit' will create the ~/.irods directory if it is not present and prompt for and store the needed .irodsEnv items if they are missing. The install scripts now default to Postgres 8.3.5.
 - **New Transfer Logging.** When enabled (manually), the transfer operations of get, put, replicate, and rsync are logged. See the comments in rsDataObjClose.c for more information.
 - **imkdir can create parent collection.** A -p option was added to the imkdir command to cause it to create parent collections if they don't already exist.
 - **Other Bug Fixes.** As always, other bugs have been fixed and many small improvements made; too numerous to describe.

**Note that a patch to the ICAT database is required when converting from 1.1 to 2.0.** The 'irodssetup --upgrade' (equivalent to 'irodsupgrade') script will warn and prompt you about this.

**Also note that iRODS Servers are backward compatible but iRODS Clients are not.** There is a protocol change to support iRODS Zone Federation, where the Zone is included in a login message. The server will recognize messages without the Zone and will default to the local Zone. So servers can accept connections from old (e.g. irods 1.1) clients, but 2.0 clients will not be able to connect to old servers. So be sure to upgrade your servers first, and then the clients.

## 1.1

Release Date: 2008-06-27

As always, this release builds on the previous versions. For a description of iRODS functionality, see the Introduction to iRODS and iRODS V1.0.

### New features of 1.1 (from 1.0) include:

 - **Grid Security Infrastructure (GSI).** GSI is now supported as an additional optional authentication method. When clients and servers are built GSI-enabled, users can choose to authenticate via their GSI X.509 certificates. GSI is enabled by answering a few questions in the irodssetup script.
 - **Electronic Records Archives (ERA) Module Extensions.** The ERA module contains new collections management micro-services for manipulating objects, user accounts, access rights and metadata. Several micro-services have also been added to retrieve audit trail information from the iCAT. An XML module has been created and contains a micro-service that performs XSLT transformations on iRODS objects. Several miscellaneous functions have been added to the core set of micro-services (to print data structures, manipulate time and apply a Dublin Core metadata template).
 - **A rich web client: iRODS Browser (Beta).** Introducing iRODS Browser (Beta), a user-friendly web application for iRODS users to access and manage iRODS collections stored on any iRODS server, using a standard web browser. iRODS Browser is hosted here: [1]. No installation is necessary for end-users, unless you wish to host your own iRODS Browser, which requires extensive knowledge of web server setup/configuration. You can get more information about iRODS Browser on this page: iRODS_Browser.
 - **Mounted Structured Files.** This is similar to mounting a UNIX file directory to a collection implemented in iRods 1.0. In this case, a structure file (with internal structure containing files and subdirectories) such as a tar file is mounted instead of a file directory. Once the tar file is mounted, a user can use iCommands to access the files and subdirectories contained in the tar file. The implementation includes:
     - Creating a framework for mounting multiple types of structured files. To implement a new type, 17 I/O functions (open, read, write, close, etc) specific to the structured file need to be provided to the driver.
     - Currently we have implemented one type of structured file - the tar file.
     - imcoll - A new command for managing (mount, unmount, sync, etc.) the structured files. In addition, the mounting and unmounting of UNIX file directories has been moved from the ireg command to the new imcoll command.
     - More than 20 new APIs (client/server calls) have been created to support this implementation.
 - **iRods HDF5 Integration.** HDF5, a general-purpose library and file format for storing scientific data, has been integrated into the iRods framework in the form of micro-services. Five HDF5 microservices: msiH5File_open, msiH5File_close, msiH5Dataset_read, msiH5Dataset_read_attribute and msiH5Group_read_attribute have been implemented on the server. HDF5 files can now be stored in iRods and users can use iRods client functions to make HDF5 specific calls to access HDF5 files stored in iRods. The client implementation also includes a JNI interface that allows the HFD5 Java browser HDF5View to access HDF5 files stored in iRods.
 - **Java Client API: JARGON.** The Java Client API for the datagrid now officially includes iRODS. It supports most of current iRODS functionality, including iCAT queries, file I/O, metadata manipulation, and basic rule executions. A quick starter guide plus a full API documentation is hosted here: Jargon documentation. You can download Jargon from here: extrods project download page.
 - **Web Services Available as Micro-Services.** One can now create iRODS micro-services that call Web Services by wrapping the web service interactions using a gsoap envelope and writing micro-service interfaces for input and output arguments for the web services. A description of how to write those interfaces and how to access web services as micro-services is available at: Web_Services_As_Micro_Services.
 - **RuleGen Rule Language.** Rulegen is a parser that takes rules written in a nicer language to the cryptic one needed by irule and core.irb. The input files for the rulgen are recommended to be *.r (.r extensions) and the output created by the rulegen is in the form of *.ir (.ir extensions). The rulegen parser is found in icommands/bin with its source files in icommands/rulegen. There is a note called HELP.rulegen that explains how to make and use the parser. The note also contains the grammar of the rulegen language. HELP.rulegen can also be found here.
 - **PHP Client API: prods.** Introducing prods, a PHP Client API for iRODS. It supports most of current iRODS functionality, including iCAT queries, file I/O, metadata manipulation, basic rule executions. A quick starter guide plus a full API documentation is hosted here: prods documentation. You can download prods from here: extrods project download page.
 - **Preliminary ICAT Auditing.** A preliminary version of ICAT Auditing has been developed. When enabled, significant events (at the ICAT level) are recorded into an ICAT audit table. This is still under development.
 - **Preliminary Rule-oriented Database Access (RDA).** There is now a preliminary version of Rule-oriented Database Access (RDA). This is generally similar to SRB-MCAT DAI as it provides access to arbitrary databases through the iRODS system, but it is based on the use of Rules and Microservices to achieve this. There are significant restrictions with this version, however, and RDA will be substantially improved in later releases.
 - **Windows i-commands.** The pre-built binaries are available for download. Users can also build their own Windows i-command binaries from iRODS source distribution.

### Major improvements in 1.1 (over 1.0) include:

 - **Improved Oracle Support.** Significant problems when using Oracle for the catalog (ICAT) have been fixed. This includes an error dealing with repeated open/closes which caused the RuleEngine Server to abort, a handle-leak which would cause errors when iput'ing large subdirectories, an error with rollback causing error-recovery failures, and problems in the irodssetup script.
 - **Three New Collection Client/Server Calls.** rcOpenCollection, rcReadCollection and rcCloseCollection were added to make it easier for users to query the content of a collection. Instead of the very powerful but complicated-to-use rcGenGuery call which is normally used for these type of queries, the new calls are similar to the familiar opendir, readdir and closedir calls of UNIX. However, these calls are inefficient since a rcReadCollection call is needed to read each entry. A more efficient set of calls - rclOpenCollection, rclReadCollection and rclCloseCollection which use the rcGenGuery call underneath, were created to give the same functionalities and an easy-to-use interface. Most of the iCommands have been converted to use these functions.
 - **New group 'public' and user 'anonymous'.** All users are automatically added to the group 'public' as the ICAT user entries are created. Users can give access to 'public' to give access to all authenticated users. If the administrator adds user 'anonymous' people will be able to login as 'anonymous' without a password. User 'anonymous' does NOT belong to group 'public'. (Various Rules are used in doing this). 'ils -A' now shows the access lists for collections as well as data-objects.
 - **irodssetup/irodsctl improvements.** The installation script system (irodssetup) has been improved in many ways. It is now possible to build a state file (irods.config) via prompts, quit the setup and edit the irods.config by hand, and then resume; repeated runs of irodssetup can be done, reusing some or all of the irods.config settings; there is support now for running multiple irods systems on the same host; irodssetup now displays and prompts for postgreSQL and ODBC versions to use; some additional 'advanced' prompts have been added; the sub-scripts have been refactored; terminology and descriptions improved; and numerous small improvements and bug fixes have been made.
 - **Improved Pre-Release Testing.** We are now running continuous build/test runs via Tinderbox on a Ubuntu linux host and a Macintosh, and as-needed build and test runs at the NMI Build and Test Lab. The NMI B&T tests run on 5 platforms: Linux, Mac-PowerPC, Mac-Intel, Solaris, and AIX (in various modes). Testing now includes a new suite of load tests in addition to the previous i-command (from IN2P3) and ICAT test suites.
 - **Improved User Password Security.** User passwords as stored in the ICAT are no longer plain-text. They are scrambled using an internal iRODS algorithm similar to how passwords are concealed in the user authentication file.
 - **iRods FUSE Improvements.** Fuse now sees mounted collections. A memory leak problem when uploading a large number of files has been fixed.
 - **Safer irm and irmtrash.** The protocol for the rcRmColl API which has been used by the irm and irmtrash commands to recursively delete a collection, has been changed to make it safer to use. Before this change we found that once this call is made, the server will continue with the deletion even after the the client process has exited (e.g. by typing control-C). The new protocol now has the server and client exchange some status messages after every 10 files have been deleted. The server terminates itself once it discovers the client has exited. All future recursive operations on collections will also use this protocol.
 - **irepl update option.** An option (-U) has been added to irepl to update old copies with the latest copy.
 - **irsync all option.** An option, (-a) has been added to irsync to synchronize all copies of an irods file with a local copy.
 - **Rule Engine Re-initialize Option.** A feature has been added to re-initialize the rule engine of the Rule Execution server (irodsReServer) when the core.irb file has been changed.
 - **Bug fix for icp and irepl.** A bug was fixed with the icp and irepl commands where the SYS_OUT_OF_FILE_DESC was returned when more than 95 files were copied.
 - **iexecmd bug fix.** A bug was fixed with the iexecmd command which returned an EXEC_CMD_ERR error.
 - **-X option bug fix.** A bug was fixed with the -X option (restart) of the iput, iget and irepl commands to be able to handle path names containing spaces.
 - **Much More.** As always, many additional improvements and bug fixes have been made, too numerous to effectively describe.

See the Released Micro Services page for descriptions of the current set of released microservices.

For instructions on installing iRODS or upgrading from 1.0 to 1.1, see the INSTALL.txt file within the distribution. You will need to upgrade the clients to 1.1 too, as there was a minor protocol change and so 1.0 clients will get an error when connecting to 1.1 servers.

## 1.0

Release Date: 2008-01-23

As always, this release builds on the previous versions. For a description of iRODS functionality, see the Introduction to iRODS and iRODS V1.0.

New features of 1.0 (from 0.9.x) include:

 - Oracle can be used as the iRODS Database (ICAT) (in addition to the previous PostgreSQL).
 - The ICAT can now be run on 64-bit hosts, via either PostgreSQL/ODBC or Oracle (Release_Notes_1.0#ICAT_Compatibility)
 - There is now a FUSE interface to iRODS, allowing users to interact with iRODS data-objects via Linux file utilities (NFS-mounting iRODS space).
 - Rule Engine/Workflow Language - A scripting language is being developed in addition to the logic programming type interface currently employed for rules and workflow execution. The programming language makes it easier for user to design rules and workflow. This release includes the first phase of this development.
 - A framework has been added for "mounted collections". UK eScience is developing a version of this to aggregate files into tar-like files. Another version allows one to a mount Unix directory as a collection which allows the access of all files and subdirectories beneath a Unix directory by registering just the top directory using the 'ireg -C' command.
 - A RemoteExec function has been added to the rule and workflow framework to allow the remote execution of rules and micro-services on remote hosts. An option to execute micro-services on remote hosts has been added to the rcExecMyRule API as part of the implementation
 - A irodsXmsgServer server has been added which allows the exchange of out-of-band messages between micro-services, clients and servers, servers and servers, etc. Initially, it will be primarily used to exchange progress status type messages. This is the first phase of the implementation which has the basic functionality of sending and receiving out-of-band text messages.
 - The source tree has been reorganized and "modulized" to make it easier to add microservices.
 - A large number of new microservices have been added, providing even greater configurability and capabilities (see Released Micro Services). There are Test Services, iCAT System Services, RuleEngine MicroServices, Workflow Services, System MicroServices, User MicroServices, iCAT Services, and User MicroServices.
 - The configure/make/install systems have been extended, refactored, and portions rewritten to ease installation in multiple configurations.
 - Additional testing subsystems have been added and/or improved.
 - Many additional improvements and bug fixes have been made.
 - Documentation has been extended.

This table shows the type of ICAT installations that are currently supported.

| Operating System |     Hardware     | PostgreSQL/OldODBC | PostgreSQL/NewODBC | Oracle/OCI | MySql/NewODBC |
|:----------------:|:----------------:|:------------------:|:------------------:|:----------:|:-------------:|
|       Linux      | Intel x86 32-bit |         Yes        |         Yes        |     Yes    |      Yes      |
|       Linux      | Intel x86 64-bit |         No         |         Yes        |    Yes*    |       ??      |
|      Solaris     |   Sparc 32-bit   |         Yes        |        ?Soon       |     Yes    |       ??      |
|      Solaris     |   Sparc 64-bit   |         No         |        ?Soon       |     Yes    |       ??      |
|      Solaris     | Intel x86 32-bit |          ?         |         Yes        |     Yes    |       ??      |
|     Mac OS X     |      PowerPC     |         Yes        |          ?         |      ?     |       ??      |
|     Mac OS X     | Intel x86 32-bit |         Yes        |          ?         |      ?     |      Yes      |
|        AIX       |        IBM       |         Yes        |          ?         |      ?     |       ??      |

Yes - Tested, known to work

Yes* - Used in production (Jean-Yves)

No - Does not work, subsystem (oldODBC) does not support it

?Soon - Not tested yet

? - Not tested (may not be needed)

?? - Unknown, not tested by DICE but may work

OldODBC - psqlodbc-07.03.200, used with SRB MCAT for the past few years

NewODBC - unixODBC (version 2.2.12 currently)

## 0.9

Release Date: 2007-06-01

We are pleased to announce the release of iRODS version 0.9, an open source data grid / data management system, which, we believe, contains sufficient features, performance, and reliability to be deployed and used widely.

Features include data movement, replication, migration, integrity checking, a logical name space, a trash system, system metadata, user defined metadata, metadata queries, administrative functionality, and error reporting and recovery. In addition to these, iRODS includes many layers, calling interfaces, subsystems, utilities, etc, that we have striven to integrate together in a coherent and comprehensive way.

Additional attention has been applied to robustness of operations and new functionality, including new icommands, a restart capability built into many operations, socket reconnection, and improved database performance and security.

Major new features of iRODS 0.9 include:

 - Several new commands:
     - ireg - registering files and directories into the iCat.
     - irsync - synchronizing local and iRODS data.
     - ichksum - checksuming iRODS data.
     - iexecmd - fork and exec commands on the iRODS server.
     - imv - renaming/moving iRODS data and collections.
     - iphymv - moving iRODS data from one resource to another.
     - itrim - trimming/removing iRODS replica.
     - irmtrash - removing iRODS data from the trash bin.
 - A restart capability built into the iput, iget, irepl and icp commands with the use of restart files (-X option).
 - Socket reconnection to handle broken connection due to unreliable networks.
 - 64 bit platform support - Non-iCat enabled servers can now run on the 64 bit Linux platform.
 - Bind Variables in the ICAT - paralleling an effort on the SRB MCAT code, the ICAT interface to the RDMS now uses "bind variables" to improve security and performance.
 - Even higher-performance than SRB. Due to the streamlined protocol, consolidated iCat schema, and the use of bind variables in the iCat code, the performance of iRODS is much improved over SRB for similar operations. For small files especially, iRODS is typically 3 to 4 times faster than SRB.
 - The addition of many new system level data management rules.
 - Numerous bug fixes, internal improvements, and testing features.

IRODS 0.9 is a major step in our plans for the future:

In September, 2007, we plan to release two client Graphical User Interface systems. One is a Web client interface to the iRODS server via PHP on a web server and JAVA script on the web client. The other is a Windows GUI client, somewhat like the SRB inQ.

In the fall, we also plan to release iRODS 1.0 which will include support for using Oracle as the database (iCAT), a Zone Federation capability, and a complete Rule Engine implementation.

Beyond that, we expect to be building on this foundation for many years to come, collaborating and adding features most needed by the community. Current near-term possibilities include support for data bundling, a notification server, verifying vault contents (each file registered in iCAT), GSI authentication, Shibboleth authentication, access controls on rules and micro-services, integration with Kepler workflow, invocation of an OGSA service, tools for migration from SRB to iRODS, GUI for rule creation, rule validation tool, an administration GUI tool, extensible iCAT, snowflake schema, a Windows server, a JARGON(Java) interface, SAGA API, HPSS driver, 64-bit database systems, SQLserver port, DB2 port, mySQL port (version 5), DAI interface, etc.

Major emphasis will be on developing application specific rules, micro-services and workflow. This includes ERA capabilities list rules, RLG/NARA assessment criteria rules, and ORION data streaming control services.

See http://irods.sdsc.edu, for downloads and additional information.

## 0.5

Release Date: 2006-12-20

We are pleased to announce that, after more than a year in development, iRODS (the integrated Rule Oriented Data System) 0.5 is now available for download. See the new web site, https://www.irods.org, for descriptions, documentation, the release file, etc.

- iRODS/SRB team -
