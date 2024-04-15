<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gmx="http://www.isotc211.org/2005/gmx"
    xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:srv="http://www.isotc211.org/2005/srv"
    xmlns:nrw="http://naturalresources.wales/nrw"
    exclude-result-prefixes="srv">
    
    <xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes" indent="yes"/>


    
    <!-- Import base formatter -->

    <xsl:import href="generic-postprocessing.xsl"/>
    
    <!--  Change standard to UK GEMINI  -->
    <xsl:template match="//gmd:metadataStandardName"  priority="10">
        <xsl:message>=== Updating Metadata Standard Name ===</xsl:message>
        <gmd:metadataStandardName>
            <gmx:Anchor xlink:type="simple" xlink:href="http://vocab.nerc.ac.uk/collection/M25/current/MEDIN/">MEDIN</gmx:Anchor>
        </gmd:metadataStandardName>
    </xsl:template>
    
    <xsl:template match="//gmd:metadataStandardVersion"  priority="10">
        <xsl:message>=== Updating Metadata Standard Version ===</xsl:message>
        <gmd:metadataStandardVersion>
            <gco:CharacterString>3.1.2</gco:CharacterString>
        </gmd:metadataStandardVersion>
        
    </xsl:template>
        
    
    <!--<xsl:template match="//gmd:extent/gmd:EX_Extent/gmd:geographicElement[gmd:EX_GeographicDescription/gmd:geographicIdentifier/gmd:MD_Identifier/gmd:authority/gmd:CI_Citation/gmd:title/gco:CharacterString='SeaVoX Vertical Co-ordinate Coverages']">
        <xsl:message>==== Removing MEDIN-Specific Vertical Extent keywords ====</xsl:message>
    </xsl:template>-->
        
   
    


</xsl:stylesheet>

