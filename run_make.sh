#!/bin/bash
cp -a /irods_docs /irods_docs_copy
cd /irods_docs_copy
make "$@"
