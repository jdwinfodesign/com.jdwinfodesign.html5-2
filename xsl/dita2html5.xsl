<?xml version="1.0" encoding="UTF-8"?>
<!--
      © info goes here
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
  xmlns:dita2html="http://dita-ot.sourceforge.net/ns/200801/dita2html"
  xmlns:ditamsg="http://dita-ot.sourceforge.net/ns/200704/ditamsg"
  xmlns:related-links="http://dita-ot.sourceforge.net/ns/200709/related-links" version="2.0"
  xmlns:table="http://dita-ot.sourceforge.net/ns/201007/dita-ot/table"
  exclude-result-prefixes="xs dita-ot dita2html ditamsg related-links ">
  
  <xsl:param name="xslJSroot"/>
  <xsl:param name="xslJSpath"/>
  
  <xsl:import href="plugin:org.dita.html5:xsl/dita2html5Impl.xsl"/>
  <xsl:import href="nav.xsl"/>

  <xsl:output method="html" encoding="utf-8" indent="yes"/>

  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>
  <!-- not sure this does anything, so sanity checking -->
  <!-- Matches /dita or a root topic -->
<!--  <xsl:template match="*" mode="root_element.jdwinfodesign" name="root_element.jdwinfodesign">
    <xsl:call-template name="chapter-setup"/>
  </xsl:template>-->
  
  <!-- ============= fig ============= -->
  <xsl:template match="*[contains(@class, ' topic/fig ')]" name="topic.fig">
    <xsl:variable name="default-fig-class">
      <xsl:apply-templates select="." mode="dita2html:get-default-fig-class"/>
    </xsl:variable>
    <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]" mode="out-of-line"/>
    <figure>
      <xsl:if test="$default-fig-class != ''">
        <xsl:attribute name="class" select="$default-fig-class"/>
      </xsl:if>
      <xsl:call-template name="commonattributes">
        <xsl:with-param name="default-output-class" select="$default-fig-class"/>
      </xsl:call-template>
      <xsl:call-template name="setscale"/>
      <xsl:call-template name="setidaname"/>
      <xsl:call-template name="place-fig-lbl.jdwinfodesign"/>
      <xsl:apply-templates select="node() except *[contains(@class, ' topic/title ') or contains(@class, ' topic/desc ')]"/>
    </figure>
    <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
  </xsl:template>

  <xsl:template name="place-fig-lbl.jdwinfodesign">
    <xsl:param name="stringName"/>
    <!-- Number of fig/title's including this one -->
<!--    <xsl:variable name="fig-count-actual" select="count(preceding::*[contains(@class, ' topic/fig ')]/*[contains(@class, ' topic/title ')])+1"/>-->
    <xsl:variable name="ancestorlang">
      <xsl:call-template name="getLowerCaseLang"/>
    </xsl:variable>
    <xsl:choose>
      <!-- title -or- title & desc -->
      <xsl:when test="*[contains(@class, ' topic/title ')]">
        <figcaption>
          <span class="fig--title-label">Figure&#160;<xsl:value-of select="@chapNum"/>-<xsl:value-of select="@figNum"/>.&#160;</span>
          <xsl:apply-templates select="*[contains(@class, ' topic/title ')]" mode="figtitle.jdwinfodesign"/>
          <xsl:if test="*[contains(@class, ' topic/desc ')]">
            <xsl:text>. </xsl:text>
          </xsl:if>
          <xsl:for-each select="*[contains(@class, ' topic/desc ')]">
            <span>
              <xsl:call-template name="commonattributes">
                <xsl:with-param name="default-output-class" select="'figdesc'"/>
              </xsl:call-template>
              <xsl:apply-templates select="." mode="figdesc"/>
            </span>
          </xsl:for-each>
        </figcaption>
      </xsl:when>
      <!-- desc -->
      <xsl:when test="*[contains(@class, ' topic/desc ')]">
        <xsl:for-each select="*[contains(@class, ' topic/desc ')]">
          <figcaption>
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates select="." mode="figdesc"/>
          </figcaption>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="*[contains(@class, ' topic/fig ')]/*[contains(@class, ' topic/title ')]" mode="figtitle.jdwinfodesign">
    <xsl:apply-templates/>
  </xsl:template>
  
  <!-- ============ table ============ -->
  <xsl:template match="*[contains(@class,' topic/table ')]" name="topic.table">
    <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]" mode="out-of-line"/>
    <table>
      <xsl:apply-templates select="." mode="table:common"/>
      <xsl:apply-templates select="." mode="table:title"/>
      <!-- title and desc are processed elsewhere -->
      <xsl:apply-templates select="*[contains(@class, ' topic/tgroup ')]"/>
    </table>
    <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
  </xsl:template>
  
  <xsl:template match="*[contains(@class, ' topic/table ')]" mode="table:title">
    <caption>
      <xsl:apply-templates select="*[contains(@class, ' topic/title ')]" mode="label.jdwinfodesign"/>
      <xsl:apply-templates select="
        *[contains(@class, ' topic/title ')] | *[contains(@class, ' topic/desc ')]
        "/>
    </caption>
  </xsl:template>
  
  <xsl:template match="*[contains(@class, ' topic/table ')]/*[contains(@class, ' topic/title ')]" mode="label.jdwinfodesign">
    <span class="table--title-label">Table&#160;<xsl:value-of select="../@chapNum"/>-<xsl:value-of select="../@tableNum"/>.&#160;</span>
  </xsl:template>
  
</xsl:stylesheet>
