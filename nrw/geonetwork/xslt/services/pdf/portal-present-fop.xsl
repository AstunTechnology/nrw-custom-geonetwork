<?xml version="1.0" encoding="UTF-8" ?>
<!--
  ~ Copyright (C) 2001-2016 Food and Agriculture Organization of the
  ~ United Nations (FAO-UN), United Nations World Food Programme (WFP)
  ~ and United Nations Environment Programme (UNEP)
  ~
  ~ This program is free software; you can redistribute it and/or modify
  ~ it under the terms of the GNU General Public License as published by
  ~ the Free Software Foundation; either version 2 of the License, or (at
  ~ your option) any later version.
  ~
  ~ This program is distributed in the hope that it will be useful, but
  ~ WITHOUT ANY WARRANTY; without even the implied warranty of
  ~ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
  ~ General Public License for more details.
  ~
  ~ You should have received a copy of the GNU General Public License
  ~ along with this program; if not, write to the Free Software
  ~ Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA
  ~
  ~ Contact: Jeroen Ticheler - FAO - Viale delle Terme di Caracalla 2,
  ~ Rome - Italy. email: geonetwork@osgeo.org
  -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:geonet="http://www.fao.org/geonetwork"
                xmlns:util="java:org.fao.geonet.util.XslUtil"
                version="2.0"
                exclude-result-prefixes="#all">

  <xsl:include href="../../common/profiles-loader-tpl-brief.xsl"/>
  <xsl:include href="base-variables-metadata.xsl"/>
  <xsl:include href="metadata-fop.xsl"/>

  
<!-- root elements come from services/src/main/java/org/fao/geonet/api/records/formatters/XsltFormatter.java -->
  <xsl:variable name="translations"
                select="/root/translations"/>
  <xsl:variable name="gui"
                select="/root/gui"/>

 <!-- this is called when you select one or more records from the search page and click to download a pdf -->
  <xsl:template match="/root">
    <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format"
             xmlns:fox="http://xmlgraphics.apache.org/fop/extensions">
      <xsl:call-template name="fop-master"/>

      <xsl:if test="string($env/system/system/metadata/pdfReport/coverPdf)">
        <fox:external-document content-type="pdf" src="{$env/system/metadata/pdfReport/coverPdf}" />
      </xsl:if>

      <xsl:if test="$env/system/metadata/pdfReport/tocPage = 'true'">
        <fo:page-sequence master-reference="Intro" force-page-count="no-force">
          <xsl:call-template name="fop-header"/>

          <fo:flow flow-name="xsl-region-body">
            <xsl:call-template name="toc-page">
              <xsl:with-param name="res" select="/root/response/metadata"/>
            </xsl:call-template>
          </fo:flow>
        </fo:page-sequence>
      </xsl:if>

      <!-- Intro page -->
      <!-- the otherwise part of the choose statement is called when requesting a pdf from the
      search page -->
      <xsl:if test="string($env/system/metadata/pdfReport/introPdf)">
        <fox:external-document content-type="pdf" src="{$env/system/metadata/pdfReport/introPdf}" />
      </xsl:if>

      <xsl:variable name="formatter"
                    select="/root/request/formatter"/>

      <xsl:choose>
        <xsl:when test="$formatter != ''">
          <!-- Experimental / Combine all record using a dedicated formatter.
          This does not work for private record as fox is using HTTP call
          without authentication. Also paging will not work and link from
          toc does not. -->
          <xsl:for-each select="/root/response/metadata" >
            <xsl:variable name="uuid" select="/root/response/metadata/uuid"/>
            <xsl:variable name="formatterURL" select="concat(/root/gui/serverURL, 'api/records/', $uuid, '/formatters/xsl-view?output=pdf')"/>

            <fox:external-document content-type="pdf"
                                   src="{$formatterURL}" />
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          
          <fo:page-sequence master-reference="simpleA4" initial-page-number="1">

            <xsl:call-template name="fop-header"/>
            <xsl:call-template name="fop-footer"/>

            <fo:flow flow-name="xsl-region-body">
              <fo:block font-size="{$font-size}">
                    <xsl:call-template name="fo">
                      <xsl:with-param name="res" select="/root/response/metadata"/>
                    </xsl:call-template>
              </fo:block>
              <fo:block id="terminator"/>
            </fo:flow>
          </fo:page-sequence>
        </xsl:otherwise>
      </xsl:choose>

    </fo:root>
  </xsl:template>
</xsl:stylesheet>