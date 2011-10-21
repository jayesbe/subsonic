<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1"%>
<%@ include file="doctype.jsp" %>

<html>
    <head>
        <%@ include file="head.jsp" %>

        <script type="text/javascript" language="javascript">
            function deletePlaylist(deleteUrl) {
                if (confirm("<fmt:message key='playlist.load.confirm_delete'/>")) {
                    location.href = deleteUrl;
                }
            }
            function loadPlaylistTest() {
                location.href = "loadPlaylistConfirm.view?nameUtf8Hex=" + document.getElementById("playlists").value;
            }    
        </script>
    </head>
    <body class="mainframe bgcolor1">
        <div id="mainframecontainer">
            <div id="mainframemenucontainer" class="bgcolor1">
                <span id="mainframemenuleft">
                    <select id="playlists" name="playlists">
                        <c:forEach items="${model.playlists}" var="playlist">
                            <sub:url value="loadPlaylistConfirm.view" var="loadUrl"><sub:param name="name" value="${playlist}"/></sub:url>
                            <sub:url value="appendPlaylistConfirm.view" var="appendUrl">
                                <sub:param name="name" value="${playlist}"/>
                                <sub:param name="player" value="${model.player}"/>
                                <sub:param name="dir" value="${model.dir}"/>
                                <c:forEach items="${model.indexes}" var="index">
                                    <sub:param name="i" value="${index}"/>
                                </c:forEach>
                            </sub:url>
                            <sub:url value="deletePlaylist.view" var="deleteUrl"><sub:param name="name" value="${playlist}"/></sub:url>
                            <sub:url value="download.view" var="downloadUrl"><sub:param name="playlist" value="${playlist}"/></sub:url>
                            <option value="<str:replace replace='loadPlaylistConfirm.view?nameUtf8Hex=' with=''>${loadUrl}</str:replace>">${playlist}</option>
                        </c:forEach>
                    </select>
                    <c:choose>
                        <c:when test="${model.load}">
                            <span class="forward"><a href="#" onClick="loadPlaylistTest()"><fmt:message key="playlist.load.load"/></a></span>
                            <c:if test="${model.user.downloadRole}">
                                <span class="forward"><a href="#" onClick="downloadPlaylist()"><fmt:message key="common.download"/></a></span>
                            </c:if>
                            <c:if test="${model.user.playlistRole}">
                                <span class="forward"><a href="#" onClick="deletePlaylist('${deleteUrl}')"><fmt:message key="playlist.load.delete"/></a></span>
                            </c:if>
                        </c:when>
                        <c:otherwise>
                            <c:if test="${model.user.playlistRole}">
                                <span class="forward"><a href="" onClick="playListAction('append')"><fmt:message key="playlist.load.append"/></a></span>
                            </c:if>
                        </c:otherwise>
                    </c:choose>
                </span>
            </div>

            <div id="mainframecontentcontainer">
                <div id="mainframecontent">
                    <h1>
                        <c:choose>
                            <c:when test="${model.load}">
                                <fmt:message key="playlist.load.title"/>
                            </c:when>
                            <c:otherwise>
                                <fmt:message key="playlist.load.appendtitle"/>
                            </c:otherwise>
                        </c:choose>
                    </h1>
                </div>
            </div>
        </div>
    </body>
</html>