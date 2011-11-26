<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1" %>
<%@ include file="doctype.jsp" %>

<html>
    <head>
        <meta http-equiv="refresh" content="20">
        <meta http-equiv="cache-control" content="no-cache">
        <%@ include file="head.jsp" %>
        <script type="text/javascript" src="<c:url value="/script/scripts.js"/>"></script>
    </head>
    <body class="bgcolor1 mainframe">

        <div id="mainframecontainer" class="fillframe">

            <div id="mainframemenucontainer" class="bgcolor1 fade vcenterouter fillwidth">
                <span id="mainframemenuleft" class="vcenterinner">
                    <button id="playerstatuslink" class="vcenter"><fmt:message key="status.playerstatus"/></button>
                    <button id="userstatisticslink" class="vcenter"><fmt:message key="status.userstatistics"/></button>
                    <button id="logfile" class="vcenter" onClick="persistentTopLinks('logfile.view?')"><fmt:message key="logfile.logfile"/></button>
                </span>
                <span id="mainframemenuright" class="vcenterinner">
                    <button class="ui-icon-refresh ui-icon-secondary right vcenter" onClick="refreshPage()"><fmt:message key="common.refresh"/></button>
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
    
                    <div id="playerstatus" class="fillwidth ui-helper-hidden">
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

                    <div id="userstatistics" class="fillwidth ui-helper-hidden">
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
    <script type="text/javascript">
        jQueryLoad.wait(function() {
            jQueryUILoad.wait(function() {
                switch ("${model.statusView}") {
                    case "player":
                        var sel = "playerstatuslink";
                        $("#userstatisticslink").click(function() { persistentTopLinks("status.view?display=user"); });
                        $("#playerstatus").delay(30).fadeIn(600);
                        break;
                    case "user":
                        var sel = "userstatisticslink";
                        $("#playerstatuslink").click(function() { persistentTopLinks("status.view?display=player"); });
                        $("#userstatistics").delay(30).fadeIn(600);
                        break;
                    default:
                        $("#userstatisticslink").click(function() { persistentTopLinks("status.view?display=user"); });
                        $("#playerstatuslink").addClass("ui-icon-bookmark ui-icon-primary ui-state-active")
                        $("#playerstatus").delay(30).fadeIn(600);
                }
                $("#" + sel).addClass("ui-icon-bookmark ui-icon-primary ui-state-active").html('<h2 class="inline">' + $("#" + sel).html() + '</h2>')
                $("#mainframemenuleft").buttonset();
                $("#" + sel).hover(function() { $(this).removeClass("ui-state-active"); }, function() { $(this).addClass("ui-state-active"); }).click(function() { $(this).addClass("ui-state-active"); });
                $("#mainframemenucontainer").stylize();
            });
        });
    </script>
</html>