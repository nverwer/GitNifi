<?xml version="1.0" ?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
>

  <!--
    Prepare the flow.xml to be split in the next step.
    This is easier when using <xsl:result-document>, but the TransformXML processor
    does not allow setting the "http://saxon.sf.net/feature/allow-external-functions"
    feature of Saxon.
  -->

  <xsl:template match="/">
    <flow-map>
      <xsl:apply-templates select="*" mode="sub-flow"/>
    </flow-map>
  </xsl:template>

  <xsl:template match="/* | processGroup" mode="sub-flow">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:attribute name="id" select="data(id)"/>
      <xsl:attribute name="name" select="data(name)"/>
      <xsl:apply-templates select="*"/>
    </xsl:copy>
    <xsl:apply-templates select="*" mode="sub-flow"/>
  </xsl:template>

  <xsl:template match="*" mode="sub-flow" priority="-1">
    <xsl:apply-templates select="*" mode="sub-flow"/>
  </xsl:template>

  <xsl:template match="processGroup">
    <xsl:copy>
      <xsl:attribute name="refid" select="data(id)"/>
      <xsl:attribute name="name" select="data(name)"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
