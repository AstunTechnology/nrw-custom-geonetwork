<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gmx="http://www.isotc211.org/2005/gmx"
    xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:srv="http://www.isotc211.org/2005/srv"
    xmlns:nrw="http://naturalresources.wales/nrw"
    exclude-result-prefixes="srv">
    
    <xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes" indent="yes"/>


    <xsl:strip-space elements="*"/>


    <!-- Template for Copy data -->
    <xsl:template name="copyData" match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- switch identifier to use RS_Identifier -->
    <xsl:template match="//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:identifier">
        <xsl:message>== Matched identifier element ===</xsl:message>
        <!-- TODO wait for example of correct encoding using RS_Identifier -->
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    

    <!-- remove PostGIS protocol resources -->
    <xsl:template match="*[gmd:CI_OnlineResource and count(gmd:CI_OnlineResource/gmd:linkage/gmd:URL[(starts-with(text(), 'PG'))]) > 0]" priority="1000">
        <xsl:message>=== Stripping Online Resources where the URL is a PostgreSQL DSN ===</xsl:message>
    </xsl:template>

        <!-- Don't copy elements from the NRW namespace -->
    <xsl:template match="nrw:*">
        <xsl:message>== Discarding elements from the NRW namespace ===</xsl:message>
    </xsl:template>

        <!-- Don't copy elements from the NRW namespace -->
    <xsl:template match="gmd:specification" priority="1000">
        <xsl:message>== Discarding Format Specification Element ===</xsl:message>
    </xsl:template>

    
    <!--  Change standard to MEDIN -->
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
        
    


</xsl:stylesheet>

