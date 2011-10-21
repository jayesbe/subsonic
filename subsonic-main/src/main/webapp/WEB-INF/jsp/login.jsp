<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1"%>
<%@ include file="doctype.jsp" %>

<html>
    <head>
        <%@ include file="head.jsp" %>
        <script type="text/javascript">
            if (window != window.top) {
                top.location.href = location.href;
            }
        </script>
        <script src="<c:url value="/script/AC_RunActiveContent.js"/>" type="text/javascript"></script>
        <script type="text/javascript" src="<c:url value="/script/niceforms.js"/>"></script>
        <link type="text/css" rel="stylesheet" href="<c:url value="/style/niceforms-default.css" />"/>
    </head>
    <body class="bgcolor1" onLoad="document.getElementById('j_username').focus()">
        <center>
            <div id="flashcontent">
            <script type="text/javascript">
            AC_FL_RunContent( 'codebase','https://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,28,0','width','1006','height','106','src','<c:url value="/flash/twtitle_static"/>','quality','high','pluginspage','https://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash','scale','noscale','wmode','transparent','movie','<c:url value="/flash/twtitle_static"/>' ); //end AC code
            </script>
            <noscript>
                <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="https://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,28,0" width="1006px" height="106px">
                  <param name="movie" value="<c:url value="/flash/twtitle_static.swf"/>" />
                  <param name="quality" value="high" />
                  <param name="scale" value="noscale" />
                  <param name="wmode" value="transparent" />
                  <embed src="<c:url value="/flash/twtitle_static.swf"/>" quality="high" pluginspage="https://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash" type="application/x-shockwave-flash" width="1006px" height="106px" scale="noscale" wmode="transparent"></embed>
                </object>
            </noscript>
            </div>
        </center>

        <form action="<c:url value="/j_acegi_security_check"/>" method="POST" class="niceform">
            <div class="bgcolor2 logonframe" align="center" style=" position:absolute; left:0px; top:150px; width:100%; padding-top:20px; padding-bottom:20px">
                <c:if test="${not empty model.loginMessage}">
                    <div style="margin-bottom:1em;max-width:50em;text-align:left;"><sub:wiki text="${model.loginMessage}"/></div>
                </c:if>

                <table>
                <tr>
                    <td colspan="2" align="left" style="padding-bottom:10px">
                        <img src="<spring:theme code="logoImage"/>" alt="">
                    </td>
                </tr>
                <tr>
                    <td align="left" style="padding-right:10px"><fmt:message key="login.username"/></td>
                    <td align="left"><input type="text" id="j_username" name="j_username" style="width:12em" tabindex="1"></td>
                </tr>

                <tr>
                    <td align="left" style="padding-bottom:10px"><fmt:message key="login.password"/></td>
                    <td align="left" style="padding-bottom:10px"><input type="password" name="j_password" style="width:12em" tabindex="2"></td>
                </tr>

                <tr>
                    <td align="left"><input name="submit" type="submit" value="<fmt:message key="login.login"/>" tabindex="4"></td>
                    <td align="left" class="detail">
                        <input type="checkbox" name="_acegi_security_remember_me" id="remember" class="checkbox" tabindex="3">
                        <label for="remember"><fmt:message key="login.remember"/></label>
                    </td>
                </tr>
                    <c:if test="${model.logout}">
                        <tr><td colspan="2" style="padding-top:10px"><b><fmt:message key="login.logout"/></b></td></tr>
                    </c:if>
                    <c:if test="${model.error}">
                        <tr><td colspan="2" style="padding-top:10px"><b class="warning"><fmt:message key="login.error"/></b></td></tr>
                    </c:if>

                </table>

                <c:if test="${model.insecure}">
                    <p><b class="warning"><fmt:message key="login.insecure"><fmt:param value="${model.brand}"/></fmt:message></b></p>
                </c:if>
            </div>
        </form>
    </body>
</html>
