<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1" %>
<%@ include file="doctype.jsp" %>

<html>
    <head>
        <meta http-equiv="X-UA-Compatible" content="IE=9" />
        <%@ include file="head.jsp" %>
        <!--[if IE 7]>
        <![endif]-->
    </head>
    <body class="bgcolor2 topframe">
        <fmt:message key="top.home" var="home"/>
        <fmt:message key="top.now_playing" var="nowPlaying"/>
        <fmt:message key="top.settings" var="settings"/>
        <fmt:message key="top.status" var="status"/>
        <fmt:message key="top.podcast" var="podcast"/>
        <fmt:message key="top.chat" var="chat"/>
        <fmt:message key="top.more" var="more"/>
        <fmt:message key="top.help" var="help"/>
        <fmt:message key="top.about" var="about"/>
        <fmt:message key="top.donate" var="donate"/>
        <fmt:message key="top.search" var="search"/>
        <fmt:message key="top.upload" var="upload"/>
        
        <div id="topframecontainer" style="display:none">

            <div id="logocontainer">
                <div id="logo"><img src="<spring:theme code='logoImage'/>"></div>
            </div>

            <div id="topframemenucontainer">

                <c:if test="${not model.musicFoldersExist}">
                    <div style="padding-right:2em">
                        <p class="warning"><fmt:message key="top.missing"/></p>
                    </div>
                </c:if>

                <div class="topimgcontainer">
                    <div class="topimg">
                    <sub:url value="home.view" var="homeUrl">
                        <sub:param name="listType" value="${model.listType}"/>
                        <sub:param name="listRows" value="${model.listRows}"/>
                        <sub:param name="listColumns" value="${model.listColumns}"/>
                    </sub:url>
                     <a href="${homeUrl}" target="main" class="TriggerEffect" id="homeLink">
                        <img id="MenuImg" src="<spring:theme code='homeImage'/>" title="${home}" alt="${home}"/>
                     </a>
                     <div class="desc"><a href="${homeUrl}" target="main" id="homeLinkDesc">${home}</a></div> 
                    </div>
                </div>

                <div class="topimgcontainer">
                    <div class="topimg">
                     <a href="nowPlaying.view?" target="main" class="TriggerEffect">
                        <img id="MenuImg" src="<spring:theme code='nowPlayingImage'/>" title="${nowPlaying}" alt="${nowPlaying}" class="hovtive">
                     </a>
                     <div class="desc"><a href="nowPlaying.view?" target="main">${nowPlaying}</a></div>
                    </div>
                </div>
                
                <div class="topimgcontainer">
                    <div class="topimg">
                     <a href="podcastReceiver.view?" target="main" id="podcastLink">
                        <img id="MenuImg" src="<spring:theme code='podcastImage'/>" title="${podcast}" alt="${podcast}">
                     </a>
                     <div class="desc"><a href="podcastReceiver.view?" target="main" id="podcastLinkDesc">${podcast}</a></div>
                    </div>
                </div>
                
                <c:if test="${model.user.settingsRole}">
                <div class="topimgcontainer">
                    <div class="topimg">
                     <a href="settings.view?" target="main" id="settingsLink">
                        <img id="MenuImg" src="<spring:theme code='settingsImage'/>" title="${settings}" alt="${settings}">
                     </a>
                     <div class="desc"><a href="settings.view?" target="main" id="settingsLinkDesc">${settings}</a></div>
                    </div>
                </div>
                </c:if>
                
                <c:if test="${model.user.adminRole}">
                <div class="topimgcontainer">
                    <div class="topimg">
                     <a href="status.view?" target="main" id="statusLink">
                        <img id="MenuImg" src="<spring:theme code='statusImage'/>" title="${status}" alt="${status}">
                     </a>
                     <div class="desc"><a href="status.view?" target="main" id="statusLinkDesc">${status}</a></div>
                    </div>
                </div>
                </c:if>
                
                <!--
                <div class="topimgcontainer">
                    <div class="topimg">
                     <a href="javascript:chatwindow()">
                        <img id="MenuImg" src="<spring:theme code='chatImage'/>" title="${chat}" alt="${chat}">
                     </a>
                     <div class="desc"><a href="javascript:chatwindow()">${chat}</a></div>
                    </div>
                </div>
                -->

                <div class="topimgcontainer">
                    <div class="topimg">
                     <a href="more.view?" target="main">
                        <img id="MenuImg" src="<spring:theme code='moreImage'/>" title="${more}" alt="${more}">
                     </a>
                     <div class="desc"><a href="more.view?" target="main">${more}</a></div>
                    </div>
                </div>
                
                <c:if test="${model.user.adminRole}">
                <div class="topimgcontainer">
                    <div class="topimg">
                     <a href="about.view?" target="main">
                        <img id="MenuImg" src="<spring:theme code='aboutImage'/>" title="${about}" alt="${about}">
                     </a>
                     <div class="desc"><a href="about.view?" target="main">${about}</a></div>
                    </div>
                </div>
                </c:if>
                
                <!--
                <c:if test="${model.user.uploadRole}">
                <div class="topimgcontainer">
                    <div class="topimg">
                     <a href="javascript:newwindow()">
                        <img id="MenuImg" src="<spring:theme code='uploadImage'/>" title="${upload}" alt="${upload}"/>
                     </a>
                     <div class="desc"><a href="javascript:newwindow()">${upload}</a></div>
                    </div>
                </div>
                </c:if>

                <c:if test="not ${model.user.adminRole}">
                <div class="topimgcontainer">
                    <div class="topimg">
                     <a href="https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=6ZTB47DYWFS64" target="_blank"><SPAN></SPAN>
                        <img id="MenuImg" src="<spring:theme code='donateImage'/>" title="${donate}" alt="${donate}">
                     </a>
                     <div class="desc"><a href="https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=A8EU47TDXU3YA" target="_blank">${donate}</a></div>
                    </div>
                </div>
                </c:if>
                -->
            </div>
            <div id="topframemenucontainer">
                <span class="right">
                    <%@ include file="searchbox.jsp" %>
                </span>
            </div>

            <div id="topframerightmenucontainer">
                <div id="topframerightmenu">
                    <c:if test="${model.newVersionAvailable}">
                        <p class="warning center">
                        <fmt:message key="top.upgrade"><fmt:param value="${model.brand}"/><fmt:param value="${model.latestVersion}"/></fmt:message>
                        </p>
                    </c:if>
                    <p class="center">
                        <a href="j_acegi_logout" target="_top"><fmt:message key="top.logout"><fmt:param value="${model.user.username}"/></fmt:message></a>
                        <c:if test="${not model.licensed}">
                            <br><br>
                            <a href="donate.view" target="main"><img src="<spring:theme code="donateSmallImage"/>" alt=""></a>
                            <a href="donate.view" target="main"><fmt:message key="donate.title"/></a>
                        </c:if>
                    </p>
                </div>
            </div>
        </div>
        <script type="text/javascript">
            jQueryLoad.wait(function() {
                jQueryUILoad.wait(function() {
                        jQuery("#topframecontainer").show("drop", 600);
                });
            });
        </script>
    </body>
</html>