<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1" %>
<%@ include file="doctype.jsp" %>

<html>
    <head>
        <%@ include file="head.jsp" %>
    </head>
    <body class="mainframe bgcolor1">
        <c:import url="settingsHeader.jsp">
            <c:param name="cat" value="password"/>
            <c:param name="restricted" value="true"/>
        </c:import>

        <c:choose>
            <c:when test="${command.ldapAuthenticated}">
                <p><fmt:message key="usersettings.passwordnotsupportedforldap"/></p>
            </c:when>
            <c:otherwise>
                <form:form id="passwordsettingsform" method="post" action="passwordSettings.view" commandName="command">
                    <h2><fmt:message key="passwordsettings.title"><fmt:param>${command.username}</fmt:param></fmt:message></h2>

                    <table>
                        <tr>
                            <td><fmt:message key="usersettings.newpassword"/></td>
                            <td><form:password path="password"/></td>
                            <td class="warning"><form:errors path="password"/></td>
                        </tr>
                        <tr>
                            <td><fmt:message key="usersettings.confirmpassword"/></td>
                            <td><form:password path="confirmPassword"/></td>
                            <td/>
                        </tr>
                    </table>
                </form:form>
            </c:otherwise>
        </c:choose>
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
