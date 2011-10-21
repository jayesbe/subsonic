<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1"%>
<%--@elvariable id="model" type="java.util.Map"--%>
<%@ include file="doctype.jsp" %>

<html>
    <head>
        <%@ include file="head.jsp" %>
        <link href="<c:url value="/style/shadow.css"/>" rel="stylesheet">
        <c:if test="${not model.updateNowPlaying}">
            <meta http-equiv="refresh" content="180;URL=nowPlaying.view?">
        </c:if>
        <script type="text/javascript" src="<c:url value="/dwr/engine.js"/>"></script>
        <script type="text/javascript" src="<c:url value="/script/prototype.js"/>"></script>
        <script type="text/javascript" src="<c:url value="/script/scriptaculous.js?load=effects"/>"></script>
        <script type="text/javascript" src="<c:url value="/script/scripts.js"/>"></script>
        <script type="text/javascript" src="<c:url value="/script/fancyzoom/FancyZoom.js"/>"></script>
        <script type="text/javascript" src="<c:url value="/script/fancyzoom/FancyZoomHTML.js"/>"></script>
        <script type="text/javascript" src="<c:url value="/script/switchcontent.js"/>"></script>

        <script type='text/javascript'>
            function toggleAddComment() {
                $("commentForm").toggle();
                $("comment").toggle();
            }
            function toggleFormattingOptions() {
                document.getElementById("formattingOptions").style.display = (document.getElementById("formattingOptions").style.display == "none") ? "inline-block" : "none";
            }
            function verifyAlbumComment() {
                var comment = document.addCommentForm.comment.value;

                // Check for null value
                if (comment == "") {
                    return false;
                }

                // Checks passed: submit
                document.addCommentForm.submit();
                document.getElementById('addComment').style.display='none';
            }
        </script>
    </head>

    <body class="bgcolor1 mainframe" onLoad="init()">
        <div id="mainframecontainer">
            <div id="mainframemenucontainer" class="bgcolor1">
                <c:choose>
                    <c:when test="${model.dir.album}">
                    <!-- Directory is an album -->
                        <c:choose>
                            <c:when test="${empty model.previousAlbum && empty model.nextAlbum}">
                            <!-- Single album available -->
                                <span id="mainframemenuleft">
                                    <c:forEach items="${model.ancestors}" var="ancestor">
                                        <sub:url value="main.view" var="ancestorUrl">
                                            <sub:param name="path" value="${ancestor.path}"/>
                                        </sub:url>
                                        <span class="back prevAncestor"><a href="${ancestorUrl}" title="${ancestor.name}" style="width:15em;"><str:truncateNicely upper="30">${fn:escapeXml(ancestor.name)}</str:truncateNicely></a></span>
                                    </c:forEach>
                                    <span class="current <c:choose><c:when test='${empty model.previousAlbum && empty model.nextAlbum && empty model.ancestors}'>baseAlbum</c:when><c:when test='${(empty model.previousAlbum || empty model.nextAlbum) && not empty model.ancestors}'>singleAlbum</c:when></c:choose><c:if test='${fn:length(fn:escapeXml(model.dir.name)) > 30}'>Marquee</c:if> headerSelected">
                                        <c:choose>
                                            <c:when test="${fn:length(fn:escapeXml(model.dir.name)) > 30}"><marquee style="width:15em;display:block;">${fn:escapeXml(model.dir.name)}</marquee></c:when>
                                            <c:otherwise><str:truncateNicely upper="30">${fn:escapeXml(model.dir.name)}</str:truncateNicely></c:otherwise>
                                        </c:choose>
                                    </span>
                                </span>
                            </c:when>		
                            <c:otherwise>
                            <!-- Multiple albums available -->
                                <c:if test="${not empty model.previousAlbum}">
                                <!-- Provide link to previous album if available. -->
                                    <span id="mainframemenuleft">
                                        <sub:url value="main.view" var="previousUrl">
                                            <sub:param name="path" value="${model.previousAlbum.path}"/>
                                        </sub:url>
                                        <span class="back prevAlbum right"><a href="${previousUrl}" title="${model.previousAlbum.name}"><str:truncateNicely upper="30">${fn:escapeXml(model.previousAlbum.name)}</str:truncateNicely></a></span>
                                    </span>
                                </c:if>
                                <span id="mainframemenucenter">
                                    <span class="current <c:choose><c:when test='${(empty model.previousAlbum || empty model.nextAlbum) && not empty model.ancestors}'>doubleAlbum<c:choose><c:when test='${empty model.previousAlbum}'>Left</c:when><c:otherwise>Right</c:otherwise></c:choose></c:when><c:otherwise>multipleAlbum</c:otherwise></c:choose><c:if test='${fn:length(fn:escapeXml(model.dir.name)) > 25}'>Marquee</c:if> headerSelected">	
                                        <c:choose>
                                            <c:when test="${fn:length(fn:escapeXml(model.dir.name)) > 25}"><marquee style="width:15em;">${fn:escapeXml(model.dir.name)}</marquee></c:when>
                                            <c:otherwise><str:truncateNicely upper="25">${fn:escapeXml(model.dir.name)}</str:truncateNicely></c:otherwise>
                                        </c:choose>
                                    </span>
                                </span>

                                <c:if test="${not empty model.nextAlbum}">
                                <!-- Provide link to next album if available. -->
                                    <sub:url value="main.view" var="nextUrl">
                                        <sub:param name="path" value="${model.nextAlbum.path}"/>
                                    </sub:url>
                                    <span id="mainframemenucenter">
                                        <span class="forward nextAlbum left"><a href="${nextUrl}" title="${model.nextAlbum.name}"><str:truncateNicely upper="30">${fn:escapeXml(model.nextAlbum.name)}</str:truncateNicely></a></span>
                                    </span>
                                </c:if>
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:otherwise>
                        <!-- Directory is not an album -->
                        <span id="mainframemenuleft">
                            <span class="current baseDirectory<c:if test='${fn:length(fn:escapeXml(model.dir.name)) > 25}'>Marquee</c:if> headerSelected">
                                <c:choose>
                                    <c:when test="${fn:length(fn:escapeXml(model.dir.name)) > 25}">
                                        <marquee style="width:15em">${fn:escapeXml(model.dir.name)}</marquee>
                                    </c:when>
                                    <c:otherwise>
                                        <str:truncateNicely upper="25">${fn:escapeXml(model.dir.name)}</str:truncateNicely>
                                    </c:otherwise>
                                </c:choose>
                            </span>
                        </span>
                    </c:otherwise>
                </c:choose>
                <span id="mainframemenuright">
                    <%@ include file="searchbox.jsp" %>
                </span>
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

                    <script type="text/javascript" language="javascript">
                        function init() {
                            setupZoom('<c:url value="/"/>');
                        }

                        <!-- actionSelected() is invoked when the users selects from the "More actions..." combo box. -->
                        function actionSelected(id) {
                            switch (id) {
                                case "top": return;
                                case "selectAll": selectAll(true); break;
                                case "selectNone": selectAll(false); break;
                                case "share": parent.frames.main.location.href = "${shareUrl}&" + getSelectedIndexes(); break;
                                case "download": location.href = "${downloadUrl}&" + getSelectedIndexes(); break;
                                case "appendPlaylist": parent.frames.main.location.href = "${appendPlaylistUrl}&" + getSelectedIndexes(); break;
                            }
                            $("moreActions").selectedIndex = 0;
                        }

                        function getSelectedIndexes() {
                            var result = "";
                            for (var i = 0; i < ${fn:length(model.children)}; i++) {
                                var checkbox = $("songIndex" + i);
                                if (checkbox != null  && checkbox.checked) {
                                    result += "i=" + i + "&";
                                }
                            }
                            return result;
                        }

                        function selectAll(b) {
                            for (var i = 0; i < ${fn:length(model.children)}; i++) {
                                var checkbox = $("songIndex" + i);
                                if (checkbox != null) {
                                    checkbox.checked = b;
                                }
                            }
                        }

                    </script>

                    <c:if test="${model.updateNowPlaying}">
                        <script type="text/javascript" language="javascript">
                            // Variable used by javascript in playlist.jsp
                            var updateNowPlaying = true;
                        </script>
                    </c:if>

                    <h1>
                        <img id="pageimage" src="<spring:theme code="nowPlayingImage"/>" alt="" />

                        <c:forEach items="${model.ancestors}" var="ancestor">
                            <sub:url value="main.view" var="ancestorUrl">
                                <sub:param name="path" value="${ancestor.path}"/>
                            </sub:url>
                            <a href="${ancestorUrl}">${ancestor.name}</a> &raquo;
                        </c:forEach>
                        ${model.dir.name}

                        <c:if test="${model.dir.album and model.averageRating gt 0}">
                            &nbsp;&nbsp;
                            <c:import url="rating.jsp">
                                <c:param name="path" value="${model.dir.path}"/>
                                <c:param name="readonly" value="true"/>
                                <c:param name="rating" value="${model.averageRating}"/>
                            </c:import>
                        </c:if>
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
                                    <a href="javascript:noop()" onClick="javascript:actionSelected(this.id)" id="appendPlaylist" style="text-transform:capitalize"><fmt:message key="playlist.append"/></a>
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

                            <div style="float:right;padding-right:50px;">
                                <c:set var="artist" value="${model.children[0].metaData.artist}"/>
                                <c:set var="album" value="${model.children[0].metaData.album}"/>
                                <c:if test="${not empty artist and not empty album}">
                                    <sub:url value="http://www.google.com/search" var="googleUrl" encoding="UTF-8">
                                        <sub:param name="q" value="\"${artist}\" \"${album}\""/>
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
                                        <sub:param name="q" value="site:wikipedia.org \"${artist}\" \"${album}\""/>
                                        <sub:param name="btnI" value="I\'m+Feeling+Lucky"/>
                                    </sub:url>
                                    <sub:url value="http://www.google.com/search" var="allmusicUrl" encoding="UTF-8">
                                        <sub:param name="q" value="site:allmusic.com \"${artist}\" \"${album}\""/>
                                        <sub:param name="btnI" value="I\'m+Feeling+Lucky"/>
                                    </sub:url>
                                    <sub:url value="http://www.google.com/search" var="lastFmUrl" encoding="UTF-8">
                                        <sub:param name="q" value="site:last.fm album \"${artist}\" \"${album}\""/>
                                        <sub:param name="btnI" value="I\'m+Feeling+Lucky"/>
                                    </sub:url>

                                    <fmt:message key="top.search"/><br/>
                                    <a target="_blank" href="${googleUrl}"><img src="icons/google.ico"></a> |
                                    <a target="_blank" href="${wikipediaUrl}"><img src="icons/wikipedia.ico"></a> |
                                    <a target="_blank" href="${allmusicUrl}"><img src="icons/allmusic.ico"></a> |
                                    <a target="_blank" href="${lastFmUrl}"><img src="icons/lastfm.ico"></a>
                                </c:if>
                            </div>
                        </span>
                    </c:if>

                    <div id="comment" class="albumComment"><sub:wiki text="${model.comment}"/></div>

                    <div id="commentForm" style="display:none">
                        <form name="addCommentForm" method="post" action="setMusicFileInfo.view">
                            <input type="hidden" name="action" value="comment">
                            <input type="hidden" name="path" value="${model.dir.path}">
                            <table>
                                <tr>
                                    <td><textarea name="comment" rows="6" style="width:48em">${model.comment}</textarea></td>
                                </tr>
                                <tr>
                                    <td style="text-align:right">
                                        <a href="#" onClick="toggleFormattingOptions()" style="font-size:80%;vertical-align:top">Formatting Options</a>
                                        <input type="button" value="<fmt:message key='common.save'/>" onClick="verifyAlbumComment()">
                                        <input type="reset" value="<fmt:message key='common.cancel'/>" onClick="toggleAddComment()">
                                    </td>
                                </tr>
                            </table>
                        </form>
                        <div class="bgcolor1 formattingOptions" id="formattingOptions" style="display:none">
                            <div style="display:inline:position:relative;width:85%;margin: 0px auto"><fmt:message key="main.wiki"/></div>
                        </div>
                    </div>

                    <c:if test="${model.dir.album}">
                        <c:if test="${model.user.shareRole}">
                            <fieldset style="width:110px;"> 
                            <span class="detail">
                                <c:if test="${needSep}">&nbsp;</c:if>
                                <a href="${shareUrl}"><fmt:message key="main.sharealbum"/></a>
                                <c:set var="needSep" value="true"/>
                                <c:if test="${needSep}">|</c:if>
                                <span id="togglecontent2-title" class="handcursor"></span>
                                <div id="togglecontent2" class="switchgroup2"></div>
                                    <script type="text/javascript">
                                            var toggle2img=new switchcontent("switchgroup2", "div") //Limit scanning of switch contents to just "div" elements
                                            toggle2img.setStatus('<a href="javascript:noop()" onClick="javascript:selectAll(false)" title="<fmt:message key="playlist.more.selectnone"/>"/><fmt:message key="playlist.more.selectnone"/> ', '<a href="javascript:noop()" onClick="javascript:selectAll(true)" title="<fmt:message key="playlist.more.selectall"/>"/><fmt:message key="playlist.more.selectall"/> ')
                                            toggle2img.setPersist(true)
                                            toggle2img.collapsePrevious(true) //Only one content open at any given time
                                            toggle2img.init()
                                    </script>
                                </a>
                            </span>
                            </fieldset>
                         </c:if>
                    </c:if>

                    <table cellpadding="10" style="width:100%">
                        <tr style="vertical-align:top;">
                            <td style="vertical-align:top;">
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

                                        <tr style="margin:0;padding:0;border:0">
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
                            </td>

                            <td style="vertical-align:top;width:100%">
                                <c:forEach items="${model.coverArts}" var="coverArt" varStatus="loopStatus">
                                    <div style="float:left; padding:5px"><c:if test="${model.dir.album}">Rate Album:<c:import url="rating.jsp">
                                            <c:param name="path" value="${model.dir.path}"/>
                                            <c:param name="readonly" value="false"/>
                                            <c:param name="rating" value="${model.userRating}"/>
                                        </c:import></c:if><br/>
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
                                    <div style="float:left; padding:5px">
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
                            </td>

                            <c:if test="${not empty model.ad}">
                                <td style="vertical-align:top;">
                                    <div style="padding:0 1em 0 1em;">
                                        <div class="detail" style="text-align:center">
                                            ${model.ad}
                                            <br/>
                                            <br/>
                                            <sub:url value="donate.view" var="donateUrl">
                                                    <sub:param name="path" value="${model.dir.path}"/>
                                            </sub:url>
                                            <fmt:message key="main.donate"><fmt:param value="${donateUrl}"/><fmt:param value="${model.brand}"/></fmt:message>
                                        </div>
                                    </div>
                                </td>
                            </c:if><!---->
                    </tr>
                </table>
            </div>
        </div>
    </body>
</html>
