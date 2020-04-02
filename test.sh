#!/bin/env bash

readonly __RFC2MDDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )" # https://stackoverflow.com/a/246128/902217
sed "s|\${BASEPATH}|${__RFC2MDDIR}|g" ${__RFC2MDDIR}/external/sgml_catalogue_files.xml.in > ${__RFC2MDDIR}/external/sgml_catalogue_files.xml

export XML_CATALOG_FILES="$PWD/external/sgml_catalogue_files.xml file://${PWD}/external/sgml_catalogue_files.xml"
export SGML_CATALOG_FILES=${XML_CATALOG_FILES}
export XML_DEBUG_CATALOG=1

xsltproc --catalogs rfc2md.xslt rfcV2.xml
xsltproc --stringparam draft "final" --catalogs rfc2md.xslt rfcV2.xml