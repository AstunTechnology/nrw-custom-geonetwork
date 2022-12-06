<?xml version="1.0" encoding="UTF-8"?>
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

<!--
  The main entry point for all user interface generated
  from XSLT.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="2.0"
                xmlns:util="java:org.fao.geonet.util.XslUtil"
                exclude-result-prefixes="#all">

  <xsl:output omit-xml-declaration="yes" method="html" doctype-system="html" indent="yes"
              encoding="UTF-8"/>

  <xsl:include href="common/base-variables.xsl"/>
  <xsl:include href="base-layout-cssjs-loader.xsl"/>
  <xsl:include href="skin/default/skin.xsl"/>

  <xsl:template match="/">
    <html ng-app="{$angularModule}" lang="{$lang2chars}" id="ng-app">
      <head>
        <title>
            <xsl:value-of select="util:getNodeName('', $lang, true())"/>
        </title>
        <meta charset="utf-8"/>
        <meta name="viewport" content="initial-scale=1.0"/>
        <meta name="apple-mobile-web-app-capable" content="yes"/>

        <meta name="description" content="{concat($env/system/site/name, ' - ', $env/system/site/organization)}"/>
        <meta name="keywords" content="GeoNetwork opensource metadata ISO19115 ISO19139 ISO GIS remote sensing data shapefiles spatial data satellite images map maps interactive opengis geospatial CSW reference implementation mapping 19115 19139 geographic z39.50 catalog clearinghouse coverages grid raster data opensource open source network"/>
        <link rel="schema.DC" href="http://purl.org/dc/elements/1.1/"/>
        <meta name="DC.title" lang="English"
              content="Scottish Spatial Data Infrastructure"/>
        <meta name="DC.creator" content="GeoNetwork Team"/>
        <meta name="DC.subject" lang="English"
              content="GeoNetwork opensource metadata ISO19115 ISO19139 ISO GIS remote sensing data shapefiles spatial data satellite images map maps interactive opengis mapping 19115 19139 geographic z39.50 catalog clearinghouse coverages grid raster data opensource open source network"/>
        <meta name="DC.description" lang="English"
              content="GeoNetwork opensource provides Internet access to interactive maps, satellite imagery and related spatial databases. It's purpose is to improve access to and integrated use of spatial data and information. GeoNetwork opensource allows to easily share spatial data among different users"/>
        <meta name="DC.publisher" content=""/>
        <meta name="DC.date" content="02-07-2007"/>
        <meta name="DC.type" scheme="DCMIType" content="InteractiveResource"/>
        <meta name="DC.format" content="text/html; charset=UTF-8"/>
        <meta name="DC.language"
              content="English"/>
        <meta name="DC.coverage" content="Global"/>

	<!-- Google Tag Manager -->
	<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
		new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
		j=d.createElement(s),dl=l!='dataLayer'?'&amp;l='+l:'';j.async=true;j.src=
		'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
		})(window,document,'script','dataLayer','GTM-NQFJ7QL');</script>
	<!-- End Google Tag Manager -->

        <link rel="icon" sizes="16x16 32x32 48x48" type="image/png"
              href="../../images/logos/favicon.png"/>
        <link href="rss.search?sortBy=changeDate" rel="alternate" type="application/rss+xml"
              title="{concat($env/system/site/name, ' - ', $env/system/site/organization)}"/>
        <link href="portal.opensearch" rel="search" type="application/opensearchdescription+xml"
              title="{concat($env/system/site/name, ' - ', $env/system/site/organization)}"/>

        <xsl:call-template name="css-load"/>
      </head>


      <!-- The GnCatController takes care of
      loading site information, check user login state
      and a facet search to get main site information.
      -->
      <body data-ng-controller="GnCatController" data-ng-class="[isHeaderFixed ? 'gn-header-fixed' : 'gn-header-relative', isLogoInHeader ? 'gn-logo-in-header' : 'gn-logo-in-navbar', isFooterEnabled ? 'gn-show-footer' : 'gn-hide-footer']">

      
      <!-- structured data -->
      <script type="application/ld+json">{
        "@context": "http://schema.org/",
        "@type": "schema:DataCatalog",  
        "url": "<xsl:value-of select="util:getSettingValue('nodeUrl')"/>",
        "@id": "<xsl:value-of select="util:getSettingValue('nodeUrl')"/>",
        "inLanguage":"eng",
        "name": "<xsl:value-of select="util:getNodeName('', $lang, true())"/>",
        "thumbnailUrl": ["../../images/logos/favicon.png"],
        "description": "GeoNetwork opensource provides Internet access to interactive maps, satellite imagery and related spatial databases. It's purpose is to improve access to and integrated use of spatial data and information. GeoNetwork opensource allows to easily share spatial data among different users"
      }</script>
      <!-- End structured data -->

      	<!-- Google Tag Manager (noscript) -->
      	<noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-NQFJ7QL"
			      height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
	      <!-- End Google Tag Manager (noscript) -->
	              <div data-gn-alert-manager=""></div>

        <xsl:choose>
          <xsl:when test="ends-with($service, 'nojs')">
            <!-- No JS degraded mode ... -->
            <div>
              <!-- TODO: Add header/footer -->
              <xsl:apply-templates mode="content" select="."/>
            </div>
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="$isJsEnabled">
              <xsl:call-template name="no-js-alert"/>
            </xsl:if>
            <!-- AngularJS application -->
            <xsl:if test="$angularApp != 'gn_search' and $angularApp != 'gn_viewer' and $angularApp != 'gn_formatter_viewer'">
              <div class="navbar navbar-default gn-top-bar"
                   role="navigation"
                   data-ng-hide="layout.hideTopToolBar"
                   data-ng-include="'{$uiResourcesPath}templates/top-toolbar.html'"></div>
            </xsl:if>

            <xsl:apply-templates mode="content" select="."/>

            <xsl:if test="$isJsEnabled">
              <xsl:call-template name="javascript-load"/>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
      </body>
    </html>
  </xsl:template>


  <xsl:template name="no-js-alert">
    <noscript>
      <xsl:call-template name="header"/>
      <div class="container page">
        <div class="row gn-row-main">
          <div class="col-sm-8 col-sm-offset-2">
            <h1><xsl:value-of select="$env/system/site/name"/></h1>
            <p><xsl:value-of select="/root/gui/strings/mainpage2"/></p>
            <p><xsl:value-of select="/root/gui/strings/mainpage1"/></p>
            <br/><br/>
            <div class="alert alert-warning" data-ng-hide="">
              <strong>
                <xsl:value-of select="$i18n/warning"/>
              </strong>
              <xsl:text> </xsl:text>
              <xsl:copy-of select="$i18n/nojs"/>
            </div>
          </div>
        </div>
      </div>
      <xsl:call-template name="footer"/>
    </noscript>
  </xsl:template>

</xsl:stylesheet>
