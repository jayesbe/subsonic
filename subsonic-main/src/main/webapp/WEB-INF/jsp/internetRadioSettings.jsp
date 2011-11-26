<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1" %>
<%@ include file="doctype.jsp" %>

<html>
    <head>
        <%@ include file="head.jsp" %>
    </head>
    <body class="mainframe bgcolor1">

        <c:import url="settingsHeader.jsp">
            <c:param name="cat" value="internetRadio"/>
        </c:import>

        <form id="internetradiosettingsform" method="post" action="internetRadioSettings.view">

            <table>
                <tr>
                    <th><fmt:message key="internetradiosettings.name"/></th>
                    <th><fmt:message key="internetradiosettings.streamurl"/></th>
                    <th><fmt:message key="internetradiosettings.homepageurl"/></th>
                    <th style="padding-left:1em"><fmt:message key="internetradiosettings.enabled"/></th>
                    <th style="padding-left:1em"><fmt:message key="common.delete"/></th>
                </tr>

                <c:forEach items="${model.internetRadios}" var="radio">
                    <tr>
                        <td><input type="text" name="name[${radio.id}]" size="20" value="${radio.name}"/></td>
                        <td><input type="text" name="streamUrl[${radio.id}]" size="40" value="${radio.streamUrl}"/></td>
                        <td><input type="text" name="homepageUrl[${radio.id}]" size="40" value="${radio.homepageUrl}"/></td>
                        <td align="center" style="padding-left:1em"><input type="checkbox" ${radio.enabled ? "checked" : ""} name="enabled[${radio.id}]" class="checkbox"/></td>
                        <td align="center" style="padding-left:1em"><input type="checkbox" name="delete[${radio.id}]" class="checkbox"/></td>
                    </tr>
                </c:forEach>

                <tr>
                    <th colspan="5" align="left" style="padding-top:1em"><fmt:message key="internetradiosettings.add"/></th>
                </tr>

                <tr>
                    <td><input type="text" name="name" size="20"/></td>
                    <td><input type="text" name="streamUrl" size="40"/></td>
                    <td><input type="text" name="homepageUrl" size="40"/></td>
                    <td align="center" style="padding-left:1em"><input name="enabled" checked type="checkbox" class="checkbox"/></td>
                    <td/>
                </tr>
            </table>
        </form>

        <c:if test="${not empty model.error}">
            <p class="warning"><fmt:message key="${model.error}"/></p>
        </c:if>

    </blockquote>
    </div>
    </div>
    </div>
    </body>
    <script type="text/javascript">
        if (${model.reload}) parent.location.href="index.view?";
        jQueryLoad.wait(function() {
            jQueryUILoad.wait(function() {
                $(init);
            });
        });
    </script>
</html>