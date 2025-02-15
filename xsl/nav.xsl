<?xml version="1.0" encoding="UTF-8"?>
<!--

-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
  xmlns:ditamsg="http://dita-ot.sourceforge.net/ns/200704/ditamsg"
  version="2.0"
  exclude-result-prefixes="xs dita-ot ditamsg">
  
  <xsl:template match="*" mode="gen-user-sidetoc">
    <xsl:if test="$nav-toc = ('partial', 'full')">
      <nav class="toc col-lg-3">
        <ul class="accordion accordion-flush" id="main-toc">
          <!-- ======================================================= -->
          <!-- jdw 09-13-2022 Link to the home page -->
          <xsl:element name="li">
            <a>
              <xsl:attribute name="href">
                <xsl:value-of select="concat($PATH2PROJ, 'index.html')"/>
              </xsl:attribute>
              <xsl:text>Home</xsl:text>
            </a>
          </xsl:element>
          <!-- ======================================================= -->
          <xsl:choose>
            <xsl:when test="$nav-toc = 'partial'">
              <!-- jdw 09-12-2022 If our topic is not one of the frontmatter
                                  topics, get the links to the frontmatter 
                                  topics for the TOC                       -->
              <xsl:if test="$current-topicref/..[not(contains(@class, ' bookmap/frontmatter '))]">
                <xsl:for-each select="$input.map/bookmap/frontmatter/*">
                  <li>
                    <a>
                      <xsl:attribute name="href">
                        <xsl:call-template name="replace-extension">
                          <xsl:with-param name="filename" select="substring-after(@href, 'topics/')"/>
                          <xsl:with-param name="extension" select="$OUTEXT"/>
                        </xsl:call-template>
                      </xsl:attribute>
                      <xsl:value-of select="topicmeta/navtitle"/>
                    </a>
                  </li>
                </xsl:for-each>
              </xsl:if>
              <!-- ======================================================= -->
              <xsl:apply-templates select="$current-topicref" mode="toc-pull">
                <xsl:with-param name="pathFromMaplist" select="$PATH2PROJ" as="xs:string"/>
                <xsl:with-param name="children" as="element()*">
                  <xsl:apply-templates select="$current-topicref/*[contains(@class, ' map/topicref ')]" mode="toc">
                    <xsl:with-param name="pathFromMaplist" select="$PATH2PROJ" as="xs:string"/>
                  </xsl:apply-templates>
                </xsl:with-param>
              </xsl:apply-templates>
            </xsl:when>
            <xsl:when test="$nav-toc = 'full'">
              <xsl:apply-templates select="$input.map" mode="toc">
                <xsl:with-param name="pathFromMaplist" select="$PATH2PROJ" as="xs:string"/>
              </xsl:apply-templates>
            </xsl:when>
          </xsl:choose>
        </ul>
      </nav>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="*[contains(@class, ' map/topicref ')]
    [not(@toc = 'no')]
    [not(@processing-role = 'resource-only')]"
    mode="toc" priority="10">
    <xsl:param name="pathFromMaplist" as="xs:string"/>
    <xsl:param name="children" select="if ($nav-toc = 'full') then *[contains(@class, ' map/topicref ')] else ()" as="element()*"/>
    <xsl:variable name="title">
      <xsl:apply-templates select="." mode="get-navtitle"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="normalize-space($title)">
        <li class="accordion-item">
          <xsl:if test=". is $current-topicref">
            <xsl:attribute name="class">active</xsl:attribute>
          </xsl:if>
          <xsl:choose>
            <xsl:when test="normalize-space(@href)">
              <xsl:comment>no active</xsl:comment>
              <a>
                <xsl:attribute name="href">
                  <xsl:if test="not(@scope = 'external')">
                    <xsl:value-of select="$pathFromMaplist"/>
                  </xsl:if>
                  <xsl:choose>
                    <xsl:when test="@copy-to and not(contains(@chunk, 'to-content')) and 
                      (not(@format) or @format = 'dita' or @format = 'ditamap') ">
                      <xsl:call-template name="replace-extension">
                        <xsl:with-param name="filename" select="@copy-to"/>
                        <xsl:with-param name="extension" select="$OUTEXT"/>
                      </xsl:call-template>
                      <xsl:if test="not(contains(@copy-to, '#')) and contains(@href, '#')">
                        <xsl:value-of select="concat('#', substring-after(@href, '#'))"/>
                      </xsl:if>
                    </xsl:when>
                    <xsl:when test="not(@scope = 'external') and (not(@format) or @format = 'dita' or @format = 'ditamap')">
                      <xsl:call-template name="replace-extension">
                        <xsl:with-param name="filename" select="@href"/>
                        <xsl:with-param name="extension" select="$OUTEXT"/>
                      </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="@href"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
                <xsl:value-of select="$title"/>
              </a>
            </xsl:when>
            <xsl:otherwise>
              <span>
                <xsl:value-of select="$title"/>
              </span>
            </xsl:otherwise>
          </xsl:choose>
        </li>
      </xsl:when>
    </xsl:choose>
  </xsl:template>  

</xsl:stylesheet>
