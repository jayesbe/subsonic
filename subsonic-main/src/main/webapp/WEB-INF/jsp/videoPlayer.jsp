<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1" %>
<%@ include file="doctype.jsp" %>

<html>
    <head>
        <%@ include file="head.jsp" %>

        <sub:url value="videoPlayer.view" var="baseUrl"><sub:param name="path" value="${model.video.path}"/></sub:url>
        <sub:url value="main.view" var="backUrl"><sub:param name="path" value="${model.video.parent.path}"/></sub:url>

        <sub:url value="/stream" var="streamUrl">
            <sub:param name="path" value="${model.video.path}"/>
        </sub:url>

        <script type="text/javascript" src="<c:url value="/script/scripts.js"/>"></script>
        <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/swfobject/2.2/swfobject.js"></script>
    </head>
    <c:choose>
        <c:when test="${model.popout}">
            <body class="center">
        </c:when>
        <c:otherwise> 
            <body class="mainframe bgcolor1" class="center">
        </c:otherwise>
    </c:choose>

        <div id="mainframecontainer" class="fillframe">
            <div id="mainframemenucontainer" class="bgcolor1 fade vcenterouter fillwidth">
                <div id="mainframemenuleft" class="vcenterinner">
                    <c:if test="${not model.popout}"> 
                        <button onClick="location.href='${backUrl}'" class="ui-icon-triangle-1-w ui-icon-primary vcenter"><fmt:message key="common.back"/></button>
                    </c:if>
                </div>
                <div id="mainframemenucenter" class="vcenterinner">
                    <span class="center vcenter">
                        <select id="timeOffset" onChange="changeTimeOffset();">
                            <c:forEach items="${model.skipOffsets}" var="skipOffset">
                                <c:choose>
                                    <c:when test="${skipOffset.value - skipOffset.value mod 60 eq model.timeOffset - model.timeOffset mod 60}">
                                        <option selected="selected" value="${skipOffset.value}">${skipOffset.key}</option>
                                    </c:when>
                                    <c:otherwise>
                                        <option value="${skipOffset.value}">${skipOffset.key}</option>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </select>
                        <span id="position">0:00</span>
                        <select id="maxBitRate" onChange="changeBitRate();">
                            <c:forEach items="${model.bitRates}" var="bitRate">
                                <c:choose>
                                    <c:when test="${bitRate eq model.maxBitRate}">
                                        <option selected="selected" value="${bitRate}">${bitRate} Kbps</option>
                                    </c:when>
                                    <c:otherwise>
                                        <option value="${bitRate}">${bitRate} Kbps</option>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </select>
                    </span>
                </div>
                <div id="mainframemenuright" class="vcenterinner">
                    <c:choose>
                        <c:when test="${model.popout}">
                            <button onClick="javascript:popin();" class="ui-icon-newwin ui-icon-secondary right"><fmt:message key="common.back"/></button>
                        </c:when>
                        <c:otherwise>
                            <button onClick="javascript:popout();" class="ui-icon-newwin ui-icon-secondary right"><fmt:message key="videoPlayer.popout"/></button>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            <div id="mainframecontentcontainer">
                <div id="mainframecontent">

                    <c:if test="${model.trial}">
                        <fmt:formatDate value="${model.trialExpires}" dateStyle="long" var="expiryDate"/>

                        <p class="warning" style="padding-top:1em">
                            <c:choose>
                                <c:when test="${model.trialExpired}">
                                    <fmt:message key="networksettings.trialexpired"><fmt:param>${expiryDate}</fmt:param></fmt:message>
                                </c:when>
                                <c:otherwise>
                                    <fmt:message key="networksettings.trialnotexpired"><fmt:param>${expiryDate}</fmt:param></fmt:message>
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </c:if>

                    <c:if test="${not model.popout}">
                        <div style="height:2.0em"></div>
                        <h1 style="padding-top:10pt;">${model.video.title}</h1>
                    </c:if>
                    <span style="text-align:center">
                        <div id="wrapper" style="background-color:#000;margin-left:-5px">
                        <div id="videoplaceholder"><a href="http://www.adobe.com/go/getflashplayer" target="_blank"><fmt:message key="playlist.getflash"/></a></div>
                        </div>
                    </span>

            </div>
        </div>
    </body>
    <script type="text/javascript">
        var player;
        var position;
        var maxBitRate = ${model.maxBitRate};
        var timeOffset = ${model.timeOffset};

        function init() {
            var jwplayerskin = "/flash/skins/<spring:theme code='jwPlayerVideoSkin'/>.zip"

            var flashvars = {
                id:"player1",
                skin: jwplayerskin,
//                plugins:"metaviewer-1",
                screencolor:"000000",
                controlbar:"over",
                autostart:"false",
                bufferlength:3,
                backcolor:"<spring:theme code='backgroundColor'/>",
                frontcolor:"<spring:theme code='textColor'/>",
                provider:"video"
            };
            var params = {
                allowfullscreen:"true",
                allowscriptaccess:"always"
            };
            var attributes = {
                id:"player1",
                name:"player1"
            };

            var width = "${model.popout ? '100%' : '600'}";
            var height = "${model.popout ? '85%' : '360'}";
            swfobject.embedSWF("<c:url value='/flash/jw-player-5.8.swf'/>", "videoplaceholder", width, height, "9", false, flashvars, params, attributes);
        }

        function playerReady(thePlayer) {
            player = $("#player1")[0];
            player.addModelListener("TIME", "timeListener");

            if (${not (model.trial and model.trialExpired)}){
                play();
            }
        }

        function play() {
            var list = new Array();
            list[0] = {
                file:"${streamUrl}&maxBitRate=" + maxBitRate + "&timeOffset=" + timeOffset + "&player=${model.player}",
                duration:${model.duration} - timeOffset,
                provider:"video"
            };
            player.sendEvent("LOAD", list);
            player.sendEvent("PLAY");
        }

        function timeListener(obj) {
            var newPosition = Math.round(obj.position);
            if (newPosition != position) {
                position = newPosition;
                updatePosition();
            }
        }

        function updatePosition() {
            var pos = getPosition();

            var minutes = Math.round(pos / 60);
            var seconds = pos % 60;

            var result = minutes + ":";
            if (seconds < 10) {
                result += "0";
            }
            result += seconds;
            $("#position .ui-button-text").html(result);
        }

        function changeTimeOffset() {
            timeOffset = $("#timeOffset").val();
            play();
        }

        function changeBitRate() {
            maxBitRate = $("#maxBitRate").val();
            timeOffset = getPosition();
            play();
        }

        function popout() {
            var url = "${baseUrl}&maxBitRate=" + maxBitRate + "&timeOffset=" + getPosition() + "&popout=true";
            popupSize(url, "video", 600, 400);
            window.location.href = "${backUrl}";
        }

        function popin() {
            window.opener.location.href = "${baseUrl}&maxBitRate=" + maxBitRate + "&timeOffset=" + getPosition();
            window.close();
        }

        function getPosition() {
            return parseInt(timeOffset) + parseInt(position);
        }

        jQueryLoad.wait(function() {
            $(init);
            jQueryUILoad.wait(function() {
                $("#mainframemenucontainer").stylize();
                $("#position").button().addClass("headerSelected");
            });
        });
    </script>
</html>
