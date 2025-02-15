<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
  xmlns:ditamsg="http://dita-ot.sourceforge.net/ns/200704/ditamsg" version="2.0"
  exclude-result-prefixes="xs dita-ot ditamsg">

  <!--  <xsl:import href="plugin:org.dita.html5:xsl/dita2html5Impl.xsl"/>-->
  <xsl:import href="plugin:org.dita.html5:xsl/map2html5-cover.xsl"/>

  <!-- ================================================================================= -->
  <!-- jdw 03-20-2022 Overrides for cover.xsl in org.dita.html5 -->
  <xsl:template match="*[contains(@class, ' map/map ')]" mode="imom-toc">
    <xsl:param name="pathFromMaplist"/>
    <xsl:if test="
        descendant::*[contains(@class, ' map/topicref ')]
        [not(@toc = 'no')]
        [not(@processing-role = 'resource-only')]">
      <nav class="toc col-lg-3">
        <ul id="main-toc">
          <xsl:call-template name="commonattributes"/>
          <xsl:attribute name="class">imom-map map bookmap accordion accordion-flush</xsl:attribute>
          <xsl:apply-templates select="*[contains(@class, ' map/topicref ')]" mode="toc">
            <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
          </xsl:apply-templates>
        </ul>
      </nav>
    </xsl:if>
  </xsl:template>
  
  <!-- jdw 08-05-2022 There is no HTML5 template for bookmeta, and we need this info for the cover -->
  <xsl:template match="*[contains(@class, ' bookmap/bookmeta ')]" mode="doc-info">
    <xsl:for-each select="data">
      <xsl:choose>
        <xsl:when test="@outputclass='imom-logo'">
          <xsl:element name="img">
            <xsl:attribute name="class">
              <xsl:value-of select="@outputclass"/>
            </xsl:attribute>
            <xsl:attribute name="src">
              <xsl:text>include/iMomLogo.png</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="alt">
              <xsl:text>iMOM Logo</xsl:text>
            </xsl:attribute>
          </xsl:element>
        </xsl:when>
        <xsl:otherwise>
          <xsl:element name="p">
            <xsl:attribute name="class">
              <xsl:value-of select="@outputclass"/>
            </xsl:attribute>
            <xsl:value-of select="."/>
          </xsl:element>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="
      *[contains(@class, ' map/topicref ')]
      [not(@toc = 'no')]
      [not(@processing-role = 'resource-only')]" mode="toc">
    <xsl:param name="pathFromMaplist"/>
    <xsl:variable name="title">
      <xsl:apply-templates select="." mode="get-navtitle"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="normalize-space($title)">
        <li>
          <xsl:call-template name="commonattributes"/>
          <xsl:attribute name="class">topicref chapter accordion-item</xsl:attribute>
          <xsl:choose>
            <!-- If there is a reference to a DITA or HTML file, and it is not external: -->
            <xsl:when test="normalize-space(@href)">
              <xsl:variable name="spanId">
                <xsl:value-of
                  select="concat('span-', substring-before((substring-after(./@href, 'topics/')), '.dita'))"
                />
              </xsl:variable>
              <xsl:variable name="collapseId">
                <xsl:value-of
                  select="concat('collapse-', substring-before((substring-after(./@href, 'topics/')), '.dita'))"
                />
              </xsl:variable>
              <xsl:comment>
                <xsl:value-of select="name(.)"/>
              </xsl:comment>
              <xsl:choose>
                <xsl:when
                  test=".[contains(@class, ' bookmap/notices ') or contains(@class, ' bookmap/preface ')]">
                  <span class="accordion-header">
                    <xsl:attribute name="id">
                      <xsl:value-of select="$spanId"/>
                    </xsl:attribute>
                    <!-- /bookmap/chapter[1]/@href -->
                    <button type="button" class="accordion-button collapsed"
                      data-bs-toggle="collapse" data-bs-target="#{$collapseId}"
                      aria-expanded="false" aria-controls="{$collapseId}">
                      <xsl:value-of select="topicmeta/navtitle"/>
                    </button>
                  </span>
                  
                  <div>
                    <xsl:attribute name="class">accordion-collapse collapse</xsl:attribute>
                    <xsl:attribute name="id">
                      <xsl:value-of select="$collapseId"/>
                    </xsl:attribute>
                    <xsl:attribute name="aria-labelledby">
                      <xsl:value-of select="$spanId"/>
                    </xsl:attribute>
                    <xsl:attribute name="data-bs-parent">#map-toc</xsl:attribute>
                    <div class="accordion-body">
                      <a>
                        <xsl:attribute name="href">
                          <xsl:choose>
                            <xsl:when test="
                              @copy-to and not(contains(@chunk, 'to-content')) and
                              (not(@format) or @format = 'dita' or @format = 'ditamap')">
                              <xsl:if test="not(@scope = 'external')">
                                <xsl:value-of select="$pathFromMaplist"/>
                              </xsl:if>
                              <xsl:call-template name="replace-extension">
                                <xsl:with-param name="filename" select="@copy-to"/>
                                <xsl:with-param name="extension" select="$OUTEXT"/>
                              </xsl:call-template>
                              <xsl:if test="not(contains(@copy-to, '#')) and contains(@href, '#')">
                                <xsl:value-of select="concat('#', substring-after(@href, '#'))"/>
                              </xsl:if>
                            </xsl:when>
                            <xsl:when
                              test="not(@scope = 'external') and (not(@format) or @format = 'dita' or @format = 'ditamap')">
                              <xsl:if test="not(@scope = 'external')">
                                <xsl:value-of select="$pathFromMaplist"/>
                              </xsl:if>
                              <xsl:call-template name="replace-extension">
                                <xsl:with-param name="filename" select="@href"/>
                                <xsl:with-param name="extension" select="$OUTEXT"/>
                              </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                              <!-- If non-DITA, keep the href as-is -->
                              <xsl:if test="not(@scope = 'external')">
                                <xsl:value-of select="$pathFromMaplist"/>
                              </xsl:if>
                              <xsl:value-of select="@href"/>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:attribute>
                        <xsl:if
                          test="@scope = 'external' or not(not(@format) or @format = 'dita' or @format = 'ditamap')">
                          <xsl:apply-templates select="." mode="external-link"/>
                        </xsl:if>
                        <xsl:value-of select="$title"/>
                      </a>
                      <xsl:if test="
                        descendant::*[contains(@class, ' map/topicref ')]
                        [not(@toc = 'no')]
                        [not(@processing-role = 'resource-only')]">
                        <!-- jdw 04-01-2022 Need to rewrite templates to use spans and 
                                            buttons at this level of the TOC.          -->
                        <ul>
                          <xsl:apply-templates select="*[contains(@class, ' map/topicref ')]"
                            mode="toc">
                            <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
                          </xsl:apply-templates>
                        </ul>
                      </xsl:if>
                    </div>
                  </div>
                </xsl:when>
                <xsl:when
                  test=".[contains(@class, ' bookmap/chapter ') or contains(@class, ' bookmap/appendix ')]">
                  <span class="accordion-header">
                    <xsl:attribute name="id">
                      <xsl:value-of select="$spanId"/>
                    </xsl:attribute>
                    <!-- /bookmap/chapter[1]/@href -->
                    <button type="button" class="accordion-button collapsed"
                      data-bs-toggle="collapse" data-bs-target="#{$collapseId}"
                      aria-expanded="false" aria-controls="{$collapseId}">
                      <xsl:value-of select="topicmeta/navtitle"/>
                    </button>
                  </span>

                  <div>
                    <xsl:attribute name="class">accordion-collapse collapse</xsl:attribute>
                    <xsl:attribute name="id">
                      <xsl:value-of select="$collapseId"/>
                    </xsl:attribute>
                    <xsl:attribute name="aria-labelledby">
                      <xsl:value-of select="$spanId"/>
                    </xsl:attribute>
                    <xsl:attribute name="data-bs-parent">#map-toc</xsl:attribute>
                    <div class="accordion-body">
                      <a>
                        <xsl:attribute name="href">
                          <xsl:choose>
                            <xsl:when test="
                                @copy-to and not(contains(@chunk, 'to-content')) and
                                (not(@format) or @format = 'dita' or @format = 'ditamap')">
                              <xsl:if test="not(@scope = 'external')">
                                <xsl:value-of select="$pathFromMaplist"/>
                              </xsl:if>
                              <xsl:call-template name="replace-extension">
                                <xsl:with-param name="filename" select="@copy-to"/>
                                <xsl:with-param name="extension" select="$OUTEXT"/>
                              </xsl:call-template>
                              <xsl:if test="not(contains(@copy-to, '#')) and contains(@href, '#')">
                                <xsl:value-of select="concat('#', substring-after(@href, '#'))"/>
                              </xsl:if>
                            </xsl:when>
                            <xsl:when
                              test="not(@scope = 'external') and (not(@format) or @format = 'dita' or @format = 'ditamap')">
                              <xsl:if test="not(@scope = 'external')">
                                <xsl:value-of select="$pathFromMaplist"/>
                              </xsl:if>
                              <xsl:call-template name="replace-extension">
                                <xsl:with-param name="filename" select="@href"/>
                                <xsl:with-param name="extension" select="$OUTEXT"/>
                              </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                              <!-- If non-DITA, keep the href as-is -->
                              <xsl:if test="not(@scope = 'external')">
                                <xsl:value-of select="$pathFromMaplist"/>
                              </xsl:if>
                              <xsl:value-of select="@href"/>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:attribute>
                        <xsl:if
                          test="@scope = 'external' or not(not(@format) or @format = 'dita' or @format = 'ditamap')">
                          <xsl:apply-templates select="." mode="external-link"/>
                        </xsl:if>
                        <xsl:value-of select="$title"/>
                      </a>
                      <xsl:if test="
                          descendant::*[contains(@class, ' map/topicref ')]
                          [not(@toc = 'no')]
                          [not(@processing-role = 'resource-only')]">
                        <!-- jdw 04-01-2022 Need to rewrite templates to use spans and 
                                            buttons at this level of the TOC.          -->
                        <ul>
                          <xsl:apply-templates select="*[contains(@class, ' map/topicref ')]"
                            mode="toc">
                            <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
                          </xsl:apply-templates>
                        </ul>
                      </xsl:if>
                    </div>
                  </div>
                </xsl:when>
                <xsl:otherwise>
                  <a>
                    <xsl:attribute name="href">
                      <xsl:choose>
                        <xsl:when test="
                            @copy-to and not(contains(@chunk, 'to-content')) and
                            (not(@format) or @format = 'dita' or @format = 'ditamap')">
                          <xsl:if test="not(@scope = 'external')">
                            <xsl:value-of select="$pathFromMaplist"/>
                          </xsl:if>
                          <xsl:call-template name="replace-extension">
                            <xsl:with-param name="filename" select="@copy-to"/>
                            <xsl:with-param name="extension" select="$OUTEXT"/>
                          </xsl:call-template>
                          <xsl:if test="not(contains(@copy-to, '#')) and contains(@href, '#')">
                            <xsl:value-of select="concat('#', substring-after(@href, '#'))"/>
                          </xsl:if>
                        </xsl:when>
                        <xsl:when
                          test="not(@scope = 'external') and (not(@format) or @format = 'dita' or @format = 'ditamap')">
                          <xsl:if test="not(@scope = 'external')">
                            <xsl:value-of select="$pathFromMaplist"/>
                          </xsl:if>
                          <xsl:call-template name="replace-extension">
                            <xsl:with-param name="filename" select="@href"/>
                            <xsl:with-param name="extension" select="$OUTEXT"/>
                          </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                          <!-- If non-DITA, keep the href as-is -->
                          <xsl:if test="not(@scope = 'external')">
                            <xsl:value-of select="$pathFromMaplist"/>
                          </xsl:if>
                          <xsl:value-of select="@href"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:attribute>
                    <xsl:if
                      test="@scope = 'external' or not(not(@format) or @format = 'dita' or @format = 'ditamap')">
                      <xsl:apply-templates select="." mode="external-link"/>
                    </xsl:if>
                    <xsl:value-of select="$title"/>
                  </a>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$title"/>
            </xsl:otherwise>
          </xsl:choose>
        </li>
      </xsl:when>
      <xsl:otherwise>
        <!-- if it is an empty topicref -->
        <xsl:apply-templates select="*[contains(@class, ' map/topicref ')]" mode="toc">
          <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ================================================================================= -->
  <!-- jdw 04-18-2022 This is an override of the same template in topic.xsl so we can add
                      the viewport metadata for Bootstrap.                               -->

  <xsl:template name="chapterHead">
    <xsl:apply-templates select="." mode="chapterHead"/>
  </xsl:template>
  <xsl:template match="*" mode="chapterHead">
    <head>
      <!-- initial meta information -->
      <xsl:call-template name="generateCharset"/>   <!-- Set the character set to UTF-8 -->
      <!-- jdw 04-18-2022 Viewport for Bootstrap. -->
      <meta name="viewport" content="width=device-width, initial-scale=1"/>
      <meta name="build" content="{current-date()}, {current-time()}"/>
      <xsl:apply-templates select="." mode="generateDefaultCopyright"/> <!-- Generate a default copyright, if needed -->
      <xsl:apply-templates select="." mode="getMeta"/> <!-- Process metadata from topic prolog -->
      <xsl:call-template name="copyright"/>         <!-- Generate copyright, if specified manually -->
      <xsl:call-template name="generateChapterTitle"/> <!-- Generate the <title> element -->
      <xsl:call-template name="gen-user-head" />    <!-- include user's XSL HEAD processing here -->
      <xsl:call-template name="gen-user-scripts" /> <!-- include user's XSL javascripts here -->
      <xsl:call-template name="gen-user-styles" />  <!-- include user's XSL style element and content here -->
      <xsl:call-template name="processHDF"/>        <!-- Add user HDF file, if specified -->
      <xsl:call-template name="generateCssLinks"/>  <!-- Generate links to CSS files -->
    </head>
  </xsl:template>

  <!-- ================================================================================= -->
  <!-- jdw 04-01-2022 The following is the landing page content. In a DITA authoring 
                      environment, the content could be drawn from metadata in the map. 
                      Even in the current authoring environment, when the need or 
                      opportunity arises, the info in the Word document could be 
                      styled, the tag map revised to produce map metadata, and the 
                      metadata pulled into this template.                               -->

  <xsl:template match="*[contains(@class, ' map/map ')]" mode="chapterBody">
    <body>
      <div class="container-fluid mt-3">
      <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/@style"
        mode="add-ditaval-style"/>
      <xsl:if test="@outputclass">
        <xsl:attribute name="class" select="@outputclass"/>
      </xsl:if>
      <xsl:apply-templates select="." mode="addAttributesToBody"/>
      <xsl:call-template name="setidaname"/>
      <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]"
        mode="out-of-line"/>
      <xsl:if test="$INDEXSHOW = 'yes'">
        <xsl:apply-templates
          select="/*/*[contains(@class, ' map/topicmeta ')]/*[contains(@class, ' topic/keywords ')]/*[contains(@class, ' topic/indexterm ')]"
        />
      </xsl:if>
      <xsl:variable name="map" as="element()*">
        <xsl:apply-templates select="." mode="normalize-map"/>
      </xsl:variable>
<!-- ============================================================= -->
<!-- jdw 04-11-2022 Adding header verbatim from imom/dita2html xsl -->
<!-- jdw 06-09-2022  -->
      <header>
        <nav class="navbar navbar-expand-lg navbar-light">
          <div class="container-fluid">
            <!--<a class="navbar-brand" href="https://devnde.disne.local/">NKMEP</a>-->
            <a class="navbar-brand" href="{$PATH2PROJ}..">
              <img src="./include/NKMEP-Logo1-300dpi.png" class="nav-logo" alt="Go to NKMEP"/>
            </a>
            <xsl:comment>
              <xsl:text>'$WORKDIR' = </xsl:text><xsl:value-of select="concat($PATH2PROJ, '..')"/>
            </xsl:comment>
            <button
            class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent"
            aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
              <span
              class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarSupportedContent">
              <!-- search form -->
<!--              <form class="d-flex imom-search" action="{$PATH2PROJ}../search.php" method="get" name="">-->
              <form action="{$PATH2PROJ}../search.php" method="get" class="form-inline d-flex imom-search">
                <input id="nkmepSearch" 
                  class="form-control me-2" 
                  type="search" 
                  name="k"
                  placeholder="Search"
                  aria-label="Search"/>
                <button class="nkmepSearchButton" type="submit" data-bs-toggle="tooltip" data-bs-placement="top" title="Search the repository">
                  <img src="include/PrettyMagnifyingGlass-BlueHandle.svg" 
                    alt="Search Respository" />
                </button>
              </form>
              <!--</form>-->
              <!-- print form -->
<!--              <form class="d-flex imom-print">
                <button id="imom-print-button"
                  class="btn" 
                  type="button">Print</button>
              </form>-->
              <form class="form-inline d-flex imom-print">
                <button id="imom-print-button" data-bs-toggle="tooltip" data-bs-placement="top" title="Print this page"
                  class="nkmepPrintButton" type="button">
                  <img src="include/PrintIcon-GrayBlue-Darker.svg"
                    alt="Print this page"/>
                </button>
              </form>
            </div>
            <div id="feedback-link">
              <p>We're always looking to improve our process and the quality of our content. Got an idea?
                Let us know!</p>
              <a href="feedback-survey.php" target="_blank">Provide Feedback</a><br />
              <img src="include/stylizedUnderline-3.svg" width="150" height="auto"/>
            </div>
          </div>
        </nav>
      </header>
<!-- ============================================================= -->
      <div id="content" class="container-fluid">
        <div class="row">
        <!-- jdw 03-31-2022 This is where the nav gets inserted into the page -->
        <xsl:apply-templates select="$map" mode="imom-toc"/>
        <!-- jdw 03-31-2022 This is where the bootstrap divs should begin -->
        <main class="col" id="printarea">
          <!-- jdw 08-04-2022 Working on getting Word doc info into map -->

          <article class="cover">
            <xsl:attribute name="aria-labelledby">imom-map-title</xsl:attribute>
            <div class="body cover">
              <h1 id="imom-map-title" class="title topictitle1">
                <xsl:value-of select="booktitle/mainbooktitle"/>
              </h1>
                <xsl:apply-templates mode="doc-info" select="bookmeta"/>
              </div>
            <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]"
              mode="out-of-line"/>
          </article>
          <!-- ======================================================== -->
        </main>
      </div>
      </div>
      <footer>
        <div>
          <script src="js/jquery-3.6.0.min.js"/>
          <script src="js/bootstrap.bundle.js"/>
          <script src="js/imom-print.js"/>
        </div>
      </footer>
      </div>
    </body>
  </xsl:template>

</xsl:stylesheet>
