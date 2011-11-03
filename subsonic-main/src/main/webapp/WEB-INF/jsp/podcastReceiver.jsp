<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1" %>
<%@ include file="doctype.jsp" %>

<html>
    <head>
        <%@ include file="head.jsp" %>
        <script type="text/javascript" src="<c:url value="/script/scripts.js"/>"></script>

        <script type="text/javascript">
            var channelCount;
            var playing = false;
            
            function itemSelected() {
            }

            function downloadSelected() {
                if (getSelectedEpisodes().length == 0 && getSelectedChannels().length == 0) { return false; }
                location.href = "podcastReceiverAdmin.view?downloadChannel=" + getSelectedChannels() +
                                "&downloadEpisode=" + getSelectedEpisodes() +
                                "&expandedChannels=" + getExpandedChannels();
            }

            function deleteSelected() {
                if (getSelectedChannels().length == 0 && getSelectedEpisodes().length == 0) { return false; }
                if (confirm("<fmt:message key='podcastreceiver.confirmdelete'/>")) {
                    location.href = "podcastReceiverAdmin.view?deleteChannel=" + getSelectedChannels() +
                    "&deleteEpisode=" + getSelectedEpisodes() +
                    "&expandedChannels=" + getExpandedChannels();
                }
            }

            function refreshChannels() {
                location.href = "podcastReceiverAdmin.view?refresh=" + ((getExpandedChannels() != null) ? "&expandedChannels=" + getExpandedChannels() : "");
            }

            function refreshPage() {
                location.href = "podcastReceiver.view?" + ((getExpandedChannels() != null) ? "expandedChannels=" + getExpandedChannels() : "");
            }

            function toggleEpisodesUpdate() {
                channelCount = ${fn:length(model.channels)};
                var expandedChannels = getExpandedChannels().split(" ");
                var expandedChannelCount = expandedChannels.length - 1;
                
                (expandedChannelCount > 0) ? $("#hideEpisodes").show() : $("#hideEpisodes").hide();
                (expandedChannelCount == channelCount) ? $("#showEpisodes").hide() : $("#showEpisodes").show();

                var newURI = "podcastReceiver.view?" + ((expandedChannelCount > 0) ? "expandedChannels=" + getExpandedChannels() : "");
                persistentTopLinks(newURI, false);
            }

            function selectionUpdate() {
                var selectedChannels = getSelectedChannels().split(" ");
                var selectedChannelCount = selectedChannels.length - 1;
                var selectedEpisodes = getSelectedEpisodes().split(" ");
                var selectedEpisodeCount = selectedEpisodes.length - 1;

                if (selectedChannelCount > 0 || selectedEpisodeCount > 0) {$("#downloadSelected").show(); $("#deleteSelected").show()} else {$("#downloadSelected").hide(); $("#deleteSelected").hide();}
            }

            function toggleEpisodes(channelIndex) {
                
                for (var i = 0; i < episodeCount; i++) {
                    var row = $("#episodeRow" + i)[0];
                    if (row.title == "channel" + channelIndex) {
                        $(row).delay(i * 10).fadeToggle(100);
                        $("#channelExpanded" + channelIndex)[0].checked = !$(row).is(':visible') ? "checked" : "";
                    }
                }
                toggleEpisodesUpdate();
            }

            function toggleAllEpisodes(visible) {
                if (playing) return;
                playing = true;
                if (visible) {
                    $('tr[id^="episodeRow"]').each(function(i) {
                        $(this).css({ 'visibility' : 'visible', "display" : "none" });
                        $(this).delay(i * 10).fadeIn(400);
                    })
                } else {
                    $('tr[id^="episodeRow"]').each(function(i) {
                        $(this).delay(i * 10).fadeOut(200);
                    });
                }
                $('tr[id^="episodeRow"]').promise().done(function() {
                    playing = false;
                });
                for (i = 0; i < channelCount; i++) {
                    $("#channelExpanded" + i)[0].checked =  visible ? "checked" : "";
                }
                toggleEpisodesUpdate();
            }

            function getExpandedChannels() {
                var result = "";
                for (var i = 0; i < channelCount; i++) {
                    var checkbox = $("#channelExpanded" + i)[0];
                    if (checkbox.checked) {
                        result += (checkbox.value + " ");
                    }
                }
                return result;
            }

            function getSelectedChannels() {
                var result = "";
                for (var i = 0; i < channelCount; i++) {
                    var checkbox = $("#channel" + i)[0];
                    if (checkbox.checked) {
                        result += (checkbox.value + " ");
                    }
                }
                return result;
            }

            function getSelectedEpisodes() {
                var result = "";
                for (var i = 0; i < episodeCount; i++) {
                    var checkbox = $("#episode" + i)[0];
                    if (checkbox.checked) {
                        result += (checkbox.value + " ");
                    }
                }
                return result;
            }

            function toggleAddPodcast() {
                $("#addPodcastFormContainer").toggle("blind");
            }
            
            function verifyPodcastURI() {
                // Not foolproof but keeps most 
                // junk values from being submitted.
                var uri = document.addPodcastForm.add.value;
                var regexp = /(http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/;

                // Check for null value
                if (uri == "") {
                    return false;
                }
                // Check for valid URI
                if (regexp.test(uri) == false) {
                    return false;
                }
                
                // Checks passed: submit
                document.addPodcastForm.submit();
                toggleAddPodcast();
            }
            
            jQueryLoad.wait(function() {
                $(toggleEpisodesUpdate)
                jQueryUILoad.wait(function() {
                    $("#podcastcontainer").css({ 'visibility' : 'visible', "display" : "none" });
                    $("#podcastcontainer").delay(30).fadeIn(600);
                });
            });
        </script>
    </head>
    <body class="mainframe bgcolor1">

        <c:if test="${model.user.podcastRole}">
            <div id="addPodcastFormContainer" class="bgcolor1" style="display:none">
                <div style="width:50%;margin:2px auto;">
                    <form name="addPodcastForm" method="post" action="podcastReceiverAdmin.view?">
                        <input type="hidden" name="expandedChannels" value=""/>
                        <table>
                            <tr>
                                <td><fmt:message key="podcastreceiver.address"/></td>
                                <td><input type="text" name="add" value="" style="width:30em" onclick="select()"/></td>
                                <td><input type="button" value="<fmt:message key='common.ok'/>" onClick="verifyPodcastURI()"/></td>
                                <td><input type="reset" value="<fmt:message key='common.cancel'/>" onClick="toggleAddPodcast()"/></td>
                            </tr>
                        </table>
                    </form>
                </div>
            </div>
        </c:if>

        <div id="mainframecontainer">

            <div id="mainframemenucontainer" class="bgcolor1 fade">
                <span id="mainframemenuleft">
                    <c:if test="${model.user.podcastRole}">
                        <span class="mainframemenuitem refresh"><a href="javascript:refreshChannels()"><fmt:message key="podcastreceiver.check"/></a></span>
                        <span id="addPodcast" class="mainframemenuitem addFromURI"><a href="#" onClick="javascript:toggleAddPodcast()"><fmt:message key="podcastreceiver.subscribe"/></a></span>
                        <span id="downloadSelected" class="mainframemenuitem download" style="display:none"><a href="javascript:downloadSelected()"><fmt:message key="podcastreceiver.downloadselected"/></a></span>
                        <span id="deleteSelected" class="mainframemenuitem delete" style="display:none"><a href="javascript:deleteSelected()"><fmt:message key="podcastreceiver.deleteselected"/></a></span>
                    </c:if>
                </span>
                <span id="mainframemenucenter">
                    <span id="hideEpisodes" class="mainframemenuitem up" style="display:none"><a href="javascript:toggleAllEpisodes(false)"><fmt:message key="podcastreceiver.collapseall"/></a></span>
                    <span id="showEpisodes" class="mainframemenuitem down" style="display:none"><a href="javascript:toggleAllEpisodes(true)"><fmt:message key="podcastreceiver.expandall"/></a></span>
                </span>
                <span id="mainframemenuright">
                    <span class="mainframemenuitem refresh right"><a href="javascript:refreshPage()"><fmt:message key="podcastreceiver.refresh"/></a></span>
                    <c:if test="${model.user.adminRole}">
                        <span class="mainframemenuitem forward right"><a href="podcastSettings.view?"><fmt:message key="podcastreceiver.settings"/></a></span>
                    </c:if>
                </span>
            </div>

            <div id="mainframecontentcontainer">
                <div id="mainframecontent">
                    <div id="mainframecontentheader" class="fade">
                        <h1>
                            <img id="pageimage" src="<spring:theme code="podcastImage"/>" alt=""/>
                            <span class="desc"><fmt:message key="podcastreceiver.title"/></span>
                        </h1>
                    </div>

                    <table id="podcastcontainer" style="border-collapse:collapse;white-space:nowrap">
                        <tr style="margin:0;padding:0;border:0">
                            <td style="padding-left:0.25em;padding-top:1em" colspan="7">Podcast Name</td>
                            <td style="padding-left:1.5em;padding-top:1em;text-align:center;" align="center">Status</td>
                            <td style="padding-left:1.5em;padding-top:1em">Details</td>
                        </tr>

                        <c:set var="episodeCount" value="0"/>

                        <c:forEach items="${model.channels}" var="channel" varStatus="i">

                            <c:set var="title" value="${channel.key.title}"/>
                            <c:if test="${empty title}">
                                <c:set var="title" value="${channel.key.url}"/>
                            </c:if>

                            <c:set var="channelExpanded" value="false"/>
                            <c:forEach items="${model.expandedChannels}" var="expandedChannelId">
                                <c:if test="${expandedChannelId eq channel.key.id}">
                                    <c:set var="channelExpanded" value="true"/>
                                </c:if>
                            </c:forEach>

                            <tr style="margin:0;padding:0;border:0">
                                <td style="padding-top:1em">
                                    <input type="checkbox" class="checkbox" id="channel${i.index}" value="${channel.key.id}" onClick="selectionUpdate()"/>
                                    <input type="checkbox" class="checkbox" id="channelExpanded${i.index}" value="${channel.key.id}" style="display:none"
                                           <c:if test="${channelExpanded}">checked="checked"</c:if>/>
                                </td>
                                <td colspan="6" style="padding-left:0.25em;padding-top:1em">
                                    <a href="javascript:toggleEpisodes(${i.index})">
                                        <span title="${title}"><b><str:truncateNicely upper="40">${title}</str:truncateNicely></b></span>
                                        (${fn:length(channel.value)})
                                    </a>
                                </td>
                                <td style="padding-left:1.5em;padding-top:1em;text-align:center;">
                                    <span class="detail"><fmt:message key="podcastreceiver.status.${fn:toLowerCase(channel.key.status)}"/></span>
                                </td>
                                <td style="padding-left:1.5em;padding-top:1em">
                                    <c:choose>
                                        <c:when test="${channel.key.status eq 'ERROR'}">
                                            <span class="detail warning" title="${channel.key.errorMessage}"><str:truncateNicely upper="100">${channel.key.errorMessage}</str:truncateNicely></span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="detail" title="${channel.key.description}"><str:truncateNicely upper="100">${channel.key.description}</str:truncateNicely></span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>

                            <c:set var="class" value=""/>

                            <c:forEach items="${channel.value}" var="episode" varStatus="j">

                                <c:choose>
                                    <c:when test="${empty class}">
                                        <c:set var="class" value="class='bgcolor2'"/>
                                    </c:when>
                                    <c:otherwise>
                                        <c:set var="class" value=""/>
                                    </c:otherwise>
                                </c:choose>
                                <tr title="channel${i.index}" id="episodeRow${episodeCount}" style="margin:0;padding:0;border:0;display:${channelExpanded ? 'table-row' : 'none'}">

                                    <td><input type="checkbox" class="checkbox" id="episode${episodeCount}" value="${episode.id}" onClick="selectionUpdate()"/></td>

                                    <c:choose>
                                        <c:when test="${empty episode.path}">
                                            <td ${class} colspan="3"/>
                                        </c:when>
                                        <c:otherwise>
                                            <c:import url="playAddDownload.jsp">
                                                <c:param name="path" value="${episode.path}"/>
                                                <c:param name="playEnabled" value="${model.user.streamRole and not model.partyMode}"/>
                                                <c:param name="addEnabled" value="${model.user.streamRole and not model.partyMode}"/>
                                                <c:param name="downloadEnabled" value="false"/>
                                                <c:param name="asTable" value="true"/>
                                            </c:import>
                                        </c:otherwise>
                                    </c:choose>

                                    <c:set var="episodeCount" value="${episodeCount + 1}"/>


                                    <sub:url value="main.view" var="mainUrl">
                                        <sub:param name="path" value="${episode.path}"/>
                                    </sub:url>


                                    <td ${class} style="padding-left:0.6em">
                                        <span title="${episode.title}">
                                            <c:choose>
                                                <c:when test="${empty episode.path}">
                                                    <str:truncateNicely upper="40">${episode.title}</str:truncateNicely>
                                                </c:when>
                                                <c:otherwise>
                                                    <a target="main" href="${mainUrl}"><str:truncateNicely upper="40">${episode.title}</str:truncateNicely></a>
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </td>

                                    <td ${class} style="padding-left:1.5em">
                                        <span class="detail">${episode.duration}</span>
                                    </td>

                                    <td ${class} style="padding-left:1.5em">
                                        <span class="detail"><fmt:formatDate value="${episode.publishDate}" dateStyle="medium"/></span>
                                    </td>

                                    <td ${class} style="padding-left:1.5em;text-align:center">
                                        <span class="detail">
                                        <c:choose>
                                            <c:when test="${episode.status eq 'DOWNLOADING'}">
                                                <fmt:formatNumber type="percent" value="${episode.completionRate}"/>
                                            </c:when>
                                            <c:otherwise>
                                                <fmt:message key="podcastreceiver.status.${fn:toLowerCase(episode.status)}"/>
                                            </c:otherwise>
                                        </c:choose>
                                        </span>
                                    </td>

                                    <td ${class} style="padding-left:1.5em">
                                        <c:choose>
                                            <c:when test="${episode.status eq 'ERROR'}">
                                                <span class="detail warning" title="${episode.errorMessage}"><str:truncateNicely upper="100">${episode.errorMessage}</str:truncateNicely></span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="detail" title="${episode.description}"><str:truncateNicely upper="100">${episode.description}</str:truncateNicely></span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                </tr>
                            </c:forEach>
                        </c:forEach>
                    </table>

                    <script type="text/javascript" language="javascript">
                        var episodeCount = ${episodeCount};
                    </script>

                    <table style="padding-top:1em"><tr>
                    </tr></table>
                </div>
            </div>
        </div>
    </body>
</html>