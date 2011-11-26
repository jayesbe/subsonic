<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1" %>
<%@ include file="doctype.jsp" %>

<html>
    <head>
        <%@ include file="head.jsp" %>
        <script type="text/javascript" src="<c:url value="/dwr/engine.js"/>"></script>
        <script type="text/javascript" src="<c:url value="/dwr/interface/chatService.js"/>"></script>
        <script type="text/javascript" src="<c:url value="/dwr/interface/nowPlayingService.js"/>"></script>

        <script type="text/javascript" src="<c:url value="/script/scrolltitle.js"/>"></script>
        <script type="text/javascript" src="<c:url value="/script/music_brainz/music_brainz.js"/>"></script>

        <script type="text/javascript" src="<c:url value="/script/scripts.js"/>"></script>
        <link rel="stylesheet" href="/script/plugins/jquery.fancybox-1.3.4.css" type="text/css" media="screen" />
    </head>

    <body class="bgcolor1 rightframe">
        <div id="calendar" class="bgcolor1 mainmenudropdown fillwidth aligncenter ui-helper-hidden"></div>
        <div id="rightframecontainer" class="fillframe scroll-y">
            <div id="rightframemenucontainer" class="bgcolor1 fade vcenterouter fillwidth">
                <span id="rightframemenucenter" class="vcenterinner aligncenter">
                    <span class="vcenter">
                        <button id="clockbox" class="ui-icon-calendar ui-icon-secondary" onClick="toggleCalendar()"></button>
                    </span>
                </span>
            </div>

            <c:if test="${model.showChat}">
                <script type="text/javascript">
                    dwr.engine.setErrorHandler(null);
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
                        chatService.addMessage($("#message").val());
                        setTimeout("startGetMessagesTimer()", 500);
                        $("#message").val("");
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
                        $('#chatlog tr').not('#pattern').remove();

                        // Create a new set cloned from the pattern row
                        for (var i = 0; i < messages.messages.length; i++) {
                            var message = messages.messages[i];
                            var id = i + 1;

                            var node = $("#pattern").clone();
                            $(node).attr("id", $(node).attr("id") + id);
                            $(node).find("*").filter('[id]').each(function() { this.id = this.id + id; });
                            $(node).appendTo("#chatlog");
                            
                            $("#user" + id).html(message.username);
                            $("#date" + id).html(" [" + formatDate(message.date) + "]");
                            $("#content" + id).html(split_long_word(message.content, 25));
                            
                            $("#pattern" + id).slideDown("slow");
                        }

                        $("#clearChat").toggle(messages.messages.length != 0);
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
                </script>

                <div class="rightframespacebar fade"></div>
                <div id="chatContainer" class="fade fillwidth">
                    <h2><fmt:message key="main.chat"/></h2>
                    <form id="chatmessageform" class="center">
                        <input type="text" id="message" value="<fmt:message key='main.message'/>" class="inputWithIcon" validation="required" onClick="select();"
                            onFocus="if(this.value=='<fmt:message key='main.message'/>'){this.value='';}else{this.select();}"
                            onBlur="if(this.value==''){this.value='<fmt:message key='main.message'/>';$(this).change();}" />
                        <span class="ui-icon ui-icon-comment right"></span>
                    </form>
                    <table id="chatlog">
                        <tr id="pattern" class="chatLogMessage dense ui-helper-hidden"><td>
                            <span id="user" class="detail bold"></span>&nbsp;<span id="date" class="detail"></span> <span id="content"></span></td>
                        </tr>
                    </table>

                    <c:if test="${model.user.adminRole}">
                        <button id="clearChat" onClick="clearMessages(); return false;" class="ui-icon-cancel ui-icon-primary center ui-helper-hidden"><fmt:message key="main.clearchat"/></button>
                    </c:if>
                </div>
            </c:if>

            <c:if test="${model.showNowPlaying}">
                <!-- This script uses AJAX to periodically retrieve what all users are playing. -->
                <script type="text/javascript" language="javascript">
                    function startGetNowPlayingTimer() {
                        nowPlayingService.getNowPlaying(getNowPlayingCallback);
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
                                                            "<a title='" + nowPlaying[i].tooltip + "' class='coverart' href='" + nowPlaying[i].coverArtZoomUrl + "'>" +
                                                            "<img src='" + nowPlaying[i].coverArtUrl + "' width=\"48\" height=\"48\"></a>" +
                                                        "</span>";
                                            }

                                            html += "<span>" +
                                                        "<a id=\"albumArtist\" title='" + nowPlaying[i].tooltip + "' target='main' href='" + nowPlaying[i].albumUrl + "'><em>" + nowPlaying[i].artist + "</em></a><br/>" +
                                                        "<a id=\"songTitle\" title='" + nowPlaying[i].tooltip + "' target='main' href='" + nowPlaying[i].albumUrl + "'><em>" + nowPlaying[i].title + "</em></a><br/>" +
                                                        "<span class='lyricsLink inline'>" + 
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
                        $('#nowPlaying').html(html);
                        $(".coverart").fancybox({
                            'type' : 'image', 
                            'overlayShow' : false, 
                            'hideOnContentClick' : true, 
                            'padding' : 0
                        });
                        //debug.log(artistTitleInfo);
                        updateTitle(artistTitleInfo.length == 0 ? "Subsonic" : artistTitleInfo);
                    }
                </script>
                <div id="nowPlaying" class="fade"></div>
            </c:if>
        </div>
    </body>
    <script type="text/javascript">
        function toggleCalendar() {
            $("#calendar").toggle("blind");
        }
        jQueryLoad.wait(function() {
            if (${model.showChat}) $(startGetMessagesTimer);
            if (${model.showNowPlaying}) { $(startGetNowPlayingTimer); $(getMusicBrainz); }
            $("#message").bind('keydown', function(e) {
                var code = (e.keyCode ? e.keyCode : e.which); 
                if (code == 13) { addMessage() }
            });
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
                jClockLoad = $LAB
                    .script({src:"script/plugins/jquery.clock.min.js", test:"$.addClock"})
                        .wait(function() {
                            $("#clockbox .ui-button-text").addClock({ format: 15 });
                        });
                $("#rightframemenucenter").stylize()
                $("#chatContainer").validation().stylize()
                $("#calendar").datepicker({
                    showOtherMonths: true,
                    showButtonPanel: true,
                    changeYear: true
                });
            });
        });

        if (window.webkitNotifications) {

            if (window.webkitNotifications.checkPermission() == 0) {
                //debug.log("Desktop notifications are supported and enabled.");
            } else {
                //debug.warn("Desktop notifications are supported but not enabled.");
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
</html>