<?xml version="1.0" ?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
>

  <xsl:param name="path"/>

  <xsl:template match="*[@refid]">
    <!-- Read the sub-flow from its own file. -->
    <xsl:variable name="filename"
      select="replace(string-join((@name, @refid, 'flow-map.xml'), '_'), '[^0-9A-Za-z_.-]', '')"/>
    <xsl:apply-templates select="document(concat($path, '/', $filename))"/>
  </xsl:template>

  <xsl:template match="@id | @name">
  </xsl:template>

  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
