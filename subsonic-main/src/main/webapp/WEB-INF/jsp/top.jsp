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
        <fmt:message key='search.query' var="query"/>
        
        <div id="topframecontainer" class="fillframe vcenterouter" style="display:none;">

            <span id="topframelogocontainer" class="vcenterinner">
                <img id="logo" class="vcenter" src="<spring:theme code='logoImage'/>">
            </span>

            <span id="topframemenucontainer" class="vcenterinner">
                <span id="topframemenuleft" class="vcenter">
                    <span class="topimgcontainer inline">
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
                    </span>

                    <span class="topimgcontainer inline">
                        <div class="topimg">
                         <a href="nowPlaying.view?" target="main" class="TriggerEffect">
                            <img id="MenuImg" src="<spring:theme code='nowPlayingImage'/>" title="${nowPlaying}" alt="${nowPlaying}" class="hovtive">
                         </a>
                         <div class="desc"><a href="nowPlaying.view?" target="main">${nowPlaying}</a></div>
                        </div>
                    </span>
                    
                    <span class="topimgcontainer inline">
                        <div class="topimg">
                         <a href="podcastReceiver.view?" target="main" id="podcastLink">
                            <img id="MenuImg" src="<spring:theme code='podcastImage'/>" title="${podcast}" alt="${podcast}">
                         </a>
                         <div class="desc"><a href="podcastReceiver.view?" target="main" id="podcastLinkDesc">${podcast}</a></div>
                        </div>
                    </span>
                    
                    <c:if test="${model.user.settingsRole}">
                    <span class="topimgcontainer inline">
                        <div class="topimg">
                         <a href="settings.view?" target="main" id="settingsLink">
                            <img id="MenuImg" src="<spring:theme code='settingsImage'/>" title="${settings}" alt="${settings}">
                         </a>
                         <div class="desc"><a href="settings.view?" target="main" id="settingsLinkDesc">${settings}</a></div>
                        </div>
                    </span>
                    </c:if>
                    
                    <c:if test="${model.user.adminRole}">
                    <span class="topimgcontainer inline">
                        <div class="topimg">
                         <a href="status.view?" target="main" id="statusLink">
                            <img id="MenuImg" src="<spring:theme code='statusImage'/>" title="${status}" alt="${status}">
                         </a>
                         <div class="desc"><a href="status.view?" target="main" id="statusLinkDesc">${status}</a></div>
                        </div>
                    </span>
                    </c:if>

                    <span class="topimgcontainer inline">
                        <div class="topimg">
                         <a href="more.view?" target="main" id="moreLink">
                            <img id="MenuImg" src="<spring:theme code='moreImage'/>" title="${more}" alt="${more}">
                         </a>
                         <div class="desc"><a href="more.view?" target="main" id="moreLinkDesc">${more}</a></div>
                        </div>
                    </span>
                    
                    <c:if test="${model.user.adminRole}">
                    <span class="topimgcontainer inline">
                        <div class="topimg">
                         <a href="about.view?" target="main">
                            <img id="MenuImg" src="<spring:theme code='aboutImage'/>" title="${about}" alt="${about}">
                         </a>
                         <div class="desc"><a href="about.view?" target="main">${about}</a></div>
                        </div>
                    </span>
                    </c:if>
                </span>
            </span>
            <c:if test="${not model.musicFoldersExist || model.newVersionAvailable}">
            <span id="topframenotificationmessagecontainer" class="vcenterinner">
                <div id="topframenotificationmessage" class="vcenterinner ui-helper-hidden"></div>
            </span>
            </c:if>
            <span id="topframesearchboxcontainer" class="vcenterinner">
                <span class="right">
                    <c:import url="searchbox.jsp">
                        <c:param name="action" value="search.view"/>
                        <c:param name="value" value="${query}"/>
                        <c:param name="title" value="${search}"/>
                    </c:import>
                </span>
            </span>
            <span id="topframelogoutcontainer" class="vcenterinner aligncenter">
                <button onClick="javascript:parent.location.href='j_acegi_logout'" class="ui-icon-power ui-icon-secondary bold"><fmt:message key="top.logout"><fmt:param value="${model.user.username}"/></fmt:message></button>
                <c:if test="${not model.licensed}">
                <br><br>
                <button onClick="parent.main.location.href='donate.view'" class="ui-icon-heart ui-icon-secondary ui-state-error bold"><fmt:message key="donate.title"/></button>
                </c:if>
            </span>
        </div>
    </body>
    <script type="text/javascript">
        jQueryLoad.wait(function() {
            jQueryUILoad.wait(function() {
                jAlertLoad = $LAB
                    .script({src:"script/plugins/jquery-ui.alert.min.js", test:"$.writeAlert"})
                        .wait(function() {
                            if (${not model.musicFoldersExist}) $("#topframenotificationmessage").writeError({ msg : '<fmt:message key="top.missing"/>', id : "nomusicfoldermessage" });
                            if (${model.newVersionAvailable}) {
                                $("#topframenotificationmessage").writeAlert({ 
                                    msg : '<fmt:message key="top.upgrade"><fmt:param value="${model.brand}"/><fmt:param value="${model.latestVersion}"/></fmt:message>',
                                    id : "newversionmessage"
                                });
                            }
                        });
                $("#searchForm").validation().stylize();
                $("#topframelogoutcontainer").stylize();
                $("#topframecontainer").show("drop", 600);
            });
        });
    </script>
</html>