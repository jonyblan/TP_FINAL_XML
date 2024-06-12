<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
    <xsl:output method="xml" indent="yes"/>

    <xsl:template match="/">
        <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
            <fo:layout-master-set>
                <fo:simple-page-master master-name="A4" page-height="29.7cm" page-width="21cm" margin-top="1cm" margin-bottom="2cm" margin-left="1.5cm" margin-right="1.5cm">
                    <fo:region-body />
                    <fo:region-before region-name="xsl-region-before" extent="2cm"/>
                    <!-- Otras regiones si es necesario -->
                </fo:simple-page-master>
            </fo:layout-master-set>

            <fo:page-sequence master-reference="A4">
                <fo:static-content flow-name="xsl-region-before">
                    <fo:block font-size="10pt">TPE 2024 1Q - Grupo XX</fo:block>
                </fo:static-content>

                <fo:flow flow-name="xsl-region-body">
                    <fo:block font-size="14pt">
                        Drivers for <xsl:value-of select="/nascar_data/serie_type"/> for <xsl:value-of select="/nascar_data/year"/> season
                    </fo:block>

                    <fo:table table-layout="fixed" width="100%" border="1pt solid black" font-size="8pt">
                        <fo:table-column column-width="14%"/>
                        <fo:table-column column-width="10%"/>
                        <fo:table-column column-width="10%"/>
                        <fo:table-column column-width="14%"/>
                        <fo:table-column column-width="9%"/>
                        <fo:table-column column-width="8%"/>
                        <fo:table-column column-width="7%"/>
                        <fo:table-column column-width="7%"/>
                        <fo:table-column column-width="7%"/>
                        <fo:table-column column-width="8%"/>
                        <fo:table-column column-width="8%"/>

                        <fo:table-header background-color="rgb(215,245,250)">
                            <fo:table-row>
                                <fo:table-cell><fo:block>Name</fo:block></fo:table-cell>
                                <fo:table-cell><fo:block>Country</fo:block></fo:table-cell>
                                <fo:table-cell><fo:block>Birth date</fo:block></fo:table-cell>
                                <fo:table-cell><fo:block>Birth place</fo:block></fo:table-cell>
                                <fo:table-cell><fo:block>Car manufacturer</fo:block></fo:table-cell>
                                <fo:table-cell><fo:block>Rank</fo:block></fo:table-cell>
                                <fo:table-cell><fo:block>Season points</fo:block></fo:table-cell>
                                <fo:table-cell><fo:block>Wins</fo:block></fo:table-cell>
                                <fo:table-cell><fo:block>Poles</fo:block></fo:table-cell>
                                <fo:table-cell><fo:block>Unfinished races</fo:block></fo:table-cell>
                                <fo:table-cell><fo:block>Completed laps</fo:block></fo:table-cell>
                            </fo:table-row>
                        </fo:table-header>

            <fo:table-body>
              <xsl:for-each select="/nascar_data/drivers/driver">
                <fo:table-row>
                  <fo:table-cell><fo:block><xsl:value-of select="full_name/@full_name"/></fo:block></fo:table-cell>
                  <fo:table-cell><fo:block><xsl:value-of select="concat(substring(country/@country, 1, 1),lower-case(substring(country/@country,2)))"/></fo:block></fo:table-cell>
                  <fo:table-cell><fo:block><xsl:value-of select="birth_date/@birthday"/></fo:block></fo:table-cell>
                  <fo:table-cell><fo:block><xsl:value-of select="birth_place/@birth_place"/></fo:block></fo:table-cell>
                  <fo:table-cell><fo:block><xsl:value-of select="car/@name"/></fo:block></fo:table-cell>
                  <fo:table-cell><fo:block color="{if (statistics/rank &lt;= 3) then 'green' else 'black'}"><xsl:value-of select="statistics/rank"/></fo:block></fo:table-cell>
                  <fo:table-cell><fo:block><xsl:value-of select="statistics/season_points/@points"/></fo:block></fo:table-cell>
                  <fo:table-cell><fo:block><xsl:value-of select="statistics/wins/@wins"/></fo:block></fo:table-cell>
                  <fo:table-cell><fo:block><xsl:value-of select="statistics/poles/@poles"/></fo:block></fo:table-cell>
                  <fo:table-cell><fo:block><xsl:value-of select="statistics/races_not_finished/@dnf"/></fo:block></fo:table-cell>
                  <fo:table-cell><fo:block><xsl:value-of select="statistics/laps_completed/@laps_completed"/></fo:block></fo:table-cell>
                </fo:table-row>
              </xsl:for-each>
            </fo:table-body>
          </fo:table>
        </fo:flow>
      </fo:page-sequence>
    </fo:root>
  </xsl:template>
</xsl:stylesheet>
