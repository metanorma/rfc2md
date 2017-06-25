<?xml version="1.0" encoding="utf-8" ?>

<xsl:stylesheet version="1.0"

    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:date="http://exslt.org/dates-and-times"
    xmlns:strings="http://exslt.org/strings"
    xmlns:exsl="http://exslt.org/common"
    xmlns:l="urn:local"
    exclude-result-prefixes="xsl date strings exsl l">

    <xsl:output method="text" encoding="utf-8" />

    <!-- if value = final, cref are omitted -->
    <xsl:param name="draft">nonfinal</xsl:param>
    
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

<xsl:template match="rfc/middle//section">
        <xsl:text>&#xa;</xsl:text>
        <xsl:call-template name="repeat">
            <xsl:with-param name="n" select="count(ancestor-or-self::section)" />
            <xsl:with-param name="character" select="'#'" />
        </xsl:call-template>
        <xsl:text> </xsl:text>
        <xsl:value-of select="@title | name"/>
         <xsl:text> </xsl:text><xsl:apply-templates select="@anchor" />
        <xsl:apply-templates />
    </xsl:template>
    
    <xsl:template match="@anchor" >
        <xsl:text>{#</xsl:text>
        <xsl:value-of select="." />
        <xsl:text>}</xsl:text>
    </xsl:template>

    <xsl:template match="//xref"> (#<xsl:value-of select="./@target"/>)</xsl:template>
    <!-- Not bothering with differentiation between format attribute values -->


    <xsl:template match="list">
        <xsl:apply-templates />
    </xsl:template>


    <xsl:template match="t">
        <xsl:text>&#xa;</xsl:text>
     	<xsl:if test="@anchor and  string-length(@anchor)!=0">
<xsl:apply-templates select="@anchor" />
	</xsl:if>
        <xsl:apply-templates />
        <xsl:text>&#xa;</xsl:text>
    </xsl:template>

    <xsl:template match="t[parent::list]">
<!--        <xsl:message>
            <xsl:for-each select="ancestor-or-self::*">
                <xsl:value-of select="name(.)"/> /
            </xsl:for-each>
        </xsl:message> -->

     	<xsl:if test="@anchor and  string-length(@anchor)!=0">
<xsl:apply-templates select="@anchor" />
	</xsl:if>
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

  <!--
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
-->

    <xsl:template match="reference">&lt;reference<xsl:for-each select="@*"><xsl:text> </xsl:text><xsl:value-of select="name()"/>="<xsl:value-of select="."/>"</xsl:for-each>&gt;
        <xsl:apply-templates/>
        &lt;/reference&gt;
    </xsl:template>
    <xsl:template match="reference//node()">&lt;<xsl:value-of select="name()"/><xsl:for-each select="@*"><xsl:text> </xsl:text><xsl:value-of select="name()"/>="<xsl:value-of select="."/>"</xsl:for-each>&gt;<xsl:apply-templates/>&lt;/<xsl:value-of select="name()"/>&gt;</xsl:template>

    <xsl:template match="reference//text()"><xsl:copy-of select="." /></xsl:template>

  <xsl:template match="cref">
     <xsl:if test="@anchor and  string-length(@anchor)!=0">
<xsl:apply-templates select="@anchor" />
	</xsl:if>
	  <xsl:choose>
		  <xsl:when test="$draft='final'">
	  </xsl:when>
	  <xsl:otherwise>
A&gt; <xsl:value-of select="@source"/>: <xsl:value-of select="." />
	  </xsl:otherwise>
  </xsl:choose>
  </xsl:template>

  <xsl:template match="//figure">
     <xsl:if test="@anchor and  string-length(@anchor)!=0">
<xsl:apply-templates select="@anchor" />
     </xsl:if>
     <xsl:apply-templates select="./preamble"/>
     <xsl:choose>
	     <xsl:when test="./artwork/@src">
{{<xsl:value-of select="./artwork/@src"/>}}
	     </xsl:when>
	     <xsl:otherwise>
F&gt; ~~~~~
<xsl:apply-templates select="./artwork"/>
F&gt; ~~~~~
	     </xsl:otherwise>
     </xsl:choose>
     <xsl:apply-templates select="./postamble"/>
	  <xsl:choose>
		  <xsl:when test="@title and string-length(@title)!=0">
Figure: <xsl:value-of select="@title"/>
<xsl:text>&#xa;</xsl:text>
	  </xsl:when>
	  <xsl:when test="@suppress-title = 'true'">
	  </xsl:when>
	  <xsl:otherwise>
Figure: <xsl:number format="1" level="any" count="figure"/>
<xsl:text>&#xa;</xsl:text>
	  </xsl:otherwise>
	  </xsl:choose>
  </xsl:template>

  <xsl:template match="artwork//text()" name="artworkprefix">
	    <xsl:param name="pText" select="."/>

	      <xsl:if test="string-length($pText)">
F&gt; line: <xsl:text/>
		     <xsl:value-of select="substring-before(concat($pText, '&#xA;'), '&#xA;')"/>
		     <xsl:call-template name="artworkprefix">
				<xsl:with-param name="pText" select="substring-after($pText, '&#xA;')"/>
			 </xsl:call-template>
	      </xsl:if>
  </xsl:template>

  <xsl:template match="//texttable">
	  <xsl:text>&#xa;</xsl:text>
     <xsl:variable name="colcount" select="count(ttcol)"/>
     <xsl:if test="@anchor and  string-length(@anchor)!=0">
<xsl:apply-templates select="@anchor" />
     </xsl:if>
     <xsl:apply-templates select="./preamble"/>
     <xsl:for-each select="ttcol">
	     <xsl:call-template name="tableheader">
		     <xsl:with-param name="lastnode" select="position()=last()"/>
	     </xsl:call-template>
     </xsl:for-each>
     <xsl:for-each select="ttcol">
	     <xsl:call-template name="separator">
		     <xsl:with-param name="lastnode" select="position()=last()"/>
	     </xsl:call-template>
     </xsl:for-each>
     <xsl:for-each select="c">
     <xsl:call-template name="table-c">
         <xsl:with-param name="colcount" select="$colcount"/>
 </xsl:call-template>
 </xsl:for-each>
     <xsl:apply-templates select="./postamble"/>
	  <xsl:choose>
		  <xsl:when test="@title and string-length(@title)!=0">
Table: <xsl:value-of select="@title"/>
<xsl:text>&#xa;</xsl:text>
	  </xsl:when>
	  <xsl:when test="@suppress-title = 'true'">
	  </xsl:when>
	  <xsl:otherwise>
Table: <xsl:number format="1" level="any" count="texttable"/>
<xsl:text>&#xa;</xsl:text>
	  </xsl:otherwise>
	  </xsl:choose>
  </xsl:template>
  
  <xsl:template match="ttcol" name="tableheader">
	  <xsl:param name="lastnode"/>
<xsl:value-of select="."/> 
<xsl:choose>
	<xsl:when test="not($lastnode)"> | </xsl:when>
	<xsl:otherwise><xsl:text>&#xA;</xsl:text></xsl:otherwise>
</xsl:choose>
  </xsl:template>
  
  <xsl:template match="/ttcol" name="separator">
	  <xsl:param name="lastnode"/>
<xsl:choose>
	<xsl:when test="@align = 'left'">:---</xsl:when>
	<xsl:when test="@align = 'center'">:--:</xsl:when>
	<xsl:when test="@align = 'right'">---:</xsl:when>
	<xsl:otherwise>----</xsl:otherwise>
</xsl:choose>
<xsl:choose>
	<xsl:when test="not($lastnode)">|</xsl:when>
	<xsl:otherwise><xsl:text>&#xA;</xsl:text></xsl:otherwise>
</xsl:choose>
  </xsl:template>
  
  <xsl:template match="/c" name="table-c">
	  <xsl:param name="colcount"/>
      <xsl:apply-templates />
      <xsl:choose>
      <xsl:when test="position() mod $colcount = 0">
        <xsl:text>&#xA;</xsl:text>
      </xsl:when>
      <xsl:when test="position()=last()"> </xsl:when>
      <xsl:otherwise> | </xsl:otherwise>
      </xsl:choose>
  </xsl:template>


  <xsl:template match="c//text()"><xsl:copy-of select="." /></xsl:template>

</xsl:stylesheet>
