<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
    <%@ include file="head.jsp" %>
</head>
<body class="mainframe bgcolor1" onload="document.getElementById('usernameOrEmail').focus()">

<form action="recover.view" method="POST">
    <div class="bgcolor2 dropshadow" style="padding:20px 50px 20px 50px; margin-top:100px;margin-left:50px;margin-right:50px">

        <div style="margin-left: auto; margin-right: auto; width: 45em">

            <h1><fmt:message key="recover.title"/></h1>
            <p style="padding-top: 1em; padding-bottom: 0.5em"><fmt:message key="recover.text"/></p>

            <c:if test="${empty model.sentTo}">
                <input type="text" id="usernameOrEmail" name="usernameOrEmail" style="width:18em;margin-right: 1em">
                <input name="submit" type="submit" value="<fmt:message key="recover.send"/>">
            </c:if>

            <c:if test="${not empty model.captcha}">
                <p style="padding-top: 1em">
                    <c:out value="${model.captcha}" escapeXml="false"/>
                </p>
            </c:if>

            <c:if test="${not empty model.sentTo}">
                <p style="padding-top: 1em"><fmt:message key="recover.success"><fmt:param value="${model.sentTo}"/></fmt:message></p>
            </c:if>

            <c:if test="${not empty model.error}">
                <p style="padding-top: 1em" class="warning"><fmt:message key="${model.error}"/></p>
            </c:if>

            <div style="margin-top: 1.5em"><i class="fa fa-chevron-left icon"></i>&nbsp;<a href="login.view"><fmt:message key="common.back"/></a></div>

        </div>
    </div>
</form>
</body>
</html>
