<?xml version="1.0" encoding="utf-8" ?>

<xsl:stylesheet version="1.0"

    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:date="http://exslt.org/dates-and-times"
    xmlns:strings="http://exslt.org/strings"
    xmlns:exsl="http://exslt.org/common"
    xmlns:l="urn:local"
    exclude-result-prefixes="xsl date strings exsl l">

    <xsl:output method="text" encoding="utf-8" />
    
    
    <xsl:variable name="listMapping"> <!-- TODO -->
        <l:style>hanging</l:style><l:counter></l:counter>
        <l:style>letters</l:style><l:counter>a</l:counter>
        <l:style>numbers</l:style><l:counter>1</l:counter>
        <l:style>symbols</l:style><l:counter></l:counter>
    </xsl:variable>
    
	<!-- TODO: move utility templates to a common include file -->
	<xsl:template name="commafy">
	    <xsl:param name="nodes" />
	    
        <xsl:for-each select="$nodes">
            <xsl:choose>
                <xsl:when test="position() = 1">
                    <xsl:text>"</xsl:text>
                    <xsl:value-of select="normalize-space(.)" />
                    <xsl:text>"</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>, "</xsl:text>
                    <xsl:value-of select="normalize-space(.)" />
                    <xsl:text>"</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
	</xsl:template>
	
    <xsl:template name="repeat">
        <xsl:param name="n" />
        <xsl:param name="character" />
        
        <xsl:if test="$n > 0">
            <xsl:call-template name="repeat">
                <xsl:with-param name="n" select="$n - 1" />
                <xsl:with-param name="character" select="$character" />
            </xsl:call-template>
            <xsl:value-of select="$character" />
        </xsl:if>

    </xsl:template>
    
    <xsl:template name="makeCounter">
        <xsl:param name="style" />
        <xsl:param name="position" />
        
        <xsl:message>makeCounter: style=<xsl:value-of select="$style"/>, position=<xsl:value-of select="$position"/>
        </xsl:message>
        <xsl:choose>
            <xsl:when test="$style = 'letters'">
                <xsl:number value="$position" format="a" />
                <xsl:text>) </xsl:text>
            </xsl:when>
            <xsl:when test="$style = 'numbers'">
                <xsl:number value="$position" format="1" />
                <xsl:text>. </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>* </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:variable name="areas">
        <xsl:call-template name="commafy">
            <xsl:with-param name="nodes" select="rfc/front/area" />
        </xsl:call-template>
    </xsl:variable>
    
    <xsl:variable name="workgroups">
        <xsl:call-template name="commafy">
            <xsl:with-param name="nodes" select="rfc/front/workgroup" />
        </xsl:call-template>
    </xsl:variable>
    
    <xsl:variable name="keywords">
        <xsl:call-template name="commafy">
            <xsl:with-param name="nodes" select="rfc/front/keyword" />
        </xsl:call-template>
</xsl:variable>

	<xsl:variable name="listprefix" />
	<xsl:template name="author">
	
	<!-- TODO: each needs wrapping with xsl:if to not include line if no metadata -->
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

    <xsl:template match="section">
        <xsl:text>&#xa;</xsl:text>
        <xsl:call-template name="repeat">
            <xsl:with-param name="n" select="count(ancestor-or-self::section)" />
            <xsl:with-param name="character" select="'#'" />
        </xsl:call-template>
        <xsl:text> </xsl:text>
        <xsl:value-of select="@title | name"/>
        <xsl:apply-templates select="@anchor" />
        <xsl:apply-templates />
    </xsl:template>
    
    <xsl:template match="@anchor" >
        <xsl:text> {#</xsl:text>
        <xsl:value-of select="." />
        <xsl:text>}</xsl:text>
    </xsl:template>

    <xsl:template match="//xref"> (#<xsl:value-of select="./@target"/>)</xsl:template>


    <xsl:template match="list">
        <xsl:apply-templates />
    </xsl:template>


    <xsl:template match="t">
        <xsl:text>&#xa;</xsl:text>
        <xsl:apply-templates />
        <xsl:text>&#xa;</xsl:text>
    </xsl:template>

    <xsl:template match="t[parent::list]">
<!--        <xsl:message>
            <xsl:for-each select="ancestor-or-self::*">
                <xsl:value-of select="name(.)"/> /
            </xsl:for-each>
        </xsl:message> -->

        <xsl:call-template name="repeat">
            <xsl:with-param name="n" select="count(ancestor::list) * 4" />
            <xsl:with-param name="character" select="' '" />
        </xsl:call-template>

        <xsl:call-template name="makeCounter">
            <xsl:with-param name="style" select="parent::list/@style" />
            <xsl:with-param name="position" select="count(preceding-sibling::t) + 1" />
        </xsl:call-template>
        
        <xsl:value-of select="."/>
        
        <xsl:apply-templates select="list" />
    </xsl:template>
    
    <!--
    <xsl:template match="t//*">
        <xsl:copy>
            <xsl:copy-of select="@*" />
            <xsl:apply-templates />
        </xsl:copy>
    </xsl:template> -->

    <xsl:template match="eref">
        <xsl:text>[</xsl:text>
        <xsl:value-of select="." />
        <xsl:text>](</xsl:text>
        <xsl:value-of select="@target" />
        <xsl:text>)</xsl:text>
    </xsl:template>
 
    <xsl:template match="em">
        <xsl:text>*</xsl:text>
        <xsl:value-of select="." />
        <xsl:text>*</xsl:text>
    </xsl:template>
    
    <xsl:template match="strong">
        <xsl:text>**</xsl:text>
        <xsl:value-of select="." />
        <xsl:text>**</xsl:text>
    </xsl:template>
    
    <xsl:template match="tt">
        <xsl:text>`</xsl:text>
        <xsl:value-of select="." />
        <xsl:text>`</xsl:text>
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
    <xsl:template match="t//text()">
        <xsl:copy-of select="." />
    </xsl:template>

    <xsl:template match="rfc/back">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
   </xsl:template>

   <xsl:template match="rfc/back">
<xsl:text>
</xsl:text>
	   <xsl:for-each select="references">
		   <xsl:choose>
			   <xsl:when test="string-length(@title)>0">
# <xsl:value-of select="@title"/> 
			   </xsl:when>
			   <xsl:otherwise>
# References
			   </xsl:otherwise>
		   </xsl:choose>
<xsl:text>
</xsl:text>
<xsl:text>
</xsl:text>
<xsl:apply-templates/>
	   </xsl:for-each>

{backmatter}

	   <xsl:for-each select="section">
		   <xsl:apply-templates/>
	   </xsl:for-each>
   </xsl:template>

  <xsl:template match="reference">
     <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
     </xsl:copy>
  </xsl:template>
  <xsl:template match="reference//@*">
     <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
</xsl:copy>
  </xsl:template>

  <xsl:template match="reference//node()">
     <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
     </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
