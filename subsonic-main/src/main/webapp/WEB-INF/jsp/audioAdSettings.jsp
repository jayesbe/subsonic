<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1" %>

<%--
  ~ This file is part of Subsonic.
  ~
  ~  Subsonic is free software: you can redistribute it and/or modify
  ~  it under the terms of the GNU General Public License as published by
  ~  the Free Software Foundation, either version 3 of the License, or
  ~  (at your option) any later version.
  ~
  ~  Subsonic is distributed in the hope that it will be useful,
  ~  but WITHOUT ANY WARRANTY; without even the implied warranty of
  ~  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  ~  GNU General Public License for more details.
  ~
  ~  You should have received a copy of the GNU General Public License
  ~  along with Subsonic.  If not, see <http://www.gnu.org/licenses/>.
  ~
  ~  Copyright 2015 (C) Sindre Mehus
  --%>

<html><head>
    <%@ include file="head.jsp" %>
    <%@ include file="jquery.jsp" %>
</head>
<body class="mainframe bgcolor1">

<c:import url="settingsHeader.jsp">
    <c:param name="cat" value="audioAd"/>
    <c:param name="toast" value="${model.toast}"/>
</c:import>

<form method="post" action="audioAdSettings.view">

    <div>
        <input type="checkbox" name="audioAdEnabled" id="audioAdEnabled" class="checkbox"
               <c:if test="${model.audioAdEnabled}">checked="checked"</c:if>/>
        <label for="audioAdEnabled"><fmt:message key="audioadsettings.enabled"/></label>
    </div>

    <p class="detail" style="width:60%;white-space:normal">
        <fmt:message key="audioadsettings.enabled.description"/>
    </p>
    <div>
        <fmt:message key="audioadsettings.frequency"/>
        <input name="audioAdFrequency" id="audioAdFrequency" size="5" value="${model.audioAdFrequency}"/>
    </div>
    <p class="detail" style="width:60%;white-space:normal;padding-top:0">
        <fmt:message key="audioadsettings.frequency.description"/>
    </p>

    <table class="indent">
        <tr>
            <th><fmt:message key="audioadsettings.path"/></th>
            <th><fmt:message key="audioadsettings.comment"/></th>
            <th><fmt:message key="audioadsettings.weight"/></th>
            <th><fmt:message key="audioadsettings.playcount"/></th>
            <th style="padding-left:1em"><fmt:message key="common.enabled"/></th>
            <th style="padding-left:1em"><fmt:message key="common.delete"/></th>
        </tr>

        <c:forEach items="${model.ads}" var="ad">
            <tr>
                <td><input type="text" name="path[${ad.id}]" size="40" value="${ad.mediaFile.path}"/></td>
                <td><input type="text" name="comment[${ad.id}]" size="30" value="${ad.comment}"/></td>
                <td><input type="text" style="text-align:right" name="weight[${ad.id}]" size="6" value="${ad.weight}"/></td>
                <td><input type="text" style="text-align:right" disabled size="6" value="${ad.mediaFile.playCount}"/></td>
                <td align="center" style="padding-left:1em"><input type="checkbox" ${ad.enabled ? "checked" : ""} name="enabled[${ad.id}]" class="checkbox"/></td>
                <td align="center" style="padding-left:1em"><input type="checkbox" name="delete[${ad.id}]" class="checkbox"/></td>
            </tr>
        </c:forEach>

        <tr>
            <th colspan="5" align="left" style="padding-top:1em"><fmt:message key="audioadsettings.add"/></th>
        </tr>

        <tr>
            <td><input type="text" name="path" size="40"/></td>
            <td><input type="text" name="comment" size="30"/></td>
            <td><input type="text" style="text-align:right" name="weight" size="6" value="1.0"/></td>
            <td></td>
            <td align="center" style="padding-left:1em"><input name="enabled" checked type="checkbox" class="checkbox"/></td>
            <td></td>
        </tr>

        <tr>
            <td style="padding-top:1.5em" colspan="5">
                <input type="submit" value="<fmt:message key="common.save"/>" style="margin-right:0.3em">
                <input type="button" value="<fmt:message key="common.cancel"/>" onclick="location.href='nowPlaying.view'">
            </td>
        </tr>
    </table>
</form>


<c:if test="${not empty model.error}">
    <p class="warning"><fmt:message key="${model.error}"/></p>
</c:if>

</body></html>