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

		<script type="text/javascript" src="<c:url value="/script/swfobject.js"/>"></script>
		<script type="text/javascript" src="<c:url value="/script/prototype.js"/>"></script>
		<script type="text/javascript" src="<c:url value="/script/scripts.js"/>"></script>
		<script type="text/javascript" language="javascript">

			var player;
			var position;
			var maxBitRate = ${model.maxBitRate};
			var timeOffset = ${model.timeOffset};

			function init() {

				var flashvars = {
					id:"player1",
					skin:"<c:url value="/flash/whotube.zip"/>",
	//                plugins:"metaviewer-1",
					screencolor:"000000",
					controlbar:"over",
					autostart:"false",
					bufferlength:3,
					backcolor:"<spring:theme code="backgroundColor"/>",
					frontcolor:"<spring:theme code="textColor"/>",
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
				swfobject.embedSWF("<c:url value="/flash/jw-player-5.6.swf"/>", "placeholder1", width, height, "9.0.0", false, flashvars, params, attributes);
			}

			function playerReady(thePlayer) {
				player = $("player1");
				player.addModelListener("TIME", "timeListener");

			<c:if test="${not (model.trial and model.trialExpired)}">
				play();
			</c:if>
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
				$("position").innerHTML = result;
			}

			function changeTimeOffset() {
				timeOffset = $("timeOffset").getValue();
				play();
			}

			function changeBitRate() {
				maxBitRate = $("maxBitRate").getValue();
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

		</script>
	</head>
	<c:choose>
		<c:when test="${model.popout}">
			<body style="margin: 0 auto;" onLoad="init();">
		</c:when>
		<c:otherwise> 
			<body class="mainframe bgcolor1" style="margin: 0 auto; padding-bottom:0.5em" onLoad="init();">
		</c:otherwise>
	</c:choose>

		<div id="mainframecontainer">
			<div id="mainframemenucontainer" class="bgcolor1 searchbox" style="margin-left:-5px; padding: 10px 0px 0px 10px; border-width:1px; width: 100%; height: 30px;">
				<div class="mainframemenuleft">
					<span id="position" style="padding-right:0.5em">0:00</span>
					<select id="timeOffset" onChange="changeTimeOffset();" style="">
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

					<select id="maxBitRate" onChange="changeBitRate();" style="padding-left:0.25em;padding-right:0.25em;margin-right:0.5em">
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
				</div>  

				<div class="mainframemenuleft">
					<c:choose>
						<c:when test="${model.popout}">
							<span class="mainframemenuitem back"><a href="javascript:popin();" style="width: 5em;"><fmt:message key="common.back"/></a></span>
						</c:when>
						<c:otherwise> 
							<span class="mainframemenuitem back"><a href="${backUrl}" style="width: 5em;"><fmt:message key="common.back"/></a></span>
							<span class="mainframemenuitem orward"><a href="javascript:popout();" style="width: 12em;"><fmt:message key="videoPlayer.popout"/></a></span>
						</c:otherwise>
					</c:choose>
				</div>

							
				<div class="mainframemenuright">
					<c:if test="${not model.popout}">
						<form method="post" action="search.view" target="main" name="searchForm">
							<table bgcolor="#ffffff" cellpadding="0px" cellspacing="0px" align="right" width="300px" style="margin-right:5px">
								<tr>
									<td style="border-style:solid none solid solid;border-color:#849dbd;border-width:1px;">
									<input type="text" name="query" id="query" onClick="select();" value="<fmt:message key='search.query'/>"
											onFocus="if(this.value=='<fmt:message key='search.query'/>'){this.value='';this.style.color='#000';}else{this.select();}"
											onBlur="if(this.value=='${search}'){this.value='<fmt:message key='search.query'/>';this.style.color='b3b3b3';}"
											style="margin:1px 0; width:100%; color:b3b3b3; border:0px solid; height:18px; padding:0px 3px; position:relative;">
									</td>
									<td style="border-style:solid solid solid none;border-color:#849dbd;border-width:1px;" width="24px" align="right">
									<input id="Submit" type="image" src="<spring:theme code="searchImage"/>" alt="${search}" title="${search}" align="absBottom" style="border-style:none" width="18px">
									<!--<a href="javascript:document.searchForm.submit()"><img src="<spring:theme code="searchImage"/>" alt="${search}" title="${search}"></a>-->
									</td>
								</tr>
							</table>
						</form>
					</c:if>
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
									<fmt:message
											key="networksettings.trialnotexpired"><fmt:param>${expiryDate}</fmt:param></fmt:message>
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
						<div id="placeholder1"><a href="http://www.adobe.com/go/getflashplayer" target="_blank"><fmt:message key="playlist.getflash"/></a></div>
						</div>
					</span>

			</div>
		</div>
</body>
</html>
