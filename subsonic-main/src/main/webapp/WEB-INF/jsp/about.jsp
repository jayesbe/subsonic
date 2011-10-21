<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1"%>
<%@ include file="doctype.jsp" %>

<html>
    <head>
        <%@ include file="head.jsp" %>
        <script type="text/javascript" src="<c:url value="/script/scripts.js"/>"></script>
    </head>
    <body class="mainframe bgcolor1">

        <c:choose>
            <c:when test="${empty model.buildDate}">
                <fmt:message key="common.unknown" var="buildDateString"/>
            </c:when>
            <c:otherwise>
                <fmt:formatDate value="${model.buildDate}" dateStyle="long" var="buildDateString"/>
            </c:otherwise>
        </c:choose>

        <c:choose>
            <c:when test="${empty model.localVersion}">
                <fmt:message key="common.unknown" var="versionString"/>
            </c:when>
            <c:otherwise>
                <c:set var="versionString" value="${model.localVersion} (build ${model.buildNumber})"/>
            </c:otherwise>
        </c:choose>

        <div id="mainframecontainer">

            <div id="mainframemenucontainer" class="bgcolor1">
                <c:if test="${not model.licensed}">
                <span id="mainframemenuleft">
                    <a href="<c:url value="donate.view?"/>"><img src="<spring:theme code='paypalImage'/>" alt=""></a>
                </span>
                </c:if>
                <span id="mainframemenuright">
                    <span class="mainframemenuitem refresh right" style="margin-top:-1px;background-image: url('<spring:theme code='refreshImage'/>')"><a href="about.view?"><fmt:message key="common.refresh"/> Page</a></span>
                </span>
            </div>
    
            <div id="mainframecontentcontainer">
                <div id="mainframecontent">
                    <h1>
                        <img id="pageimage" src="<spring:theme code='helpImage'/>" alt="">
                        <span class="desc"><fmt:message key="help.title"><fmt:param value="${model.brand}"/></fmt:message></span>
                    </h1>
                    <div style="width:75%;text-align:center;margin:2px auto">
                        <c:if test="${model.newVersionAvailable}">
                            <p class="warning"><fmt:message key="help.upgrade"><fmt:param value="${model.brand}"/><fmt:param value="${model.latestVersion}"/></fmt:message></p>
                        </c:if>

                        <br>

                        <c:if test="${not model.licensed}">
                        <fmt:message key="help.donate"><fmt:param value="${model.brand}"/></fmt:message>
                        </c:if>

                        <table width="100%" class="ruleTable indent" style="text-align: left">
                            <tr><td class="ruleTableHeader"><fmt:message key="help.version.title"/></td><td class="ruleTableCell">${versionString} &ndash; ${buildDateString}</td></tr>
                            <tr><td class="ruleTableHeader"><fmt:message key="help.server.title"/></td><td class="ruleTableCell">${model.serverInfo} (<sub:formatBytes bytes="${model.usedMemory}"/> / <sub:formatBytes bytes="${model.totalMemory}"/>)</td></tr>
                            <tr><td class="ruleTableHeader"><fmt:message key="help.license.title"/></td><td class="ruleTableCell">
                                <a href="http://www.gnu.org/copyleft/gpl.html" target="_blank"><img style="float:right;margin-left: 10px" alt="GPL 3.0" src="<c:url value="/icons/gpl.png"/>"></a>
                                <fmt:message key="help.license.text"><fmt:param value="${model.brand}"/></fmt:message></td></tr>
                            <tr><td class="ruleTableHeader"><fmt:message key="help.homepage.title"/></td><td class="ruleTableCell"><a target="_blank" href="http://www.subsonic.org/">subsonic.org</a></td></tr>
                            <tr><td class="ruleTableHeader"><fmt:message key="help.forum.title"/></td><td class="ruleTableCell"><a target="_blank" href="http://forum.subsonic.org/">forum.subsonic.org</a></td></tr>
                            <tr><td class="ruleTableHeader"><fmt:message key="help.contact.title"/></td><td class="ruleTableCell"><fmt:message key="help.contact.text"><fmt:param value="${model.brand}"/></fmt:message></td></tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>