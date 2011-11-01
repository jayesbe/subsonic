<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1" %>
<%@ include file="doctype.jsp" %>

<html>
    <head>
        <script type="text/javascript" src="/script/LAB.load.js"></script>
        <script>webfont = "${model.systemWebFont}";</script>
        <%@ include file="head.jsp" %>
                
        <script type="text/javascript">

            function clearAutoComplete() {
                if (navigator.userAgent.toLowerCase().indexOf("chrome") >= 0) {
                    (function($) {
                        $('input:-webkit-autofill').each(function(){
                            var text = $(this).val();
                            var name = $(this).attr('name');
                            $(this).after(this.outerHTML).remove();
                            $('input[name=' + name + ']').val(text);
                        });
                    })(jQuery);
                }
            }
            jQueryLoad.wait(function() {
                if (typeof(jQuery) !== "undefined") {
                    jQuery(clearAutoComplete);
                    //$LAB
                            //.script("script/jquery.jqtransform.js")
                            //.wait(function() { jQuery("form.jqtransform").jqTransform(); });
                }
            });
    
        </script>
        
        <script type="text/javascript" src="<c:url value="/script/niceforms2.js"/>"></script>
        <link type="text/css" rel="stylesheet" href="<c:url value="/style/niceforms2/niceforms-default.css" />"/>
    </head>
    <body class="bgcolor1">
        <div id="logonframecontainer">
            <div id="logonframeformcontainer">
                <div id="logonframeform" class="bgcolor2 logonframe">
                    <div id="niceformcontainer">
                        <form action="<c:url value='/j_acegi_security_check'/>" method="POST" class="niceform">
                            <c:if test="${not empty model.loginMessage}">
                                <div style="margin-bottom:1em;max-width:50em;text-align:left;"><sub:wiki text="${model.loginMessage}"/></div>
                            </c:if>

                            <table class="center">
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
                                    <td align="left"><input name="submit" type="submit" value="<fmt:message key='login.login'/>" tabindex="4"></td>
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
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
