<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1" %>
<%@ include file="doctype.jsp" %>

<html>
    <head>
        <%@ include file="head.jsp" %>
    </head>

    <body class="mainframe bgcolor1">
        <c:import url="settingsHeader.jsp">
            <c:param name="cat" value="advanced"/>
        </c:import>

        <form:form id="advancedsettingsform" method="post" action="advancedSettings.view" commandName="command">

            <table>

                <tr>
                    <td><fmt:message key="advancedsettings.downsamplecommand"/></td>
                    <td>
                        <form:input path="downsampleCommand" size="70"/>
                        <c:import url="helpToolTip.jsp"><c:param name="topic" value="downsamplecommand"/></c:import>
                    </td>
                </tr>

                <tr><td colspan="2">&nbsp;</td></tr>

                <tr>
                    <td><fmt:message key="advancedsettings.coverartlimit"/></td>
                    <td>
                        <form:input path="coverArtLimit" size="8"/>
                        <c:import url="helpToolTip.jsp"><c:param name="topic" value="coverartlimit"/></c:import>
                    </td>
                </tr>

                <tr>
                    <td><fmt:message key="advancedsettings.downloadlimit"/></td>
                    <td>
                        <form:input path="downloadLimit" size="8"/>
                        <c:import url="helpToolTip.jsp"><c:param name="topic" value="downloadlimit"/></c:import>
                    </td>
                </tr>

                <tr>
                    <td><fmt:message key="advancedsettings.uploadlimit"/></td>
                    <td>
                        <form:input path="uploadLimit" size="8"/>
                        <c:import url="helpToolTip.jsp"><c:param name="topic" value="uploadlimit"/></c:import>
                    </td>
                </tr>

                <tr>
                    <td><fmt:message key="advancedsettings.streamport"/></td>
                    <td>
                        <form:input path="streamPort" size="8"/>
                        <c:import url="helpToolTip.jsp"><c:param name="topic" value="streamport"/></c:import>
                    </td>
                </tr>

                <tr><td colspan="2">&nbsp;</td></tr>

                <tr>
                    <td colspan="2">
                        <form:checkbox path="ldapEnabled" id="ldap" cssClass="checkbox" onclick="toggleLdapFields()"/>
                        <label for="ldap"><fmt:message key="advancedsettings.ldapenabled"/></label>
                        <c:import url="helpToolTip.jsp"><c:param name="topic" value="ldap"/></c:import>
                    </td>
                </tr>

                <tr>
                    <td colspan="2">
                        <table class="indent" id="ldapTable" style="padding-left:2em">
                            <tr>
                                <td><fmt:message key="advancedsettings.ldapurl"/></td>
                                <td colspan="3">
                                    <form:input path="ldapUrl" size="70"/>
                                    <c:import url="helpToolTip.jsp"><c:param name="topic" value="ldapurl"/></c:import>
                                </td>
                            </tr>

                            <tr>
                                <td><fmt:message key="advancedsettings.ldapsearchfilter"/></td>
                                <td colspan="3">
                                    <form:input path="ldapSearchFilter" size="70"/>
                                    <c:import url="helpToolTip.jsp"><c:param name="topic" value="ldapsearchfilter"/></c:import>
                                </td>
                            </tr>

                            <tr>
                                <td><fmt:message key="advancedsettings.ldapmanagerdn"/></td>
                                <td>
                                    <form:input path="ldapManagerDn" size="20"/>
                                </td>
                                <td><fmt:message key="advancedsettings.ldapmanagerpassword"/></td>
                                <td>
                                    <form:password path="ldapManagerPassword" size="20"/>
                                    <c:import url="helpToolTip.jsp"><c:param name="topic" value="ldapmanagerdn"/></c:import>
                                </td>
                            </tr>

                            <tr>
                                <td colspan="5">
                                    <form:checkbox path="ldapAutoShadowing" id="ldapAutoShadowing" cssClass="checkbox"/>
                                    <label for="ldapAutoShadowing"><fmt:message key="advancedsettings.ldapautoshadowing"><fmt:param value="${command.brand}"/></fmt:message></label>
                                    <c:import url="helpToolTip.jsp"><c:param name="topic" value="ldapautoshadowing"/></c:import>
                                </td>
                            </tr>
                        </table>
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
        if (${command.reloadNeeded}) {
            parent.frames.left.location.href="left.view?";
            parent.frames.playlist.location.href="playlist.view?";
        }

        function toggleLdapFields() {
            var b = $("#ldap").attr("checked") ? true : false;
            $("#ldapTable").toggle(b);
        }

        jQueryLoad.wait(function() {
            $(toggleLdapFields);
            jQueryUILoad.wait(function() {
                $(init);
            });
        });
    </script>
</html>