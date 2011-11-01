<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1" %>
<%@ include file="include.jsp" %>

<script type="text/javascript" src="<c:url value="/script/scripts.js"/>"></script>

<c:set var="categories" value="${param.restricted ? 'personal password player share' : 'general personal user player musicFolder share search podcast internetRadio network transcoding advanced'}"/>

<div id="mainframecontainer">
    <div id="mainframemenucontainer" class="bgcolor1 fade">
        <span id="mainframemenucenter">
            <c:forTokens items="${categories}" delims=" " var="cat" varStatus="loopStatus">
                <c:url var="url" value="${cat}Settings.view?"/>
                <c:choose>
                    <c:when test="${param.cat eq cat}">
                        <span class="mainframemenuitem forward"><b><fmt:message key="settingsheader.${cat}"/></b></span>
                    </c:when>
                    <c:otherwise>
                        <span class="mainframemenuitem settings"><a href="#" onClick="persistentTopLinks('${cat}'+'Settings.view?')"><fmt:message key="settingsheader.${cat}"/></a></span>
                    </c:otherwise>
                </c:choose>
            </c:forTokens>
        </span>
    </div>

    <div id="mainframecontentcontainer">
        <div id="mainframecontent">


            <div id="mainframecontentheader" class="fade">
                <h1>
                    <img id="pageimage" src="<spring:theme code='settingsImage'/>" alt=""/>
                    <span class="desc"><fmt:message key="settingsheader.title"/></span>
                </h1>
            </div>

            <blockquote class="fade">
