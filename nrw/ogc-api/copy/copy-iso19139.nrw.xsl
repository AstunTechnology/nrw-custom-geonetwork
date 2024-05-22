<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:nrw="http://naturalresources.wales/nrw"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                exclude-result-prefixes="nrw gmd"
                version="3.0">
  
  <!-- Identity template to copy everything by default -->
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- Template to remove the nrw:internalLocationInfo element -->
  <xsl:template match="nrw:internalLocationInfo">
    <xsl:message>=== Removing NRW Internal Location Info ===</xsl:message>
  </xsl:template>

  <!-- Template to remove the nrw:internalContactInfo element -->
  <xsl:template match="nrw:internalContactInfo">
    <xsl:message>=== Removing NRW Internal Contact Info ===</xsl:message>
  </xsl:template>

</xsl:stylesheet>
