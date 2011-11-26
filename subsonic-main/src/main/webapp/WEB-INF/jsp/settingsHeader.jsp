<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1" %>
<%@ include file="include.jsp" %>

<script type="text/javascript" src="<c:url value="/script/wz_tooltip.js"/>"></script>
<script type="text/javascript" src="<c:url value="/script/tip_balloon.js"/>"></script>
<script type="text/javascript" src="<c:url value="/script/scripts.js"/>"></script>
<script type="text/javascript">
function init() {
    $("form:first").prepend('<div class="right"><button type="reset" id="cancelSettings"><fmt:message key="common.cancel"/></button><button type="submit" id="submitSettings" class="ui-icon-disk"><fmt:message key="common.save"/></button></div>').stylize();
    $("#cancelSettings").click(function() { location.href = 'nowPlaying.view'; });
    $("#mainframemenucontainer").stylize().buttonset();
    $("#mainframemenucontainer .ui-state-active").hover(function() { $(this).removeClass("ui-state-active"); }, function() { $(this).addClass("ui-state-active"); }).click(function() { $(this).addClass("ui-state-active"); });;
    $("#mainframemenucontainer .ui-icon").parent().removeClass("ui-button-text-icon-secondary").addClass("ui-button-text-only");
}

</script>

<c:set var="categories" value="${param.restricted ? 'personal password player share' : 'general personal user player musicFolder share search podcast internetRadio network transcoding advanced'}"/>

<div id="mainframecontainer" class="fillframe">
    <div id="mainframemenucontainer" class="bgcolor1 fade vcenterouter fillwidth">
        <span id="mainframemenucenter" class="vcenterinner aligncenter">
            <span class="vcenter">
            <c:forTokens items="${categories}" delims=" " var="cat" varStatus="loopStatus">
                <c:url var="url" value="${cat}Settings.view?"/>
                <c:choose>
                    <c:when test="${param.cat eq cat}">
                        <button class="ui-icon-wrench ui-icon-primary ui-state-active"><h2><fmt:message key="settingsheader.${cat}"/></h2></button>
                    </c:when>
                    <c:otherwise>
                        <button onClick="persistentTopLinks('${cat}'+'Settings.view?')"><fmt:message key="settingsheader.${cat}"/></button>
                    </c:otherwise>
                </c:choose>
            </c:forTokens>
            </span>
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
