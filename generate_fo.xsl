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
					<xsl:when test="/nascar_data/error != ''">
							<fo:flow flow-name="xsl-region-body">
								<fo:block line-height="14pt" font-size="10pt"><xsl:value-of select="/nascar_data/error"/></fo:block>
							</fo:flow>
					</xsl:when>
					<xsl:otherwise>
						<fo:static-content flow-name="xsl-region-before">
							<fo:block line-height="14pt" font-size="10pt" text-align="end">TPE 2024 1Q - Grupo 13</fo:block>
						</fo:static-content>

						<fo:flow flow-name="xsl-region-body">
							<fo:block space-before.optimum="14pt" space-after.optimum="14pt">
								Drivers for <xsl:value-of select="/nascar_data/serie_type"/> for <xsl:value-of select="/nascar_data/year"/> season
							</fo:block>

							<fo:table table-layout="fixed" width="100%">
								<fo:table-column column-width="15%"/>
								<fo:table-column column-width="15%"/>
								<fo:table-column column-width="10%"/>
								<fo:table-column column-width="15%"/>
								<fo:table-column column-width="15%"/>
								<fo:table-column column-width="10%"/>
								<fo:table-column column-width="10%"/>
								<fo:table-column column-width="10%"/>
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
									</fo:table-row>

					  <xsl:for-each select="/nascar_data/drivers/driver">
					  	<xsl:sort select="number(rank)"/>
						<xsl:if test="rank != '' and rank &lt;= 10">
							<xsl:variable name="color">
							 	<xsl:choose>
									<xsl:when test="rank &lt;= 3">
										<xsl:text>lime</xsl:text>
									</xsl:when>
									<xsl:when test="rank &lt;= 6">
										<xsl:text>blue</xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>red</xsl:text>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable> 
							<fo:table-row background-color="{$color}">
							  	<fo:table-cell><fo:block font-size="8pt" text-align="center"><xsl:value-of select="full_name"/></fo:block></fo:table-cell>
							  	<fo:table-cell><fo:block font-size="8pt" text-align="center"><xsl:value-of select="concat(upper-case(substring(country, 1, 1)),lower-case(substring(country,2)))"/></fo:block></fo:table-cell>
							  	<fo:table-cell><fo:block font-size="8pt" text-align="center"><xsl:value-of select="birth_date"/></fo:block></fo:table-cell>
							  	<fo:table-cell><fo:block font-size="8pt" text-align="center"><xsl:value-of select="birth_place"/></fo:block></fo:table-cell>
							  	<xsl:choose>
									<xsl:when test="car != ''">
									  <fo:table-cell><fo:block font-size="8pt" text-align="center"><xsl:value-of select="car"/></fo:block></fo:table-cell>
									</xsl:when>
									<xsl:otherwise>
									  <fo:table-cell><fo:block font-size="8pt" text-align="center">-</fo:block></fo:table-cell>
									</xsl:otherwise>
							 	</xsl:choose>
								<fo:table-cell><fo:block  font-size="8pt" text-align="center"><xsl:value-of select="rank"/></fo:block></fo:table-cell>
							 	<fo:table-cell><fo:block font-size="8pt" text-align="center"><xsl:value-of select="statistics/season_points"/></fo:block></fo:table-cell>
							  	<fo:table-cell><fo:block font-size="8pt" text-align="center"><xsl:value-of select="statistics/wins"/></fo:block></fo:table-cell>
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
