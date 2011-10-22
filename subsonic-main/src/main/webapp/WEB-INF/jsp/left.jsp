<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1"%>
<%@ include file="doctype.jsp" %>

<html>
    <head>
        <%@ include file="head.jsp" %>
        <script type="text/javascript" src="<c:url value="/script/scripts.js"/>"></script>
        <script type="text/javascript" src="<c:url value="/script/smooth-scroll.js"/>"></script>
        <script type="text/javascript" src="<c:url value="/script/jquery-1.6.4.min.js"/>"></script>
        <script type="text/javascript" src="<c:url value="/script/jquery-ui-1.8.16.custom.min.js"/>"></script>
        <script type="text/javascript" src="<c:url value="/script/niceforms2.js"/>"></script>
        <script>
            $(document).ready(function() {
            var icons = {
                    header: "ui-icon-circle-arrow-e",
                    headerSelected: "ui-icon-circle-arrow-s"
                };
            $("#accordion").accordion( {active: false, autoHeight: false, navigation: true, collapsible: true, icons: icons} );    
          });
        </script>
        <!--[if lte IE 8]>
            <style type="text/css" media="screen">
                /* use static images */
            </style>
        <![endif]-->
        <!--[if IE 7]>
            <style type="text/css" media="screen">
                .ui-accordion-header h3 { position:fixed; display:inline-block; }
            </style>
        <![endif]-->
    </head>

    <body class="bgcolor1 leftframe">

        <div id="leftframecontainer">

            <div id="leftframemenucontainer" class="bgcolor1">
                <div id="musicfoldercontainer">
                    <c:if test="${fn:length(model.musicFolders) > 1}">
                        <select id="musicFolder" name="musicFolderId" onChange="location='left.view?musicFolderId=' + options[selectedIndex].value;">
                            <option value="-1"><fmt:message key="left.allfolders"/></option>
                            <c:forEach items="${model.musicFolders}" var="musicFolder">
                                <option ${model.selectedMusicFolder.id == musicFolder.id ? "selected" : ""} value="${musicFolder.id}">${musicFolder.name}</option>
                            </c:forEach>
                        </select>
                    </c:if>
                </div>
            </div>
            <a name="top"></a>

            <c:if test="${not empty model.podcast}">
                <h2 class="bgcolor1 messagecontent"><fmt:message key="left.podcast"/></h2>
                <c:forEach items="${model.podcast}" var="radio">
                    <p class="dense"  style="margin-left:15px;">
                        <a target="hidden" href="${episode.path}">
                            <img src="<spring:theme code="playImage"/>" alt="<fmt:message key="common.play"/>" title="<fmt:message key="common.play"/>"></a>
                        <c:choose>
                            <c:when test="${empty episode.path}">
                                ${radio.name}
                            </c:when>
                            <c:otherwise>
                                <a target="main" href="${episode.path}">${radio.name}</a>
                            </c:otherwise>
                        </c:choose>
                    </p>
                </c:forEach>
            </c:if>


            <div id="accordioncontainer">
                <div id="accordion">
                    <c:if test="${model.statistics.songCount gt 0}">
                        <h3><a name="#"><fmt:message key="left.index"/></a></h3>
                        <div>
                            <p class="dense" style="padding-left:0.5em">
                                    <fmt:message key="left.statistics">
                                    <fmt:param value="${model.statistics.artistCount}"/>
                                    <fmt:param value="${model.statistics.albumCount}"/>
                                    <fmt:param value="${model.statistics.songCount}"/>
                                    <fmt:param value="${model.bytes}"/>
                                    <fmt:param value="${model.hours}"/>
                                    <span class="indexhrs"><fmt:param value="${model.hours}"/></span>
                                </fmt:message>
                            </p>
                        </div>
                    </c:if>

                    <c:if test="${not empty model.shortcuts}">
                        <h3><a name="#"><fmt:message key="left.shortcut"/></a></h3>
                        <div>
                        <c:forEach items="${model.shortcuts}" var="shortcut">
                            <p class="dense" style="padding-left:0.5em">
                                <span title="${shortcut.name}">
                                    <sub:url value="main.view" var="mainUrl">
                                        <sub:param name="path" value="${shortcut.path}"/>
                                    </sub:url>
                                    <a target="main" href="${mainUrl}">${shortcut.name}</a>
                                </span>
                            </p>
                        </c:forEach>
                        </div>
                    </c:if>

                    <c:if test="${not empty model.radios}">
                        <h3><a name="#"><fmt:message key="left.radio"/></a></h3>
                        <div>
                        <c:forEach items="${model.radios}" var="radio">
                            <p class="dense"  style="margin-left:15px;">
                                <a target="hidden" href="${radio.streamUrl}">
                                    <img src="<spring:theme code="playImage"/>" alt="<fmt:message key="common.play"/>" title="<fmt:message key="common.play"/>"></a>
                                <c:choose>
                                    <c:when test="${empty radio.homepageUrl}">
                                        ${radio.name}
                                    </c:when>
                                    <c:otherwise>
                                        <a target="main" href="${radio.homepageUrl}">${radio.name}</a>
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </c:forEach>
                        </div>
                    </c:if>

                    <c:forEach items="${model.indexedArtists}" var="entry">
                        <h3><a name="#">${entry.key.index}</a></h3>
                        <div>
                        <c:forEach items="${entry.value}" var="artist">
                            <p class="dense" style="padding-left:0.5em">
                                <span title="${artist.name}">
                                    <sub:url value="main.view" var="mainUrl">
                                        <c:forEach items="${artist.musicFiles}" var="musicFile">
                                            <sub:param name="path" value="${musicFile.path}"/>
                                        </c:forEach>
                                    </sub:url>
                                    <a target="main" href="${mainUrl}"><str:truncateNicely upper="${model.captionCutoff}">${artist.name}</str:truncateNicely></a>
                                </span>
                            </p>
                        </c:forEach>
                        </div>
                    </c:forEach>
                </div>

                <c:if test="${not empty model.singleSongs}">
                    <!--<h3><a name="#"><fmt:message key="left.index"/></a></h3>
                    <div>-->
                    <c:forEach items="${model.singleSongs}" var="song">
                        <p class="dense" style="padding-left:0.5em">
                            <span title="${song.title}">
                                <c:import url="playAddDownload.jsp">
                                    <c:param name="path" value="${song.path}"/>
                                    <c:param name="playEnabled" value="${model.user.streamRole and not model.partyMode}"/>
                                    <c:param name="addEnabled" value="${model.user.streamRole}"/>
                                    <c:param name="downloadEnabled" value="${model.user.downloadRole and not model.partyMode}"/>
                                    <c:param name="video" value="${song.video and model.player.web}"/>
                                </c:import>
                                <str:truncateNicely upper="${model.captionCutoff}">${song.title}</str:truncateNicely>
                            </span>
                        </p>
                    </c:forEach>
                    <!--</div>-->
                </c:if>
            </div>
        </div>
    </body>
</html>