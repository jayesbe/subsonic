<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1" %>
<%@ include file="doctype.jsp" %>

<html>
    <head>
        <%@ include file="head.jsp" %>
        <meta http-equiv="cache-control" content="no-cache">
        <meta http-equiv="refresh" content="20">
        <script type="text/javascript" src="<c:url value="/script/scripts.js"/>"></script>
    </head>
    <body class="bgcolor1 mainframe">

        <div id="mainframecontainer">

            <div id="mainframemenucontainer" class="bgcolor1 fade">
                <span id="mainframemenuleft">
                    <span class="mainframemenuitem logfile"><a href="logfile.view?" onClick="persistentTopLinks('logfile.view?')"><fmt:message key="logfile.logfile"/></a></span>
                    <span class="mainframemenuitem" id="playerstatuslink"><a href="#" onClick="persistentTopLinks('status.view?display=player')"><fmt:message key="status.playerstatus"/></a></span>
                    <span class="mainframemenuitem" id="userstatisticslink"><a href="#" onClick="persistentTopLinks('status.view?display=user')"><fmt:message key="status.userstatistics"/></a></span>
                </span>
                <span id="mainframemenuright">
                    <span class="mainframemenuitem refresh right"><a href="#" onClick="javascript: refreshPage()"><fmt:message key="common.refresh"/></a></span>
                </span>
            </div>

            <div id="mainframecontentcontainer">
                <div id="mainframecontent">
                    <div id="mainframecontentheader" class="fade">
                        <h1>
                            <img id="pageimage" src="<spring:theme code="statusImage"/>" alt="">
                            <span class="desc"><fmt:message key="status.title"/></span>
                        </h1>
                    </div>
    
                    <div id="playerstatus" style="width:100%;display:none">
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
        <script type="text/javascript">
            function refreshPage() {
                location.href = "status.view?display=${model.statusView}";
            }

            jQueryLoad.wait(function() {
                jQueryUILoad.wait(function() {
                    switch ("${model.statusView}") {
                        case "player":
                            jQuery("#playerstatus").delay(30).fadeIn(600);
                            jQuery("#playerstatuslink").addClass("forward");
                            jQuery("#userstatisticslink").removeClass("forward");
                            break;
                        case "user":
                            jQuery("#userstatistics").delay(30).fadeIn(600);
                            jQuery("#userstatisticslink").addClass("forward");
                            jQuery("#playerstatuslink").removeClass("forward");
                            break;
                        default:
                            jQuery("#playerstatus").delay(30).fadeIn(600);
                            jQuery("#playerstatuslink").addClass("forward");
                            jQuery("#userstatisticslink").removeClass("forward");
                    }
                });
            });
        </script>
    </body>
</html>