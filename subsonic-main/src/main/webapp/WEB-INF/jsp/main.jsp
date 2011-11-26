<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1" %>
<%--@elvariable id="model" type="java.util.Map"--%>
<%@ include file="doctype.jsp" %>

<html>
    <head>
        <%@ include file="head.jsp" %>
        <c:if test="${not model.updateNowPlaying}">
            <meta http-equiv="refresh" content="180;URL=nowPlaying.view?">
        </c:if>
        <script type="text/javascript" src="<c:url value="/dwr/engine.js"/>"></script>
        <script type="text/javascript" src="<c:url value="/script/scripts.js"/>"></script>
        <link rel="stylesheet" href="/script/plugins/jquery.fancybox-1.3.4.css" type="text/css" media="screen" />
    </head>

    <body class="bgcolor1 mainframe">
        <div id="mainframecontainer" class="fillframe">
            <div id="mainframemenucontainer" class="bgcolor1 fade vcenterouter fillwidth">
                <c:choose>
                    <c:when test="${model.dir.album}">
                    <!-- Directory is an album -->
                        <span id="mainframemenuleft" class="vcenterinner">
                        <c:if test="${not empty model.ancestors}">
                            <c:forEach items="${model.ancestors}" var="ancestor">
                                <sub:url value="main.view" var="ancestorUrl">
                                    <sub:param name="path" value="${ancestor.path}"/>
                                </sub:url>
                                <button class="prevAncestor ui-icon-arrowreturnthick-1-w ui-icon-primary vcenter bold" onClick="location.href='${ancestorUrl}'" title="${ancestor.name}"><str:truncateNicely upper="30">${fn:escapeXml(ancestor.name)}</str:truncateNicely></button>
                            </c:forEach>
                        </c:if>
                        <c:choose>
                            <c:when test="${empty model.previousAlbum && empty model.nextAlbum}">
                            <!-- Single album available -->
                                <span class="<c:choose><c:when test='${empty model.previousAlbum && empty model.nextAlbum && empty model.ancestors}'>baseAlbum</c:when><c:when test='${(empty model.previousAlbum || empty model.nextAlbum) && not empty model.ancestors}'>singleAlbum</c:when></c:choose><c:if test='${fn:length(fn:escapeXml(model.dir.name)) > 30}'>Marquee</c:if> ui-state-active vcenter">
                                    <h2>
                                    <c:choose>
                                        <c:when test="${fn:length(fn:escapeXml(model.dir.name)) > 30}"><marquee>${fn:escapeXml(model.dir.name)}</marquee></c:when>
                                        <c:otherwise><str:truncateNicely upper="30">${fn:escapeXml(model.dir.name)}</str:truncateNicely></c:otherwise>
                                    </c:choose>
                                    </h2>
                                </span>
                            </span>
                            </c:when>
                            <c:otherwise>
                            </span>
                            <!-- Multiple albums available -->
                                <span id="mainframemenu<c:choose><c:when test='${model.dir.album and model.averageRating gt 0}'>center</c:when><c:otherwise>right</c:otherwise></c:choose>" class="vcenterinner">
                                    <span id="mainframemenualbumcontrols" class="vcenter">
                                        <c:if test="${not empty model.previousAlbum}">
                                        <!-- Provide link to previous album if available. -->
                                            <sub:url value="main.view" var="previousUrl">
                                                <sub:param name="path" value="${model.previousAlbum.path}"/>
                                            </sub:url>
                                            <button class="prevAlbum ui-icon-triangle-1-w ui-icon-primary" onClick="location.href='${previousUrl}'" title="${model.previousAlbum.name}"><str:truncateNicely upper="30">${fn:escapeXml(model.previousAlbum.name)}</str:truncateNicely></button>
                                        </c:if>

                                        <span class="<c:choose><c:when test='${(empty model.previousAlbum || empty model.nextAlbum) && not empty model.ancestors}'>doubleAlbum<c:choose><c:when test='${empty model.previousAlbum}'>Left</c:when><c:otherwise>Right</c:otherwise></c:choose></c:when><c:otherwise>multipleAlbum</c:otherwise></c:choose><c:if test='${fn:length(fn:escapeXml(model.dir.name)) > 25}'>Marquee</c:if> ui-state-active">    
                                            <h2>
                                            <c:choose>
                                                <c:when test="${fn:length(fn:escapeXml(model.dir.name)) > 25}"><marquee>${fn:escapeXml(model.dir.name)}</marquee></c:when>
                                                <c:otherwise><str:truncateNicely upper="25">${fn:escapeXml(model.dir.name)}</str:truncateNicely></c:otherwise>
                                            </c:choose>
                                            </h2>
                                        </span>

                                        <c:if test="${not empty model.nextAlbum}">
                                        <!-- Provide link to next album if available. -->
                                            <sub:url value="main.view" var="nextUrl">
                                                <sub:param name="path" value="${model.nextAlbum.path}"/>
                                            </sub:url>
                                            <button class="nextAlbum ui-icon-triangle-1-e ui-icon-secondary" onClick="location.href='${nextUrl}'" title="${model.nextAlbum.name}"><str:truncateNicely upper="30">${fn:escapeXml(model.nextAlbum.name)}</str:truncateNicely></button>
                                        </c:if>
                                    </span>
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:otherwise>
                        <!-- Directory is not an album -->
                        <span id="mainframemenuleft" class="vcenterinner">
                            <span class="baseDirectory<c:if test='${fn:length(fn:escapeXml(model.dir.name)) > 25}'>Marquee</c:if> ui-state-active vcenter">
                                <h2>
                                <c:choose>
                                    <c:when test="${fn:length(fn:escapeXml(model.dir.name)) > 25}">
                                        <marquee style="width:15em;">${fn:escapeXml(model.dir.name)}</marquee>
                                    </c:when>
                                    <c:otherwise>
                                        <str:truncateNicely upper="25">${fn:escapeXml(model.dir.name)}</str:truncateNicely>
                                    </c:otherwise>
                                </c:choose>
                                </h2>
                            </span>
                        </span>
                    </c:otherwise>
                </c:choose>
                <c:if test="${model.dir.album and model.averageRating gt 0}">
                    <span id="mainframemenuright" class="alignright vcenterinner">
                        <span id="averagerating">
                            <span class="ui-state-active vcenter">
                                <h2><fmt:message key="rating.rating"/> ${model.averageRating/10}</h2>
                            </span>
                            <span class="ui-state-active vcenter">
                            <c:import url="rating.jsp">
                                <c:param name="path" value="${model.dir.path}"/>
                                <c:param name="readonly" value="true"/>
                                <c:param name="rating" value="${model.averageRating}"/>
                            </c:import>
                            </span>
                        </span>
                    </span>
                </c:if>
            </div>

            <div id="mainframecontentcontainer">
                <div id="mainframecontent">
                    <sub:url value="createShare.view" var="shareUrl">
                        <sub:param name="dir" value="${model.dir.path}"/>
                    </sub:url>
                    <sub:url value="download.view" var="downloadUrl">
                        <sub:param name="dir" value="${model.dir.path}"/>
                    </sub:url>
                    <sub:url value="appendPlaylist.view" var="appendPlaylistUrl">
                        <sub:param name="dir" value="${model.dir.path}"/>
                    </sub:url>

                    <c:if test="${model.updateNowPlaying}">
                        <script type="text/javascript" language="javascript">
                            // Variable used by javascript in playlist.jsp
                            var updateNowPlaying = true;
                        </script>
                    </c:if>

                    <div id="mainframecontentheader" class="fade">
                        <h1 class="left"style="padding-right:0.5em;">
                            <img id="pageimage" src="<spring:theme code="nowPlayingImage"/>" alt="" />

                            <!--<c:forEach items="${model.ancestors}" var="ancestor">
                                <sub:url value="main.view" var="ancestorUrl">
                                    <sub:param name="path" value="${ancestor.path}"/>
                                </sub:url>
                                <a href="${ancestorUrl}">${ancestor.name}</a> &raquo;
                            </c:forEach>
                            ${model.dir.name}-->
                        </h1>

                        <c:if test="${not model.partyMode}">
                            <h2>
                                <c:if test="${model.navigateUpAllowed}">
                                    <sub:url value="main.view" var="upUrl">
                                        <sub:param name="path" value="${model.dir.parent.path}"/>
                                    </sub:url>
                                    <a href="${upUrl}"><fmt:message key="main.up"/></a>
                                    <c:set var="needSep" value="true"/>
                                </c:if>

                                <c:set var="path">
                                    <sub:escapeJavaScript string="${model.dir.path}"/>
                                </c:set>

                                <c:if test="${model.user.streamRole}">
                                    <c:if test="${needSep}">|</c:if>
                                    <a href="javascript:noop()" onclick="top.playlist.onPlay('${path}');" style="text-transform:capitalize"><fmt:message key="main.playall"/></a> |
                                    <a href="javascript:noop()" onclick="top.playlist.onPlayRandom('${path}', 10);" style="text-transform:capitalize"><fmt:message key="main.playrandom"/></a> |
                                    <a href="javascript:noop()" onclick="top.playlist.onAdd('${path}');" style="text-transform:capitalize"><fmt:message key="main.addall"/></a>
                                    <c:set var="needSep" value="true"/>
                                </c:if>

                                <c:if test="${model.dir.album}">
                                    <c:if test="${model.user.playlistRole}">
                                    <c:if test="${needSep}">|</c:if>
                                        <a href="javascript:noop()" onClick="appendPlaylist()" id="appendPlaylist" style="text-transform:capitalize"><fmt:message key="playlist.append"/></a>
                                    </c:if>

                                    <c:if test="${model.user.downloadRole}">
                                        <sub:url value="download.view" var="downloadUrl">
                                            <sub:param name="path" value="${model.dir.path}"/>
                                        </sub:url>
                                        <c:if test="${needSep}">|</c:if>
                                        <a href="${downloadUrl}"><fmt:message key="common.download"/></a>
                                        <c:set var="needSep" value="true"/>
                                    </c:if>

                                    <c:if test="${model.user.coverArtRole}">
                                        <sub:url value="editTags.view" var="editTagsUrl">
                                            <sub:param name="path" value="${model.dir.path}"/>
                                        </sub:url>
                                        <c:if test="${needSep}">|</c:if>
                                        <a href="${editTagsUrl}" style="text-transform:capitalize"><fmt:message key="main.tags"/></a>
                                        <c:set var="needSep" value="true"/>
                                    </c:if>
                                    <c:if test="${needSep}">|</c:if>
                                    <a href="javascript:noop()" onClick="javascript:selectAllOrNone()" id="selectAllOrNone" class="tracklistselectall" title="<fmt:message key='playlist.more.selectall'/>"><fmt:message key="playlist.more.selectall"/></a>
                                </c:if>

                                <c:if test="${model.user.commentRole}">
                                    <c:if test="${needSep}">|</c:if>
                                    <a href="#" onClick="toggleAddComment()"><fmt:message key="main.comment"/></a>
                                </c:if>

                            </h2>
                        </c:if>
                        <c:if test="${model.dir.album}">
                            <span class="detail">
                                <c:choose>
                                    <c:when test="${model.playCount eq 0}"><fmt:message key="main.playcountnever" /></c:when>
                                    <c:when test="${model.playCount eq 1}"><fmt:message key="main.playcountonce" /></c:when>
                                    <c:when test="${model.playCount gt 0}"><fmt:message key="main.playcount"><fmt:param value="${model.playCount}"/></fmt:message></c:when>
                                </c:choose>
                                <c:if test="${not empty model.lastPlayed}">
                                    <fmt:message key="main.lastplayed">
                                        <fmt:param><fmt:formatDate type="date" dateStyle="long" value="${model.lastPlayed}"/></fmt:param>
                                    </fmt:message>
                                </c:if>
                            </span>
                        </c:if>
                        <c:if test="${fn:length(model.comment) gt 0}"><blockquote id="comment" class="albumComment"><sub:wiki text="${model.comment}"/></blockquote></c:if>
                    </div>

                    <c:if test="${model.dir.album}">
                        <span class="aligncenter fade right" style="padding-right:1em;">
                            <div id="searchlinks" style="padding: 1em .5em;">
                                <c:if test="${not empty model.artist and not empty model.album}">
                                    <sub:url value="http://www.google.com/search" var="googleUrl" encoding="UTF-8">
                                        <sub:param name="q" value="\"${model.artist}\" \"${model.album}\""/>
                                    </sub:url>

                                    <!--
                                    <sub:url value="http://en.wikipedia.org/wiki/Special:Search" var="wikipediaUrl" encoding="UTF-8">
                                        <sub:param name="search" value="\"${album}\""/>
                                        <sub:param name="go" value="Go"/>
                                    </sub:url>
                                    <sub:url value="allmusic.view" var="allmusicUrl">
                                        <sub:param name="album" value="${album}"/>
                                    </sub:url>
                                    <sub:url value="http://www.last.fm/search" var="lastFmUrl" encoding="UTF-8">
                                        <sub:param name="q" value="\"${artist}\" \"${album}\""/>
                                        <sub:param name="type" value="album"/>
                                    </sub:url>
                                    -->

                                    <sub:url value="http://www.google.com/search" var="wikipediaUrl" encoding="UTF-8">
                                        <sub:param name="q" value="site:wikipedia.org \"${model.artist}\" \"${model.album}\""/>
                                        <sub:param name="btnI" value="I\'m+Feeling+Lucky"/>
                                    </sub:url>
                                    <sub:url value="http://www.google.com/search" var="allmusicUrl" encoding="UTF-8">
                                        <sub:param name="q" value="site:allmusic.com \"${model.artist}\" \"${model.album}\""/>
                                        <sub:param name="btnI" value="I\'m+Feeling+Lucky"/>
                                    </sub:url>
                                    <sub:url value="http://www.google.com/search" var="lastFmUrl" encoding="UTF-8">
                                        <sub:param name="q" value="site:last.fm album \"${model.artist}\" \"${model.album}\""/>
                                        <sub:param name="btnI" value="I\'m+Feeling+Lucky"/>
                                    </sub:url>

                                    <fmt:message key="top.search"/><br/>
                                    <a target="_blank" href="${googleUrl}"><img src="icons/google.ico"></a> |
                                    <a target="_blank" href="${wikipediaUrl}"><img src="icons/wikipedia.ico"></a> |
                                    <a target="_blank" href="${allmusicUrl}"><img src="icons/allmusic.ico"></a> |
                                    <a target="_blank" href="${lastFmUrl}"><img src="icons/lastfm.ico"></a>
                                </c:if>
                            </div>

                            <c:if test="${model.user.shareRole}">
                            <div id="sharelinks" style="padding: 1em .5em;">
                                <fmt:message key="main.sharealbum"/><br/>
                                <a href="${shareUrl}"><img src="<spring:theme code="shareFacebookImage"/>" alt=""></a> |
                                <a href="${shareUrl}"><img src="<spring:theme code="shareTwitterImage"/>" alt=""></a> |
                                <a href="${shareUrl}"><img src="<spring:theme code="shareGooglePlusImage"/>" alt=""></a>
                            </div>
                            </c:if>

                            <c:if test="${not empty model.ad}">
                            <div id="adcontainer" style="padding: 1em .5em;" class="detail aligncenter">
                                ${model.ad}
                                <br/><br/>
                                <sub:url value="donate.view" var="donateUrl">
                                    <sub:param name="path" value="${model.dir.path}"/>
                                </sub:url>
                                <fmt:message key="main.donate"><fmt:param value="${donateUrl}"/><fmt:param value="${model.brand}"/></fmt:message>
                            </div>
                            </c:if><!---->
                        </span>
                    </c:if>


                    <div id="commentForm" class="aligncenter ui-helper-hidden">
                        <form id="addCommentForm" name="addCommentForm" method="post" action="setMusicFileInfo.view">
                            <input type="hidden" name="action" value="comment">
                            <input type="hidden" name="path" value="${model.dir.path}">
                            <textarea name="comment" rows="6" cols="75">${model.comment}</textarea>
                        </form>
                        <div id="formattingOptions" class="bgcolor2 center formattingOptions ui-helper-hidden">
                            <div style="width:85%" class="center alignleft"><fmt:message key="main.wiki"/></div>
                        </div>
                    </div>

                    <div id="mainframecontentalbumdetail">
                        <span id="mainframecontenttrackdetail" class="aligntop inline">
                            <table style="border-collapse:collapse;white-space:nowrap">
                                <c:set var="cutoff" value="${model.visibility.captionCutoff}"/>
                                <c:forEach items="${model.children}" var="child" varStatus="loopStatus">
                                    <c:choose>
                                        <c:when test="${loopStatus.count % 2 == 1}">
                                            <c:set var="class" value="class='bgcolor2 tracklist2'"/>
                                        </c:when>
                                        <c:otherwise>
                                            <c:set var="class" value="class='bgcolor2 tracklist1'"/>
                                        </c:otherwise>
                                    </c:choose>

                                    <tr class="fade dense">
                                        <c:import url="playAddDownload.jsp">
                                            <c:param name="path" value="${child.path}"/>
                                            <c:param name="video" value="${child.video and model.player.web}"/>
                                            <c:param name="playEnabled" value="${model.user.streamRole and not model.partyMode}"/>
                                            <c:param name="addEnabled" value="${model.user.streamRole and (not model.partyMode or not child.directory)}"/>
                                            <c:param name="downloadEnabled" value="${model.user.downloadRole and not model.partyMode}"/>
                                            <c:param name="asTable" value="true"/>
                                        </c:import>

                                        <c:choose>
                                            <c:when test="${child.directory}">
                                                <sub:url value="main.view" var="childUrl">
                                                    <sub:param name="path" value="${child.path}"/>
                                                </sub:url>
                                                <td style="padding-left:0.25em" colspan="4">
                                                    <a href="${childUrl}" title="${child.name}"><span style="white-space:nowrap;"><str:truncateNicely upper="${cutoff}">${child.name}</str:truncateNicely></span></a>
                                                </td>
                                            </c:when>

                                            <c:otherwise>
                                                <td ${class} style="padding-left:0.25em"><input type="checkbox" class="checkbox" id="songIndex${loopStatus.count - 1}"></td>

                                                <c:if test="${model.visibility.trackNumberVisible}">
                                                    <td ${class} style="padding-right:0.5em;text-align:right">
                                                        <span class="detail">${child.metaData.trackNumber}</span>
                                                    </td>
                                                </c:if>

                                                <td ${class} style="padding-right:1.25em;white-space:nowrap">
                                                    <span title="${child.title}"><str:truncateNicely upper="${cutoff}">${fn:escapeXml(child.title)}</str:truncateNicely></span>
                                                </td>

                                                <c:if test="${model.visibility.albumVisible}">
                                                    <td ${class} style="padding-right:1.25em;white-space:nowrap">
                                                        <span class="detail" title="${child.metaData.album}"><str:truncateNicely upper="${cutoff}">${fn:escapeXml(child.metaData.album)}</str:truncateNicely></span>
                                                    </td>
                                                </c:if>

                                                <c:if test="${model.visibility.artistVisible and model.multipleArtists}">
                                                    <td ${class} style="padding-right:1.25em;white-space:nowrap">
                                                        <span class="detail" title="${child.metaData.artist}"><str:truncateNicely upper="${cutoff}">${fn:escapeXml(child.metaData.artist)}</str:truncateNicely></span>
                                                    </td>
                                                </c:if>

                                                <c:if test="${model.visibility.genreVisible}">
                                                    <td ${class} style="padding-right:1.25em;white-space:nowrap">
                                                        <span class="detail">${child.metaData.genre}</span>
                                                    </td>
                                                </c:if>

                                                <c:if test="${model.visibility.yearVisible}">
                                                    <td ${class} style="padding-right:1.25em">
                                                        <span class="detail">${child.metaData.year}</span>
                                                    </td>
                                                </c:if>

                                                <c:if test="${model.visibility.formatVisible}">
                                                    <td ${class} style="padding-right:1.25em">
                                                        <span class="detail">${fn:toLowerCase(child.metaData.format)}</span>
                                                    </td>
                                                </c:if>

                                                <c:if test="${model.visibility.fileSizeVisible}">
                                                    <td ${class} style="padding-right:1.25em;text-align:right">
                                                        <span class="detail"><sub:formatBytes bytes="${child.metaData.fileSize}"/></span>
                                                    </td>
                                                </c:if>

                                                <c:if test="${model.visibility.durationVisible}">
                                                    <td ${class} style="padding-right:1.25em;text-align:right">
                                                        <span class="detail">${child.metaData.durationAsString}</span>
                                                    </td>
                                                </c:if>

                                                <c:if test="${model.visibility.bitRateVisible}">
                                                    <td ${class} style="padding-right:0.25em">
                                                        <span class="detail">
                                                            <c:if test="${not empty child.metaData.bitRate}">
                                                                ${child.metaData.bitRate} Kbps ${child.metaData.variableBitRate ? "vbr" : ""}
                                                            </c:if>
                                                            <c:if test="${child.video and not empty child.metaData.width and not empty child.metaData.height}">
                                                                (${child.metaData.width}x${child.metaData.height})
                                                            </c:if>
                                                        </span>
                                                    </td>
                                                </c:if>
                                            </c:otherwise>
                                        </c:choose>
                                    </tr>
                                </c:forEach>
                            </table>
                        </span>

                        <span id="mainframecontentcoverartdetail" class="aligncenter aligntop fade inline">
                            <c:if test="${model.dir.album}"><fmt:message key="rating.addrating"/>:<c:import url="rating.jsp">
                                <c:param name="path" value="${model.dir.path}"/>
                                <c:param name="readonly" value="false"/>
                                <c:param name="rating" value="${model.userRating}"/>
                            </c:import></c:if><br/>
                            <c:forEach items="${model.coverArts}" var="coverArt" varStatus="loopStatus">
                                <div style="padding:0.5em" class="left">
                                    <c:import url="coverArt.jsp">
                                            <c:param name="albumPath" value="${coverArt.parentFile.path}"/>
                                            <c:param name="albumName" value="${coverArt.parentFile.name}"/>
                                            <c:param name="coverArtSize" value="${model.coverArtSize}"/>
                                            <c:param name="coverArtPath" value="${coverArt.path}"/>
                                            <c:param name="showLink" value="${coverArt.parentFile.path ne model.dir.path}"/>
                                            <c:param name="showZoom" value="${coverArt.parentFile.path eq model.dir.path}"/>
                                            <c:param name="showChange" value="${(coverArt.parentFile.path eq model.dir.path) and model.user.coverArtRole}"/>
                                            <c:param name="showCaption" value="true"/>
                                            <c:param name="appearAfter" value="${loopStatus.count * 30}"/>
                                    </c:import>
                                </div>
                            </c:forEach>

                            <c:if test="${model.showGenericCoverArt}">
                                <div style="padding:0.5em" class="left">
                                    <c:import url="coverArt.jsp">
                                        <c:param name="albumPath" value="${model.dir.path}"/>
                                        <c:param name="coverArtSize" value="${model.coverArtSize}"/>
                                        <c:param name="showLink" value="false"/>
                                        <c:param name="showZoom" value="false"/>
                                        <c:param name="showChange" value="${model.user.coverArtRole}"/>
                                        <c:param name="appearAfter" value="0"/>
                                    </c:import>
                                </div>
                            </c:if>
                        </span>
                    </div>
                </div>
            </div>
        </div>
    </body>
    <script type="text/javascript">
        function appendPlaylist() {
            parent.frames.main.location.href = "${appendPlaylistUrl}&" + getSelectedIndexes();
        }

        function getSelectedIndexes() {
            var result = "";
            for (var i = 0; i < ${fn:length(model.children)}; i++) {
                var checkbox = $("#songIndex" + i);
                if (checkbox != null  && checkbox[0].checked) {
                    result += "i=" + i + "&";
                }
            }
            return result;
        }

        function selectAllOrNone() {
            var b = $("#selectAllOrNone").hasClass("tracklistselectall") ? true : false;
            for (var i = 0; i < ${fn:length(model.children)}; i++) {
                $("#songIndex" + i)[0].checked = b;
            }
            if (b) {
                $("#selectAllOrNone").addClass("tracklistselectnone").removeClass("tracklistselectall").attr("title", "<fmt:message key='playlist.more.selectnone'/>").html("<fmt:message key='playlist.more.selectnone'/>");
            } else {
                $("#selectAllOrNone").addClass("tracklistselectall").removeClass("tracklistselectnone").attr("title", "<fmt:message key='playlist.more.selectall'/>").html("<fmt:message key='playlist.more.selectall'/>");
            }
        }

        function toggleAddComment() {
            //$("#commentForm").toggle("drop");
            $("#commentForm").dialog({
                modal: true,
                show: 'drop',
                width: 'auto',
                title: "<fmt:message key='main.comment'/>",
                buttons: {
                    "<fmt:message key='main.wiki.formatting'/>": function() {
                        toggleFormattingOptions()
                    },
                    "<fmt:message key='common.save'/>": function() {
                        $("#addCommentForm")[0].submit();
                        $(this).dialog("close");
                    }
                },
                close: function() {
                    $("#addCommentForm")[0].reset();
                }
            });
        }
        function toggleFormattingOptions() {
            $("#formattingOptions").toggle("drop");
        }

        jQueryLoad.wait(function() {
            jFancyboxLoad = $LAB
                .script({src:"script/plugins/jquery.fancybox.min.js", test:"$.fancybox"})
                    .wait(function() {
                        $(".coverart").fancybox({
                            'type' : 'image', 
                            'overlayShow' : false, 
                            'hideOnContentClick' : true, 
                            'padding' : 0
                        });
                    });
            jQueryUILoad.wait(function() {
                $("#addCommentForm").stylize();
                $("#mainframemenucontainer .ui-state-active").button().hover(function() { $(this).removeClass("ui-state-active"); }, function() { $(this).addClass("ui-state-active"); }).click(function() { $(this).addClass("ui-state-active"); });
                //$("#listOffsetControls").buttonset();
                $("#averagerating").buttonset();
                $("#mainframemenualbumcontrols").buttonset();
                $("#mainframemenucontainer").stylize();
                $("#searchlinks").css({ 'visibility' : 'visible', "display" : "none" });
                $("#searchlinks").delay(30).fadeIn(600);
                $("#adcontainer").css({ 'visibility' : 'visible', "display" : "none" });
                $("#adcontainer").delay(30).fadeIn(600);
            });
        });
    </script>
</html>
