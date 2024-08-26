iRODS Documentation
===================

The iRODS documentation is housed in this repository (https://github.com/irods/irods_docs).

Prerequisites
-------------

- docker

Update for correct version
--------------------------

- Update Makefile with correct GITHUB_ACCOUNT
- Update Makefile with correct GIT_COMMITTISH
- Update build/irods_for_doxygen/Doxyfile with correct PROJECT_NUMBER

Build
-----

Docker will create a builder image.

```
$ docker build -t irods_docs_builder .
```

Running the docker image will save artifacts into `$(pwd)/build`:

```
$ docker run --rm -v $(pwd):/irods_docs:ro -v $(pwd)/build:/hostcomputer irods_docs_builder
```

You can generate documentation for a specific build of iRODS by running the following:

```
$ docker run --rm -v $(pwd):/irods_docs:ro -v $(pwd)/build:/hostcomputer irods_docs_builder GITHUB_ACCOUNT=<account> GIT_COMMITTISH=<branch-or-commit>
```

The resulting `build/site` directory will contain the generated standalone documentation.

View
----

Launch a webserver on port 8080 to show the resulting `build/site` directory:

```bash
$ docker run -d --rm --name irods_docs -p 8080:80 -v $(pwd)/build/site:/usr/local/apache2/htdocs/ httpd:2.4
```

To stop the webserver:

```bash
$ docker stop irods_docs
```
