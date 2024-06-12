<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
    <xsl:output method="xml" indent="yes"/>

    <xsl:template match="/">
        <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
            <fo:layout-master-set>
                <fo:simple-page-master master-name="A4" page-height="29.7cm" page-width="21cm" margin-top="1cm" margin-bottom="2cm" margin-left="1.5cm" margin-right="1.5cm">
                    <fo:region-body margin-top="1cm"/>
                    <fo:region-before region-name="xsl-region-before" extent="1cm"/>
                    <fo:region-after extent="1.5cm"/>
                </fo:simple-page-master>
            </fo:layout-master-set>

            <fo:page-sequence master-reference="A4">
				<xsl:choose>
					<xsl:when test="error/@error != ''">
						<fo:block line-height="14pt" font-size="10pt"><xsl:value-of select="/nascar_data/error/@error"/></fo:block>
					</xsl:when>
					<xsl:otherwise>
						<fo:static-content flow-name="xsl-region-before">
							<fo:block line-height="14pt" font-size="10pt" text-align="end">TPE 2024 1Q - Grupo 13</fo:block>
						</fo:static-content>

						<fo:flow flow-name="xsl-region-body">
							<fo:block space-before.optimum="15pt" space-after.optimum="15pt">
								Drivers for <xsl:value-of select="/nascar_data/serie_type/@name"/> for <xsl:value-of select="/nascar_data/year/@year"/> season
							</fo:block>

							<fo:table table-layout="fixed" width="100%">
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
								<fo:table-body border-width="1pt" border-style="solid">
									<fo:table-row background-color="rgb(215,245,250)">
										<fo:table-cell><fo:block font-size="8pt" text-align="center">Name</fo:block></fo:table-cell>
										<fo:table-cell><fo:block font-size="8pt" text-align="center">Country</fo:block></fo:table-cell>
										<fo:table-cell><fo:block font-size="8pt" text-align="center">Birth date</fo:block></fo:table-cell>
										<fo:table-cell><fo:block font-size="8pt" text-align="center">Birth place</fo:block></fo:table-cell>
										<fo:table-cell><fo:block font-size="8pt" text-align="center">Car manufacturer</fo:block></fo:table-cell>
										<fo:table-cell><fo:block font-size="8pt" text-align="center">Rank</fo:block></fo:table-cell>
										<fo:table-cell><fo:block font-size="8pt" text-align="center">Season points</fo:block></fo:table-cell>
										<fo:table-cell><fo:block font-size="8pt" text-align="center">Wins</fo:block></fo:table-cell>
										<fo:table-cell><fo:block font-size="8pt" text-align="center">Poles</fo:block></fo:table-cell>
										<fo:table-cell><fo:block font-size="8pt" text-align="center">Unfinished races</fo:block></fo:table-cell>
										<fo:table-cell><fo:block font-size="8pt" text-align="center">Completed laps</fo:block></fo:table-cell>
									</fo:table-row>

					  <xsl:for-each select="/nascar_data/drivers/driver">
						<xsl:if test="rank/@rank != ''">
							<fo:table-row>
							  <fo:table-cell><fo:block font-size="8pt" text-align="center"><xsl:value-of select="full_name/@full_name"/></fo:block></fo:table-cell>
							  <fo:table-cell><fo:block font-size="8pt" text-align="center"><xsl:value-of select="concat(upper-case(substring(country/@country, 1, 1)),lower-case(substring(country/@country,2)))"/></fo:block></fo:table-cell>
							  <fo:table-cell><fo:block font-size="8pt" text-align="center"><xsl:value-of select="birth_date/@birthday"/></fo:block></fo:table-cell>
							  <fo:table-cell><fo:block font-size="8pt" text-align="center"><xsl:value-of select="birth_place/@birth_place"/></fo:block></fo:table-cell>
							  <xsl:choose>
								<xsl:when test="car/@name != ''">
								  <fo:table-cell><fo:block font-size="8pt" text-align="center"><xsl:value-of select="car/@name"/></fo:block></fo:table-cell>
								</xsl:when>
								<xsl:otherwise>
								  <fo:table-cell><fo:block font-size="8pt" text-align="center">-</fo:block></fo:table-cell>
								</xsl:otherwise>
							  </xsl:choose>
							  
							  <xsl:variable name="rank" select="rank/@rank"/>
							  <xsl:choose>
								<xsl:when test="$rank &lt; 4">
								  <fo:table-cell><fo:block color="green" font-size="8pt" text-align="center"><xsl:value-of select="rank/@rank"/></fo:block></fo:table-cell>
								</xsl:when>
								<xsl:otherwise>
								  <fo:table-cell><fo:block color="black" font-size="8pt" text-align="center"><xsl:value-of select="rank/@rank"/></fo:block></fo:table-cell>
								</xsl:otherwise>
							  </xsl:choose>
							  <fo:table-cell><fo:block font-size="8pt" text-align="center"><xsl:value-of select="statistics/season_points/@points"/></fo:block></fo:table-cell>
							  <fo:table-cell><fo:block font-size="8pt" text-align="center"><xsl:value-of select="statistics/wins/@wins"/></fo:block></fo:table-cell>
							  <fo:table-cell><fo:block font-size="8pt" text-align="center"><xsl:value-of select="statistics/poles/@poles"/></fo:block></fo:table-cell>
							  <fo:table-cell><fo:block font-size="8pt" text-align="center"><xsl:value-of select="statistics/races_not_finished/@dnf"/></fo:block></fo:table-cell>
							  <fo:table-cell><fo:block font-size="8pt" text-align="center"><xsl:value-of select="statistics/laps_completed/@laps_completed"/></fo:block></fo:table-cell>
							</fo:table-row>
						</xsl:if>
					  </xsl:for-each>
					</fo:table-body>
				  </fo:table>
				</fo:flow>
			</xsl:otherwise>
		</xsl:choose>
      </fo:page-sequence>
    </fo:root>
  </xsl:template>
</xsl:stylesheet>
