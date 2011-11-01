<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1" %>
<%@ include file="doctype.jsp" %>

<html>
    <head>
        <%@ include file="head.jsp" %>
        <script type="text/javascript" src="<c:url value="/script/scripts.js"/>"></script>
    </head>
    <body class="mainframe bgcolor1">

        <div id="mainframecontainer">

            <div id="mainframemenucontainer" class="bgcolor1 fade">
                <span id="mainframemenuleft">
                    <span class="mainframemenuitem back cancel"><a href="status.view?" onClick="persistentTopLinks('status.view?')"><fmt:message key="common.back"/></a></span>
                </span>
                <span id="mainframemenuright">
                    <span class="mainframemenuitem refresh right"><a href="logfile.view?"><fmt:message key="common.refresh"/></a></span>
                </span>
            </div>

            <div id="mainframecontentcontainer">
                <div id="mainframecontent">

                    <div id="logfilecontainer" class="fade">
                        <h2 style="text-align: center"><img src="<spring:theme code='logImage'/>" alt="">&nbsp;<fmt:message key="logfile.log"/></h2>
                        <table id="logfile" cellpadding="2" class="log" style="margin:2px auto;text-align:left">
                            <c:forEach items="${model.logEntries}" var="entry">
                                <tr>
                                    <td>[<fmt:formatDate value="${entry.date}" dateStyle="short" timeStyle="long" type="both"/>]</td>
                                    <td>${entry.level}</td><td>${entry.category}</td><td><str:truncateNicely upper="100">${entry.message}</str:truncateNicely></td>
                                </tr>
                            </c:forEach>
                        </table>
                        <p style="text-align: center"><fmt:message key="logfile.logpath"><fmt:param value="${model.logFile}"/></fmt:message></p>
                    </div>

                </div>
            </div>
        </div>
    </body>
</html>