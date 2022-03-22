iRODS Documentation
===================

The iRODS documentation is housed in this repository (https://github.com/irods/irods_docs).

Each release is kept in a separate branch.

Prerequisites
-------------

- docker

Update for correct version
--------------------------

- Update Makefile with correct MAKEGITHUBACCOUNT
- Update Makefile with correct MAKEIRODSVERSION
- Update build/irods_for_doxygen/Doxyfile with correct PROJECT_NUMBER

Build
-----

Docker will create a builder image.

```
$ docker build -t irods_docs_builder .
```

Running the docker image will save artifacts into `$(pwd)/build`:

```
$ docker run --rm -v $(pwd)/build:/hostcomputer irods_docs_builder

```

The resulting `build/site` directory will contain the generated standalone documentation.


----

TGR - this should probably go away...  not sure whether still useful/relevant...

The `Makefile` default target will build two other targets, 'doxygen' and 'mkdocs'.

```
$ make [MAKEGITHUBACCOUNT=irods] [MAKEIRODSVERSION=main]
```

