<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1" %>
<%@ include file="doctype.jsp" %>

<html>
    <head>
        <%@ include file="head.jsp" %>
        <script type="text/javascript" src="<c:url value="/dwr/engine.js"/>"></script>
        <script type="text/javascript" src="<c:url value="/dwr/util.js"/>"></script>
        <script type="text/javascript" src="<c:url value="/dwr/interface/chatService.js"/>"></script>
        <script type="text/javascript" src="<c:url value="/dwr/interface/nowPlayingService.js"/>"></script>
        
        <script type="text/javascript" src="<c:url value="/script/fancyzoom/FancyZoom.js"/>"></script>
        <script type="text/javascript" src="<c:url value="/script/fancyzoom/FancyZoomHTML.js"/>"></script>
        
        <script type="text/javascript" src="<c:url value="/script/niceforms2.js"/>"></script>
        <link type="text/css" rel="stylesheet" href="<c:url value="/style/niceforms2/niceforms-default.css" />"/>

        <script type="text/javascript" src="<c:url value="/script/jscal2.js"/>"></script>
        <script type="text/javascript" src="<c:url value="/script/unicode-letter.js"/>"></script>
        <script type="text/javascript" src="<c:url value="/script/jscal_en.js"/>"></script>
        <link type="text/css" rel="stylesheet" href="<c:url value="/style/jscal/jscal2.css" />"/>
        <link type="text/css" rel="alternate stylesheet" id="skinhelper-compact" href="<c:url value="/style/jscal/reduce-spacing.css" />">

        <script type="text/javascript" src="<c:url value="/script/jsclock.js"/>"></script>
        <script type="text/javascript" src="<c:url value="/script/scrolltitle.js"/>"></script>
        <script type="text/javascript" src="<c:url value="/script/music_brainz/music_brainz.js"/>"></script>

        <script type="text/javascript" src="<c:url value="/script/scripts.js"/>"></script>
    </head>

    <body class="bgcolor1 rightframe">
        <div id="clockbox" class="bgcolor1 fade center"></div>
        <div id="calendarbox" class="bgcolor1 fade center">
            <div id="calendar"></div>
            <script type="text/javascript">
                var LEFT_CAL = Calendar.setup({
                    cont: "calendar",
                    weekNumbers: true,
                    selection: Calendar.dateToInt(new Date()),
                    selectionType: Calendar.SEL_MULTIPLE,
                    animation: false,
                    bottomBar: false
                    // titleFormat: "%B %Y"
                })
            </script>
        </div>
        <div id="rightframecontainer">

            <c:if test="${model.showChat}">
                <script type="text/javascript">

                    var revision = 0;

                    function split_long_word(text, limit) {
                        var t = '';
                        var j = 0;
                        for (var i = 0; i < text.length; i++) {
                            if (text[i] == ' ') {
                                    j = i;
                            }
                            if (i > j + limit) {
                                    t += "-\n-";
                                    j = i;
                            }
                            t += text[i];
                        }
                        return t;
                    }

                    function startGetMessagesTimer() {
                        chatService.getMessages(revision, getMessagesCallback);
                        setTimeout("startGetMessagesTimer()", 10000);
                    }

                    function addMessage() {
                        chatService.addMessage($("message").value);
                        dwr.util.setValue("message", null);
                        setTimeout("startGetMessagesTimer()", 500);
                    }
                    function clearMessages() {
                        chatService.clearMessages();
                        setTimeout("startGetMessagesTimer()", 500);
                    }
                    function getMessagesCallback(messages) {

                        if (messages == null) {
                            return;
                        }
                        revision = messages.revision;

                        // Delete all the rows except for the "pattern" row
                        dwr.util.removeAllRows("chatlog", { filter:function(div) {
                            return (div.id != "pattern");
                        }});

                        // Create a new set cloned from the pattern row
                        for (var i = 0; i < messages.messages.length; i++) {
                            var message = messages.messages[i];
                            var id = i + 1;
                            dwr.util.cloneNode("pattern", { idSuffix:id });
                            dwr.util.setValue("user" + id, message.username);
                            dwr.util.setValue("date" + id, " [" + formatDate(message.date) + "]");
                            dwr.util.setValue("content" + id, split_long_word(message.content, 25));
                            $("pattern" + id).show();
                        }

                        var clearDiv = $("clearDiv");
                        if (clearDiv) {
                            if (messages.messages.length == 0) {
                                clearDiv.hide();
                            } else {
                                clearDiv.show();
                            }
                        }
                    }
                    function formatDate(date) {
                        var hours = date.getHours();
                        var minutes = date.getMinutes();
                        var result = hours < 10 ? "0" : "";
                        result += hours;
                        result += ":";
                        if (minutes < 10) {
                            result += "0";
                        }
                        result += minutes;
                        return result;
                    }

                    function init() {
                        dwr.engine.setErrorHandler(null);
                        if (${model.showChat}) {
                            chatService.addMessage(null);
                        }
                    }
                    
                    jQueryLoad.wait(function() {
                        jsClock();
                        setupZoom('<c:url value="/"/>');
                        prototypeLoad.wait(function() {
                            jQuery(init);
                            jQuery(startGetMessagesTimer);
                            jQuery(getMusicBrainz)
                        });
                    });
                </script>

                <div class="rightframespacebar fade"></div>
                <div id="chatContainer" class="fade">
                    <h2><fmt:message key="main.chat"/></h2>
                    <div id="niceformcontainer" style="display:block;">
                        <form class="niceform">
                            <input id="message" class="niceform" type="text" value=" <fmt:message key='main.message'/>" onclick="dwr.util.setValue('message', null);" onkeypress="dwr.util.onReturn(event, addMessage)" style="width:100%;" />
                        </form>
                    </div>

                    <table>
                        <tbody id="chatlog">
                        <tr id="pattern" style="display:none;margin:0;padding:0 0 0.15em 0;border:0"><td>
                            <span id="user" class="detail" style="font-weight:bold"></span>&nbsp;<span id="date" class="detail"></span> <span id="content"></span></td>
                        </tr>
                        </tbody>
                    </table>

                    <c:if test="${model.user.adminRole}">
                        <div id="clearDiv" style="display:none;" class="forward"><a href="#" onClick="clearMessages(); return false;"> <fmt:message key="main.clearchat"/></a></div>
                    </c:if>
                </div>
            </c:if>

            <c:if test="${model.showNowPlaying}">
                <!-- This script uses AJAX to periodically retrieve what all users are playing. -->
                <script type="text/javascript" language="javascript">

                    startGetNowPlayingTimer();

                    function startGetNowPlayingTimer() {
                        nowPlayingService.getNowPlaying(getNowPlayingCallback);
                        // the above line randomly causes a javascript error
                        // which requires subsonic restart for it to go away.
                        // maybe an issue parsing 'stale' now playing info?
                        
                        setTimeout("startGetNowPlayingTimer()", 10000);
                    }

                    function getNowPlayingCallback(nowPlaying) {
                        var currentUser = "${model.user.username}";
                        var nowPlayingUsers = "";
                        var artistTitleInfo = "";
                        var html = nowPlaying.length == 0 ? "" : "<div class=\"rightframespacebar\"></div><h2 class=\"nowPlayingHeader\"><fmt:message key='main.nowplaying' /></h2>";
                        for (var n = 0; n < 2; n++) {
                            if (n == 1 && nowPlaying.length > 1) {
                                html += "<div class=\"rightframespacebar\"></div><h2 class=\"nowPlayingHeader\"><fmt:message key='main.othersnowplaying' /></h2>"
                            }
                            for (var i = 0; i < nowPlaying.length; i++) {
                                if (n == 0) {
                                    if (nowPlaying[i].username == "${model.user.username}" || nowPlaying[i].username.substr(0, nowPlaying[i].username.indexOf("@")) == "${model.user.username}") {
                                        <!-- Check for current user on first iteration -->
                                    
                                        nowPlayingUsers += nowPlaying[i].username.substr(0, nowPlaying[i].username.indexOf("@")) + " ";

                                        artistTitleInfo = nowPlaying[i].artist + " - " + nowPlaying[i].title;
                                        var ta = document.createElement("textarea");
                                        ta.innerHTML = artistTitleInfo.replace(/</g,"&lt;").replace(/>/g,"&gt;");
                                        artistTitleInfo = ta.value;

                                        html += "<div class=\"nowPlayingChip\">"+
                                                    "<span id=\"userPlayer\" style=\"padding:2px;display:block;\">";

                                            if (nowPlaying[i].avatarUrl != null) {
                                                html += "<img src='" + nowPlaying[i].avatarUrl + "' class=\"right\" style=\"width:24px;padding-right:5px;\">";
                                            }
                                            html += "&nbsp;" + nowPlaying[i].username + 
                                                    "</span>"

                                            html += "<span style=\"display:block\">"
                                            if (nowPlaying[i].coverArtUrl != null) {
                                                html += "<span id=\"coverArt\" class=\"left\" style='padding:0 0.5em 0 1em'>" + 
                                                            "<a title='" + nowPlaying[i].tooltip + "' rel=\"zoom\" href='" + nowPlaying[i].coverArtZoomUrl + "'>" +
                                                            "<img src='" + nowPlaying[i].coverArtUrl + "' width=\"48\" height=\"48\"></a>" +
                                                        "</span>";
                                            }

                                                html += "<span>" +
                                                            "<a id=\"albumArtist\" title='" + nowPlaying[i].tooltip + "' target='main' href='" + nowPlaying[i].albumUrl + "'><em>" + nowPlaying[i].artist + "</em></a><br/>" +
                                                            "<a id=\"songTitle\" title='" + nowPlaying[i].tooltip + "' target='main' href='" + nowPlaying[i].albumUrl + "'><em>" + nowPlaying[i].title + "</em></a><br/>" +
                                                            "<span class='lyricsLink'>" + 
                                                                "<img src=\"<c:url value='/icons/anim_plus.gif'/>\" style=\"padding-right:5px;\">" +
                                                                "<a href='" + nowPlaying[i].lyricsUrl + "' onclick=\"return popupSize(this, 'lyrics', 430, 550)\"><fmt:message key='main.lyrics'/></a>" + 
                                                            "</span>" +
                                                        "</span>" +
                                                    "</span>";

                                        var minutesAgo = nowPlaying[i].minutesAgo;
                                        if (minutesAgo > 4) {
                                            html += "<span class=\"right\" style=\"padding-right:5px;\">" + minutesAgo + " <fmt:message key='main.minutesago'/></span>";
                                        }
                                        html += "</div><br>";
                                    }
                                } else {
                                    if (nowPlaying[i].username != "${model.user.username}" && nowPlaying[i].username.substr(0, nowPlaying[i].username.indexOf("@")) != "${model.user.username}") {
                                        <!-- Check for other users on later iterations -->

                                        html += "<div class=\"nowPlayingChip\">"+
                                                    "<span id=\"userPlayer\" style=\"padding:2px;display:block;\">";

                                            if (nowPlaying[i].avatarUrl != null) {
                                                html += "<img src='" + nowPlaying[i].avatarUrl + "' class=\"right\" style=\"width:24px;padding-right:5px;\">";
                                            }
                                            html += "&nbsp;" + nowPlaying[i].username + 
                                                    "</span>"

                                            html += "<span style=\"display:block\">"
                                            if (nowPlaying[i].coverArtUrl != null) {
                                                html += "<span id=\"coverArt\" class=\"left\" style='padding:0 0.5em 0 1em'>" + 
                                                            "<a title='" + nowPlaying[i].tooltip + "' rel=\"zoom\" href='" + nowPlaying[i].coverArtZoomUrl + "'>" +
                                                            "<img src='" + nowPlaying[i].coverArtUrl + "' width=\"48\" height=\"48\"></a>" +
                                                        "</span>";
                                            }

                                                html += "<span>" +
                                                            "<a id=\"albumArtist\" title='" + nowPlaying[i].tooltip + "' target='main' href='" + nowPlaying[i].albumUrl + "'><em>" + nowPlaying[i].artist + "</em></a><br/>" +
                                                            "<a id=\"songTitle\" title='" + nowPlaying[i].tooltip + "' target='main' href='" + nowPlaying[i].albumUrl + "'><em>" + nowPlaying[i].title + "</em></a><br/>" +
                                                            "<span class='lyricsLink'>" + 
                                                                "<img src=\"<c:url value='/icons/anim_plus.gif'/>\" style=\"padding-right:5px;\">" +
                                                                "<a href='" + nowPlaying[i].lyricsUrl + "' onclick=\"return popupSize(this, 'lyrics', 430, 550)\"><fmt:message key='main.lyrics'/></a>" + 
                                                            "</span>" +
                                                        "</span>" +
                                                    "</span>";

                                        var minutesAgo = nowPlaying[i].minutesAgo;
                                        if (minutesAgo > 4) {
                                            html += "<span class=\"right\" style=\"padding-right:5px;\">" + minutesAgo + " <fmt:message key='main.minutesago'/></span>";
                                        }
                                        html += "</div><br>";
                                    }
                                }
                            }
                        }
                        $('nowPlaying').innerHTML = html;
                        //alert(artistTitleInfo);
                        updateTitle(artistTitleInfo.length == 0 ? "Subsonic" : artistTitleInfo);
                        prepZooms();
                    }
                </script>
                <div id="nowPlaying" class="fade"></div>
            </c:if>
        </div>
        
        <script>
            if (window.webkitNotifications) {

                if (window.webkitNotifications.checkPermission() == 0) {
                    debug.log("Desktop notifications are supported and enabled.");
                } else {
                    debug.warn("Desktop notifications are supported but not enabled.");
                }

                function createNotificationInstance(options) {
                    if (options.notificationType == 'simple') {
                        window.webkitNotifications.createNotification('coverArtURI', 'Artist Name', 'Song Title').show();
                    } else if (options.notificationType == 'html') {
                        return window.webkitNotifications.createHTMLNotification(options.notificationURI);
                    }
                }
            }
            else {
                debug.log("Desktop notifications are not supported for this Browser/OS version yet.");
            }
        </script>

    </body>
</html>