<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" encoding="utf-8" indent="no" />
  <xsl:decimal-format decimal-separator = "," NaN = "" grouping-separator=" "/>

  <xsl:variable name="qty_mask" select="'# ##0,00'"/>
  <xsl:variable name="money_mask" select="'# ##0,00'"/>
  <xsl:variable name="prcnt_mask" select="'0'"/>
  <xsl:variable name="simple_mask" select="'# ##0,0'"/>
  <xsl:variable name="report" select="DATA/@REPORT"/>
  <xsl:variable name="tov_count" select="count(DATA/PRICES/COLUMNS/TOV)"/>
  <xsl:variable name="sk_exists" select="SALES/AZS/TOV/CASHFORM/@SK"/>

  <xsl:variable name="period" select="string(DATA/@PERIOD)"/>
  <xsl:variable name="IsDrillThrough" select="DATA/@VIEW='drillthrough'"/>

  	
  <xsl:template match="/DATA/SALES">
    <xsl:variable name="measure_count" select="3"/>
    <xsl:variable name="cashform_count" select="count(CASHFORMS/CASHFORM)"/>

    <table class="table table-bordered">
      <thead>
        <tr>
          <th rowspan="3">Наименование</th>
          <th rowspan="3">Цена</th>
          <th colspan="{$cashform_count*($measure_count - 1)+1}">Форма оплаты</th>
          <xsl:if test="$cashform_count>1">
            <th rowspan="2" colspan="{$measure_count - 1}">
              Итого
            </th>
          </xsl:if>
        </tr>
        <tr>
          <xsl:for-each select="CASHFORMS/CASHFORM">
            <xsl:variable name="cash_colspan">
              <xsl:choose>
                <xsl:when test="@ID=2 and $sk_exists">3</xsl:when>
                <xsl:otherwise>2</xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <th colspan="{$cash_colspan}">
              <a href="javascript:cashformid='{@ID}';RefreshReport();" title="Кликните для того, чтобы отфильтровать отчёт по {@NAME}" style="color:inherit">
                <xsl:value-of select="@NAME"/>
              </a>
            </th>
          </xsl:for-each>
        </tr>
        <tr>
          <xsl:for-each select="(CASHFORMS/CASHFORM)|(CASHFORMS[$cashform_count>1])">
            <xsl:sort select="not(boolean(@ID))"/>
            <xsl:sort select="@ID"/>

            <th title="{@ID}">Продано, л</th>
            <xsl:if test="@ID=2 and $sk_exists">
              <th>Округление</th>
            </xsl:if>
            <th>Продано, сумма</th>
          </xsl:for-each>
        </tr>
        <xsl:if test="not(/DATA/@AZS_ID)">
          <xsl:call-template name="sales_row"/>
        </xsl:if>
      </thead>
      <tbody>
        <xsl:apply-templates/>
        <xsl:if test="not(/DATA/@AZS_ID)">
          <xsl:call-template name="sales_row"/>
        </xsl:if>
      </tbody>
    </table>

  </xsl:template>

  <xsl:template match="/DATA/SALES/AZS">
    <xsl:call-template name="sales_row"/>
    <xsl:apply-templates select="TOV"/>
  </xsl:template>

  <xsl:template match="/DATA/SALES/AZS/TOV">
    <xsl:call-template name="sales_row"/>
  </xsl:template>

  <xsl:template match="/DATA/STRINGS"/>

  <xsl:template name="sales_row">
    <xsl:variable name="row_level" select="count(ancestor::*)"/>
    <xsl:variable name="tovId" select="self::node()[$row_level=3]/@ID"/>
    <xsl:variable name="azsId" select="(self::node()[$row_level=2]|parent::node()[$row_level=3])/@ID"/>

    <tr class="row{$row_level}">
      <td>
        <xsl:if test="not(@PRICE)">
          <xsl:attribute name="colspan">2</xsl:attribute>
        </xsl:if>

        <xsl:choose>
          <xsl:when test="$row_level=1">
            Итого:
          </xsl:when>
          <xsl:otherwise>
            <xsl:variable name="azsFilter">
              <xsl:if test="not($tovId)">
                <xsl:value-of select="$azsId"/>
              </xsl:if>
            </xsl:variable>
            <a href="javascript:tovid='{$tovId}';azsid='{$azsFilter}';RefreshReport();" title="Кликните для того, чтобы отфильтровать отчёт по {@NAME}">
              <xsl:value-of select="@NAME"/>
            </a>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <xsl:if test="@PRICE">
        <td class="money">
          <xsl:value-of select="format-number(@PRICE, $money_mask)"/>
        </td>
      </xsl:if>

      <xsl:variable name="all_cashform_nodes" select=".//CASHFORM"/>

      <xsl:for-each select="(/DATA/SALES/CASHFORMS/CASHFORM)|(/DATA/SALES/CASHFORMS[count(CASHFORM)>1])">
        <xsl:sort select="not(boolean(@ID))"/>
        <xsl:sort select="@ID"/>

        <xsl:variable name="current_cashform_nodes" select="$all_cashform_nodes[(@ID=current()/@ID) or not(current()/@ID)]"/>

        <td class="qty">

          <xsl:call-template name="a">
            <xsl:with-param name="href">
              javascript:cashformid='<xsl:value-of select="@ID"/>';tovid='<xsl:value-of select="$tovId"/>';azsid='<xsl:value-of select="$azsId"/>';view='drillthrough';RefreshReport();
            </xsl:with-param>
            <xsl:with-param name="title">Кликните для просмотра деталировки по чекам</xsl:with-param>
            <xsl:with-param name="active" select="$row_level!=1"/>
            <xsl:with-param name="text">
              <xsl:call-template name="data_cell">
                <xsl:with-param name="value" select="sum($current_cashform_nodes/@QTY)"/>
                <xsl:with-param name="format_mask" select="$qty_mask"/>
              </xsl:call-template>
            </xsl:with-param>
          </xsl:call-template>
        </td>
        <xsl:if test="@ID=2 and $sk_exists">
          <td class="money">
            <xsl:call-template name="data_cell">
              <xsl:with-param name="value" select="sum($current_cashform_nodes/@SK)"/>
            </xsl:call-template>
          </td>
        </xsl:if>
        <td class="money">
          <xsl:call-template name="data_cell">
            <xsl:with-param name="value" select="sum($current_cashform_nodes/@PROD)"/>
            <xsl:with-param name="format_mask" select="$qty_mask"/>
          </xsl:call-template>
        </td>
      </xsl:for-each>
    </tr>
  </xsl:template>

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
