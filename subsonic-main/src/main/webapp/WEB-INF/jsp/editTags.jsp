<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1" %>
<%@ include file="doctype.jsp" %>


<html>
    <head>
        <%@ include file="head.jsp" %>
        <sub:url value="main.view" var="backUrl"><sub:param name="path" value="${model.path}"/></sub:url>
        <script type="text/javascript" src="<c:url value="/dwr/interface/tagService.js"/>"></script>
        <script type="text/javascript" src="<c:url value="/dwr/engine.js"/>"></script>
    </head>
    <body class="mainframe bgcolor1">
        <c:set value="${model.songs}" var="songs"/>

        <div id="mainframecontainer" class="fillframe">
            <div id="mainframemenucontainer" class="bgcolor1 fade vcenterouter fillwidth">
                <span id="mainframemenuleft" class="vcenterinner">
                    <button type="reset" id="cancelTagEdits" class="vcenter"><fmt:message key='common.cancel'/></button>
                </span>
                <span id="mainframemenuright" class="vcenterinner">
                    <button id="submitTagEdits" class="ui-icon-disk ui-icon-secondary vcenter right"><fmt:message key='common.save'/></button>
                </span>
            </div>

            <div id="mainframecontentcontainer">
                <div id="mainframecontent">
                    <div id="mainframecontentheader" class="fade">
                        <h1><fmt:message key="edittags.title"/></h1>
                    </div>

                    <table id="edittagsform" class="fade" class="ruleTable indent" style="margin: 2px auto">
                        <tr>
                            <th class="ruleTableHeader"><fmt:message key="edittags.file"/></th>
                            <th class="ruleTableHeader"><fmt:message key="edittags.track"/></th>
                            <th class="ruleTableHeader"><fmt:message key="edittags.songtitle"/></th>
                            <th class="ruleTableHeader"><fmt:message key="edittags.artist"/></th>
                            <th class="ruleTableHeader"><fmt:message key="edittags.album"/></th>
                            <th class="ruleTableHeader"><fmt:message key="edittags.year"/></th>
                            <th class="ruleTableHeader"><fmt:message key="edittags.genre"/></th>
                            <th class="ruleTableHeader" width="60pt"><fmt:message key="edittags.status"/></th>
                        </tr>
                        <tr>
                            <th class="ruleTableHeader"/>
                            <th class="ruleTableHeader"><a href="javascript:suggestTrack()"><fmt:message key="edittags.suggest.short"/></a> |
                                <a href="javascript:resetTrack()"><fmt:message key="edittags.reset.short"/></a></th>
                            <th class="ruleTableHeader"><a href="javascript:suggestTitle()"><fmt:message key="edittags.suggest"/></a> |
                                <a href="javascript:resetTitle()"><fmt:message key="edittags.reset"/></a></th>
                            <th class="ruleTableHeader" style="white-space: nowrap"><input type="text" id="artistAll" name="artistAll" size="15" value="${model.defaultArtist}"/>&nbsp;<a href="javascript:setArtist()"><fmt:message key="edittags.set"/></a></th>
                            <th class="ruleTableHeader" style="white-space: nowrap"><input type="text" id="albumAll" name="albumAll" size="15" value="${model.defaultAlbum}"/>&nbsp;<a href="javascript:setAlbum()"><fmt:message key="edittags.set"/></a></th>
                            <th class="ruleTableHeader" style="white-space: nowrap"><input type="text" id="yearAll" name="yearAll" size="5" value="${model.defaultYear}"/>&nbsp;<a href="javascript:setYear()"><fmt:message key="edittags.set"/></a></th>
                            <th class="ruleTableHeader" style="white-space: nowrap">
                                <select id="genreAll" name="genreAll" style="width:7em">
                                    <option value=""/>
                                    <c:forEach items="${model.allGenres}" var="genre">
                                        <option ${genre eq model.defaultGenre ? "selected" : ""} value="${genre}">${genre}</option>
                                    </c:forEach>
                                </select>

                                <a href="javascript:setGenre()"><fmt:message key="edittags.set"/></a>
                            </th>
                            <th class="ruleTableHeader"/>
                        </tr>

                        <c:forEach items="${model.songs}" var="song" varStatus="loopStatus">
                            <tr>
                                <str:truncateNicely lower="25" upper="25" var="fileName">${song.fileName}</str:truncateNicely>
                                <input type="hidden" id="path${loopStatus.count - 1}" name="path${loopStatus.count - 1}" value="${song.path}"/>
                                <input type="hidden" id="suggestedTitle${loopStatus.count - 1}" name="suggestedTitle${loopStatus.count - 1}" value="${song.suggestedTitle}"/>
                                <input type="hidden" id="originalTitle${loopStatus.count - 1}" name="originalTitle${loopStatus.count - 1}" value="${song.title}"/>
                                <input type="hidden" id="suggestedTrack${loopStatus.count - 1}" name="suggestedTrack${loopStatus.count - 1}" value="${song.suggestedTrack}"/>
                                <input type="hidden" id="originalTrack${loopStatus.count - 1}" name="originalTrack${loopStatus.count - 1}" value="${song.track}"/>
                                <td class="ruleTableCell" title="${song.fileName}">${fileName}</td>
                                <td class="ruleTableCell"><input type="text" size="5" id="track${loopStatus.count - 1}" name="track${loopStatus.count - 1}" value="${song.track}"/></td>
                                <td class="ruleTableCell"><input type="text" size="30" id="title${loopStatus.count - 1}" name="title${loopStatus.count - 1}" value="${song.title}"/></td>
                                <td class="ruleTableCell"><input type="text" size="15" id="artist${loopStatus.count - 1}" name="artist${loopStatus.count - 1}" value="${song.artist}"/></td>
                                <td class="ruleTableCell"><input type="text" size="15" id="album${loopStatus.count - 1}" name="album${loopStatus.count - 1}" value="${song.album}"/></td>
                                <td class="ruleTableCell"><input type="text" size="5" id="year${loopStatus.count - 1}" name="year${loopStatus.count - 1}" value="${song.year}"/></td>
                                <td class="ruleTableCell"><input type="text" id="genre${loopStatus.count - 1}" name="genre${loopStatus.count - 1}" value="${song.genre}" style="width:7em"/></td>
                                <td class="ruleTableCell"><div id="status${loopStatus.count - 1}"/></td>
                            </tr>
                        </c:forEach>

                    </table>

                    <div class="warning" id="errors"></div>
                </div>
            </div>
        </div>
    </body>
    <script type="text/javascript">
        var index = 0;
        var fileCount = ${fn:length(model.songs)};
        function setArtist() {
            for (i = 0; i < fileCount; i++) {
                $("#artist" + i).val($("#artistAll").val());
            }
        }
        function setAlbum() {
            for (i = 0; i < fileCount; i++) {
                $("#album" + i).val($("#albumAll").val());
            }
        }
        function setYear() {
            for (i = 0; i < fileCount; i++) {
                $("#year" + i).val($("#yearAll").val());
            }
        }
        function setGenre() {
            for (i = 0; i < fileCount; i++) {
                $("#genre" + i).val($("#genreAll").val());
            }
        }
        function suggestTitle() {
            for (i = 0; i < fileCount; i++) {
                $("#title" + i).val($("#suggestedTitle" + i).val());
            }
        }
        function resetTitle() {
            for (i = 0; i < fileCount; i++) {
                $("#title" + i).val($("#originalTitle" + i).val());
            }
        }
        function suggestTrack() {
            for (i = 0; i < fileCount; i++) {
                $("#track" + i).val($("#suggestedTrack" + i).val());
            }
        }
        function resetTrack() {
            for (i = 0; i < fileCount; i++) {
                $("#track" + i).val($("#originalTrack" + i).val());
            }
        }
        function updateTags() {
            index = 0;
            $("#submitTagEdits").attr({ "disabled" : "disabled" });
            $("#errors").val("");
            for (i = 0; i < fileCount; i++) {
                $("#status" + i).val("");
            }
            updateNextTag();
            $(".ui-button-text", "#cancelTagEdits").html("<fmt:message key='common.back'/>")
            $(".ui-icon", "#cancelTagEdits").removeClass("ui-icon-close").addClass("ui-icon-triangle-1-w");
        }
        function updateNextTag() {
            var path = $("#path" + index).val();
            var artist = $("#artist" + index).val();
            var track = $("#track" + index).val();
            var album = $("#album" + index).val();
            var title = $("#title" + index).val();
            var year = $("#year" + index).val();
            var genre = $("#genre" + index).val();
            $("#status" + index).html("<fmt:message key='edittags.working'/>");
            tagService.setTags(path, track, artist, album, title, year, genre, setTagsCallback);
        }
        function setTagsCallback(result) {
            var message;
            var changed = 0;
            if (result == "SKIPPED") {
                message = "<fmt:message key='edittags.skipped'/>";
            } else if (result == "UPDATED") {
                message = "<b><fmt:message key='edittags.updated'/></b>";
            } else {
                message = "<div class='warning'><fmt:message key='edittags.error'/></div>"
                var errors = $("#errors").val();
                errors += result + "<br/>";
                $("#errors").html(errors);
            }
            $("#status" + index).html(message);
            index++;
            if (index < fileCount) {
                updateNextTag();
            } else {
                $("#submitTagEdits").removeAttr("disabled");
            }
        }
        jQueryLoad.wait(function() {
            $("#cancelTagEdits").click(function() { location.href = '${backUrl}'; });
            $("#submitTagEdits").click(function() { $(updateTags) });
            $("#artistAll").bind('keydown', function(e) {
                var code = (e.keyCode ? e.keyCode : e.which); 
                if (code == 13) { setArtist() }
            });
            $("#albumAll").bind('keydown', function(e) {
                var code = (e.keyCode ? e.keyCode : e.which); 
                if (code == 13) { setAlbum() }
            });
            $("#yearAll").bind('keydown', function(e) {
                var code = (e.keyCode ? e.keyCode : e.which); 
                if (code == 13) { setYear() }
            });
            jQueryUILoad.wait(function() {
                $("#edittagsform").stylize(); $("#mainframemenucontainer").stylize();
                jTooltipsLoad = $LAB
                    .script({src:"script/plugins/jquery-ui.widget.min.js", test:"$.widget"})
                    .script({src:"script/plugins/jquery-ui.position.min.js", test:"$.position"})
                    .script({src:"script/plugins/jquery-ui.tooltips.min.js", test:"$.ui.tooltip"})
                        .wait(function() {
                            $("#edittagsform tr td").tooltip({
                                position: {
                                    my: "left+25 center",
                                    at: "center"
                                },
                                open: function(event) {
                                    var tooltip = $(".ui-tooltip"),
                                        positionOption = $( this ).tooltip("option", "position");
                                    function position(event) {
                                        positionOption.of = event;
                                        tooltip.position(positionOption);
                                    }
                                    $(document).bind("mousemove.tooltip-position", position);
                                    position(event);
                                },
                                close: function() {
                                    $(document).unbind("mousemove.tooltip-position");
                                }
                            });
                        });
            });
        });
    </script>
</html>