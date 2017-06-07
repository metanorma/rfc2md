<?xml version="1.0" encoding="utf-8" ?>

<xsl:stylesheet version="1.0"

	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:date="http://exslt.org/dates-and-times"
    xmlns:strings="http://exslt.org/strings"
    xmlns:exsl="http://exslt.org/common"
	exclude-result-prefixes="xsl date strings exsl">

    <xsl:output method="text"  encoding="utf-8"/>

    <!-- Identity transform (for testing) -->

    <xsl:template match="/ | @* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
