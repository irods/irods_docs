.PHONY : default get_irods doxygen mkdocs clean

SHELL = /bin/bash

MAKEIRODSVERSION = master
MAKEDOXYGENVERSION = Release_1_8_12

IRODSTARGET = irods_for_doxygen
DOXYGENTARGET = doxygen_for_docs
VENVTARGET = venv

DOCS_SOURCE_DIR = docs

default : doxygen mkdocs
	@cp -r doxygen/* site/doxygen

get_irods :
	@echo "Getting iRODS source... v[${MAKEIRODSVERSION}]"
	@if [ ! -d ${IRODSTARGET} ] ; then git clone https://github.com/irods/irods ${IRODSTARGET}; fi
	@cd ${IRODSTARGET}; git pull; git checkout ${MAKEIRODSVERSION}

doxygen : get_irods
	@echo "Generating Doxygen..."
	@if [ ! -d ${DOXYGENTARGET} ] ; then git clone https://github.com/doxygen/doxygen ${DOXYGENTARGET}; fi
	@cd ${DOXYGENTARGET}; git pull; git checkout ${MAKEDOXYGENVERSION}
	@cd ${DOXYGENTARGET} ; mkdir -p build ; cd build ; cmake .. ; make
	@cd ${IRODSTARGET}; ../${DOXYGENTARGET}/build/bin/doxygen Doxyfile 1> /dev/null
	@rsync -ar ${IRODSTARGET}/doxygen/html/ doxygen/
	@cp ${IRODSTARGET}/doxygen/custom.css doxygen/

mkdocs : get_irods
	@echo "Generating Mkdocs..."
	@./generate_icommands_md.sh
	@grep RESOURCE_OP ${IRODSTARGET}/server/core/include/irods_resource_constants.hpp | grep "resource_" | awk -F'"' '{print $$2}' | sort | sed 's/$$/<br\/>/' > ${DOCS_SOURCE_DIR}/op-resource.mdpp
	@grep AUTH ${IRODSTARGET}/lib/core/include/irods_auth_constants.hpp | grep "auth_" | awk -F'"' '{print $$2}' | sort | sed 's/$$/<br\/>/' > ${DOCS_SOURCE_DIR}/op-auth.mdpp
	@grep NETWORK_OP ${IRODSTARGET}/lib/core/include/irods_network_constants.hpp | grep "network_" | awk -F'"' '{print $$2}' | sort | sed 's/$$/<br\/>/' > ${DOCS_SOURCE_DIR}/op-network.mdpp
	@grep DATABASE_OP ${IRODSTARGET}/server/core/include/irods_database_constants.hpp | grep "database_" | awk -F'"' '{print $$2}' | sort | sed 's/$$/<br\/>/' > ${DOCS_SOURCE_DIR}/op-database.mdpp
	@grep -A1 "boost::any" ${IRODSTARGET}/lib/api/include/apiTable.hpp | awk '{mod=NR%3; if (mod==2) {print $$0}} ' | awk -F'"' '{print $$2}' | sort | sed 's/$$/<br\/>/' > ${DOCS_SOURCE_DIR}/op-api.mdpp
	@python generate_dynamic_peps_md.py > ${DOCS_SOURCE_DIR}/plugins/dynamic_peps_table.mdpp
	@if [ ! -d ${VENVTARGET} ] ; then virtualenv ${VENVTARGET}; fi
	@. ${VENVTARGET}/bin/activate; \
		pip install -r requirements.txt; \
		pushd ${DOCS_SOURCE_DIR}; \
		markdown-pp -e latexrender -o plugins/plugin_interfaces.md plugins/plugin_interfaces.mdpp; \
		markdown-pp -e latexrender -o plugins/dynamic_policy_enforcement_points.md plugins/dynamic_policy_enforcement_points.mdpp; \
		mkdir -p doxygen; \
		touch doxygen/index.html; \
		popd; \
		mkdocs build --clean
	@cp images/* site/

clean :
	@echo "Cleaning..."
	@rm -rf site
	@rm -rf ${IRODSTARGET} ${DOXYGENTARGET} ${VENVTARGET}
	@rm -rf ${DOCS_SOURCE_DIR}/doxygen
	@rm -rf ${DOCS_SOURCE_DIR}/icommands
	@rm -rf ${DOCS_SOURCE_DIR}/op-*.mdpp
	@rm -rf ${DOCS_SOURCE_DIR}/plugins/plugin_interfaces.md
	@rm -rf ${DOCS_SOURCE_DIR}/plugins/rule_engine_plugin_framework.md
