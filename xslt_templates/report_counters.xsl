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
	<xsl:template match="DATA/COUNTERS">
		<table class="table table-bordered table-hover">
			<thead>
				<tr>
					<th rowspan="2">АЗС</th>
					<th colspan="4">Смена</th>
					<th rowspan="2">Топливо</th>
					<th rowspan="2">ТРК</th>
					<th colspan="2">Показания счётчиков</th>
					<th rowspan="2">Отпущено по счётчикам</th>
				</tr>
				<tr>
					<th>№</th>
					<th>Оператор</th>
					<th>Начало</th>
					<th>Конец</th>
					<th>На начало</th>
					<th>На конец</th>
				</tr>
			</thead>
			<tbody>
				<xsl:apply-templates/>
			</tbody>
		</table>
	</xsl:template>
	<xsl:template match="DATA/COUNTERS/AZS">
		<tr class="data_group3">
			<td colspan="10">
				<xsl:value-of select="@NAME"/>
			</td>
		</tr>
		<xsl:apply-templates select="SESSION"/>
	</xsl:template>
	<xsl:template match="DATA/COUNTERS/AZS/SESSION">
		<tr class="data_group2">
			<td/>
			<td>
				<xsl:value-of select="@NUM"/>
			</td>
			<td>
				<xsl:value-of select="@NAME"/>
			</td>
			<td>
				<xsl:call-template name="DateTimeToStr">
					<xsl:with-param name="datetime" select="@DT1"/>
				</xsl:call-template>
			</td>
			<td>
				<xsl:call-template name="DateTimeToStr">
					<xsl:with-param name="datetime" select="@DT2"/>
				</xsl:call-template>
			</td>
			<td colspan="5"/>
		</tr>
		<xsl:apply-templates select="TOV"/>
	</xsl:template>
	<xsl:template match="DATA/COUNTERS/AZS/SESSION/TOV">
		<tr class="data_group1">
			<td colspan="5"/>
			<td colspan="4">
				<xsl:value-of select="@NAME"/>
			</td>
			<td align="right" class="qty">
				<xsl:value-of select="format-number((sum(NOZZLE/@COUNTER2))-(sum(NOZZLE/@COUNTER1)), $qty_mask)"/>
			</td>
		</tr>
		<xsl:apply-templates select="NOZZLE"/>
	</xsl:template>
	<xsl:template match="DATA/COUNTERS/AZS/SESSION/TOV/NOZZLE">
		<tr class="data_group0">
			<td colspan="6"/>
			<td>
				<xsl:value-of select="@TRK_NUM"/>
			</td>
			<td class="qty">
				<xsl:value-of select="format-number(@COUNTER1, $qty_mask)"/>
			</td>
			<td class="qty">
				<xsl:value-of select="format-number(@COUNTER2, $qty_mask)"/>
			</td>
			<td class="qty">
				<xsl:value-of select="format-number((@COUNTER2)-(@COUNTER1), $qty_mask)"/>
			</td>
		</tr>
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
	<xsl:template name="DateTimeToStr">
		<xsl:param name="datetime"/>
		<xsl:value-of select ="substring($datetime,9,2)"/>
		<xsl:text>.</xsl:text>
		<xsl:value-of select ="substring($datetime,6,2)"/>
		<xsl:text>.</xsl:text>
		<xsl:value-of select ="substring($datetime,1,4)"/>
		<xsl:text></xsl:text>
		<xsl:value-of select ="substring($datetime,12,2)"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select ="substring($datetime,15,2)"/>
	</xsl:template>

</xsl:stylesheet>
