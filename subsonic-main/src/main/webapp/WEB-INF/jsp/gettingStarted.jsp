<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1" %>
<%@ include file="doctype.jsp" %>

<html>
    <head>
        <%@ include file="head.jsp" %>
    </head>
    <body class="mainframe bgcolor1">
        <div id="mainframecontainer" class="fillframe">
            <div id="mainframemenucontainer" class="bgcolor1 fade vcenterouter fillwidth">
                <span id="mainframemenuright" class="vcenterinner">
                    <button id="hideGettingStarted" onClick="javascript:hideGettingStarted()" class="vcenter right"><fmt:message key="gettingStarted.hide"/></button>
                </span>
            </div>

            <div id="hideGettingStartedMessage" style="display:none;" title="<fmt:message key='gettingStarted.title'/>"><fmt:message key="gettingStarted.hidealert"/></div>
            <div id="mainframecontentcontainer">
                <div id="mainframecontent">
                    <div id="mainframecontentheader" class="fade">
                        <h1>
                            <img id="pageimage" src="<spring:theme code="homeImage"/>" alt="" />
                            <span class="desc"><fmt:message key="gettingStarted.title"/></span>
                        </h1>
                    </div>

                    <div class="fade">
                        <fmt:message key="gettingStarted.text"/>

                        <table id="gettingStarted" style="padding-top:1em;padding-bottom:2em;width:60%">
                            <tr>
                                <td style="font-size:26pt;padding:20pt">1</td>
                                <td>
                                    <div style="font-size:14pt"><a href="userSettings.view?userIndex=0"><fmt:message key="gettingStarted.step1.title"/></a></div>
                                    <div style="padding-top:5pt"><fmt:message key="gettingStarted.step1.text"/></div>
                                </td>
                            </tr>
                            <tr>
                                <td style="font-size:26pt;padding:20pt">2</td>
                                <td>
                                    <div style="font-size:14pt"><a href="musicFolderSettings.view"><fmt:message key="gettingStarted.step2.title"/></a></div>
                                    <div style="padding-top:5pt"><fmt:message key="gettingStarted.step2.text"/></div>
                                </td>
                            </tr>
                            <tr>
                                <td style="font-size:26pt;padding:20pt">3</td>
                                <td>
                                    <div style="font-size:14pt"><a href="networkSettings.view"><fmt:message key="gettingStarted.step3.title"/></a></div>
                                    <div style="padding-top:5pt"><fmt:message key="gettingStarted.step3.text"/></div>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </body>
    <script type="text/javascript">
        jQueryLoad.wait(function() {
            jQueryUILoad.wait(function() {
                $("#mainframemenucontainer").stylize();
                $("#hideGettingStarted").click(function() {
                    $("#hideGettingStartedMessage").dialog({
                        modal: true,
                        buttons: {
                            Ok: function() {
                                $(this).dialog( "close" );
                                location.href = "gettingStarted.view?hide";
                            }
                        }
                    });
                });
            });
        });
    </script>
</html>