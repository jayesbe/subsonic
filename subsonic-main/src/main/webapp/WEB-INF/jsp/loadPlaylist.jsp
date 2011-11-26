<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1" %>
<%@ include file="doctype.jsp" %>

<html>
    <head>
        <%@ include file="head.jsp" %>
    </head>
    <body class="mainframe bgcolor1">
        <div id="mainframecontainer" class="fillframe">
            <div id="mainframemenucontainer" class="bgcolor1 fade vcenterouter fillwidth">
                <c:if test="${not empty model.playlists}">
                    <span id="mainframemenuleft" class="vcenterinner">
                        <span class="vcenter">
                            <select id="playlists" name="playlists" class="inputWithIcon">
                                <c:forEach items="${model.playlists}" var="playlist">
                                    <option value="${playlist}">${playlist}</option>
                                </c:forEach>
                            </select>
                            <span class="ui-icon ui-icon-document left"></span>
                            <c:choose>
                                <c:when test="${model.load}">
                                    <button onClick="loadPlaylist()" class="ui-icon-folder-open ui-icon-secondary"><fmt:message key="playlist.load.load"/></button>
                                    <c:if test="${model.user.playlistRole}">
                                        <button onClick="deletePlaylist()" class="ui-icon-cancel ui-icon-primary right"><fmt:message key="playlist.load.delete"/></button>
                                    </c:if>
                                    <c:if test="${model.user.downloadRole}">
                                        <button onClick="downloadPlaylist()" class="ui-icon-arrowthickstop-1-s ui-icon-primary right"><fmt:message key="common.download"/></button>
                                    </c:if>
                                </c:when>
                                <c:otherwise>
                                    <c:if test="${model.user.playlistRole}">
                                        <button onClick="appendPlaylist()" class="ui-icon-plus ui-icon-secondary"><fmt:message key="playlist.load.append"/></button>
                                    </c:if>
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </span>
                </c:if>
            </div>

            <div id="mainframecontentcontainer">
                <div id="mainframecontent">
                    <div id="mainframecontentheader" class="fade">
                        <h1>
                            <img id="pageimage" src="<spring:theme code="nowPlayingImage"/>" alt="" />
                            <span class="desc">
                                <c:choose>
                                    <c:when test="${model.load}">
                                        <fmt:message key="playlist.load.title"/>
                                    </c:when>
                                    <c:otherwise>
                                        <fmt:message key="playlist.load.appendtitle"/>
                                    </c:otherwise>
                                </c:choose>
                            </span>
                        </h1>
                    </div>
					<c:choose>
						<c:when test="${not model.playlistDirectoryExists}">
							<h2 class="warning indent"><fmt:message key="playlist.load.missing_folder"><fmt:param value="${model.playlistDirectory}"/></fmt:message></h2>
						</c:when>
						<c:when test="${empty model.playlists}">
							<h2 class="warning indent"><fmt:message key="playlist.load.empty"/></h2>
						</c:when>
                    </c:choose>
                    <div id="dialog-confirm"></div>
                </div>
            </div>
        </div>
    </body>
    <script type="text/javascript">
        function downloadPlaylist() {
            location.href = "download.view?playlist=" + $("#playlists").val();
        }
        function appendPlaylist() {
            location.href = "appendPlaylistConfirm.view?nameUtf8Hex=" + $("#playlists").val() + "&player=${model.player}&dir=${model.dir}";
        }
        function loadPlaylist() {
            location.href = "loadPlaylistConfirm.view?nameUtf8Hex=" + $("#playlists").val();
        }
        function deletePlaylist() {
            $("#dialog-confirm").dialog({
                resizable: false,
                height: 140,
                modal: true,
                title: "<fmt:message key='playlist.load.confirm_delete'/>",
                buttons: {
                    Cancel: function() {
                        $(this).dialog("close");
                    },
                    "<fmt:message key='playlist.load.delete'/>": function() {
                        location.href = "deletePlaylist.view?nameUtf8Hex=" + $("#playlists").val();
                    }
                }
            });
        }
        jQueryLoad.wait(function() {
            jQueryUILoad.wait(function() {
                $("#mainframemenucontainer").stylize();
            });
        });
    </script>
</html>