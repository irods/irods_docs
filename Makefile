.PHONY : default get_irods doxygen mkdocs clean

SHELL = /bin/bash

MAKEGITHUBACCOUNT = irods
MAKEIRODSVERSION = main
MAKEDOXYGENVERSION = Release_1_9_3

BUILDAREA = /hostcomputer
IRODSTARGET = ${BUILDAREA}/irods_for_doxygen
DOXYGENTARGET = ${BUILDAREA}/doxygen_for_docs
DOXYGENMAKEJOBCOUNT = 
VENVTARGET = ${BUILDAREA}/venv43

DOCS_SOURCE_DIR = docs
DOCS_TARGET_DIR = ${BUILDAREA}/site

default : doxygen mkdocs
	@rsync -ar --delete doxygen/ ${DOCS_TARGET_DIR}/doxygen/

get_irods :
	@echo "Getting iRODS source... v[${MAKEIRODSVERSION}]"
	@if [ ! -d ${IRODSTARGET} ] ; then git clone https://github.com/${MAKEGITHUBACCOUNT}/irods ${IRODSTARGET}; fi
	@cd ${IRODSTARGET}; git fetch; git checkout ${MAKEIRODSVERSION}

doxygen : get_irods
	@echo "Generating Doxygen..."
	@if [ ! -d ${DOXYGENTARGET} ] ; then git clone https://github.com/doxygen/doxygen ${DOXYGENTARGET}; fi
	@cd ${DOXYGENTARGET}; git fetch; git checkout ${MAKEDOXYGENVERSION}
	@mkdir -p ${DOXYGENTARGET}/build
	@if [ ! -f ${DOXYGENTARGET}/build/CMakeCache.txt ] ; then cd ${DOXYGENTARGET}/build; cmake ..; fi
	@cd ${DOXYGENTARGET}/build ; make -j ${DOXYGENMAKEJOBCOUNT}
	@cd ${IRODSTARGET}; ${DOXYGENTARGET}/build/bin/doxygen Doxyfile 1> /dev/null
	@rsync -ar --delete ${IRODSTARGET}/doxygen/html/ doxygen/
	@cp ${IRODSTARGET}/doxygen/custom.css doxygen/

mkdocs : get_irods
	@echo "Generating Mkdocs..."
	@./generate_icommands_md.sh
	@python3 generate_dynamic_peps_md.py > ${DOCS_SOURCE_DIR}/plugins/dynamic_peps_table.mdpp
	@if [ ! -d ${VENVTARGET} ] ; then \
		python3 -m venv ${VENVTARGET}; \
		. ${VENVTARGET}/bin/activate; \
		pip install wheel; \
		pip install -r requirements.txt; \
		fi
	@. ${VENVTARGET}/bin/activate; \
		pushd ${DOCS_SOURCE_DIR}; \
		markdown-pp -e latexrender -o plugins/dynamic_policy_enforcement_points.md plugins/dynamic_policy_enforcement_points.mdpp; \
		mkdir -p doxygen; \
		touch doxygen/index.html; \
		popd; \
		export LC_ALL=C.UTF-8; \
		export LANG=C.UTF-8; \
		mkdocs build --clean; \
		rsync -ar --delete site/ ${DOCS_TARGET_DIR}/

clean :
	@echo "Cleaning..."
	@rm -rf site
	@rm -rf ${IRODSTARGET} ${DOXYGENTARGET} ${VENVTARGET}
	@rm -rf ${DOCS_SOURCE_DIR}/doxygen
	@rm -rf ${DOCS_SOURCE_DIR}/icommands
	@rm -rf ${DOCS_SOURCE_DIR}/plugins/rule_engine_plugin_framework.md
