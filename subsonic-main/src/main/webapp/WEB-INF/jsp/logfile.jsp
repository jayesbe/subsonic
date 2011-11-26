<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1" %>
<%@ include file="doctype.jsp" %>

<html>
    <head>
        <%@ include file="head.jsp" %>
        <script type="text/javascript" src="<c:url value="/script/scripts.js"/>"></script>
    </head>
    <body class="mainframe bgcolor1">

        <div id="mainframecontainer" class="fillframe">

            <div id="mainframemenucontainer" class="bgcolor1 fade vcenterouter fillwidth">
                <span id="mainframemenuleft" class="vcenterinner">
                    <button id="playerstatuslink" class="vcenter" onClick="persistentTopLinks('status.view?display=player')"><fmt:message key="status.playerstatus"/></button>
                    <button id="userstatisticslink" class="vcenter" onClick="persistentTopLinks('status.view?display=user')"><fmt:message key="status.userstatistics"/></button>
                    <button class="ui-icon-note ui-icon-primary vcenter ui-state-active"><h2 class="inline"><fmt:message key="logfile.logfile"/></h2></button>
                </span>
                <span id="mainframemenuright" class="vcenterinner">
                    <button class="ui-icon-refresh ui-icon-secondary vcenter right" onClick="refreshPage()"><fmt:message key="common.refresh"/></button>
                </span>
            </div>

            <div id="mainframecontentcontainer">
                <div id="mainframecontent">

                    <div id="logfilecontainer" class="fade">
                        <h2 class="aligncenter"><img src="<spring:theme code='logImage'/>" alt="">&nbsp;<fmt:message key="logfile.log"/></h2>
                        <table id="logfile" cellpadding="2" class="log center alignleft">
                            <c:forEach items="${model.logEntries}" var="entry">
                                <tr>
                                    <td>[<fmt:formatDate value="${entry.date}" dateStyle="short" timeStyle="long" type="both"/>]</td>
                                    <td>${entry.level}</td><td>${entry.category}</td><td><str:truncateNicely upper="100">${entry.message}</str:truncateNicely></td>
                                </tr>
                            </c:forEach>
                        </table>
                        <p class="aligncenter"><fmt:message key="logfile.logpath"><fmt:param value="${model.logFile}"/></fmt:message></p>
                    </div>

                </div>
            </div>
        </div>
    </body>
    <script type="text/javascript">
        jQueryLoad.wait(function() {
            jQueryUILoad.wait(function() {
                $("#mainframemenucontainer .ui-state-active").button().hover(function() { $(this).removeClass("ui-state-active"); }, function() { $(this).addClass("ui-state-active"); }).click(function() { $(this).addClass("ui-state-active"); });
                $("#mainframemenuleft").buttonset();
                $("#mainframemenucontainer").stylize();
            });
        });
    </script>
</html>