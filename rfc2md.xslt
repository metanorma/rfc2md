<?xml version="1.0" encoding="utf-8" ?>

<xsl:stylesheet version="1.0"

	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:date="http://exslt.org/dates-and-times"
    xmlns:strings="http://exslt.org/strings"
    xmlns:exsl="http://exslt.org/common"
	exclude-result-prefixes="xsl date strings exsl">

	<xsl:output method="text"  encoding="utf-8"/>

	<xsl:variable name="areas" >
		<xsl:for-each select="rfc/front/area">
		<xsl:choose>
			<xsl:when test="position() = 1">"<xsl:value-of select="normalize-space(.)"/>"</xsl:when>
		<xsl:otherwise>, "<xsl:value-of select="normalize-space(.)"/>"</xsl:otherwise>
	</xsl:choose>
</xsl:for-each>
</xsl:variable>

	<xsl:variable name="workgroups" >
		<xsl:for-each select="rfc/front/workgroup">
		<xsl:choose>
			<xsl:when test="position() = 1">"<xsl:value-of select="normalize-space(.)"/>"</xsl:when>
		<xsl:otherwise>, "<xsl:value-of select="normalize-space(.)"/>"</xsl:otherwise>
	</xsl:choose>
</xsl:for-each>
</xsl:variable>

	<xsl:variable name="keywords" >
		<xsl:for-each select="rfc/front/keyword">
		<xsl:choose>
			<xsl:when test="position() = 1">"<xsl:value-of select="normalize-space(.)"/>"</xsl:when>
		<xsl:otherwise>, "<xsl:value-of select="normalize-space(.)"/>"</xsl:otherwise>
	</xsl:choose>
</xsl:for-each>
</xsl:variable>

<xsl:template name="author">
	<xsl:param name="auth"/>

[[author]]
initials = "<xsl:value-of select="($auth)/@initials"/>"
surname = "<xsl:value-of select="($auth)/@surname"/>"
fullname = "<xsl:value-of select="($auth)/@fullname"/>"
role = "<xsl:value-of select="($auth)/@role"/>"
organization = "<xsl:value-of select="($auth)/organization"/>"
[author.address]
street = "<xsl:value-of select="($auth)/address/street"/>"
city = "<xsl:value-of select="($auth)/address/city"/>"
region = "<xsl:value-of select="($auth)/address/region"/>"
code = "<xsl:value-of select="($auth)/address/code"/>"
country = "<xsl:value-of select="($auth)/address/country"/>"
phone = "<xsl:value-of select="($auth)/address/phone"/>"
facsimile = "<xsl:value-of select="($auth)/address/facsimile"/>"
email = "<xsl:value-of select="($auth)/address/email"/>"
uri = "<xsl:value-of select="($auth)/address/uri"/>"
</xsl:template>

    <xsl:template match="/">
%%%
    title = "<xsl:value-of select="normalize-space(rfc/front/title)"/>"
    abbrev = "<xsl:value-of select="rfc/title/@abbrev"/>"
    category = "<xsl:value-of select="rfc/@category"/>"
    docName = "<xsl:value-of select="rfc/@docName"/>"
    updates = <xsl:value-of select="rfc/@updates"/>
    obsoletes = <xsl:value-of select="rfc/@obsoletes"/>
    ipr = "<xsl:value-of select="rfc/@ipr"/>"
    area =  [<xsl:value-of select="$areas"/>]
    workgroup = [<xsl:value-of select="$workgroups"/>]
    keyword =  [<xsl:value-of select="$keywords"/>]
    date = <xsl:value-of select="rfc/front/date/@day"/>/<xsl:value-of select="rfc/front/date/@month"/>/<xsl:value-of select="rfc/front/date/@year"/>

    <xsl:for-each select="rfc/front/author">
	    <xsl:call-template name="author">
		    <xsl:with-param name="auth" select="."/>
	</xsl:call-template>
</xsl:for-each>
%%%

.# Abstract
<xsl:value-of select="rfc/front/abstract"/>

    <xsl:for-each select="rfc/front/note">
.# Note
<xsl:value-of select="."/>
</xsl:for-each>
<!-- nothing else from front material -->
      <xsl:apply-templates select="rfc/middle"/>
      <xsl:apply-templates select="rfc/back"/>
    </xsl:template>	

    <xsl:template match="rfc/middle">
{mainmatter}
<xsl:apply-templates />
</xsl:template>
<xsl:template match="rfc/middle/section">

# <xsl:value-of select="./@title"/> {#<xsl:value-of select="./@anchor"/>}

<xsl:apply-templates />
    </xsl:template>
    <xsl:template match="rfc/middle/section/section">

## <xsl:value-of select="./@title"/> {#<xsl:value-of select="./@anchor"/>}

<xsl:apply-templates />
    </xsl:template>
<xsl:template match="rfc/middle/section/section/section">

### <xsl:value-of select="./@title"/> {#<xsl:value-of select="./@anchor"/>}

<xsl:apply-templates />
    </xsl:template>
<xsl:template match="rfc/middle/section/section/section/section">

#### <xsl:value-of select="./@title"/> {#<xsl:value-of select="./@anchor"/>}

<xsl:apply-templates />
    </xsl:template>
<xsl:template match="rfc/middle/section/section/section/section/section">

##### <xsl:value-of select="./@title"/> {#<xsl:value-of select="./@anchor"/>}

<xsl:apply-templates />
    </xsl:template>
<xsl:template match="rfc/middle/section/section/section/section/section/section">

###### <xsl:value-of select="./@title"/> {#<xsl:value-of select="./@anchor"/>}

<xsl:apply-templates />
    </xsl:template>
<xsl:template match="rfc/middle/section/section/section/section/section/section/section">

####### <xsl:value-of select="./@title"/> {#<xsl:value-of select="./@anchor"/>}

<xsl:apply-templates />
    </xsl:template>

    <xsl:template match="//xref"> (#<xsl:value-of select="./@target"/>)</xsl:template>

    <!-- no nested list yet -->
    <xsl:template match="//list">
	                    <xsl:choose>
				    <xsl:when test="not(./@style)">
*  <xsl:apply-templates /> </xsl:when>
				    <!-- not supported in mmark -->
				    <xsl:when test="./@style='hanging'">
*  <xsl:apply-templates /> </xsl:when>
				    <xsl:when test="./@style='letters'">
a)  <xsl:apply-templates /> </xsl:when>
				    <xsl:when test="./@style='numbers'">
1.  <xsl:apply-templates /> </xsl:when>
				    <xsl:when test="./@style='symbols'">
*  <xsl:apply-templates /> </xsl:when>
					    <!-- not supported:-->
				    <xsl:when test="./@style='format'">
*  <xsl:apply-templates /> </xsl:when>
		</xsl:choose>
    </xsl:template>

    <xsl:template match="list/t"><xsl:apply-templates /></xsl:template>

<xsl:template match="t">

<xsl:apply-templates />
    </xsl:template>

    <xsl:template match="t//*">
	        <xsl:copy>
			      <xsl:copy-of select="@*" /><xsl:apply-templates /></xsl:copy>
				</xsl:template>

<!-- override rule: <link> nodes get special treatment -->
  <xsl:template match="description//link">
	      <a href="#{@ref}">
		            <xsl:apply-templates />
			        </a>
				  </xsl:template>

				    <!-- default rule: ignore any unspecific text node -->
				      <xsl:template match="text()" />

				        <!-- override rule: copy any text node beneath t -->
					<xsl:template match="t//text()"><xsl:copy-of select="normalize-space(.)" /></xsl:template>



    <xsl:template match="rfc/back">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
