<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1" %>
<%@ include file="doctype.jsp" %>

<html>
    <head>
        <%@ include file="head.jsp" %>
        <c:set var="playerBack"><spring:theme code='backgroundColor'/></c:set>
        <c:set var="playerFront"><spring:theme code='textColor'/></c:set>
        <script type="text/javascript" src="<c:url value="/dwr/interface/nowPlayingService.js"/>"></script>
        <script type="text/javascript" src="<c:url value="/dwr/interface/playlistService.js"/>"></script>
        <script type="text/javascript" src="<c:url value="/dwr/engine.js"/>"></script>
        <link rel="stylesheet" href="<c:url value='/style/playermod/bg/${playerBack}.css'/>" type="text/css">
        <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/swfobject/2.2/swfobject.js"></script>
        <script type="text/javascript" src="<c:url value="/script/scripts.js"/>"></script>
    </head>

    <body class="bgcolor2 playlistframe">
        <div id="playlistframecontainer" class="fillframe">
            <div id="playlistframemenucontainer" class="bgcolor2 fade fillwidth vcenterouter">
                <div id="playlistframemenu" class="vcenterinner">
                    <div id="playlistframemenuadvancedcontainer" class="vcenterouter fillwidth" style="display:none">
                        <span id="playlistframemenuadvancedleft" class="vcenterinner">
                            <c:if test="${model.user.settingsRole}">
                                <select id="playerSelect" onChange="location='playlist.view?player=' + options[selectedIndex].value;" class="handcursor vcenter">
                                    <c:forEach items="${model.players}" var="player">
                                    <option ${player.id eq model.player.id ? "selected" : ""} value="${player.id}">${player.shortDescription}</option>
                                    </c:forEach>
                                </select>
                            </c:if>
                        </span>
                        <span id="playlistframemenuadvancedright" class="vcenterinner">
                            <span id="playlistframemenuadvanced" class="vcenter right">
                                <a href="loadPlaylist.view?" target="main" class="playerload" title="<fmt:message key='playlist.load'/>"><span class="ui-icon ui-icon-folder-open"><fmt:message key="playlist.load"/></span></a>
                                <a href="savePlaylist.view?" target="main" class="playersave" title="<fmt:message key='playlist.save'/>"><span class="ui-icon ui-icon-disk"><fmt:message key="playlist.save"/></span></a>

                                <a href="javascript:noop()" onClick="javascript:selectAllOrNone()" id="selectAllOrNone" class="playerselectall" title="<fmt:message key='playlist.more.selectall'/>"><span class="ui-icon ui-icon-check"><fmt:message key="playlist.more.selectall"/></span></a>
                                <a href="javascript:noop()" onClick="javascript:onRemoveSelected();" class="playerremove" title="<fmt:message key='playlist.remove'/>"><span class="ui-icon ui-icon-minus"><fmt:message key="playlist.remove"/></span></a>
                                <a href="javascript:noop()" onClick="javascript:actionSelected(this.id)" id="appendPlaylist" class="playerappend" title="<fmt:message key='playlist.append'/>"><span class="ui-icon ui-icon-plus"><fmt:message key="playlist.append"/></span></a>

                                <c:if test="${model.user.shareRole}">
                                <a href="javascript:noop()" onClick="javascript:actionSelected(this.id)" id="sharePlaylist" class="playershare" title="<fmt:message key='main.more.share'/>"><span class="ui-icon ui-icon-tag"><fmt:message key="main.more.share"/></span></a>
                                </c:if>
                                <c:if test="${model.user.downloadRole}">
                                <a href="javascript:noop()" onClick="javascript:actionSelected(this.id)" id="downloadPlaylist" class="playerdownload" title="<fmt:message key='common.download'/>"><span class="ui-icon ui-icon-arrowthickstop-1-s"><fmt:message key="common.download"/></span></a>
                                </c:if>
                                <c:if test="${model.user.settingsRole}">
                                <a href="playerSettings.view?id=${model.player.id}" target="main" class="playersettings" title="<fmt:message key='playlist.settings'/>"><span class="ui-icon ui-icon-wrench"><fmt:message key="playlist.settings"/></span></a>
                                </c:if>
                            </span>
                        </span>
                    </div>

                    <div id="playlistframemenucontrolscontainer" class="vcenterouter fillwidth">
                        <span id="playlistframemenucontrolsleft" class="vcenterinner">
                            <span class="solidblockmenu-outer vcenter">
                                <span class="playerleftround left"></span>
                                <span id="playlistframemenuplayer<c:choose><c:when test='${model.player.external}'>External</c:when><c:when test='${model.player.jukebox}'>Jukebox</c:when><c:when test='${model.player.web}'>Web</c:when><c:otherwise></c:otherwise></c:choose>">
                                    <ul class="solidblockmenu left">
                                        <c:if test="${model.player.web or model.player.jukebox or model.player.external}">
                                        <li><a href="javascript:noop()" onClick="onToggleRepeat()" id="playerrepeat"><span class="ui-icon ui-icon-refresh"></span></a></li>
                                        </c:if> 
                                        <li><a href="javascript:noop()" onClick="onUndo()" class="playerundo" title="<fmt:message key='playlist.undo'/>"><span class="ui-icon ui-icon-arrowreturnthick-1-w"><fmt:message key="playlist.undo"/></span></a></li>
                                        <li><a href="javascript:noop()" onClick="onShuffle()" class="playershuffle" title="<fmt:message key='playlist.shuffle'/>"><span class="ui-icon ui-icon-shuffle"><fmt:message key="playlist.shuffle"/></span></a></li>
                                        <li><a href="javascript:noop()" onClick="onClear()" class="playerclear" title="<fmt:message key='playlist.clear'/>"><span class="ui-icon ui-icon-close"><fmt:message key="playlist.clear"/></span></a></li>

                                        <c:if test="${model.player.web}">
                                        <li><a href="javascript:noop()" onClick="onNext(false)" class="playerforward" title="<fmt:message key='playlist.forward'/>"><span class="ui-icon ui-icon-seek-next"><fmt:message key="playlist.forward"/></span></a></li>
                                        <li><a href="javascript:noop()" onClick="onPrevious()" class="playerrewind" title="<fmt:message key='playlist.rewind'/>"><span class="ui-icon ui-icon-seek-prev"><fmt:message key="playlist.rewind"/></span></a></li>
                                        </c:if>

                                        <c:if test="${model.user.streamRole and not model.player.web}">
                                        <li><a href="javascript:noop()" onClick="onStartOrStop()" id="playerStartOrStop" class="playerstart" ><span class="ui-icon ui-icon-play"><fmt:message key="playlist.start"/></span></a></li>
                                        </c:if> 
                                        <c:if test="${model.player.web}">
                                        <li><div id="placeholder" style="float:left;width:340px;margin-top:5px"><a href="http://www.adobe.com/go/getflashplayer" target="_blank"><fmt:message key="playlist.getflash"/></a></div></li>
                                        </c:if> 

                                        <c:if test="${model.player.jukebox}">
                                        <li><div id="volumesliderContainer" style="height: 24px;width:12em;padding:0.5em;"><div id="volumeslider"></div></div></li>
                                        <li><a href="javascript:noop()" onClick="toggleMute()" class="playervolume"><span class="ui-icon ui-icon-volume-on"></span></a></li>
                                        </c:if>
                                    </ul>
                                </span>
                                <span class="playerrightround left"></span>
                            </span>
                        </span>
                        <span id="playlistframemenucontrolsright" class="vcenterinner">
                            <span class="vcenter right">
                                <select id="sortActions" onChange="javascript:onSortBy(selectedIndex);">
                                    <option><fmt:message key='playlist.more.sortactions'/></option> 
                                    <option value="<fmt:message key='playlist.more.sortbytrack'/>"><fmt:message key='playlist.more.sortbytrack'/></option> 
                                    <option value="<fmt:message key='playlist.more.sortbyartist'/>"><fmt:message key='playlist.more.sortbyartist'/></option>
                                    <option value="<fmt:message key='playlist.more.sortbyalbum'/>"><fmt:message key='playlist.more.sortbyalbum'/></option>
                                </select>
                                <button id="playlistadvanced" onClick="togglePanel()" class="ui-icon-triangle-1-s ui-icon-secondary bold" title="<fmt:message key='playlist.advanced'/>"><fmt:message key="playlist.advanced"/></button>
                            </span>
                        </span>
                    </div>
                </div>
            </div>

            <div id="playlistcontainer" class="fade scroll-y">
                <div id="playlistcontent">
                    <span id="empty"><p><em><fmt:message key="playlist.empty"/></em></p></span>
                    <div id="tracklist">
                        <table border="0" cellspacing="10" cellpadding="0" width="100%">
                          <tr>
                            <td class="fillwidth">
                            <table class="fillwidth" style="border-collapse:collapse;white-space:nowrap;">
                            <tbody id="playlistBody">
                                <tr id="pattern" class="ui-helper-hidden" style="margin:0;padding:0;border:0">
                                    <td class="bgcolor2 loadedlist2"><a href="javascript:noop()">
                                        <img id="removeSong" onClick="onRemove(this.id.substring(10) - 1)" src="<spring:theme code='removeImage'/>"
                                             alt="<fmt:message key='playlist.remove'/>" title="<fmt:message key='playlist.remove'/>">&nbsp;</a></td>
                                    <!--<td class="bgcolor2 loadedlist2"><a href="javascript:noop()">
                                        <img id="up" onClick="onUp(this.id.substring(2) - 1)" src="<spring:theme code="upImage"/>"
                                             alt="<fmt:message key="playlist.up"/>" title="<fmt:message key="playlist.up"/>">&nbsp;</a></td>
                                    <td class="bgcolor2 loadedlist2"><a href="javascript:noop()">
                                        <img id="down" onClick="onDown(this.id.substring(4) - 1)" src="<spring:theme code="downImage"/>"
                                             alt="<fmt:message key="playlist.down"/>" title="<fmt:message key="playlist.down"/>">&nbsp;</a></td>-->

                                    <td class="bgcolor2 loadedlist2" style="padding-left: 0.1em"><input type="checkbox" class="checkbox" id="songIndex"></td>
                                    <td style="padding-right:0.25em"></td>

                                    <c:if test="${model.visibility.trackNumberVisible}">
                                        <td style="padding-right:0.5em;text-align:right"><span class="detail" id="trackNumber">1</span></td>
                                    </c:if>

                                    <td style="padding-right:1.25em">
                                        <img id="currentImage" src="<spring:theme code="currentImage"/>" alt="" style="display:none">
                                        <c:choose>
                                            <c:when test="${model.player.externalWithPlaylist}">
                                                <span id="title">Title</span>
                                            </c:when>
                                            <c:otherwise>
                                                <a id="titleUrl" href="javascript:noop()">Title</a>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <c:if test="${model.visibility.albumVisible}">
                                        <td style="padding-right:1.25em"><a id="albumUrl" target="main"><span id="album" class="detail">Album</span></a></td>
                                    </c:if>
                                    <c:if test="${model.visibility.artistVisible}">
                                        <td style="padding-right:1.25em"><span id="artist" class="detail">Artist</span></td>
                                    </c:if>
                                    <c:if test="${model.visibility.genreVisible}">
                                        <td style="padding-right:1.25em"><span id="genre" class="detail">Genre</span></td>
                                    </c:if>
                                    <c:if test="${model.visibility.yearVisible}">
                                        <td style="padding-right:1.25em"><span id="year" class="detail">Year</span></td>
                                    </c:if>
                                    <c:if test="${model.visibility.formatVisible}">
                                        <td style="padding-right:1.25em"><span id="format" class="detail">Format</span></td>
                                    </c:if>
                                    <c:if test="${model.visibility.fileSizeVisible}">
                                        <td style="padding-right:1.25em;text-align:right;"><span id="fileSize" class="detail">Format</span></td>
                                    </c:if>
                                    <c:if test="${model.visibility.durationVisible}">
                                        <td style="padding-right:1.25em;text-align:right;"><span id="duration" class="detail">Duration</span></td>
                                    </c:if>
                                    <c:if test="${model.visibility.bitRateVisible}">
                                        <td style="padding-right:0.25em"><span id="bitRate" class="detail">Bitrate</span></td>
                                    </c:if>
                                    <!--<td style="padding-right:1.25em"><a href="javascript:song.artist" onClick="javascript:return popupSize(this, 'lyrics', 430, 550)"><fmt:message key="main.lyrics"/></a></span></td>-->
                                </tr>
                            </tbody>
                            </td>
                            </table>
                          </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </body>
    <script type="text/javascript">
        var player = null;
        var slider = null;
        var songs = null;
        var currentAlbumUrl = null;
        var currentStreamUrl = null;
        var startPlayer = false;
        var repeatEnabled = false;
        var updateGainTimeoutId = 0;
        var gain;

        function init() {
            dwr.engine.setErrorHandler(null);
            startTimer();
        }

        function startTimer() {
            <!-- Periodically check if the current song has changed. -->
            nowPlayingService.getNowPlayingForCurrentPlayer(nowPlayingCallback);
            setTimeout("startTimer()", 10000);
        }

        function nowPlayingCallback(nowPlayingInfo) {
            if (nowPlayingInfo != null && nowPlayingInfo.streamUrl != currentStreamUrl) {
                getPlaylist();
                if (currentAlbumUrl != nowPlayingInfo.albumUrl && top.main.updateNowPlaying) {
                    top.main.location.replace("nowPlaying.view?");
                    currentAlbumUrl = nowPlayingInfo.albumUrl;
                }
                if (${not model.player.web}) {
                    currentStreamUrl = nowPlayingInfo.streamUrl;
                    updateCurrentImage();
                }
            }
        }

        function createPlayer() {
            var flashvars = {
                backcolor: "<spring:theme code='backgroundColor'/>",
                frontcolor: "<spring:theme code='textColor'/>",
                plugins: "backstroke-1,subeq-1&subeq.gain=1&subeq.nodethickness=1&subeq.channels=both&subeq.reverseleft=true&subeq.decayrate=2&subeq.barbasecolor=<spring:theme code='barbasecolor'/>&subeq.bartopcolor=<spring:theme code='bartopcolor'/>&subeq.peakcolor=<spring:theme code='barpeakcolor'/>&subeq.baralpha=80",
                id: "player1"
            };
            var params = {
                allowfullscreen: "true",
                allowscriptaccess: "always"
            };
            var attributes = {
                id: "player1",
                name: "player1"
            };
            swfobject.embedSWF("<c:url value='/flash/jw-player-5.8.swf'/>", "placeholder", "340", "24", "9", false, flashvars, params, attributes);
        }

        function playerReady(thePlayer) {
            player = document.getElementById("player1");
            player.addModelListener("STATE", "stateListener");
            getPlaylist();
        }

        function stateListener(obj) { // IDLE, BUFFERING, PLAYING, PAUSED, COMPLETED
            if (obj.newstate == "COMPLETED") {
                onNext(repeatEnabled);
            }
        }

        function getPlaylist() {
            playlistService.getPlaylist(playlistCallback);
        }

        function onClear() {
            var ok = true;
            if (${model.partyMode}) {
                ok = confirm("<fmt:message key='playlist.confirmclear'/>");
            }
            if (ok) {
                playlistService.clear(playlistCallback);
            }
        }
        function onStartOrStop() {
            var b = $("#playerStartOrStop").hasClass("playerstart") ? true : false;
            if (b) {
                $("#playerStartOrStop").removeClass("playerstart").addClass("playerstop");
                $("#playerStartOrStop .ui-icon").removeClass("ui-icon-play").addClass("ui-icon-stop");
                $(onStart)
            } else {
                $("#playerStartOrStop").removeClass("playerstop").addClass("playerstart");
                $("#playerStartOrStop .ui-icon").removeClass("ui-icon-stop").addClass("ui-icon-play");
                $(onStop)
            }
        }
        function onStart() {
            playlistService.start(playlistCallback);
        }
        function onStop() {
            playlistService.stop(playlistCallback);
        }
        function onGain(gain) {
            playlistService.setGain(gain);
        }
        function onSkip(index) {
            if (${model.player.web}) {
                skip(index);
            } else {
                currentStreamUrl = songs[index].streamUrl;
                playlistService.skip(index, playlistCallback);
            }
        }
        function onNext(wrap) {
            var index = parseInt(getCurrentSongIndex()) + 1;
            if (wrap) {
                index = index % songs.length;
            }
            skip(index);
        }
        function onPrevious() {
            skip(parseInt(getCurrentSongIndex()) - 1);
        }
        function onPlay(path) {
            startPlayer = true;
            playlistService.play(path, playlistCallback);
        }
        function onPlayRandom(path, count) {
            startPlayer = true;
            playlistService.playRandom(path, count, playlistCallback);
        }
        function onAdd(path) {
            startPlayer = false;
            playlistService.add(path, playlistCallback);
        }
        function onShuffle() {
            playlistService.shuffle(playlistCallback);
        }
        function onRemove(index) {
            playlistService.remove(index, playlistCallback);
        }
        function onRemoveSelected() {
            var indexes = new Array();
            var counter = 0;
            for (var i = 0; i < songs.length; i++) {
                var index = i + 1;
                if ($("#songIndex" + index)[0].checked) {
                    indexes[counter++] = i;
                }
            }
            playlistService.removeMany(indexes, playlistCallback);
        }

        function onUp(index) {
            playlistService.up(index, playlistCallback);
        }
        function onDown(index) {
            playlistService.down(index, playlistCallback);
        }
        function onSort(index, indexto) {
            playlistService.move(index, indexto, playlistCallback);
        }
        function onToggleRepeat() {
            playlistService.toggleRepeat(playlistCallback);
        }
        function onUndo() {
            playlistService.undo(playlistCallback);
        }
        
        function onSortBy(id) {
            if (songs.length > 0) {
                switch(id) {
                    case 0: return;
                    case 1: playlistService.sortByTrack(playlistCallback); break;
                    case 2: playlistService.sortByArtist(playlistCallback); break;
                    case 3: playlistService.sortByAlbum(playlistCallback); break;
                    default:
                }
            }
            $("#sortActions")[0].selectedIndex = 0;
        }

        function playlistCallback(playlist) {
            songs = playlist.entries;
            repeatEnabled = playlist.repeatEnabled;

            if ($("#start")) {
                $("#start").toggle(!playlist.stopEnabled);
                $("#stop").toggle(playlist.stopEnabled);
            }
            
            if (${model.player.web or model.player.jukebox}) {
                if ($("#playerrepeat").length > 0) {
                    if (repeatEnabled) {
                        $("#playerrepeat").addClass("playerrepeaton ui-state-highlight").removeClass("playerrepeatoff").attr("title", "<fmt:message key='playlist.repeat_on'/>")
                        $("#playerrepeat .ui-icon").html("<fmt:message key='playlist.repeat_on'/>");
                    } else {
                        $("#playerrepeat").addClass("playerrepeatoff").removeClass("playerrepeaton ui-state-highlight").attr("title", "<fmt:message key='playlist.repeat_off'/>")
                        $("#playerrepeat .ui-icon").html("<fmt:message key='playlist.repeat_off'/>");
                    }
                }
            }

            // Delete all the rows except for the "pattern" row
            $('#playlistBody tr').not('#pattern').remove();

            var b = (songs.length == 0)
            $("#empty").toggle(b)
            $("#selectAllOrNone, .playersave, .playerremove, .playerappend, .playershare, .playerdownload").toggle(!b);

            // Create a new set cloned from the pattern row
            for (var i = 0; i < songs.length; i++) {
                var song  = songs[i];
                var id = i + 1;

                var node = $("#pattern").clone();
                $(node).attr("id", $(node).attr("id") + id);
                $(node).find("*").filter('[id]').each(function() { this.id = this.id + id; });
                $(node).addClass((i % 2 == 0) ? "bgcolor1 loadedlist1" : "bgcolor2 loadedlist2");
                $(node).appendTo("#playlistBody");

                if (song.streamUrl == currentStreamUrl) {
                    $("#currentImage" + id).show();
                }
                if (${model.player.externalWithPlaylist}) {
                    $("#title" + id).html(truncate(song.title));
                    $("#title" + id).attr("title", song.title);
                } else {
                    $("#titleUrl" + id).html(truncate(song.title));
                    $("#titleUrl" + id).attr("title", song.title);
                    $("#titleUrl" + id).click(function () { onSkip(this.id.substring(8) - 1) });
                }
                switch(true) {
                    case ${model.visibility.trackNumberVisible}:        $("#trackNumber" + id).html(song.trackNumber);
                    case ${model.visibility.artistVisible}:             $("#artist" + id).html(truncate(song.artist));
                                                                        $("#artist" + id).attr("title", song.artist);
                    case ${model.visibility.albumVisible}:              $("#album" + id).html(truncate(song.album));
                                                                        $("#album" + id).attr("title", song.album);
                                                                        $("#albumUrl" + id).attr("href", song.albumUrl);
                    case ${model.visibility.genreVisible}:              $("#genre" + id).html(song.genre);
                    case ${model.visibility.yearVisible}:               $("#year" + id).html(song.year);
                    case ${model.visibility.bitRateVisible}:            $("#bitRate" + id).html(song.bitRate);
                    case ${model.visibility.durationVisible}:           $("#duration" + id).html(song.durationAsString);
                    case ${model.visibility.formatVisible}:             $("#format" + id).html(song.format);
                    case ${model.visibility.fileSizeVisible}:           $("#fileSize" + id).html(song.fileSize);
                }

                $(node).show();
            }
            $("#playlistBody").sortable({
                cursor: "move", 
                delay: 300,
                tolerance: "pointer",
                placeholder: 'ui-state-highlight',
                forcePlaceholderSize: true,
                start: function(event, ui) {
                    index = ui.item.prevAll().length;
                },
                update: function(event, ui) {
                    onSort(index - 1, ui.item.prevAll().length - 1);
                }
            });

            if (playlist.sendM3U) {
                parent.frames.main.location.href="play.m3u?";
            }

            if (slider.length > 0) {
                slider.slider("option", "value", playlist.gain * 100);
                gain = playlist.gain;
            }

            if (${model.player.web}) {
                triggerPlayer();
            }
        }

        function triggerPlayer() {
            if (startPlayer) {
                startPlayer = false;
                if (songs.length > 0) {
                    skip(0);
                }
            }
            updateCurrentImage();
            if (songs.length == 0) {
                player.sendEvent("LOAD", new Array());
                player.sendEvent("STOP");
            }
        }

        function skip(index) {
            if (index < 0 || index >= songs.length) {
                return;
            }

            var song = songs[index];
            currentStreamUrl = song.streamUrl;
            updateCurrentImage();
            var list = new Array();
            list[0] = {
                file:song.streamUrl,
                title:song.title,
                provider:"sound"
            };

            if (song.duration != null) {
                list[0].duration = song.duration;
            }
            if (song.format == "aac" || song.format == "m4a") {
                list[0].provider = "video";
            }

            player.sendEvent("LOAD", list);
            player.sendEvent("PLAY");
        }

        function updateCurrentImage() {
            for (var i = 0; i < songs.length; i++) {
                var song  = songs[i];
                $("#currentImage" + (i + 1)).toggle(song.streamUrl == currentStreamUrl);
            }
        }

        function getCurrentSongIndex() {
            for (var i = 0; i < songs.length; i++) {
                if (songs[i].streamUrl == currentStreamUrl) {
                    return i;
                }
            }
            return -1;
        }

        function truncate(s) {
            var cutoff = ${model.visibility.captionCutoff};
            if (s.length > cutoff) {
                return s.substring(0, cutoff) + "...";
            }
            return s;
        }

        // actionSelected() is invoked when the users selects from the "More actions..." combo box.
        function actionSelected(id) {
            switch (id) {
                case "top": return;
                case "loadPlaylist":        parent.frames.main.location.href = "loadPlaylist.view?"; break;
                case "savePlaylist":        parent.frames.main.location.href = "savePlaylist.view?"; break;
                case "downloadPlaylist":    location.href = "download.view?player=${model.player.id}"; break;
                case "sharePlaylist":       parent.frames.main.location.href = "createShare.view?player=${model.player.id}&" + getSelectedIndexes(); break;
                case "sortByTrack":         onSortBy(1); break;
                case "sortByArtist":        onSortBy(2); break;
                case "sortByAlbum":         onSortBy(3); break;
                case "selectAll":           selectAll(true); break;
                case "selectNone":          selectAll(false); break;
                case "removeSelected":      onRemoveSelected(); break;
                case "download":            location.href = "download.view?player=${model.player.id}&" + getSelectedIndexes(); break;
                case "appendPlaylist":      parent.frames.main.location.href = "appendPlaylist.view?player=${model.player.id}&" + getSelectedIndexes(); break;
                default:
            }
            $("#moreActions")[0].selectedIndex = 0;
        }

        function getSelectedIndexes() {
            var result = "";
            for (var i = 0; i < songs.length; i++) {
                var b = $("#songIndex" + (i + 1)).attr("checked") ? true : false;
                if (b) {
                    result += "i=" + i + "&";
                }
            }
            return result;
        }

        function selectAllOrNone() {
            var b = $("#selectAllOrNone").hasClass("playerselectall") ? true : false;
            for (var i = 0; i < songs.length; i++) {
                $("#songIndex" + (i + 1)).attr("checked", b);
            }
            if (b) {
                $("#selectAllOrNone").addClass("playerselectnone").removeClass("playerselectall").attr("title", "<fmt:message key='playlist.more.selectnone'/>");
                $("#selectAllOrNone .ui-icon").addClass("ui-icon-cancel").removeClass("ui-icon-check").html("<fmt:message key='playlist.more.selectnone'/>");
            } else {
                $("#selectAllOrNone").addClass("playerselectall").removeClass("playerselectnone").attr("title", "<fmt:message key='playlist.more.selectall'/>");
                $("#selectAllOrNone .ui-icon").addClass("ui-icon-check").removeClass("ui-icon-cancel").html("<fmt:message key='playlist.more.selectall'/>");
            }
        }

        function togglePanel() {
            $('#playlistframemenuadvancedcontainer').toggle("blind");
            if ($("#playlistadvanced .ui-icon").hasClass("ui-icon-triangle-1-s")) {
                $("#playlistadvanced .ui-icon").addClass("ui-icon-triangle-1-n").removeClass("ui-icon-triangle-1-s");
            } else {
                $("#playlistadvanced .ui-icon").addClass("ui-icon-triangle-1-s").removeClass("ui-icon-triangle-1-n");
            }
        }
        function toggleMute() {
            if (slider.slider("option", "value") == 0) {
                slider.slider("option", "value", gain);
            } else {
                gain = slider.slider("option", "value");
                slider.slider("option", "value", 0);
            }
        }

        jQueryLoad.wait(function() {
            if (${model.player.web}) createPlayer();
            jQueryUILoad.wait(function() {
                $(init)
                $("#playlistframemenucontrolsright, #playlistframemenuadvancedleft").stylize();
                $("#playlistframemenuadvanced").buttonset();
                $("#selectAllOrNone, .playersave, .playerremove, .playerappend, .playershare, .playerdownload").hide();
                slider = $("#volumeslider").slider({
                    change: function(event, ui) {
                        clearTimeout(updateGainTimeoutId);
                        updateGainTimeoutId = setTimeout(function() { onGain(ui.value) }, 250);
                        $(".playervolume .ui-icon").removeClass(ui.value == 0 ? "ui-icon-volume-on" : "ui-icon-volume-off").addClass(ui.value == 0 ? "ui-icon-volume-off" : "ui-icon-volume-on")
                    }
                });
                
            });
        });
    </script>
</html>