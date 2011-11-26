<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1" %>
<%--@elvariable id="model" type="Map"--%>
<%@ include file="doctype.jsp" %>

<html>
    <head>
        <%@ include file="head.jsp" %>
    </head>
    <body class="mainframe bgcolor1">
        <c:import url="settingsHeader.jsp">
            <c:param name="cat" value="share"/>
            <c:param name="restricted" value="${not model.user.adminRole}"/>
        </c:import>

        <form id="sharesettingsform" method="post" action="shareSettings.view">

            <table style="border-collapse:collapse;white-space:nowrap">
                <tr>
                    <th style="padding-left:1em"><fmt:message key="sharesettings.name"/></th>
                    <th style="padding-left:1em"><fmt:message key="sharesettings.owner"/></th>
                    <th style="padding-left:1em"><fmt:message key="sharesettings.description"/></th>
                    <th style="padding-left:1em"><fmt:message key="sharesettings.expires"/></th>
                    <th style="padding-left:1em"><fmt:message key="sharesettings.lastvisited"/></th>
                    <th style="padding-left:1em"><fmt:message key="sharesettings.visits"/></th>
                    <th style="padding-left:1em"><fmt:message key="sharesettings.files"/></th>
                    <th style="padding-left:1em"><fmt:message key="sharesettings.expirein"/></th>
                    <th style="padding-left:1em"><fmt:message key="common.delete"/></th>
                </tr>

                <c:forEach items="${model.shareInfos}" var="shareInfo" varStatus="loopStatus">
                    <c:set var="share" value="${shareInfo.share}"/>
                    <c:choose>
                        <c:when test="${loopStatus.count % 2 == 1}">
                            <c:set var="class" value="class='bgcolor2'"/>
                        </c:when>
                        <c:otherwise>
                            <c:set var="class" value=""/>
                        </c:otherwise>
                    </c:choose>

                    <sub:url value="main.view" var="albumUrl">
                        <sub:param name="path" value="${shareInfo.dir.path}"/>
                    </sub:url>

                    <tr>
                        <td ${class} style="padding-left:1em"><a href="${model.shareBaseUrl}${share.name}" target="_blank">${share.name}</a></td>
                        <td ${class} style="padding-left:1em">${share.username}</td>
                        <td ${class} style="padding-left:1em"><input type="text" name="description[${share.id}]" size="40" value="${share.description}"/></td>
                        <td ${class} style="padding-left:1em"><fmt:formatDate value="${share.expires}" type="date" dateStyle="medium"/></td>
                        <td ${class} style="padding-left:1em"><fmt:formatDate value="${share.lastVisited}" type="date" dateStyle="medium"/></td>
                        <td ${class} style="padding-left:1em; text-align:right">${share.visitCount}</td>
                        <td ${class} style="padding-left:1em"><a href="${albumUrl}" title="${shareInfo.dir.name}"><str:truncateNicely upper="30">${fn:escapeXml(shareInfo.dir.name)}</str:truncateNicely></a></td>
                        <td ${class} style="padding-left:1em">
                            <select id="expireIn[${share.id}]" name="expireIn[${share.id}]">
                                <option value="7"><fmt:message key="sharesettings.expirein.week"/></option>
                                <option value="30"><fmt:message key="sharesettings.expirein.month"/></option>
                                <option value="365"><fmt:message key="sharesettings.expirein.year"/></option>
                                <option value="0"><fmt:message key="sharesettings.expirein.never"/></option>
                            </select>
                        </td>
                        <td ${class} style="padding-left:1em" align="center" style="padding-left:1em"><input type="checkbox" name="delete[${share.id}]" class="checkbox"/></td>
                    </tr>
                </c:forEach>
            </table>
        </form>

    </blockquote>
    </div>
    </div>
    </div>
    </body>
    <script type="text/javascript">
        jQueryLoad.wait(function() {
            jQueryUILoad.wait(function() {
                $(init);
            });
        });
    </script>
</html>