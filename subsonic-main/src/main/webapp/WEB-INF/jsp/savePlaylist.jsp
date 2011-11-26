<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1" %>
<%@ include file="doctype.jsp" %>

<html>
    <head>
        <%@ include file="head.jsp" %>
    </head>
    <body class="mainframe bgcolor1">
        <div id="mainframecontainer" class="fillframe">
            <div id="mainframemenucontainer" class="bgcolor1 fade vcenterouter fillwidth">
                <span id="mainframemenuleft" class="vcenterinner">
                    <span class="vcenter">
                        <form:form commandName="command" method="post" action="savePlaylist.view">
                            <fmt:message key="playlist.save.name"/>
                            <form:input path="name" size="30"/>
                            <fmt:message key="playlist.save.format"/>
                            <form:select path="suffix">
                                <c:forEach items="${command.formats}" var="format" varStatus="loopStatus">
                                    <form:option value="${format}" label="${format}"/>
                                </c:forEach>
                            </form:select>
                            <button type="submit" class="ui-icon-disk"><fmt:message key="playlist.save.save"/></button>
                            <span class="right warning"> <form:errors path="name"/> </span>
                        </form:form>
                    </span>
                </span>
            </div>

            <div id="mainframecontentcontainer">
                <div id="mainframecontent">
                    <div id="mainframecontentheader" class="fade">
                        <h1>
                            <span class="desc"><fmt:message key="playlist.save.title"/></span>
                        </h1>
                    </div>
                </div>
            </div>
        </div>
    </body>
    <script type="text/javascript">
        jQueryLoad.wait(function() {
            jQueryUILoad.wait(function() {
                $("#mainframemenucontainer").stylize();
            });
        });
    </script>
</html>