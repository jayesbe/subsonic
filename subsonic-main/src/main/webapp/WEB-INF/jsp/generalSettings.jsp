<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1" %>
<%--@elvariable id="command" type="net.sourceforge.subsonic.command.GeneralSettingsCommand"--%>
<%@ include file="doctype.jsp" %>

<html>
    <head>
        <%@ include file="head.jsp" %>
    </head>

    <body class="mainframe bgcolor1">

        <c:import url="settingsHeader.jsp">
            <c:param name="cat" value="general"/>
        </c:import>

        <form:form id="generalsettingsform" method="post" action="generalSettings.view" commandName="command">
            <table>

                <tr>
                    <td><fmt:message key="generalsettings.language"/></td>
                    <td>
                        <form:select path="localeIndex" cssStyle="width:15em">
                            <c:forEach items="${command.locales}" var="locale" varStatus="loopStatus">
                                <form:option value="${loopStatus.count - 1}" label="${locale}"/>
                            </c:forEach>
                        </form:select>
                        <c:import url="helpToolTip.jsp"><c:param name="topic" value="language"/></c:import>
                    </td>
                </tr>

                <tr>
                    <td><fmt:message key="generalsettings.theme"/></td>
                    <td>
                        <form:select path="themeIndex" cssStyle="width:15em">
                            <c:forEach items="${command.themes}" var="theme" varStatus="loopStatus">
                                <form:option value="${loopStatus.count - 1}" label="${theme.name}"/>
                            </c:forEach>
                        </form:select>
                        <c:import url="helpToolTip.jsp"><c:param name="topic" value="theme"/></c:import>
                    </td>
                </tr>

                <tr>
                    <td><fmt:message key="generalsettings.webfont"/></td>
                    <td>
                        <form:input path="webFont" cssStyle="width:18em"/>
                        <c:import url="helpToolTip.jsp"><c:param name="topic" value="webfont"/></c:import>
                    </td>
                </tr>

                <tr>
                    <td><fmt:message key="generalsettings.mmapikey"/></td>
                    <td>
                        <form:input path="MMAPIKey" cssStyle="width:18em"/>
                        <c:import url="helpToolTip.jsp"><c:param name="topic" value="mmapikey"/></c:import>
                    </td>
                </tr>

                <tr><td colspan="2">&nbsp;</td></tr>

                <tr>
                    <td><fmt:message key="generalsettings.playlistfolder"/></td>
                    <td>
                        <form:input path="playlistFolder" size="70"/>
                        <c:import url="helpToolTip.jsp"><c:param name="topic" value="playlistfolder"/></c:import>
                    </td>
                </tr>

                <tr>
                    <td><fmt:message key="generalsettings.musicmask"/></td>
                    <td>
                        <form:input path="musicFileTypes" size="70"/>
                        <c:import url="helpToolTip.jsp"><c:param name="topic" value="musicmask"/></c:import>
                    </td>
                </tr>

                <tr>
                    <td><fmt:message key="generalsettings.videomask"/></td>
                    <td>
                        <form:input path="videoFileTypes" size="70"/>
                        <c:import url="helpToolTip.jsp"><c:param name="topic" value="videomask"/></c:import>
                    </td>
                </tr>

                <tr>
                    <td><fmt:message key="generalsettings.coverartmask"/></td>
                    <td>
                        <form:input path="coverArtFileTypes" size="70"/>
                        <c:import url="helpToolTip.jsp"><c:param name="topic" value="coverartmask"/></c:import>
                    </td>
                </tr>

                <tr><td colspan="2">&nbsp;</td></tr>

                <tr>
                    <td><fmt:message key="generalsettings.index"/></td>
                    <td>
                        <form:input path="index" size="70"/>
                        <c:import url="helpToolTip.jsp"><c:param name="topic" value="index"/></c:import>
                    </td>
                </tr>

                <tr>
                    <td><fmt:message key="generalsettings.ignoredarticles"/></td>
                    <td>
                        <form:input path="ignoredArticles" size="70"/>
                        <c:import url="helpToolTip.jsp"><c:param name="topic" value="ignoredarticles"/></c:import>
                    </td>
                </tr>

                <tr>
                    <td><fmt:message key="generalsettings.shortcuts"/></td>
                    <td>
                        <form:input path="shortcuts" size="70"/>
                        <c:import url="helpToolTip.jsp"><c:param name="topic" value="shortcuts"/></c:import>
                    </td>
                </tr>

                <tr><td colspan="2">&nbsp;</td></tr>

                <tr>
                    <td>
                    </td>
                    <td>
                        <form:checkbox path="gettingStartedEnabled" id="gettingStartedEnabled"/>
                        <label for="gettingStartedEnabled"><fmt:message key="generalsettings.showgettingstarted"/></label>
                    </td>
                </tr>
                <tr>
                    <td><fmt:message key="generalsettings.welcometitle"/></td>
                    <td>
                        <form:input path="welcomeTitle" size="70"/>
                        <c:import url="helpToolTip.jsp"><c:param name="topic" value="welcomemessage"/></c:import>
                    </td>
                </tr>
                <tr>
                    <td><fmt:message key="generalsettings.welcomesubtitle"/></td>
                    <td>
                        <form:input path="welcomeSubtitle" size="70"/>
                        <c:import url="helpToolTip.jsp"><c:param name="topic" value="welcomemessage"/></c:import>
                    </td>
                </tr>
                <tr>
                    <td style="vertical-align:top;"><fmt:message key="generalsettings.welcomemessage"/></td>
                    <td>
                        <form:textarea path="welcomeMessage" rows="8" cols="70"/>
                        <c:import url="helpToolTip.jsp"><c:param name="topic" value="welcomemessage"/></c:import>
                    </td>
                </tr>
                <tr>
                    <td style="vertical-align:top;"><fmt:message key="generalsettings.loginmessage"/></td>
                    <td>
                        <form:textarea path="loginMessage" rows="5" cols="70"/>
                        <c:import url="helpToolTip.jsp"><c:param name="topic" value="loginmessage"/></c:import>
                        <fmt:message key="main.wiki"/>
                    </td>
                </tr>

            </table>

        </form:form>
    </blockquote>
    </div>
    </div>
    </div>
    </body>
    <script type="text/javascript">
        if (${command.reloadNeeded}) parent.location.href="index.view?";
        jQueryLoad.wait(function() {
            jQueryUILoad.wait(function() {
                $(init);
            });
        });
    </script>
</html>