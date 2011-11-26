<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1" %>
<%@ include file="doctype.jsp" %>

<html>
    <head>
        <script type="text/javascript" src="/script/LAB.load.js"></script>
        <script>webfont = "${model.systemWebFont}";</script>
        <%@ include file="head.jsp" %>
        <!--[if IE]>
        <style type="text/css">
        </style>
        <![endif]-->
    </head>
    <body class="bgcolor1">
        <div id="loginframecontainer" class="fillframe vcenterouter">
            <div id="loginframeformcontainer" class="vcenterinner">
                <div id="loginframelogonmessage" style="width:350px;padding-bottom:10px;" class="center ui-helper-hidden"></div>
                <div class="bgcolor2 loginframe vcenter ui-helper-hidden">
                    <form id="loginframelogonform" action="<c:url value='/j_acegi_security_check'/>" method="post">
                    <c:if test="${not empty model.loginMessage}">
                        <div style="margin-bottom:1em;max-width:50em;text-align:left;" class="center"><sub:wiki text="${model.loginMessage}"/></div>
                    </c:if>

                        <table class="center">
                            <tr>
                                <td style="padding-bottom:20px" class="aligncenter">
                                    <img src="<spring:theme code="logoImage"/>" alt="">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input type="text" id="j_username" name="j_username" tabindex="1" class="inputWithIcon" placeholder="<fmt:message key='login.username'/>" maxlength="16" validation="required">
                                    <span class="ui-icon ui-icon-person right" title="<fmt:message key='login.register'/>" onClick="toggleForm('registration');"></span>
                                </td>
                            </tr>
                            <tr>
                                <td style="padding-bottom:10px">
                                    <input type="password" id="j_password" name="j_password" tabindex="2" class="inputWithIcon" placeholder="<fmt:message key='login.password'/>" validation="required">
                                    <span class="ui-icon ui-icon-key right" title="<fmt:message key='login.forgot'/>" onClick="toggleForm('forgotpass');"></span>
                                </td>
                            </tr>
                            <tr>
                                <td class="detail aligncenter">
                                    <input type="checkbox" id="j_remember" name="_acegi_security_remember_me" tabindex="3" class="checkbox">
                                    <label for="j_remember" class="left"><fmt:message key="login.remember"/></label>
                                    <button type="submit" id="j_login" tabindex="4" class="right"><fmt:message key="login.login"/></button>
                                </td>
                            </tr>
                        </table>
                    </form>
                    <form id="loginframeregistrationform" action="login.view?register" method="post" class="ui-helper-hidden">
                        <input type="hidden" name="redirect" value="1"/>
                        <table class="center">
                            <tr>
                                <td colspan="2" align="left" style="padding-bottom:10px"><h1><fmt:message key="login.register"/></h1></td>
                            </tr>
                            <tr>
                                <td>
                                    <input type="text" id="r_username" name="r_username" tabindex="5" class="inputWithIcon" maxlength="16" placeholder="<fmt:message key='login.username'/>" validation="required">
                                    <span class="ui-icon ui-icon-person right" title="<fmt:message key='login.username'/>"> </span>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input type="email" id="r_email" name="r_email" tabindex="6" class="inputWithIcon" placeholder="<fmt:message key='login.email'/>" validation="required email">
                                    <span class="ui-icon ui-icon-mail-closed right" title="<fmt:message key='login.email'/>"> </span>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input type="password" id="r_password" name="r_password" tabindex="7" class="inputWithIcon" placeholder="<fmt:message key='login.password'/>" validation="required">
                                    <span class="ui-icon ui-icon-key right" title="<fmt:message key='login.password'/>"> </span>
                                </td>
                            </tr>
                            <tr>
                                <td style="padding-bottom:10px">
                                    <input type="password" id="r_cpassword" name="r_cpassword" tabindex="8" class="inputWithIcon" placeholder="<fmt:message key='login.register.cpassword'/>" validation="required">
                                    <span class="ui-icon ui-icon-flag right" title="<fmt:message key='login.register.cpassword'/>"> </span>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <img src="captcha.view?" style="background-image:url('icons/captcha.png');" class="inputWithIcon ui-corner-all captcha">
                                    <span class="ui-icon ui-icon-refresh right" title="<fmt:message key='login.captcha.refresh'/>"> </span>
                                </td>
                            </tr>
                            <tr>
                                <td style="padding-bottom:10px">
                                    <input type="text" id="r_captcha" name="r_captcha" tabindex="9" class="inputWithIcon" placeholder="<fmt:message key='login.captcha'/>" validation="required">
                                    <span class="ui-icon ui-icon-locked right" title="<fmt:message key='login.captcha'/>"> </span>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <button type="reset" id="r_cancel" class="left"><fmt:message key="common.cancel"/></button>
                                    <button type="submit" id="r_submit" tabindex="10" class="right"><fmt:message key="login.register"/></button>
                                </td>
                            </tr>
                        </table>
                    </form>
                    <form id="loginframeforgotpassform" action="login.view?forgotpass" method="post" class="ui-helper-hidden">
                        <table class="center">
                            <tr>
                                <td style="padding-bottom:10px"><h1><fmt:message key="login.forgot"/></h1></td>
                            </tr>
                            <tr>
                                <td style="padding-bottom:10px">
                                    <input type="email" id="f_email" name="f_email" tabindex="11" class="inputWithIcon" placeholder="<fmt:message key='login.email'/>" validation="required email">
                                    <span class="ui-icon ui-icon-mail-closed right" title="<fmt:message key='login.email'/>"> </span>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <img src="captcha.view?" style="background-image:url('icons/captcha.png');" class="inputWithIcon ui-corner-all captcha">
                                    <span class="ui-icon ui-icon-refresh right" title="<fmt:message key='login.captcha.refresh'/>"> </span>
                                </td>
                            </tr>
                            <tr>
                                <td style="padding-bottom:10px">
                                    <input type="text" id="f_captcha" name="f_captcha" tabindex="12" class="inputWithIcon" placeholder="<fmt:message key='login.captcha'/>" validation="required">
                                    <span class="ui-icon ui-icon-locked right" title="<fmt:message key='login.captcha'/>"> </span>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <button type="reset" id="f_cancel" class="left"><fmt:message key="common.cancel"/></button>
                                    <button type="submit" id="f_submit" tabindex="13" class="right"><fmt:message key="login.forgot.reset"/></button>
                                </td>
                            </tr>
                        </table>
                    </form>
                </div>
            </div>
        </div>
    </body>
        <script type="text/javascript">
            var wait = false;
            jQueryLoad.wait(function() {
                jHistoryLoad = $LAB
                    .script({src:"script/plugins/jquery.history.min.js", test:"History.enabled"})
                        .wait(function() {
                            (function(window, undefined){
                                var History = window.History;
                                if ( !History.enabled ) return false;
                                History.replaceState('login.view?', 'Subsonic', 'login');
                            })(window);
                        });
                jQueryUILoad.wait(function() {
                    jAlertLoad = $LAB
                        .script({src:"script/plugins/jquery-ui.alert.min.js", test:"$.writeAlert"})
                            .wait(function() {
                                if (${not model.secured}) {
                                    $("#loginframelogonmessage").writeError({
                                        msg : '<fmt:message key="login.insecure"><fmt:param value="${model.brand}"/></fmt:message>',
                                        id : "insecuremessage"
                                    });
                                }
                                if (${model.logout}) $("#loginframelogonmessage").writeAlert({ msg : "<fmt:message key='login.logout'/>", id : "logoutmessage" }).delay(3000).slideUp("fast");
                                if (${model.error}) $("#loginframelogonmessage").writeError({ msg : "<fmt:message key='login.error'/>", id : "errormessage" }).delay(1000).slideUp("fast");
                                if (${model.register}) $("#loginframelogonmessage").writeAlert({ msg : "<fmt:message key='login.register.complete'/>", id : "registermessage"}).click(function() { $(this).delay(1000).slideUp("fast") });
                                if (${model.forgotpass}) $("#loginframelogonmessage").writeAlert({ msg : "<fmt:message key='login.forgot.complete'/>", id : "forgotpassmessage"}).click(function() { $(this).delay(1000).slideUp("fast") });
                            });

                    $("#loginframelogonform").validation().stylize();
                    $("#loginframeregistrationform").validation().stylize();
                    $("#loginframeforgotpassform").validation().stylize();
                    $("#r_cancel").click(function() { $(toggleForm('registration')) });
                    $("#f_cancel").click(function() { $(toggleForm('forgotpass')) });
                    $(".loginframe").show("clip");
                });
            });
            function toggleForm(option) {
                if (wait) return;
                var anim = function() {
                    wait = true;
                    switch (true) {
                        case (option == "registration" && $("#loginframeregistrationform").is(":visible")): $("#loginframeformcontainer").animate({ "padding-bottom" : "300px" }); break // Toggle Registration OFF
                        case (option == "forgotpass" && $("#loginframeforgotpassform").is(":visible")): $("#loginframeformcontainer").animate({ "padding-bottom" : "300px" }); break; // Toggle Forgotpass OFF
                        case (option == "registration"): $("#loginframeformcontainer").animate({ "padding-bottom" : "0px" }); break; // Toggle Registration ON
                        case (option == "forgotpass"): $("#loginframeformcontainer").animate({ "padding-bottom" : "85px" }); break; // Toggle Forgotpass ON
                    }
                    switch(option) {
                        case "registration":
                            if ($("#loginframeforgotpassform").is(":visible")) {
                                $("#loginframeforgotpassform").slideUp();
                            }
                            return $("#loginframeregistrationform").toggle("blind");
                        case "forgotpass":
                            if ($("#loginframeregistrationform").is(":visible")) {
                                $("#loginframeregistrationform").slideUp();
                            }
                            return $("#loginframeforgotpassform").toggle("blind")
                    }
                }
                $.when(anim()).done(function() {
                    wait = false;
                });
            }
        </script>
</html>
