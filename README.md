iRODS Documentation
===================

The iRODS documentation is housed in this repository (https://github.com/irods/irods_docs).

Each release is kept in a separate branch.

Prerequisites
-------------

- docker

Update for correct version
--------------------------

- Update Makefile with correct MAKEGITHUBACCOUNT (can be deferred to the **make** call)
- Update Makefile with correct MAKEIRODSVERSION  (can be deferred to the **make** call)
- Update irods_for_doxygen/Doxyfile with correct PROJECT_NUMBER

Build
-----

Docker will create a builder image.

```
$ docker build -t irods_docs_builder .
```

Running the docker image will produce the `site` directory.

```
$ docker run irods_docs_builder
```

The resulting `site` directory will contain the generated standalone documentation.


----

The `Makefile` default target will build two other targets, 'doxygen' and 'mkdocs'.

```
$ make [MAKEGITHUBACCOUNT=irods] [MAKEIRODSVERSION=master]
```

