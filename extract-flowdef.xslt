<?xml version="1.0" ?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
>

  <!--
    Prepare the flow.xml to be split in the next step.
    This is easier when using <xsl:result-document>, but the TransformXML processor
    does not allow setting the "http://saxon.sf.net/feature/allow-external-functions"
    feature of Saxon, so <xsl:result-document> cannot be used.
  -->

  <!-- Make a document root that will contain all flow-maps. -->
  <xsl:template match="/">
    <flow-map>
      <xsl:apply-templates select="*" mode="sub-flow"/>
    </flow-map>
  </xsl:template>

  <!-- Create flow-maps for the main flow and sub-flows.  -->
  <xsl:template match="/* | processGroup" mode="sub-flow">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:attribute name="id" select="data(id)"/>
      <xsl:attribute name="name" select="data(name)"/>
      <xsl:apply-templates select="*"/>
    </xsl:copy>
    <xsl:apply-templates select="*" mode="sub-flow"/>
  </xsl:template>

  <!-- In sub-flow mode, only look for sub-flows. -->
  <xsl:template match="*" mode="sub-flow" priority="-1">
    <xsl:apply-templates select="*" mode="sub-flow"/>
  </xsl:template>

  <!-- Replace a processGroup with a reference to a flow-map. -->
  <xsl:template match="processGroup">
    <xsl:copy>
      <xsl:attribute name="refid" select="data(id)"/>
      <xsl:attribute name="name" select="data(name)"/>
    </xsl:copy>
  </xsl:template>

  <!-- Export all processors except disabled ones in the STOPPED state. -->
  <xsl:template match="scheduledState[not(*) and not(. = 'DISABLED')]">
    <scheduledState>STOPPED</scheduledState>
  </xsl:template>

  <!-- Copy everything else. -->
  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
