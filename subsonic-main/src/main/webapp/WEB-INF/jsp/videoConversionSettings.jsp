<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1" %>
<%--@elvariable id="model" type="Map"--%>

<html><head>
    <%@ include file="head.jsp" %>
    <%@ include file="jquery.jsp" %>
    <style>
        th {
            text-align: left;
        }
    </style>
</head>
<body class="mainframe bgcolor1">

<c:set var="category" value="videoConversion"/>
<c:set var="toast" value="${model.toast}"/>
<c:set var="user" value="${model.user}"/>
<%@ include file="settingsHeader.jsp" %>

<form method="post" action="videoConversionSettings.view">

    <table>
        <tr>
            <td><fmt:message key="videoconversionsettings.directory"/></td>
            <td><input name="directory" value="${model.directory}" style="width:300px"></td>
        </tr>
        <tr>
            <td><fmt:message key="videoconversionsettings.threshold"/></td>
            <td><input name="directory" value="${model.directory}" style="width:300px"></td>
        </tr>
    </table>

    <c:if test="${not empty model.conversionInfos}">
        <h2><fmt:message key="videoconversionsettings.convertedvideos"/></h2>
        <table class="music indent">
            <tr>
                <th class="truncate"><fmt:message key="videoconversionsettings.source"/></th>
                <th class="truncate"><fmt:message key="videoConverter.details.targetfile"/></th>
                <th class="truncate"><fmt:message key="videoConverter.details.status"/></th>
                <th class="truncate"><fmt:message key="personalsettings.bitrate"/></th>
                <th class="truncate"><fmt:message key="usersettings.username"/></th>
                <th class="fit" style="text-align:center"><fmt:message key="common.delete"/></th>
            </tr>

            <c:forEach items="${model.conversionInfos}" var="conversionInfo">
                <tr>
                    <td class="truncate" style="max-width:150px"><a href="main.view?id=${conversionInfo.video.id}">${conversionInfo.video.name}</a></td>
                    <td class="truncate" style="max-width:150px" title="${conversionInfo.conversion.targetFile}">${conversionInfo.conversion.targetFile}</td>
                    <td class="truncate"><fmt:message key="videoConverter.status.${fn:toLowerCase(conversionInfo.conversion.status)}"/></td>
                    <td class="truncate"><c:if test="${not empty conversionInfo.conversion.bitRate}">${conversionInfo.conversion.bitRate} Kbps</c:if></td>
                    <td class="truncate">${conversionInfo.conversion.username}</td>
                    <td class="fit" style="text-align:center"><input type="checkbox" name="delete[${conversionInfo.conversion.id}]" class="checkbox"/></td>
                </tr>
            </c:forEach>
        </table>
    </c:if>

    <c:set var="licenseInfo" value="${model.licenseInfo}"/>
    <%@ include file="licenseNotice.jsp" %>

    <p style="padding-top:1em">
        <input type="submit" value="<fmt:message key="common.save"/>" style="margin-right:0.3em">
        <input type="button" value="<fmt:message key="common.cancel"/>" onclick="location.href='nowPlaying.view'" style="margin-right:2.0em">
    </p>

</form>

</body></html>