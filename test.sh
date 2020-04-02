#!/bin/env bash

case "$(uname -s)" in
   CYGWIN*|MINGW32*|MSYS*|MINGW*)
     	CATALOG_BASE=$(cmd //c "echo %cd:\\=/%")
     	;;

   *)
   		CATALOG_BASE="file://$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )" # https://stackoverflow.com/a/246128/902217
     	;;
esac

CATALOG_BASE="${CATALOG_BASE}/external/"

sed "s|\${BASEPATH}|${CATALOG_BASE}|g" ${PWD}/external/sgml_catalogue_files.xml.in > ${PWD}/external/sgml_catalogue_files.xml

export XML_CATALOG_FILES="$PWD/external/sgml_catalogue_files.xml ${CATALOG_BASE}/sgml_catalogue_files.xml"
export SGML_CATALOG_FILES="${XML_CATALOG_FILES}"
export XML_DEBUG_CATALOG=1

xsltproc --catalogs rfc2md.xslt rfcV2.xml
xsltproc --stringparam draft "final" --catalogs rfc2md.xslt rfcV2.xml