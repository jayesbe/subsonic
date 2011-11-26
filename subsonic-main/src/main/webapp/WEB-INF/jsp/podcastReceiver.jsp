<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1" %>
<%@ include file="doctype.jsp" %>

<html>
    <head>
        <%@ include file="head.jsp" %>
        <script type="text/javascript" src="<c:url value="/script/scripts.js"/>"></script>
    </head>
    <body class="mainframe bgcolor1">

        <c:if test="${model.user.podcastRole}">
            <div id="addPodcastFormContainer" class="bgcolor1 mainmenudropdown vcenterouter fillwidth" style="display:none">
                <span class="aligncenter vcenterinner">
                    <form id="addPodcastForm" name="addPodcastForm" method="post" action="podcastReceiverAdmin.view?" class="vcenter">
                        <input type="hidden" name="expandedChannels" value=""/>
                        <fmt:message key="podcastreceiver.address"/>
                        <input type="text" name="add" placeholder="http://" style="width:30em" validation="required url"/>
                        <button type="reset" onClick="toggleAddPodcast()"><fmt:message key="common.cancel"/></button>
                        <button type="submit" onClick="verifyPodcastURI()"><fmt:message key="common.ok"/></button>
                    </form>
                </span>
            </div>
        </c:if>

        <div id="mainframecontainer" class="fillframe">

            <div id="mainframemenucontainer" class="bgcolor1 fade vcenterouter fillwidth">
                <span id="mainframemenuleft" class="vcenterinner">
                    <c:if test="${model.user.podcastRole}">
                        <button class="ui-icon-refresh ui-icon-primary" onClick="refreshChannels()"><fmt:message key="podcastreceiver.check"/></button>
                        <button class="ui-icon-signal-diag ui-icon-primary" onClick="toggleAddPodcast()"><fmt:message key="podcastreceiver.subscribe"/></button>
                        <button id="downloadSelected" class="ui-icon-arrowthickstop-1-s ui-icon-primary ui-helper-hidden" onClick="downloadSelected()"><fmt:message key="podcastreceiver.downloadselected"/></button>
                        <button id="deleteSelected" class="ui-icon-cancel ui-icon-primary ui-helper-hidden" onClick="deleteSelected()"><fmt:message key="podcastreceiver.deleteselected"/></button>
                    </c:if>
                </span>
                <span id="mainframemenucenter" class="vcenterinner">
                    <button id="showEpisodes" class="ui-icon-arrowreturnthick-1-s ui-icon-primary ui-helper-hidden" onClick="toggleAllEpisodes(true)"><fmt:message key="podcastreceiver.expandall"/></button>
                    <button id="hideEpisodes" class="ui-icon-arrowreturnthick-1-n ui-icon-secondary ui-helper-hidden" onClick="toggleAllEpisodes(false)"><fmt:message key="podcastreceiver.collapseall"/></button>
                </span>
                <span id="mainframemenuright" class="vcenterinner">
                    <span class="right">
                        <button class="ui-icon-refresh ui-icon-secondary vcenter" onClick="refreshPage()"><fmt:message key="podcastreceiver.refresh"/></button>
                        <c:if test="${model.user.adminRole}">
                            <button class="ui-icon-wrench ui-icon-secondary vcenter" onClick="location.href='podcastSettings.view?'"><fmt:message key="podcastreceiver.settings"/></button>
                        </c:if>
                    </span>
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
                        <tr class="dense borderless">
                            <td style="padding-left:0.25em;padding-top:1em" colspan="7">Podcast Name</td>
                            <td style="padding-left:1.5em;padding-top:1em;" class="aligncenter">Status</td>
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

                            <tr class="dense borderless">
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
                                <td style="padding-left:1.5em;padding-top:1em;" class="aligncenter">
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
                                <tr title="channel${i.index}" id="episodeRow${episodeCount}" class="dense borderless" style="display:${channelExpanded ? 'table-row' : 'none'}">

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

                                    <td ${class} style="padding-left:1.5em" class="aligncenter">
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
                </div>
            </div>
        </div>
    </body>
    <script type="text/javascript">
        var episodeCount = ${episodeCount};
        var channelCount;
        var wait = false;

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

        function toggleEpisodesUpdate() {
            channelCount = ${fn:length(model.channels)};
            var expandedChannels = getExpandedChannels().split("%20");
            var expandedChannelCount = expandedChannels.length - 1;
            
            $("#hideEpisodes").toggle(expandedChannelCount > 0);
            $("#showEpisodes").toggle(expandedChannelCount != channelCount);

            var newURI = "podcastReceiver.view?";
            if (expandedChannelCount > 0) newURI += "expandedChannels=" + getExpandedChannels();
            persistentTopLinks(newURI, false);
        }

        function selectionUpdate() {
            var selectedChannels = getSelectedChannels().split("%20");
            var selectedChannelCount = selectedChannels.length - 1;
            var selectedEpisodes = getSelectedEpisodes().split("%20");
            var selectedEpisodeCount = selectedEpisodes.length - 1;
            var b = (selectedChannelCount > 0 || selectedEpisodeCount > 0);
            $("#downloadSelected").toggle(b);
            $("#deleteSelected").toggle(b);
        }

        function toggleEpisodes(channelIndex) {
            for (var i = 0; i < episodeCount; i++) {
                var row = $("#episodeRow" + i);
                if (row.attr("title") == "channel" + channelIndex) {
                    row.delay(i * 10).fadeToggle(100);
                    $("#channelExpanded" + channelIndex).attr("checked", !row.is(":visible"));
                }
            }
            toggleEpisodesUpdate();
        }

        function toggleAllEpisodes(visible) {
            if (wait) return;
            wait = true;
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
                wait = false;
            });
            for (i = 0; i < channelCount; i++) {
                $("#channelExpanded" + i).attr("checked", visible ? true : false);
            }
            toggleEpisodesUpdate();
        }

        function getExpandedChannels() {
            var result = "";
            for (var i = 0; i < channelCount; i++) {
                var b = $("#channelExpanded" + i).attr("checked") ? true : false;
                if (b) {
                    result += ($("#channelExpanded" + i).val() + "%20");
                }
            }
            return result;
        }

        function getSelectedChannels() {
            var result = "";
            for (var i = 0; i < channelCount; i++) {
                var b = $("#channel" + i).attr("checked") ? true : false;
                if (b) {
                    result += ($("#channel" + i).val() + "%20");
                }
            }
            return result;
        }

        function getSelectedEpisodes() {
            var result = "";
            for (var i = 0; i < episodeCount; i++) {
                var b = $("#episode" + i).attr("checked") ? true : false;
                if (b) {
                    result += ($("#episode" + i).val() + "%20");
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
                $("#addPodcastForm").validation().stylize();
                $("#mainframemenucontainer").stylize();
                $("#podcastcontainer").css({ 'visibility' : 'visible', "display" : "none" });
                $("#podcastcontainer").delay(30).fadeIn(600);
            });
        });
    </script>
</html>