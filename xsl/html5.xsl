<?xml version="1.0" encoding="utf-8"?>
<!--
	This file is part of the DITA-OT Open-Graph Plug-in project.
	See the accompanying LICENSE file for applicable licenses.
-->
<xsl:stylesheet
  version="2.0"
  xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  exclude-result-prefixes="xs dita-ot"
>

  <xsl:param name="OPEN_GRAPH_URL" as="xs:string?"/>
  <xsl:param name="OPEN_GRAPH_TITLE" as="xs:string?"/>
  <xsl:param name="OPEN_GRAPH_DESCRIPTION" as="xs:string?"/>
  <xsl:param name="OPEN_GRAPH_IMAGE_SRC"  as="xs:string?"/>
  <xsl:param name="OPEN_GRAPH_IMAGE_ALT" as="xs:string?"/>
  <xsl:param name="SOURCE" as="xs:string?"/>
  <xsl:param name="FILEDIR" as="xs:string?"/>
  <xsl:param name="FILENAME" as="xs:string?"/>
  <xsl:param name="TWITTER_SITE" as="xs:string?"/>

  <xsl:variable name="current-file" select="dita-ot:normalize-href(if ($FILEDIR = '.') then $FILENAME else concat($FILEDIR, '/', $FILENAME))" as="xs:string?"/>


  <xsl:param name="OPEN_GRAPH_SITE_NAME" select="''"/>
 
  <xsl:template name="chapter-setup">
    <html>
      <xsl:if test="$OPEN_GRAPH_URL">
        <xsl:attribute name="prefix" select="'og: http://ogp.me/ns#'"/>
      </xsl:if>
      <xsl:call-template name="setTopicLanguage"/>
      <xsl:call-template name="chapterHead"/>
      <xsl:call-template name="chapterBody"/> 
    </html>
  </xsl:template>

  <xsl:template match="*" mode="getMeta">
    <xsl:next-match/>
    <!-- Website URL is required -->
    <xsl:if test="$OPEN_GRAPH_URL">
      <xsl:call-template name="setOpenGraphMeta"/>
    </xsl:if>
  </xsl:template>

  <xsl:template name="setOpenGraphMeta">
    <xsl:variable name="bookmeta" select="document($SOURCE)/*[contains(@class,' bookmap/bookmap ')]/bookmeta"/>

    <!-- Page description. Either short desc or various fallbacks -->
    <xsl:variable name="og_description">
      <xsl:choose>
        <xsl:when test="//*[contains(@class,' topic/shortdesc ')][1]">
          <xsl:value-of select="//*[contains(@class,' topic/shortdesc ')][1]"/>
        </xsl:when>
        <xsl:when test="document($SOURCE)/*[contains(@class,' bookmap/bookmap ')]/shortdesc">
          <xsl:value-of select="document($SOURCE)/*[contains(@class,' bookmap/bookmap ')]/shortdesc"/>
        </xsl:when>
        <xsl:when test="$OPEN_GRAPH_DESCRIPTION">
          <xsl:value-of select="$OPEN_GRAPH_DESCRIPTION"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="/*[contains(@class, ' topic/topic ')]/*[contains(@class,' topic/p ')][1]"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- Title. Name of the book with page title or fallbacks -->
    <xsl:variable name="og_title">
      <xsl:choose>
        <xsl:when test="document($SOURCE)/*[contains(@class,' bookmap/bookmap ')]/*[contains(@class,' bookmap/booktitle ')]/*[contains(@class, ' bookmap/mainbooktitle ')]">
            <xsl:value-of select="document($SOURCE)/*[contains(@class,' bookmap/bookmap ')]/*[contains(@class,' bookmap/booktitle ')]/*[contains(@class, ' bookmap/mainbooktitle ')]"/>
            <xsl:text> - </xsl:text>
        </xsl:when>
        <xsl:when test="$OPEN_GRAPH_TITLE">
          <xsl:value-of select="$OPEN_GRAPH_TITLE"/>
           <xsl:text> - </xsl:text>
        </xsl:when>
      </xsl:choose>
      <xsl:value-of select="/*[contains(@class, ' topic/topic ')]/*[contains(@class, ' topic/title ')][1]"/>
    </xsl:variable>

    <!-- Card image - use meta data if found or fallback to common values -->
    <xsl:variable name="og_image">
      <xsl:choose>
        <xsl:when test="//*[contains(@class,' topic/prolog ')]/*[contains(@class,' topic/metadata ')]/*[contains(@class,' topic/othermeta ')][@name='og:image']/@content">
          <xsl:value-of select="//*[contains(@class,' topic/prolog ')]/*[contains(@class,' topic/metadata ')]/*[contains(@class,' topic/othermeta ')][@name='og:image']/@content"/>
        </xsl:when>
        <xsl:when test="$bookmeta/data[name='og:image']">
            <xsl:value-of select="$bookmeta/data[name='og:image']"/>
        </xsl:when>
        <xsl:when test="$OPEN_GRAPH_IMAGE_SRC">
          <xsl:value-of select="$OPEN_GRAPH_IMAGE_SRC"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>

    <!-- Card image alt text -->
     <xsl:variable name="og_image_alt">
      <xsl:choose>
        <xsl:when test="//*[contains(@class,' topic/prolog ')]/*[contains(@class,' topic/metadata ')]/*[contains(@class,' topic/othermeta ')][@name='og:image']/@content">
          <xsl:value-of select="//*[contains(@class,' topic/prolog ')]/*[contains(@class,' topic/metadata ')]/*[contains(@class,' topic/othermeta ')][@name='og:image:alt']/@content"/>
        </xsl:when>
        <xsl:when test="$bookmeta/data[name='og:image:alt']">
            <xsl:value-of select="$bookmeta/data[name='og:image:alt']"/>
        </xsl:when>
        <xsl:when test="$OPEN_GRAPH_IMAGE_ALT">
          <xsl:value-of select="$OPEN_GRAPH_IMAGE_ALT"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>

    <!-- Facebook Meta Tags -->
    <meta property="og:type" content="website"/>
    <meta property="og:url">
      <xsl:attribute name="content">
         <xsl:value-of select="concat($OPEN_GRAPH_URL, '/')"/>
         <xsl:call-template name="replace-extension">
            <xsl:with-param name="filename" select="$current-file"/>
            <xsl:with-param name="extension" select="$OUTEXT"/>
          </xsl:call-template>
      </xsl:attribute>
    </meta>
  
    <meta property="og:title">
      <xsl:attribute name="content">
         <xsl:value-of select="substring(normalize-space($og_title), 0, 60)"/>
      </xsl:attribute>
    </meta>
    <meta property="og:description">
      <xsl:attribute name="content">
         <xsl:value-of select="substring(normalize-space($og_description), 0, 160)"/>
      </xsl:attribute>
    </meta>
    <xsl:if test="$og_image">
      <meta property="og:image">
        <xsl:attribute name="content">
            <xsl:value-of select="concat($OPEN_GRAPH_URL, '/')"/>
            <xsl:value-of select="$og_image"/>
        </xsl:attribute>
      </meta>
      <xsl:if test="not($og_image_alt = '')">
        <meta property="og:image:alt">
          <xsl:attribute name="content">
              <xsl:value-of select="$og_image_alt"/>
          </xsl:attribute>
        </meta>
      </xsl:if>
    </xsl:if>

    <xsl:if test="OPEN_GRAPH_SITE_NAME">
      <meta property="og:site_name">
        <xsl:attribute name="content">
          <xsl:value-of select="$OPEN_GRAPH_SITE_NAME"/>
        </xsl:attribute>
      </meta>
    </xsl:if>

     <!-- Twitter Tags -->
    <meta name="twitter:title">
      <xsl:attribute name="content">
         <xsl:value-of select="substring(normalize-space($og_title), 0, 60)"/>
      </xsl:attribute>
    </meta>
    <meta name="twitter:description">
      <xsl:attribute name="content">
         <xsl:value-of select="substring(normalize-space($og_description), 0, 160)"/>
      </xsl:attribute>
    </meta>
    <meta property="twitter:url">
      <xsl:attribute name="content">
         <xsl:value-of select="concat($OPEN_GRAPH_URL, '/')"/>
         <xsl:call-template name="replace-extension">
            <xsl:with-param name="filename" select="$current-file"/>
            <xsl:with-param name="extension" select="$OUTEXT"/>
          </xsl:call-template>
      </xsl:attribute>
    </meta>

    <xsl:if test="$og_image">
      <meta name="twitter:card" content="summary_large_image"/>
      <meta name="twitter:image">
        <xsl:attribute name="content">
          <xsl:value-of select="concat($OPEN_GRAPH_URL, '/')"/>
          <xsl:value-of select="$og_image"/>
        </xsl:attribute>
      </meta>
      <xsl:if test="not($og_image_alt = '')">
        <meta name="twitter:image:alt">
          <xsl:attribute name="content">
              <xsl:value-of select="$og_image_alt"/>
          </xsl:attribute>
        </meta>
      </xsl:if>
    </xsl:if>

    <xsl:if test="TWITTER_SITE">
      <meta name="twitter:site">
        <xsl:attribute name="content">
          <xsl:value-of select="$TWITTER_SITE"/>
        </xsl:attribute>
      </meta>
    </xsl:if>

  </xsl:template>

    <xsl:template
      match="*[contains(@class,' topic/prolog ')]/*[contains(@class,' topic/metadata ')]/*[contains(@class,' topic/othermeta ')][@name='og:image']"
      mode="gen-metadata"
    />
    <xsl:template
      match="*[contains(@class,' topic/prolog ')]/*[contains(@class,' topic/metadata ')]/*[contains(@class,' topic/othermeta ')][@name='og:image:alt']"
      mode="gen-metadata"
    />

</xsl:stylesheet>
