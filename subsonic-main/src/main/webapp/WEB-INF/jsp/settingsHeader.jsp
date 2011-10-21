<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1" %>
<%@ include file="include.jsp" %>

<c:set var="categories" value="${param.restricted ? 'personal password player share' : 'musicFolder general advanced personal user player share network transcoding internetRadio podcast search'}"/>

<div id="mainframecontainer">
	<div id="mainframemenucontainer" class="bgcolor1">
		<span id="mainframemenucenter">
			<c:forTokens items="${categories}" delims=" " var="cat" varStatus="loopStatus">
				<c:url var="url" value="${cat}Settings.view?"/>
				<c:choose>
					<c:when test="${param.cat eq cat}">
						<span class="mainframemenuitem forward"><b><fmt:message key="settingsheader.${cat}"/></b></span>
					</c:when>
					<c:otherwise>
						<span class="mainframemenuitem settings"><a href="${url}"><fmt:message key="settingsheader.${cat}"/></a></span>
					</c:otherwise>
				</c:choose>
			</c:forTokens>
		</span>
	</div>

	<div id="mainframecontentcontainer">
		<div id="mainframecontent">

			<h1>
				<img id="pageimage" src="<spring:theme code='settingsImage'/>" alt=""/>
				<span class="desc"><fmt:message key="settingsheader.title"/></span>
			</h1>

			<blockquote>
