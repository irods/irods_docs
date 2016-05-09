.PHONY : default get_irods doxygen mkdocs clean

MAKEIRODSVERSION = master
MAKEDOXYGENVERSION = Release_1_8_12

IRODSTARGET = irods_for_doxygen
DOXYGENTARGET = doxygen_for_docs
VENVTARGET = venv

default : doxygen mkdocs
	@cp -r doxygen/* mkdocs/html/doxygen

get_irods :
	@echo "Getting iRODS source... v[${MAKEIRODSVERSION}]"
	@if [ ! -d ${IRODSTARGET} ] ; then git clone https://github.com/irods/irods ${IRODSTARGET}; fi
	@cd ${IRODSTARGET}; git checkout ${MAKEIRODSVERSION}

doxygen : get_irods
	@echo "Generating Doxygen..."
	@if [ ! -d ${DOXYGENTARGET} ] ; then git clone https://github.com/doxygen/doxygen ${DOXYGENTARGET}; fi
	@cd ${DOXYGENTARGET}; git checkout ${MAKEDOXYGENVERSION}
	@cd ${DOXYGENTARGET} ; mkdir -p build ; cd build ; cmake .. ; make
	@cd ${IRODSTARGET}; ../${DOXYGENTARGET}/build/bin/doxygen Doxyfile 1> /dev/null
	@rsync -ar ${IRODSTARGET}/doxygen/html/ doxygen/
	@cp ${IRODSTARGET}/doxygen/doxy-boot.js doxygen/
	@cp ${IRODSTARGET}/doxygen/custom.css doxygen/

mkdocs : get_irods
	@echo "Generating Mkdocs..."
	@./generate_icommands_md.sh
	@grep RESOURCE_OP ${IRODSTARGET}/server/core/include/irods_resource_constants.hpp | grep "resource_" | awk -F'"' '{print $$2}' | sort | sed 's/$$/<br\/>/' > op-resource.mdpp
	@grep AUTH ${IRODSTARGET}/lib/core/include/irods_auth_constants.hpp | grep "auth_" | awk -F'"' '{print $$2}' | sort | sed 's/$$/<br\/>/' > op-auth.mdpp
	@grep NETWORK_OP ${IRODSTARGET}/lib/core/include/irods_network_constants.hpp | grep "network_" | awk -F'"' '{print $$2}' | sort | sed 's/$$/<br\/>/' > op-network.mdpp
	@grep DATABASE_OP ${IRODSTARGET}/server/core/include/irods_database_constants.hpp | grep "database_" | awk -F'"' '{print $$2}' | sort | sed 's/$$/<br\/>/' > op-database.mdpp
	@grep -A1 "boost::any" ${IRODSTARGET}/lib/api/include/apiTable.hpp | awk '{mod=NR%3; if (mod==2) {print $$0}} ' | awk -F'"' '{print $$2}' | sort | sed 's/$$/<br\/>/' > op-api.mdpp
	@if [ ! -d ${VENVTARGET} ] ; then virtualenv ${VENVTARGET}; fi
	@. ${VENVTARGET}/bin/activate; pip install -r requirements.txt; markdown-pp -e latexrender -o manual/plugins.md manual/plugins.mdpp
	@mkdir -p doxygen
	@touch doxygen/index.html
	@mkdocs build --clean
	@cp images/* mkdocs/html/

clean :
	@echo "Cleaning..."
	@rm -rf mkdocs ${IRODSTARGET} ${DOXYGENTARGET} ${VENVTARGET} doxygen icommands op-*.mdpp manual/plugins.md
