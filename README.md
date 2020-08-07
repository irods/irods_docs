iRODS Documentation
===================

[![Build Status](https://travis-ci.org/irods/irods_docs.svg?branch=master)](https://travis-ci.org/irods/irods_docs)

The iRODS documentation is housed in this repository (https://github.com/irods/irods_docs).

Each release is kept in a separate branch.

Prerequisites
-------------

- git, g++, flex, bison, cmake, python, virtualenv, mkdocs
- iCommands (the version the generated docs will reflect)

Update for correct version
--------------------------

- Update Makefile with correct MAKEGITHUBACCOUNT (can be deferred to the **make** call)
- Update Makefile with correct MAKEIRODSVERSION  (can be deferred to the **make** call)
- Update irods_for_doxygen/Doxyfile with correct PROJECT_NUMBER

Build
-----

The `Makefile` default target will build two other targets, 'doxygen' and 'mkdocs'.

```
$ make [MAKEGITHUBACCOUNT=irods] [MAKEIRODSVERSION=4-2-stable]
```

The resulting `site` directory will contain the generated standalone documentation.


