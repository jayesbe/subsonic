<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1" %>
<%@ include file="doctype.jsp" %>

<html>
    <head>
        <%@ include file="head.jsp" %>
        <script type="text/javascript" src="https://apis.google.com/js/plusone.js"></script>
    </head>
    <body class="mainframe bgcolor1">
        <div id="mainframecontainer" class="fillframe">
            <div id="mainframemenucontainer" class="bgcolor1 fade vcenterouter fillwidth">
                <span id="mainframemenuleft" class="vcenterinner">
                    <c:if test="${not empty model.dir}">
                        <sub:url value="main.view" var="backUrl"><sub:param name="path" value="${model.dir.path}"/></sub:url>
                        <button onClick="location.href='${backUrl}'" class="ui-icon-triangle-1-w ui-icon-primary vcenter"><fmt:message key="common.back"/></button>
                    </c:if>
                </span>
                <span id="mainframemenuright" class="vcenterinner">
                    <c:if test="${model.user.settingsRole}">
                        <button onClick="location.href='shareSettings.view'" class="vcenter right ui-icon-wrench ui-icon-secondary"><fmt:message key="share.manage"/></button>
                    </c:if>
                </span>
            </div>

            <div id="mainframecontentcontainer">
                <div id="mainframecontent">

                    <div id="mainframecontentheader" class="fade">
                        <h1>
                            <span class="desc"><fmt:message key="share.title"/></span>
                        </h1>
                    </div>

                    <blockquote class="fade">
                        <c:choose>
                            <c:when test="${model.urlRedirectionEnabled}">
                                <fmt:message key="share.warning"/>
                                <p>
                                    <a href="http://www.facebook.com/sharer.php?u=${model.playUrl}" target="_blank"><img src="<spring:theme code="shareFacebookImage"/>" alt=""></a>&nbsp;
                                    <a href="http://www.facebook.com/sharer.php?u=${model.playUrl}" target="_blank"><fmt:message key="share.facebook"/></a>
                                </p>
                        
                                <p>
                                    <a href="http://twitter.com/?status=Listening to ${model.playUrl}" target="_blank"><img src="<spring:theme code="shareTwitterImage"/>" alt=""></a>&nbsp;
                                    <a href="http://twitter.com/?status=Listening to ${model.playUrl}" target="_blank"><fmt:message key="share.twitter"/></a>
                                </p>
                                <p>
                                    <g:plusone size="small" annotation="none" href="${model.playUrl}"></g:plusone>&nbsp;<fmt:message key="share.googleplus"/>
                                </p>
                                <p>
                                    <fmt:message key="share.link">
                                        <fmt:param>${model.playUrl}</fmt:param>
                                    </fmt:message>
                                </p>
                            </c:when>
                            <c:otherwise>
                                <p>
                                    <fmt:message key="share.disabled"/>
                                </p>
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
                $("#mainframemenucontainer").stylize();
            });
        });
    </script>
</html>