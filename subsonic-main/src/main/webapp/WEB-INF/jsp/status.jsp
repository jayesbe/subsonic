<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1"%>
<%@ include file="doctype.jsp" %>

<html>
    <head>
        <%@ include file="head.jsp" %>
        <meta http-equiv="CACHE-CONTROL" content="NO-CACHE">
        <meta http-equiv="REFRESH" content="20;URL=status.view">
        <script type="text/javascript" src="<c:url value="/script/prototype.js"/>"></script>
        <script type="text/javascript">
            function viewStatus(id) {
                switch (id) {
                    case 0:
                        $("userstatistics").hide();
                        $("playerstatus").show();
                        $("playerstatuslink").className = "mainframemenuitem forward";
                        $("userstatisticslink").className = "mainframemenuitem";
                        break;
                    case 1:
                        $("playerstatus").hide();
                        $("userstatistics").show();
                        $("userstatisticslink").className = "mainframemenuitem forward";
                        $("playerstatuslink").className = "mainframemenuitem";
                        break;
                    default:
                        $("userstatistics").hide();
                        $("playerstatus").show();
                        $("playerstatuslink").className = "mainframemenuitem forward";
                        $("userstatisticslink").className = "mainframemenuitem";
                }
            }
        </script>        
    </head>
    <body class="bgcolor1 mainframe">

        <div id="mainframecontainer">

            <div id="mainframemenucontainer" class="bgcolor1">
                <span id="mainframemenuleft">
                    <span class="mainframemenuitem logfile" style="background-image: url('<spring:theme code='logSmallImage'/>')"><a href="logfile.view?">Log File</a></span>
                    <span class="mainframemenuitem forward" id="playerstatuslink"><a href="#" onClick="viewStatus(0);">Player Status</a></span>
                    <span class="mainframemenuitem" id="userstatisticslink"><a href="#" onClick="viewStatus(1);">User Statistics</a></span>
                </span>
                <span id="mainframemenuright">
                    <span class="mainframemenuitem refresh right" style="background-image: url('<spring:theme code='refreshImage'/>')"><a href="status.view?"><fmt:message key="common.refresh"/></a></span>
                </span>
            </div>

            <div id="mainframecontentcontainer">
                <div id="mainframecontent">
                    <h1>
                        <img id="pageimage" src="<spring:theme code="statusImage"/>" alt="">
                        <span class="desc"><fmt:message key="status.title"/></span>
                    </h1>

                    <div id="playerstatus" style="width:100%">
                        <c:set var="pslen" value="<c:out value='${model.transferStatuses}'/>"/>
                        <table class="ruleTable" style="width:95%;margin:2px auto;">
                            <tr>
                                <th class="ruleTableHeader"><fmt:message key="status.type"/></th>
                                <th class="ruleTableHeader"><fmt:message key="status.player"/></th>
                                <th class="ruleTableHeader"><fmt:message key="status.user"/></th>
                                <th class="ruleTableHeader"><fmt:message key="status.current"/></th>
                                <th class="ruleTableHeader"><fmt:message key="status.transmitted"/></th>
                                <th class="ruleTableHeader"><fmt:message key="status.bitrate"/></th>
                            </tr>
                            <c:choose>
                                <c:when test="${fn:length(pslen) gt 19}">
                                    <c:forEach items="${model.transferStatuses}" var="status">

                                        <c:choose>
                                            <c:when test="${empty status.playerType}">
                                                <fmt:message key="common.unknown" var="type"/>
                                            </c:when>
                                            <c:otherwise>
                                                <c:set var="type" value="(${status.playerType})"/>
                                            </c:otherwise>
                                        </c:choose>

                                        <c:choose>
                                            <c:when test="${status.stream}">
                                                <fmt:message key="status.stream" var="transferType"/>
                                            </c:when>
                                            <c:when test="${status.download}">
                                                <fmt:message key="status.download" var="transferType"/>
                                            </c:when>
                                            <c:when test="${status.upload}">
                                                <fmt:message key="status.upload" var="transferType"/>
                                            </c:when>
                                        </c:choose>

                                        <c:choose>
                                            <c:when test="${empty status.username}">
                                                <fmt:message key="common.unknown" var="user"/>
                                            </c:when>
                                            <c:otherwise>
                                                <c:set var="user" value="${status.username}"/>
                                            </c:otherwise>
                                        </c:choose>

                                        <c:choose>
                                            <c:when test="${empty status.path}">
                                                <fmt:message key="common.unknown" var="current"/>
                                            </c:when>
                                            <c:otherwise>
                                                <c:set var="current" value="${status.path}"/>
                                            </c:otherwise>
                                        </c:choose>

                                        <sub:url value="/statusChart.view" var="chartUrl">
                                            <c:if test="${status.stream}">
                                                <sub:param name="type" value="stream"/>
                                            </c:if>
                                            <c:if test="${status.download}">
                                                <sub:param name="type" value="download"/>
                                            </c:if>
                                            <c:if test="${status.upload}">
                                                <sub:param name="type" value="upload"/>
                                            </c:if>
                                            <sub:param name="index" value="${status.index}"/>
                                        </sub:url>

                                        <tr>
                                            <td class="ruleTableCell">${transferType}</td>
                                            <td class="ruleTableCell">${status.player}<br>${type}</td>
                                            <td class="ruleTableCell">${user}</td>
                                            <td class="ruleTableCell">${current}</td>
                                            <td class="ruleTableCell">${status.bytes}</td>
                                            <td class="ruleTableCell" width="${model.chartWidth}"><img width="${model.chartWidth}" height="${model.chartHeight}" src="${chartUrl}" alt=""></td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td class="ruleTableCell" colspan="6">Nothing to report.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </table>
                    </div>

                    <div id="userstatistics" style="width:100%;display:none">
                        <table style="margin:2px auto">
                            <tr>
                                <th><fmt:message key="home.chart.total"/></th>
                                <th><fmt:message key="home.chart.stream"/></th>
                            </tr>
                            <tr>
                                <td><img src="<c:url value="/userChart.view"><c:param name="type" value="total"/></c:url>" alt=""></td>
                                <td><img src="<c:url value="/userChart.view"><c:param name="type" value="stream"/></c:url>" alt=""></td>
                            </tr>
                            <tr>
                                <th><fmt:message key="home.chart.download"/></th>
                                <th><fmt:message key="home.chart.upload"/></th>
                            </tr>
                            <tr>
                                <td><img src="<c:url value="/userChart.view"><c:param name="type" value="download"/></c:url>" alt=""></td>
                                <td><img src="<c:url value="/userChart.view"><c:param name="type" value="upload"/></c:url>" alt=""></td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>            
    </body>
</html>