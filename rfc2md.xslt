<?xml version="1.0" encoding="utf-8" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:date="http://exslt.org/dates-and-times" xmlns:strings="http://exslt.org/strings" xmlns:exsl="http://exslt.org/common" exclude-result-prefixes="xsl date strings exsl">
	<xsl:output method="xml" encoding="utf-8" omit-xml-declaration="yes"/>
	<xsl:variable name="areas">
		<xsl:for-each select="rfc/front/area">
			<xsl:choose>
				<xsl:when test="position() = 1"> "<xsl:value-of select="normalize-space(.)" />" </xsl:when>
				<xsl:otherwise> , "<xsl:value-of select="normalize-space(.)" />" </xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="workgroups">
		<xsl:for-each select="rfc/front/workgroup">
			<xsl:choose>
				<xsl:when test="position() = 1"> "<xsl:value-of select="normalize-space(.)" />" </xsl:when>
				<xsl:otherwise> , "<xsl:value-of select="normalize-space(.)" />" </xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="keywords">
		<xsl:for-each select="rfc/front/keyword">
			<xsl:choose>
				<xsl:when test="position() = 1"> "<xsl:value-of select="normalize-space(.)" />" </xsl:when>
				<xsl:otherwise> , "<xsl:value-of select="normalize-space(.)" />" </xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="listprefix" />
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

 
<xsl:template match="//list">
<xsl:text>
</xsl:text>
	<xsl:choose>
		<xsl:when test="not(./@style)">
			<xsl:for-each select="t">
				<xsl:call-template name="inlist">
		            <xsl:with-param name="listprefix">* </xsl:with-param>
	            </xsl:call-template>
	        </xsl:for-each>
        </xsl:when>
				    <!-- not supported in mmark -->
				    <xsl:when test="./@style='hanging'">
		<xsl:for-each select="t">
	    <xsl:call-template name="inlist">
		    <xsl:with-param name="listprefix">* </xsl:with-param>
	</xsl:call-template>
	</xsl:for-each>
</xsl:when>
				    <xsl:when test="./@style='letters'">
		<xsl:for-each select="t">
	    <xsl:call-template name="inlist">
		    <xsl:with-param name="listprefix">a) </xsl:with-param>
	</xsl:call-template>
	</xsl:for-each>
</xsl:when>
				    <xsl:when test="./@style='numbers'">
		<xsl:for-each select="t">
	    <xsl:call-template name="inlist">
		    <xsl:with-param name="listprefix">1. </xsl:with-param>
	</xsl:call-template>
	</xsl:for-each>
</xsl:when>
				    <xsl:when test="./@style='symbols'">
		<xsl:for-each select="t">
	    <xsl:call-template name="inlist">
		    <xsl:with-param name="listprefix">* </xsl:with-param>
	</xsl:call-template>
	</xsl:for-each>
</xsl:when>
					    <!-- not supported:-->
				    <xsl:when test="./@style='format'">
		<xsl:for-each select="t">
	    <xsl:call-template name="inlist">
		    <xsl:with-param name="listprefix">* </xsl:with-param>
	</xsl:call-template>
	</xsl:for-each>
</xsl:when>
				    <xsl:otherwise>
		<xsl:for-each select="t">
	    <xsl:call-template name="inlist">
		    <xsl:with-param name="listprefix">* </xsl:with-param>
	</xsl:call-template>
	</xsl:for-each>
</xsl:otherwise>
		</xsl:choose>
    </xsl:template>
    
        <xsl:template match="//list/t/list">
<xsl:text>
</xsl:text>
	                    <xsl:choose>
				    <xsl:when test="not(./@style)">
		<xsl:for-each select="t">
					    <xsl:call-template name="inlist">
		    <xsl:with-param name="listprefix">  * </xsl:with-param>
	</xsl:call-template>
	</xsl:for-each>
</xsl:when>
				    <!-- not supported in mmark -->
				    <xsl:when test="./@style='hanging'">
		<xsl:for-each select="t">
	    <xsl:call-template name="inlist">
		    <xsl:with-param name="listprefix">  * </xsl:with-param>
	</xsl:call-template>
	</xsl:for-each>
</xsl:when>
				    <xsl:when test="./@style='letters'">
		<xsl:for-each select="t">
	    <xsl:call-template name="inlist">
		    <xsl:with-param name="listprefix">  a) </xsl:with-param>
	</xsl:call-template>
	</xsl:for-each>
</xsl:when>
				    <xsl:when test="./@style='numbers'">
		<xsl:for-each select="t">
	    <xsl:call-template name="inlist">
		    <xsl:with-param name="listprefix">  1. </xsl:with-param>
	</xsl:call-template>
	</xsl:for-each>
</xsl:when>
				    <xsl:when test="./@style='symbols'">
		<xsl:for-each select="t">
	    <xsl:call-template name="inlist">
		    <xsl:with-param name="listprefix">  * </xsl:with-param>
	</xsl:call-template>
	</xsl:for-each>
</xsl:when>
					    <!-- not supported:-->
				    <xsl:when test="./@style='format'">
		<xsl:for-each select="t">
	    <xsl:call-template name="inlist">
		    <xsl:with-param name="listprefix">  * </xsl:with-param>
	</xsl:call-template>
	</xsl:for-each>
</xsl:when>
				    <xsl:otherwise>
		<xsl:for-each select="t">
	    <xsl:call-template name="inlist">
		    <xsl:with-param name="listprefix">  * </xsl:with-param>
	</xsl:call-template>
	</xsl:for-each>
</xsl:otherwise>
		</xsl:choose>
    </xsl:template>

        <xsl:template match="//list/t/list/t/list">
<xsl:text>
</xsl:text>
	                    <xsl:choose>
				    <xsl:when test="not(./@style)">
		<xsl:for-each select="t">
					    <xsl:call-template name="inlist">
		    <xsl:with-param name="listprefix">    * </xsl:with-param>
	</xsl:call-template>
	</xsl:for-each>
</xsl:when>
				    <!-- not supported in mmark -->
				    <xsl:when test="./@style='hanging'">
		<xsl:for-each select="t">
	    <xsl:call-template name="inlist">
		    <xsl:with-param name="listprefix">    * </xsl:with-param>
	</xsl:call-template>
	</xsl:for-each>
</xsl:when>
				    <xsl:when test="./@style='letters'">
		<xsl:for-each select="t">
	    <xsl:call-template name="inlist">
		    <xsl:with-param name="listprefix">    a) </xsl:with-param>
	</xsl:call-template>
	</xsl:for-each>
</xsl:when>
				    <xsl:when test="./@style='numbers'">
		<xsl:for-each select="t">
	    <xsl:call-template name="inlist">
		    <xsl:with-param name="listprefix">    1. </xsl:with-param>
	</xsl:call-template>
	</xsl:for-each>
</xsl:when>
				    <xsl:when test="./@style='symbols'">
		<xsl:for-each select="t">
	    <xsl:call-template name="inlist">
		    <xsl:with-param name="listprefix">    * </xsl:with-param>
	</xsl:call-template>
	</xsl:for-each>
</xsl:when>
					    <!-- not supported:-->
				    <xsl:when test="./@style='format'">
		<xsl:for-each select="t">
	    <xsl:call-template name="inlist">
		    <xsl:with-param name="listprefix">    * </xsl:with-param>
	</xsl:call-template>
	</xsl:for-each>
</xsl:when>
				    <xsl:otherwise>
		<xsl:for-each select="t">
	    <xsl:call-template name="inlist">
		    <xsl:with-param name="listprefix">    * </xsl:with-param>
	</xsl:call-template>
	</xsl:for-each>
</xsl:otherwise>
		</xsl:choose>
    </xsl:template>

        <xsl:template match="//list/t/list/t/list/t/list">
<xsl:text>
</xsl:text>
	                    <xsl:choose>
				    <xsl:when test="not(./@style)">
		<xsl:for-each select="t">
					    <xsl:call-template name="inlist">
		    <xsl:with-param name="listprefix">      * </xsl:with-param>
	</xsl:call-template>
	</xsl:for-each>
</xsl:when>
				    <!-- not supported in mmark -->
				    <xsl:when test="./@style='hanging'">
		<xsl:for-each select="t">
	    <xsl:call-template name="inlist">
		    <xsl:with-param name="listprefix">      * </xsl:with-param>
	</xsl:call-template>
	</xsl:for-each>
</xsl:when>
				    <xsl:when test="./@style='letters'">
		<xsl:for-each select="t">
	    <xsl:call-template name="inlist">
		    <xsl:with-param name="listprefix">      a) </xsl:with-param>
	</xsl:call-template>
	</xsl:for-each>
</xsl:when>
				    <xsl:when test="./@style='numbers'">
		<xsl:for-each select="t">
	    <xsl:call-template name="inlist">
		    <xsl:with-param name="listprefix">      1. </xsl:with-param>
	</xsl:call-template>
	</xsl:for-each>
</xsl:when>
				    <xsl:when test="./@style='symbols'">
		<xsl:for-each select="t">
	    <xsl:call-template name="inlist">
		    <xsl:with-param name="listprefix">      * </xsl:with-param>
	</xsl:call-template>
	</xsl:for-each>
</xsl:when>
					    <!-- not supported:-->
				    <xsl:when test="./@style='format'">
		<xsl:for-each select="t">
	    <xsl:call-template name="inlist">
		    <xsl:with-param name="listprefix">      * </xsl:with-param>
	</xsl:call-template>
	</xsl:for-each>
</xsl:when>
				    <xsl:otherwise>
		<xsl:for-each select="t">
	    <xsl:call-template name="inlist">
		    <xsl:with-param name="listprefix">      * </xsl:with-param>
	</xsl:call-template>
	</xsl:for-each>
</xsl:otherwise>
		</xsl:choose>
    </xsl:template>

        <xsl:template match="//list/t/list/t/list/t/list/t/list">
<xsl:text>
</xsl:text>
	                    <xsl:choose>
				    <xsl:when test="not(./@style)">
		<xsl:for-each select="t">
					    <xsl:call-template name="inlist">
		    <xsl:with-param name="listprefix">        * </xsl:with-param>
	</xsl:call-template>
	</xsl:for-each>
</xsl:when>
				    <!-- not supported in mmark -->
				    <xsl:when test="./@style='hanging'">
		<xsl:for-each select="t">
	    <xsl:call-template name="inlist">
		    <xsl:with-param name="listprefix">        * </xsl:with-param>
	</xsl:call-template>
	</xsl:for-each>
</xsl:when>
				    <xsl:when test="./@style='letters'">
		<xsl:for-each select="t">
	    <xsl:call-template name="inlist">
		    <xsl:with-param name="listprefix">        a) </xsl:with-param>
	</xsl:call-template>
	</xsl:for-each>
</xsl:when>
				    <xsl:when test="./@style='numbers'">
		<xsl:for-each select="t">
	    <xsl:call-template name="inlist">
		    <xsl:with-param name="listprefix">        1. </xsl:with-param>
	</xsl:call-template>
	</xsl:for-each>
</xsl:when>
				    <xsl:when test="./@style='symbols'">
		<xsl:for-each select="t">
	    <xsl:call-template name="inlist">
		    <xsl:with-param name="listprefix">        * </xsl:with-param>
	</xsl:call-template>
	</xsl:for-each>
</xsl:when>
					    <!-- not supported:-->
				    <xsl:when test="./@style='format'">
		<xsl:for-each select="t">
	    <xsl:call-template name="inlist">
		    <xsl:with-param name="listprefix">        * </xsl:with-param>
	</xsl:call-template>
	</xsl:for-each>
</xsl:when>
		</xsl:choose>
    </xsl:template>

 
    <!-- inlist is t+ -->
    <xsl:template name="inlist">
        <xsl:param name="listprefix" />
<xsl:text>
</xsl:text>
        <xsl:value-of select="$listprefix" /> <xsl:apply-templates />
<xsl:text>
</xsl:text>
    </xsl:template>
    <xsl:template match="t">
<xsl:text>
</xsl:text>
<xsl:text>
</xsl:text>
        <xsl:apply-templates />
<xsl:text>
</xsl:text>
    </xsl:template>
    <xsl:template match="t//*">
        <xsl:copy>
            <xsl:copy-of select="@*" />
            <xsl:apply-templates />
        </xsl:copy>
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
        <xsl:copy-of select="normalize-space(.)" />
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
   <!--
   <xsl:template match="reference">
	   <xsl:copy>
		   <xsl:apply-templates mode="copyxml" select="node()|@*"/>
	   </xsl:copy>
<xsl:text>
</xsl:text>
   </xsl:template>
-->
<!--
   <xsl:template match="*" mode="copyxml">
	   so
	        <xsl:element name="HEYHO">
			       <xsl:copy-of select="@*"/>
			              <xsl:apply-templates/>
				           </xsl:element>
					     </xsl:template>

					     <xsl:template match="text() | comment() | processing-instruction()"  mode="copyxml">
						     what
           <xsl:copy/>
   </xsl:template>
   
       <xsl:template match="back/references/reference">
	       hello
	               <xsl:copy>
			                   <xsl:apply-templates select="@*|node()" mode="copyxml"/>
					           </xsl:copy>
						       </xsl:template>

-->

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
