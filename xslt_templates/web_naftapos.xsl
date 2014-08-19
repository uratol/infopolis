<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common">
  <xsl:output method="html" encoding="utf-8" indent="no" />
  <xsl:decimal-format decimal-separator = "," NaN = "" grouping-separator=" "/>

  <xsl:variable name="qty_mask" select="'# ##0,00'"/>
  <xsl:variable name="money_mask" select="'# ##0,00'"/>
  <xsl:variable name="prcnt_mask" select="'0'"/>
  <xsl:variable name="simple_mask" select="'# ##0,0'"/>
  <xsl:variable name="report" select="DATA/@REPORT"/>
  <xsl:variable name="tov_count" select="count(DATA/PRICES/COLUMNS/TOV)"/>

  <xsl:variable name="period" select="string(DATA/@PERIOD)"/>
  <xsl:variable name="IsDrillThrough" select="DATA/@VIEW='drillthrough'"/>

  <xsl:template match="/">
    <style>
      td {padding:2px 3px; border-color:silver; font-family: sans-serif; color:#505050;}
      th {padding:2px 3px; text-align: center; font-weight: normal; font-family: sans-serif; background-color:#b0b0b0; white-space:normal; color:#ffffff
      ;border: 1px solid silver;
      }

      .report > * > tr > td {
      border: 1px solid silver;
      }

      .report {font-size:10pt;margin-left:10px; border-color: #fcfcfc; border-collapse:collapse;}

      .row1 {background-color:#b0b0b0;}
      .row2 {background-color:#d0d0d0;}
      .row3 {background-color:#ffffff;}
      a:link {color: #3388aa; text-decoration: none}
      a:visited {color: #3388aa; text-decoration: none}
      .qty {white-space:nowrap; text-align: right}
      .money {white-space:nowrap; text-align: right}
      .filterValue {color:#202080; font-size:8pt;}
      input {font-family: sans-serif}

      @media screen and (-ms-high-contrast: active), (-ms-high-contrast: none) {
      <!--стили только для IE10 -->
      .IE_invisible {display:none}
      }
    </style>
    <xsl:comment>[if IE]&gt; &lt;style&gt;.IE_invisible {display:none}&lt;/style&gt;&lt;![endif]</xsl:comment>

    <script language="javascript">
      var period='',tovid='',azsid='',tankid='',report='',cashformid='<xsl:value-of select="DATA/@CASHFORM_ID"/>',view='<xsl:value-of select="DATA/@VIEW"/>';


      function RefreshReport(){

      if ((period=='')|(period=='set')){
      if (('<xsl:value-of select="$period"/>'=='p')|(period=='set'))
      period=document.getElementById('dt1').value +' '+ document.getElementById('time1').value +'x'+document.getElementById('dt2').value +' '+ document.getElementById('time2').value
      else
      period='<xsl:value-of select="$period"/>';
      };

      if (period=='')
      period='d';

      if (report=='')
      report='<xsl:value-of select="DATA/@REPORT"/>';

      if (tovid=='')
      tovid='<xsl:value-of select="DATA/@TOV_ID"/>';

      if (azsid=='')
      azsid='<xsl:value-of select="DATA/@AZS_ID"/>';

      if (tankid=='')
      tankid='<xsl:value-of select="DATA/@TANK_ID"/>';


      var s = window.location.pathname+'?'+'report='+report;
      if(report!='prices' &amp;&amp; report!='tanks')
      s+= '&amp;period='+period;

      if (tovid!='' &amp;&amp; tovid!='0')
      s += '&amp;tovid='+tovid;

      if (azsid!='' &amp;&amp; azsid!='0')
      s += '&amp;azsid='+azsid;

      if (tankid!='' &amp;&amp; tankid!='0' &amp;&amp; report=='tank')
      s += '&amp;tankid='+tankid;

      if (cashformid!='' &amp;&amp; cashformid!='0')
      s += '&amp;cashform='+cashformid;

      if (view!='')
      s += '&amp;view='+view;

      document.location=s;
      }
    </script>

    <script>
      var tableToExcel = (function() {
      var uri = 'data:application/vnd.ms-excel;base64,'
      , template = '&lt;html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40">&lt;head>&lt;!--[if gte mso 9]>&lt;xml>&lt;x:ExcelWorkbook>&lt;x:ExcelWorksheets>&lt;x:ExcelWorksheet>&lt;x:Name>{worksheet}&lt;/x:Name>&lt;x:WorksheetOptions>&lt;x:DisplayGridlines/>&lt;/x:WorksheetOptions>&lt;/x:ExcelWorksheet>&lt;/x:ExcelWorksheets>&lt;/x:ExcelWorkbook>&lt;/xml>&lt;![endif]-->&lt;/head>&lt;body>&lt;table>{table}&lt;/table>&lt;/body>&lt;/html>'
      , base64 = function(s) { return window.btoa(unescape(encodeURIComponent(s))) }
      , format = function(s, c) { return s.replace(/{(\w+)}/g, function(m, p) { return c[p]; }) }
      return function(table, name) {
      if (!table.nodeType) table = document.getElementById(table);
      var TableInnerHTML = table.innerHTML;
      TableInnerHTML = TableInnerHTML.replace(/&lt;a\s/g,'&lt;span ');
      var ctx = {worksheet: name || 'Worksheet', table: TableInnerHTML};
      window.location.href = uri + base64(format(template, ctx))
      }
      })()
    </script>

    <table width="100%">
      <tr>
        <td valign="Top" width="150">

          <table border="0" style="white-space:nowrap;border-collapse:collapse;" width="100%">
            <xsl:if test="DATA/@CASHFORM_ID or DATA/@ERROR_MESSAGE or DATA/@AZS_ID or DATA/@TOV_ID or $IsDrillThrough">
              <tr bgcolor="#c0c0c0">
                <td colspan="2">
                  Фильтр
                </td>
              </tr>
              <xsl:if test="$IsDrillThrough">
                <tr title="Вернуться к итогам" onclick="view='';RefreshReport()" style="cursor:pointer">
                  <td>
                    <img src="App_Themes/infopolis/close.gif"/>
                  </td>
                  <td>
                    <div>
                      Деталировка по чекам
                    </div>
                  </td>
                </tr>
              </xsl:if>
              <xsl:if test="DATA/@AZS_ID">
                <tr onclick="azsid='0';RefreshReport()" title="Убрать фильтр по АЗС" style="cursor:pointer">
                  <td>
                    <img src="App_Themes/infopolis/close.gif"/>
                  </td>
                  <td>
                    <div>
                      АЗС
                    </div>
                    <div class="filterValue">
                      <xsl:value-of select="//AZS[@NAME][1]/@NAME"/>
                    </div>
                  </td>
                </tr>
              </xsl:if>
              <xsl:if test="DATA/@TOV_ID">
                <tr title="Убрать фильтр по товару" onclick="tovid='0';RefreshReport()" style="cursor:pointer">
                  <td>
                    <img src="App_Themes/infopolis/close.gif"/>
                  </td>
                  <td>
                    <div>
                      Товар
                    </div>
                    <div class="filterValue">
                      <xsl:value-of select="//TOV[@NAME][1]/@NAME"/>
                    </div>
                  </td>
                </tr>
              </xsl:if>
              <xsl:if test="DATA/@CASHFORM_ID">
                <tr title="Убрать фильтр по форме оплаты" onclick="cashformid='';RefreshReport()" style="cursor:pointer">
                  <td>
                    <img src="App_Themes/infopolis/close.gif"/>
                  </td>
                  <td>
                    <div>
                      Форма оплаты
                    </div>
                    <div class="filterValue">
                      <xsl:value-of select="//CASHFORM[@NAME][1]/@NAME"/>
                    </div>
                  </td>
                </tr>
              </xsl:if>
              <xsl:if test="DATA/@ERROR_MESSAGE">
                <tr>
                  <td>
                    <img src="App_Themes/infopolis/close.gif"/>
                  </td>
                  <td>
                    <div>
                      Ошибка
                    </div>
                    <div class="filterValue">
                      <xsl:value-of select="DATA/@ERROR_MESSAGE"/>
                    </div>
                  </td>
                </tr>
              </xsl:if>
            </xsl:if>

            <tr bgcolor="#c0c0c0">
              <td colspan="2">
                Меню
              </td>
            </tr>
            <tr>
              <td>
                <xsl:if test="DATA/@REPORT='sales'">
                  <img src="App_Themes/infopolis/check.gif"/>
                </xsl:if>
              </td>
              <td>
                <xsl:call-template name="a">
                  <xsl:with-param name="href">
                    javascript:report='sales';RefreshReport();
                  </xsl:with-param>
                  <xsl:with-param name="active" select="$report!='sales'"/>
                  <xsl:with-param name="text">
                    Продажи
                  </xsl:with-param>
                </xsl:call-template>
              </td>
            </tr>
            <tr>
              <td>
                <xsl:if test="DATA/@REPORT='counters'">
                  <img src="App_Themes/infopolis/check.gif"/>
                </xsl:if>
              </td>
              <td>
                <xsl:choose>
                  <xsl:when test="$report='counters'">Показания счётчиков</xsl:when>
                  <xsl:otherwise>
                    <a href="javascript:report='counters';RefreshReport();">
                      Показания счётчиков
                    </a>
                  </xsl:otherwise>
                </xsl:choose>
              </td>
            </tr>

            <tr>
              <td>
                <xsl:if test="DATA/@REPORT='prices'">
                  <img src="App_Themes/infopolis/check.gif"/>
                </xsl:if>
              </td>
              <td>
                <xsl:call-template name="a">
                  <xsl:with-param name="href">
                    javascript:report='prices';RefreshReport();
                  </xsl:with-param>
                  <xsl:with-param name="active" select="$report!='prices'"/>
                  <xsl:with-param name="text">
                    Управление ценами
                  </xsl:with-param>
                </xsl:call-template>
              </td>
            </tr>
            <tr>
              <td>
                <xsl:if test="DATA/@REPORT='sync'">
                  <img src="App_Themes/infopolis/check.gif"/>
                </xsl:if>
              </td>
              <td>
                <xsl:call-template name="a">
                  <xsl:with-param name="href">
                    javascript:report='sync';RefreshReport();
                  </xsl:with-param>
                  <xsl:with-param name="active" select="$report!='sync'"/>
                  <xsl:with-param name="text">
                    Синхронизация с АЗС
                  </xsl:with-param>
                </xsl:call-template>
              </td>
            </tr>
            <tr>
              <td>
                <xsl:if test="DATA/@REPORT='tank' or DATA/@REPORT='tanks'">
                  <img src="App_Themes/infopolis/check.gif"/>
                </xsl:if>
              </td>
              <td>
                <xsl:call-template name="a">
                  <xsl:with-param name="href">
                    javascript:report='tanks';RefreshReport();
                  </xsl:with-param>
                  <xsl:with-param name="active" select="$report!='tanks'"/>
                  <xsl:with-param name="text">
                    Контроль резервуаров
                  </xsl:with-param>
                </xsl:call-template>
              </td>
            </tr>
            <tr>
              <td>
              </td>
              <td style="color:#a0a0a0">
                Юстировка измерителей
              </td>
            </tr>

            <xsl:if test="$report!='tanks'">
              <tr class="IE_invisible">
                <td>
                </td>
                <td>
                  <a href="javascript:tableToExcel('ReportTable', 'InfoPos report')">Экспортировать в Excel</a>
                </td>
              </tr>
            </xsl:if>


            <xsl:if test="$report!='prices' and $report!='sync' and $report!='tanks'">
              <tr bgcolor="#c0c0c0">
                <td colspan="2">
                  Период
                </td>
              </tr>
              <xsl:call-template name="filterPeriod">
                <xsl:with-param name="xperiod" select="'p'"/>
              </xsl:call-template>
              <xsl:call-template name="filterPeriod">
                <xsl:with-param name="caption" select="'Сегодня'"/>
                <xsl:with-param name="xperiod" select="'d'"/>
              </xsl:call-template>
              <xsl:call-template name="filterPeriod">
                <xsl:with-param name="caption" select="'Вчера'"/>
                <xsl:with-param name="xperiod" select="'e'"/>
              </xsl:call-template>
              <xsl:call-template name="filterPeriod">
                <xsl:with-param name="caption" select="'За неделю'"/>
                <xsl:with-param name="xperiod" select="'w'"/>
              </xsl:call-template>
              <xsl:call-template name="filterPeriod">
                <xsl:with-param name="caption" select="'За месяц'"/>
                <xsl:with-param name="xperiod" select="'m'"/>
              </xsl:call-template>
            </xsl:if>
          </table>
        </td>
        <td valign="Top" align="Center">
          <!--REPORTS CONTENT-->
          <xsl:apply-templates/>
        </td>
        <td>
          <xsl:for-each select="DATA/CHARTS/CHART">
            <div id="chart_div{@NUM}"></div>
          </xsl:for-each>
          <xsl:apply-templates select="DATA/CHARTS"/>
        </td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template match="DATA[@VIEW='drillthrough']/SALES">
    <table border="1" class="report">
      <thead>
        <tr>
          <th>№ чека</th>
          <th>Время</th>
          <th>Наименование</th>
          <th>Кол-во</th>
          <th>Сумма</th>
          <th>Форма оплаты</th>
          <th>Сессия</th>
          <th>Оператор</th>
        </tr>
      </thead>
      <tbody>
        <tr class="row1">
          <td colspan="3">
            Итого:
          </td>
          <td class="qty">
            <xsl:call-template name="data_cell">
              <xsl:with-param name="value" select="sum(SALE/@QTY)"/>
              <xsl:with-param name="format_mask" select="$qty_mask"/>
            </xsl:call-template>
          </td>
          <td class="money">
            <xsl:call-template name="data_cell">
              <xsl:with-param name="value" select="sum(SALE/@PROD)"/>
            </xsl:call-template>
          </td>
          <td colspan="3"/>
        </tr>
      </tbody>
      <xsl:apply-templates select="SALE"/>
    </table>
  </xsl:template>
  <xsl:template match="DATA[@VIEW='drillthrough']/SALES/SALE">
    <tr>
      <td>
        <xsl:value-of select="@NUMNAK"/>
      </td>
      <td>
        <xsl:value-of select="@DT"/>
      </td>
      <td>
        <xsl:value-of select="@TOV_NM"/>
      </td>
      <td class="qty">
        <xsl:call-template name="data_cell">
          <xsl:with-param name="value" select="@QTY"/>
          <xsl:with-param name="format_mask" select="$qty_mask"/>
        </xsl:call-template>
      </td>
      <td class="money">
        <xsl:call-template name="data_cell">
          <xsl:with-param name="value" select="@PROD"/>
        </xsl:call-template>
      </td>
      <td>
        <xsl:value-of select="@CASHFORM_NM"/>
      </td>
      <td>
        <xsl:value-of select="@SESSION_NUM"/>
      </td>
      <td>
        <xsl:value-of select="@SESSION_OPERATOR"/>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="DATA[@VIEW!='drillthrough']/SALES">
    <xsl:variable name="measure_count" select="3"/>
    <xsl:variable name="cashform_count" select="count(CASHFORMS/CASHFORM)"/>

    <table border="1" class="report" id="ReportTable">
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
                <xsl:when test="@ID=2">3</xsl:when>
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
            <xsl:if test="@ID=2">
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

  <xsl:template match="DATA[@VIEW!='drillthrough']/SALES/AZS">
    <xsl:call-template name="sales_row"/>
    <xsl:apply-templates select="TOV"/>
  </xsl:template>

  <xsl:template match="DATA[@VIEW!='drillthrough']/SALES/AZS/TOV">
    <xsl:call-template name="sales_row"/>
  </xsl:template>

  <xsl:template name="filterPeriod">
    <xsl:param name="caption"/>
    <xsl:param name="xperiod"/>
    <tr>
      <td>
        <xsl:choose>
          <xsl:when test="string($xperiod)=$period">
            <img src="App_Themes/infopolis/check.gif"/>
          </xsl:when>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="string($xperiod)='p'">
            <div align="right">
              c <input type="date" id="dt1" value="{string(DATA/@SDT)}" max="2113-06-04" min="2012-01-01"/>
            </div>
            <div align="right">
              время <input type="time" id="time1" value="{string(DATA/@STIME)}"/>
            </div>
            <br/>
            <div align="right">
              по <input type="date" id="dt2" value="{string(DATA/@EDT)}" max="2113-06-04" min="2012-01-01"/>
            </div>
            <div align="right">
              время <input type="time" id="time2" value="{string(DATA/@ETIME)}"/>
            </div>
            <div align="right">
              <a href="javascript:period='set';RefreshReport();">
                применить
              </a>
            </div>
          </xsl:when>
          <xsl:when test="string($xperiod)=$period">
            <div>
              <xsl:value-of select="$caption"/>
            </div>
            <!--<div style="color:maroon; font-size:7pt;">
              <xsl:value-of select="DATA/@SDT"/>
              <xsl:if test="string(DATA/@SDT)!=string(DATA/@EDT)">
                -
                <xsl:value-of select="DATA/@EDT"/>
              </xsl:if>
            </div>-->
          </xsl:when>
          <xsl:otherwise>
            <a href="javascript:period='{$xperiod}';RefreshReport();">
              <xsl:value-of select="$caption"/>
            </a>
          </xsl:otherwise>
        </xsl:choose>
      </td>
    </tr>
  </xsl:template>


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
        <xsl:if test="@ID=2">
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

  <xsl:template match="DATA/CHARTS">
    <script type="text/javascript" src="https://www.google.com/jsapi"/>
    <script type="text/javascript">

      google.load('visualization', '1.0', {'packages':['corechart','table']});
      google.setOnLoadCallback(drawChart);
      function drawChart() {


      <xsl:for-each select="CHART">
        var data = new google.visualization.DataTable();

        <xsl:for-each select="COLUMNS/COLUMN">
          data.addColumn('<xsl:value-of select="@TYPE"/>', '<xsl:value-of select="@CAPTION"/>');
        </xsl:for-each>
        <xsl:variable name="ColumnCount" select="count(COLUMNS/COLUMN)"/>

        data.addRows([
        <xsl:for-each select="ROWS/ROW">
          <xsl:if test="position()!=1">,</xsl:if>
          [
          <xsl:variable name="row" select="."/>
          <xsl:for-each select="../../COLUMNS/COLUMN">
            <xsl:if test="position()!=1">,</xsl:if>
            <xsl:if test="@TYPE='string'">'</xsl:if>
            <xsl:variable name="value" select="$row/COL[@NUM=current()/@NUM]"/>
            <xsl:choose>
              <xsl:when test="$value">
                <xsl:value-of select="$value"/>
              </xsl:when>
              <xsl:otherwise>null</xsl:otherwise>
            </xsl:choose>
            <xsl:if test="@TYPE='string'">'</xsl:if>
          </xsl:for-each>
          ]
        </xsl:for-each>
        ]);

        var options = {title:'<xsl:value-of select="@NAME"/>'
        ,width:600
        ,height:300
        ,isStacked: true
        ,backgroundColor: 'transparent'
        <xsl:if test="@OPTIONS">
          ,<xsl:value-of select="@OPTIONS"/>
        </xsl:if>
        };
        <xsl:value-of select="@SCRIPT_CODE"/>
        var chart = new google.visualization.<xsl:value-of select="@TYPE"/>(document.getElementById('chart_div<xsl:value-of select="@NUM"/>'));
        chart.draw(data, options);
      </xsl:for-each>
      }
    </script>

  </xsl:template>

  <xsl:template match="DATA/COUNTERS">
    <table border="1" class="report" id="ReportTable">
      <tr bgcolor="#a0a0a0" style="white-space:normal" align="left">
        <th rowspan="2">АЗС</th>
        <th colspan="4">Смена</th>
        <th rowspan="2">Топливо</th>
        <th rowspan="2">ТРК</th>
        <th colspan="2">Показания счётчиков</th>
        <th rowspan="2">Отпущено по счётчикам</th>
      </tr>
      <tr bgcolor="#a0a0a0">
        <th>№</th>
        <th>Оператор</th>
        <th>Начало</th>
        <th>Конец</th>
        <th>На начало</th>
        <th>На конец</th>
      </tr>
      <xsl:apply-templates/>
    </table>
  </xsl:template>

  <xsl:template match="DATA/COUNTERS/AZS">
    <tr bgcolor="#b0b0b0">
      <td colspan="10">
        <a href="javascript:tovid='0';azsid='{@ID}';RefreshReport();">
          <b>
            <xsl:value-of select="@NAME"/>
          </b>
        </a>
      </td>
    </tr>
    <xsl:apply-templates select="SESSION"/>
  </xsl:template>

  <xsl:template match="DATA/COUNTERS/AZS/SESSION">
    <tr bgcolor="#d0d0d0">
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
    <tr bgcolor="#f0f0f0">
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
    <tr bgcolor="#ffffff">
      <td colspan="6"/>
      <td>
        <xsl:value-of select="@TRK_NUM"/>
      </td>
      <td align="right" class="qty">
        <xsl:value-of select="format-number(@COUNTER1, $qty_mask)"/>
      </td>
      <td align="right" class="qty">
        <xsl:value-of select="format-number(@COUNTER2, $qty_mask)"/>
      </td>
      <td align="right" class="qty">
        <xsl:value-of select="format-number((@COUNTER2)-(@COUNTER1), $qty_mask)"/>
      </td>
    </tr>
  </xsl:template>


  <xsl:template match="DATA/TANKS/AZS">
    <div style="text-align:left">
      <b>
        <xsl:value-of select="@NAME"/>
      </b>
      <div>
        <xsl:apply-templates/>
      </div>
    </div>
  </xsl:template>

  <xsl:variable name="tank_height" select="98"/>
  <xsl:variable name="tank_width" select="62"/>
  <xsl:variable name="tank_border_height" select="3"/>
  <xsl:variable name="tank_border_width" select="2"/>

  <xsl:template match="DATA/TANKS/AZS/TANK">
    <div style="float:left;margin-top:30px;margin-left:25px;">


      <xsl:variable name="water_height" select="round((VALUE[@NAME='OIL_WATER']/@VAL * ($tank_height - 2*$tank_border_height)) div @VOLUME)"/>
      <xsl:variable name="fuel_height" select="round((VALUE[@NAME='OIL_REMAINDER2']/@VAL * ($tank_height - 2*$tank_border_height)) div @VOLUME)"/>
      <xsl:variable name="book_height" select="round((@VOLUME_BOOK * ($tank_height - 2*$tank_border_height)) div @VOLUME)"/>


      <div style="float:left;">
        <table class="report" style="font-size:75%">
          <tr>
            <th colspan="4">
              <a href="javascript:report='tank';tankid='{@ID}';RefreshReport();" title="Кликните для отображения показаний за период">
                Резервуар № <xsl:value-of select="@NUM"/>, <xsl:value-of select="@TOV_NAME"/>
              </a>
            </th>
          </tr>
          <tr>
            <td rowspan="12" style="vertical-align:middle;padding:5px;">

              <xsl:variable name="tank_filling" select="(VALUE[@NAME='OIL_REMAINDER2']/@VAL div @VOLUME)*100"/>
              <div style="text-align:center; font-weight:bold;" title="% заполнения резервуара топливом">
                <xsl:call-template name="data_cell">
                  <xsl:with-param name="value" select="$tank_filling"/>
                  <xsl:with-param name="format_mask" select="$prcnt_mask"/>
                </xsl:call-template>
                %
              </div>

              <a href="javascript:report='tank';tankid='{@ID}';RefreshReport();">
                <div style="position:relative; height:{$tank_height}px; width:{$tank_width}px;" title="Кликните для отображения показаний за период">
                  <img src="tank_empty.png"/>

                  <div style="position:absolute; bottom:{$tank_border_height}px; left:{$tank_border_width}px">
                    <img src="tank_water.png" style="height:{$water_height}px; width:{$tank_width - $tank_border_width*2}px;"/>
                  </div>
                  <div style="position:absolute; bottom:{$tank_border_height+$water_height}px; left:{$tank_border_width}px">
                    <img src="tank_fuel.png" style="height:{$fuel_height}px; width:{$tank_width - $tank_border_width*2}px; left:{$tank_border_width}px"/>
                  </div>
                  <!--<div style="position:absolute; bottom:{$tank_border_height+$water_height+$book_height}px; left:{$tank_border_width}px">
                    <img src="tank_book.png" style="width:{$tank_width - $tank_border_width*2}px; left:{$tank_border_width}px"/>
                  </div>-->
                </div>
              </a>
              <div style="text-align:center; font-size:65%" title="Дата и время актуальности показаний">
                <xsl:call-template name="DateTimeToStr">
                  <xsl:with-param name="datetime" select="@DT"/>
                </xsl:call-template>
              </div>

            </td>
            <td>Объем топлива</td>
            <td class="qty">
              <xsl:call-template name="data_cell">
                <xsl:with-param name="value" select="VALUE[@NAME='OIL_REMAINDER2']/@VAL"/>
                <xsl:with-param name="format_mask" select="$simple_mask"/>
              </xsl:call-template>
            </td>
            <td>
              л
            </td>
          </tr>
          <tr>
            <td>Объем топлива учетный</td>
            <td class="qty">
              <xsl:call-template name="data_cell">
                <xsl:with-param name="value" select="@VOLUME_BOOK"/>
                <xsl:with-param name="format_mask" select="$simple_mask"/>
              </xsl:call-template>
            </td>
            <td>
              л
            </td>
          </tr>
          <tr>
            <xsl:variable name="volume_diff" select="@VOLUME_BOOK - VALUE[@NAME='OIL_REMAINDER2']/@VAL"/>
            <td>
              <xsl:choose>
                <xsl:when test="$volume_diff > 0">
                  Недостача
                </xsl:when>
                <xsl:otherwise>
                  Излишек
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td class="qty">
              <xsl:call-template name="data_cell">
                <xsl:with-param name="value" select="$volume_diff * (1 - 2*($volume_diff &lt; 0))"/>
                <xsl:with-param name="format_mask" select="$simple_mask"/>
              </xsl:call-template>
            </td>
            <td>
              л
            </td>
          </tr>
          <tr>
            <td>Объем резервуара</td>
            <td class="qty">
              <xsl:call-template name="data_cell">
                <xsl:with-param name="value" select="@VOLUME"/>
                <xsl:with-param name="format_mask" select="$simple_mask"/>
              </xsl:call-template>
            </td>
            <td>
              л
            </td>
          </tr>
          <tr>
            <td>Высота резервуара</td>
            <td class="qty">
              <xsl:call-template name="data_cell">
                <xsl:with-param name="value" select="@HEIGHT"/>
                <xsl:with-param name="format_mask" select="$simple_mask"/>
              </xsl:call-template>
            </td>
            <td>
              мм
            </td>
          </tr>
          <tr>
            <td>Уровень топлива</td>
            <td class="qty">
              <xsl:call-template name="data_cell">
                <xsl:with-param name="value" select="VALUE[@NAME='OIL_AMOUNTMM']/@VAL"/>
                <xsl:with-param name="format_mask" select="$simple_mask"/>
              </xsl:call-template>
            </td>
            <td>
              мм
            </td>
          </tr>
          <tr>
            <td>Уровень воды</td>
            <td class="qty">
              <xsl:call-template name="data_cell">
                <xsl:with-param name="value" select="VALUE[@NAME='OIL_WATERMM']/@VAL"/>
                <xsl:with-param name="format_mask" select="$simple_mask"/>
              </xsl:call-template>
            </td>
            <td>
              мм
            </td>
          </tr>
          <tr>
            <td>Объем воды</td>
            <td class="qty">
              <xsl:call-template name="data_cell">
                <xsl:with-param name="value" select="VALUE[@NAME='OIL_WATER']/@VAL"/>
                <xsl:with-param name="format_mask" select="$simple_mask"/>
              </xsl:call-template>
            </td>
            <td>
              л
            </td>
          </tr>
          <tr>
            <td>Температура</td>
            <td class="qty">
              <xsl:call-template name="data_cell">
                <xsl:with-param name="value" select="VALUE[@NAME='OIL_TEMP2']/@VAL"/>
                <xsl:with-param name="format_mask" select="$simple_mask"/>
              </xsl:call-template>
            </td>
            <td>
              °С
            </td>
          </tr>
          <tr>
            <td>Плотность топлива</td>
            <td class="qty">
              <xsl:call-template name="data_cell">
                <xsl:with-param name="value" select="VALUE[@NAME='OIL_DENSITY2']/@VAL"/>
                <xsl:with-param name="format_mask" select="$qty_mask"/>
              </xsl:call-template>
            </td>
            <td style="white-space:nowrap;">
              кг/л
            </td>
          </tr>
          <tr>
            <td>Масса топлива</td>
            <td class="qty">
              <xsl:call-template name="data_cell">
                <xsl:with-param name="value" select="VALUE[@NAME='OIL_DENSITY2']/@VAL * VALUE[@NAME='OIL_REMAINDER2']/@VAL"/>
                <xsl:with-param name="format_mask" select="$qty_mask"/>
              </xsl:call-template>
            </td>
            <td>
              кг
            </td>
          </tr>
          <tr>
            <td>Свободный объём</td>
            <td class="qty">
              <xsl:call-template name="data_cell">
                <xsl:with-param name="value" select="@VOLUME - VALUE[@NAME='OIL_REMAINDER2']/@VAL - VALUE[@NAME='OIL_WATER']/@VAL"/>
                <xsl:with-param name="format_mask" select="$simple_mask"/>
              </xsl:call-template>
            </td>
            <td>
              л
            </td>
          </tr>
        </table>
      </div>
    </div>
  </xsl:template>



  <xsl:template match="DATA/TANK">
    <table border="1" class="report" id="ReportTable">
      <tr bgcolor="#a0a0a0" style="white-space:normal" align="left">
        <th colspan="2">Резервуар</th>
        <th colspan="5">Чек</th>
        <th rowspan="2">Учетный остаток, л</th>
        <th colspan="4">Показатели датчиков</th>
      </tr>
      <tr bgcolor="#a0a0a0" style="white-space:normal" align="left">
        <th>№</th>
        <th>Топливо</th>
        <th>Смена</th>
        <th>№ чека</th>
        <th>Тип операции</th>
        <th>Время</th>
        <th>Объём, л</th>
        
        <th>Остаток, л</th>
        <th>Плотность</th>
        <th>Масса</th>
        <th>Температура</th>
      </tr>
      <xsl:apply-templates/>
    </table>
  </xsl:template>

  <xsl:template match="DATA/TANK/AZS">
    <tr bgcolor="#b0b0b0">
      <td colspan="12">
        <a href="javascript:tovid='0';azsid='{@ID}';RefreshReport();">
          <b>
            <xsl:value-of select="@NAME"/>
          </b>
        </a>
      </td>
    </tr>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="DATA/TANK/AZS/TANK">
    <tr bgcolor="#d0d0d0">
      <td>
        <xsl:value-of select="@NUM"/>
      </td>
      <td colspan="11">
        <xsl:value-of select="@TOV_NAME"/>
      </td>
    </tr>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="DATA/TANK/AZS/TANK/SESSION/SALE">
    <xsl:variable name="SaleCount" select="count(../SALE)"/>
    <tr bgcolor="#f0f0f0">
      <xsl:if test="@QTY > 0">
        <xsl:attribute name="style">font-weight:bold</xsl:attribute>
      </xsl:if>
      <xsl:if test="position()=1">
        <td colspan="2" rowspan="{$SaleCount}"/>
        <td rowspan="{$SaleCount}">
          <xsl:value-of select="../@NAME"/>
        </td>
      </xsl:if>
      <td>
        <xsl:value-of select="@NUM"/>
      </td>
      <td>
        <xsl:value-of select="@MTP_NM"/>
      </td>
      <td>
        <xsl:call-template name="DateTimeToStr">
          <xsl:with-param name="datetime" select="@DT"/>
        </xsl:call-template>
      </td>
      <td align="right" nowrap="nowrap">
        <xsl:call-template name="data_cell">
          <xsl:with-param name="value" select="- @QTY"/>
          <xsl:with-param name="format_mask" select="$qty_mask"/>
        </xsl:call-template>
      </td>
      <td align="right">
        <xsl:value-of select="@VOLUME_BOOK"/>
      </td>
      <td align="right">
        <xsl:value-of select="@VOLUME"/>
      </td>
      <td align="right">
        <xsl:value-of select="@DENSITY"/>
      </td>
      <td align="right">
        <xsl:value-of select="@WEIGHT"/>
      </td>
      <td align="right">
        <xsl:value-of select="@TEMP"/>
      </td>
    </tr>
  </xsl:template>


  <xsl:template name="DateTimeToStr">
    <xsl:param name="datetime"/>
    <xsl:value-of select ="substring($datetime,9,2)"/>.<xsl:value-of select ="substring($datetime,6,2)"/>.<xsl:value-of select ="substring($datetime,1,4)"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select ="substring($datetime,12,2)"/>:<xsl:value-of select ="substring($datetime,15,2)"/>
  </xsl:template>

  <xsl:template match="DATA/PRICES">
    <script language="javascript">
      function createXmlDocument(){
      var ret;
      if (document.implementation &amp;&amp; document.implementation.createDocument) {
      ret = document.implementation.createDocument('', '', null);
      }
      else {
      ret = new ActiveXObject('MSXML2.DomDocument');
      };
      return ret;
      };

      function getXmlDocumentString(xmlDoc){
      if (document.implementation &amp;&amp; document.implementation.createDocument) {
      return (new XMLSerializer().serializeToString(xmlDoc));
      }
      else {
      return xmlDoc.xml;
      }
      }

      function SetNodeText(node, value){

      node.appendChild(node.ownerDocument.createTextNode(value));
      }

      function saveData(){


      var xmlDoc = createXmlDocument();

      rootNode = xmlDoc.createElement('root');
      xmlDoc.appendChild(rootNode);

      //xmlDoc = xmlDoc.createElement ("root");
      // document.createElement('root');

      var combos = document.getElementsByName('PrCombo');

      for (var i = 0; i&lt;combos.length;i++){
      if (!combos[i].options[combos[i].selectedIndex].defaultSelected){
      var AzsNode = xmlDoc.createElement('azs');

      AzsNode.setAttribute('id',combos[i].id);

      AzsProperties = '';
      if (combos[i].value==1) AzsProperties = 'OIL_PRICES_EXPORT_DISABLE';

      if (AzsProperties!='')
      AzsNode.setAttribute('properties',AzsProperties);

      rootNode.appendChild(AzsNode);
      }
      }

      var prices = document.getElementsByName('PrPrice');
      for (var i = 0; i&lt;prices.length; i++){
      if (prices[i].value!=prices[i].defaultValue){
      var PriceNode = xmlDoc.createElement('price');
      PriceNode.setAttribute('azs_id',prices[i].parentNode.parentNode.id);
      PriceNode.setAttribute('tov_id',prices[i].id);

      SetNodeText(PriceNode,prices[i].value);
      rootNode.appendChild(PriceNode);
      }
      }

      document.getElementById('submitData').value = getXmlDocumentString(xmlDoc);
      }

      function ControlChange(){
      document.getElementById('btReset').disabled = '';
      document.getElementById('btSubmit').disabled = '';
      };

      function formReset()
      {
      document.forms['form'].reset();
      document.getElementById('btReset').disabled = 'disabled';
      document.getElementById('btSubmit').disabled = 'disabled';
      }

      function numberValidate(evt) {
      var theEvent = evt || window.event;
      var key = theEvent.keyCode || theEvent.which;
      key = String.fromCharCode( key );
      var regex = /[0-9]|[\.,]/;
      if( !regex.test(key) ) {
      theEvent.returnValue = false;
      if(theEvent.preventDefault) theEvent.preventDefault();
      }
      else ControlChange();
      }
    </script>
    <table border="1" class="report" id="ReportTable">
      <tr bgcolor="#a0a0a0" align="left">
        <th rowspan="2">АЗС</th>
        <th rowspan="2">Управление ценами</th>
        <th colspan="{$tov_count}">
          Цены
        </th>
      </tr>
      <tr bgcolor="#a0a0a0" align="left">
        <xsl:for-each select="COLUMNS/TOV">
          <th>
            <xsl:value-of select="@NAME"/>
          </th>
        </xsl:for-each>
      </tr>
      <xsl:apply-templates/>
      <tr>
        <td colspan="{$tov_count+2}" align="right">
          <input type="hidden" id="submitData" name="data"/>
          <input id="btReset" type="reset" value="Отмена" style="margin-right:15px; padding:0px 5px" disabled="disabled" onclick="formReset();"></input>
          <input id="btSubmit" type="submit" onclick="saveData()" value="Сохранить" style="padding:0px 5px" disabled="disabled"></input>
        </td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template match="DATA/PRICES/AZS">
    <xsl:variable name="PRICES_EXPORT_DISABLE" select="contains(@PROPERTIES,'OIL_PRICES_EXPORT_DISABLE')"/>
    <tr bgcolor="#ffffff" id="{@ID}">
      <td bgcolor="#e0e0e0">
        <a href="javascript:tovid='0';azsid='{@ID}';RefreshReport();">
          <b>
            <xsl:value-of select="@NAME"/>
          </b>
        </a>
      </td>
      <td style="padding:0">
        <select name="PrCombo" id="{@ID}" onchange="ControlChange()" style="border: 0 none;">
          <option value="1">
            <xsl:if test="$PRICES_EXPORT_DISABLE">
              <xsl:attribute name="selected">1</xsl:attribute>
            </xsl:if>
            Цена задаётся на АЗС
          </option>
          <option value="0">
            <xsl:if test="not($PRICES_EXPORT_DISABLE)">
              <xsl:attribute name="selected">1</xsl:attribute>
            </xsl:if>
            Цена задаётся на сайте
          </option>
        </select>
      </td>
      <xsl:variable name="azs" select="."/>
      <xsl:variable name="ReadOnlyColor">
        <xsl:choose>
          <xsl:when test="$PRICES_EXPORT_DISABLE">#a0a0a0</xsl:when>
          <xsl:otherwise>
            inherit
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:for-each select="../COLUMNS/TOV">
        <td class="money">
          <input type="text" name="PrPrice" id="{@ID}" value="{number($azs/TOV[@ID=current()/@ID]/@PRICE)}" style="width:100px; border: 0 none; text-align:right;color:{$ReadOnlyColor}" onkeypress="if (!this.readOnly) numberValidate(event);" onchange="ControlChange()">
            <xsl:if test="$PRICES_EXPORT_DISABLE">
              <xsl:attribute name="readonly">
                readonly
              </xsl:attribute>
            </xsl:if>
          </input>


        </td>
      </xsl:for-each>
    </tr>
  </xsl:template>

  <xsl:template match="DATA/SYNC">
    <input type="hidden" id="submitData" name="data"/>
    <table border="1" class="report" id="ReportTable">
      <thead>
        <tr bgcolor="#a0a0a0" align="left">
          <th rowspan="2">АЗС</th>
          <th rowspan="2">Расписание</th>
          <th colspan="3">
            Последняя синхронизация
          </th>
          <th rowspan="2">
            Примечания
          </th>
        </tr>
        <tr bgcolor="#a0a0a0" align="left">
          <th>
            Дата
          </th>
          <th>
            Время
          </th>
          <th>
            Длительность
          </th>
        </tr>
      </thead>
      <tbody>
        <xsl:apply-templates/>
      </tbody>
    </table>
  </xsl:template>

  <xsl:template match="DATA/SYNC/AZS">
    <xsl:variable name="lastSuccessfulTask" select="TASK[@SUCCESFUL][1]"/>
    <tr class="row2">
      <td>
        <xsl:call-template name="a">
          <xsl:with-param name="href">
            javascript:azs='<xsl:value-of select="@ID"/>';RefreshReport();
          </xsl:with-param>
          <xsl:with-param name="active" select="false"/>
          <xsl:with-param name="text">
            <xsl:value-of select="@NAME"/>
          </xsl:with-param>
        </xsl:call-template>
      </td>
      <td>
        <xsl:value-of select="SHED/@NAME"/>
      </td>
      <td nowrap="nowrap">
        <xsl:value-of select="substring($lastSuccessfulTask/@START_DT,1,10)"/>
      </td>
      <td>
        <xsl:value-of select="substring($lastSuccessfulTask/@START_DT,12,5)"/>
      </td>
      <td align="center">
        <xsl:if test="$lastSuccessfulTask/@DURATION_MINUTES>0">
          <xsl:value-of select="$lastSuccessfulTask/@DURATION_MINUTES"/> мин.
        </xsl:if>
        <xsl:value-of select="$lastSuccessfulTask/@DURATION_SECONDS"/> сек.
      </td>
      <td>

        <xsl:choose>
          <xsl:when test="@SYNC_ACTIVE">
            Синхронизация выполняется
          </xsl:when>
          <xsl:otherwise>
            <div>
              Следующая синхронизация: <xsl:value-of select="concat(substring(SHED[1]/@NEXT_RUN_DT,1,10),' ',substring(SHED[1]/@NEXT_RUN_DT,12,5))"/>
            </div>
            <input type="submit" value="Запустить синхронизацию" onclick="document.getElementById('submitData').value='&lt;azs id=&quot;{@ID}&quot;/>';" style="padding:0px 5px"/>
          </xsl:otherwise>
        </xsl:choose>

      </td>
    </tr>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="DATA/SYNC/AZS/TASK">
    <tr class="row3">
      <xsl:if test="not(preceding-sibling::TASK)">
        <td colspan="2" rowspan="{count(../TASK)}"/>
      </xsl:if>
      <td nowrap="nowrap">
        <xsl:value-of select="substring(@START_DT,1,10)"/>
      </td>
      <td nowrap="nowrap">
        <xsl:value-of select="substring(@START_DT,12,5)"/>
      </td>
      <td align="center">
        <xsl:if test="@DURATION_MINUTES>0">
          <xsl:value-of select="@DURATION_MINUTES"/> мин.
        </xsl:if>
        <xsl:value-of select="@DURATION_SECONDS"/> сек.
      </td>
      <td>
        <xsl:value-of select="@NAME"/>
        <br/>
        <xsl:value-of select="text()" disable-output-escaping="yes"/>
      </td>
    </tr>


  </xsl:template>

</xsl:stylesheet>
