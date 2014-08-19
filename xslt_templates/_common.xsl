<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" encoding="utf-8" indent="no" />
	<xsl:decimal-format decimal-separator = "," NaN = "" grouping-separator=" "/>
	<xsl:variable name="qty_mask" select="'# ##0,00'"/>
	<xsl:variable name="money_mask" select="'# ##0,00'"/>
	<xsl:variable name="prcnt_mask" select="'0'"/>
	<xsl:variable name="simple_mask" select="'# ##0,0'"/>
	<xsl:template name="data_cell">
		<xsl:param name="value"/>
		<xsl:param name="format_mask" select="$money_mask"/>
		<xsl:if test="$value">
			<xsl:value-of select="format-number($value, $format_mask)"/>
		</xsl:if>

	</xsl:template>
	<xsl:template name="a">
		<xsl:param name="text"/>
		<xsl:param name="href"/>
		<xsl:param name="title"/>
		<xsl:param name="active" select="true"/>
		<xsl:choose>
			<xsl:when test="$active">
				<a href="{normalize-space($href)}" title="{$title}">
					<xsl:value-of select="$text"/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>
</xsl:stylesheet>
