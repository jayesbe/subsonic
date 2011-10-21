<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1" %>
<%@ include file="doctype.jsp" %>

<html>
	<head>
		<%@ include file="head.jsp" %>
		<script type="text/javascript" src="https://apis.google.com/js/plusone.js"></script>
	</head>
	<body class="mainframe bgcolor1">
		<div id="mainframecontainer">
			<div id="mainframemenucontainer" class="bgcolor1">
				<span id="mainframemenuleft">
					<c:if test="${not empty model.dir}">
						<sub:url value="main.view" var="backUrl"><sub:param name="path" value="${model.dir.path}"/></sub:url>
						<span class="mainframemenuitem back cancel"><a href="${backUrl}"><fmt:message key="common.back"/></a></span>
					</c:if>
				</span>
				<span id="mainframemenuright">
					<c:if test="${model.user.settingsRole}">
						<span class="mainframemenuitem forward right"><a href="shareSettings.view"><fmt:message key="share.manage"/></a></span>
					</c:if>
				</span>
			</div>

			<div id="mainframecontentcontainer">
				<div id="mainframecontent">

					<h1><fmt:message key="share.title"/></h1>

					<c:choose>
					    <c:when test="${model.urlRedirectionEnabled}">
					        <fmt:message key="share.warning"/>
					        <p>
					            <a href="http://www.facebook.com/sharer.php?u=${model.playUrl}" target="_blank"><img src="<spring:theme code="shareFacebookImage"/>" alt=""></a>&nbsp;
					            <a href="http://www.facebook.com/sharer.php?u=${model.playUrl}" target="_blank"><fmt:message key="share.facebook"/></a>
					        </p>
					
					        <p>
					            <a href="http://twitter.com/?status=Listening to ${model.playUrl}" target="_blank"><img src="<spring:theme code="shareTwitterImage"/>" alt=""></a>&nbsp;
					            <a href="http://twitter.com/?status=Listening to ${model.playUrl}" target="_blank"><fmt:message key="share.twitter"/></a>
					        </p>
					        <p>
					            <g:plusone size="small" annotation="none" href="${model.playUrl}"></g:plusone>&nbsp;<fmt:message key="share.googleplus"/>
					        </p>
					        <p>
					            <fmt:message key="share.link">
					                <fmt:param>${model.playUrl}</fmt:param>
					            </fmt:message>
					        </p>
					    </c:when>
					    <c:otherwise>
					        <p>
					            <fmt:message key="share.disabled"/>
					        </p>
					    </c:otherwise>
					</c:choose>
				</div>
			</div>
		</div>
	</body>
</html>