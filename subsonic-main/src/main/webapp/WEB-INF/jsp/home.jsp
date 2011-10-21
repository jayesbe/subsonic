<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1"%>
<%@ include file="doctype.jsp" %>

<html>
    <head>
        <%@ include file="head.jsp" %>
        <link href="<c:url value="/style/shadow.css"/>" rel="stylesheet">
        <c:if test="${model.listType eq 'random'}">
            <meta http-equiv="refresh" content="2000">
        </c:if>
        <script type="text/javascript" src="<c:url value="/script/prototype.js"/>"></script>
        <script type="text/javascript" src="<c:url value="/script/scriptaculous.js?load=effects"/>"></script>
        <script type="text/javascript">        
            function updateListOption(opt, val) {
                var newURI = 'home.view?listType='
                switch (opt) {
                    case ("type"):    newURI += val + '&listRows=${model.listRows}&listColumns=${model.listColumns}&listOffset=${model.listOffset}'; break;
                    case ("rows"):    newURI += '${model.listType}&listRows=' + val + '&listColumns=${model.listColumns}&listOffset=${model.listOffset}'; break;
                    case ("columns"): newURI += '${model.listType}&listRows=${model.listRows}&listColumns=' + val + '&listOffset=${model.listOffset}'; break;
                    case ("offset"):  newURI += '${model.listType}&listRows=${model.listRows}&listColumns=${model.listColumns}&listOffset=' + val; break;
                }
                parent.upper.document.getElementById("homeLink").href = newURI;
                parent.upper.document.getElementById("homeLinkDesc").href = newURI;
                parent.main.src = newURI;
                location =  newURI;
            }
        </script>
    </head>
    <body class="mainframe bgcolor1">
        <fmt:message key='common.pluralizer' var="pluralizer"/>
        <div id="mainframecontainer">

            <div id="mainframemenucontainer" class="bgcolor1">
                <span id="mainframemenuleft">
                    <select name="listRows" id="listRows" onChange="updateListOption('rows', options[selectedIndex].value);">
                    <c:forTokens items="1 2 3 4 5 6 7 8 9 10 15 20 25 30 40 50 75 100" delims=" " var="listrows">
                            <option ${listrows eq model.listRows ? "selected" : ""} value="${listrows}"><fmt:message key="home.listrows"><fmt:param value="${listrows}"/></fmt:message>${listrows gt 1 ? pluralizer : ""}</option>
                    </c:forTokens>
                    </select>

                    <select name="listColumns" id="listColumns" onChange="updateListOption('columns', options[selectedIndex].value);">
                    <c:forEach begin="1" end="18" var="listcolumns">
                            <c:if test="${listcolumns gt 10}">

                                    <c:set var="listcolumns" value="${((listcolumns - 10) * 5) + 10}"/>
                            </c:if>
                            <option ${listcolumns eq model.listColumns ? "selected" : ""} value="${listcolumns}"><fmt:message key="home.listcolumns"><fmt:param value="${listcolumns}"/></fmt:message>${listcolumns gt 1 ? pluralizer : ""}</option>
                    </c:forEach>
                    </select>
                </span>
                <span id="mainframemenucenter">
                    <c:choose>
                        <c:when test="${model.listType eq 'random'}">
                            <sub:url value="home.view" var="moreUrl">
                                <sub:param name="listType" value="${model.listType}"/>
                                <sub:param name="listRows" value="${model.listRows}"/>
                                <sub:param name="listColumns" value="${model.listColumns}"/>
                            </sub:url>
                            <span class="mainframemenuitem"><a href="${moreUrl}" style="width:5em;"><fmt:message key="common.more"/></a></span>
                        </c:when>
                        <c:otherwise>
                            <sub:url value="home.view" var="previousUrl">
                                <sub:param name="listType" value="${model.listType}"/>
                                <sub:param name="listRows" value="${model.listRows}"/>
                                <sub:param name="listColumns" value="${model.listColumns}"/>
                                <sub:param name="listOffset" value="${model.listOffset - model.listSize}"/>
                            </sub:url>
                            <sub:url value="home.view" var="nextUrl">
                                <sub:param name="listType" value="${model.listType}"/>
                                <sub:param name="listRows" value="${model.listRows}"/>
                                <sub:param name="listColumns" value="${model.listColumns}"/>
                                <sub:param name="listOffset" value="${model.listOffset + model.listSize}"/>
                            </sub:url>
                                <span class="mainframemenuitem back"><a href="${previousUrl}" onclick="updateListOption('offset', ${model.listOffset - model.listSize});"><fmt:message key="common.previous"/></a></span>
                                <span class="mainframemenuitem current"><fmt:message key="home.albums"><fmt:param value="${model.listOffset + 1}"/><fmt:param value="${model.listOffset + model.listSize}"/></fmt:message></span>
                                <span class="mainframemenuitem forward"><a href="${nextUrl}" onclick="updateListOption('offset', ${model.listOffset + model.listSize});"><fmt:message key="common.next"/></a></span>
                        </c:otherwise>
                    </c:choose>
                </span>

                <span id="mainframemenuright">
                        <%@ include file="searchbox.jsp" %>
                </span>
            </div>

            <div id="mainframecontentcontainer">
                <div id="mainframecontent">
                    <h1>
                            <img id="pageimage" src="<spring:theme code="homeImage"/>" alt="" />
                            <span class="desc">${model.welcomeTitle}</span>
                    </h1>

                    <c:if test="${not empty model.welcomeSubtitle}">
                            <h2>${model.welcomeSubtitle}</h2>
                    </c:if>

                    <h2 class="homecategories">
                        <c:set var="listTypeEnum" value="newest highest frequent recent random"/>
                        <c:set var="listTypeEnum">${model.listType} <str:replace replace="${model.listType}" with="">${listTypeEnum}</str:replace></c:set>
                        <c:forTokens items="${listTypeEnum}" delims=" " var="cat" varStatus="loopStatus">
                            ${loopStatus.count gt 1 ? "&nbsp;|&nbsp;" : ""}
                            <sub:url var="url" value="home.view">
                                <sub:param name="listType" value="${cat}"/>
                                <sub:param name="listRows" value="${model.listRows}"/>
                                <sub:param name="listColumns" value="${model.listColumns}"/>
                            </sub:url>

                            <c:choose>
                                <c:when test="${model.listType eq cat}">
                                    <span class="headerSelected"><fmt:message key="home.${cat}.title"/></span>
                                </c:when>
                                <c:otherwise>
                                    <a href="${url}" onclick="updateListOption('type','${cat}');"><fmt:message key="home.${cat}.title"/></a>
                                </c:otherwise>
                            </c:choose>
                        </c:forTokens>
                    </h2>

                    <div id="longbar"></div>

                    <c:if test="${model.isIndexBeingCreated}">
                        <p class="warning"><fmt:message key="home.scan"/></p>
                    </c:if>

                    <h2 id="pageimage"><fmt:message key="home.${model.listType}.text"/></h2>

                    <div id="homeContent" style="vertical-align:top;float:left;width:100%">
                        <div id="categoryContent">
                            <c:choose>
                                <c:when test="${model.listType eq 'users'}">
                                </c:when>
                                <c:otherwise>
                                    <c:if test="${not empty model.welcomeMessage}"><table><tr><td></c:if>
                                    <table>
                                        <c:forEach items="${model.albums}" var="album" varStatus="loopStatus">
                                            <c:if test='${loopStatus.count % model.listColumns == 1}'>
                                                <tr>
                                            </c:if>
                                            <td style="vertical-align:top">
                                                <table>
                                                    <tr>
                                                        <td>
                                                            <c:import url="coverArt.jsp">
                                                                <c:param name="albumPath" value="${album.path}"/>
                                                                <c:param name="albumName" value="${album.albumTitle}"/>
                                                                <c:param name="coverArtSize" value="110"/>
                                                                <c:param name="coverArtPath" value="${album.coverArtPath}"/>
                                                                <c:param name="showLink" value="true"/>
                                                                <c:param name="showZoom" value="false"/>
                                                                <c:param name="showChange" value="false"/>
                                                                <c:param name="appearAfter" value="${loopStatus.count * 30}"/>
                                                            </c:import>

                                                            <div class="detail">
                                                                <c:if test="${not empty album.playCount}">
                                                                    <fmt:message key="home.playcount"><fmt:param value="${album.playCount}"/></fmt:message>${album.playCount gt 1 ? pluralizer : ""}
                                                                </c:if>
                                                                <c:if test="${not empty album.lastPlayed}">
                                                                    <fmt:formatDate value="${album.lastPlayed}" dateStyle="short" var="lastPlayedDate"/>
                                                                    <fmt:message key="home.lastplayed"><fmt:param value="${lastPlayedDate}"/></fmt:message>
                                                                </c:if>
                                                                <c:if test="${not empty album.created}">
                                                                    <fmt:formatDate value="${album.created}" dateStyle="short" var="creationDate"/>
                                                                    <fmt:message key="home.created"><fmt:param value="${creationDate}"/></fmt:message>
                                                                </c:if>
                                                                <c:if test="${not empty album.rating}">
                                                                    <c:import url="rating.jsp">
                                                                        <c:param name="readonly" value="true"/>
                                                                        <c:param name="rating" value="${album.rating}"/>
                                                                    </c:import>
                                                                </c:if>
                                                            </div>

                                                            <c:choose>
                                                                <c:when test="${empty album.artist and empty album.albumTitle}">
                                                                    <div class="detail"><fmt:message key="common.unknown"/></div>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <div class="detail"><em><str:truncateNicely lower="15" upper="15">${album.artist}</str:truncateNicely></em></div>
                                                                    <div class="detail"><str:truncateNicely lower="15" upper="15">${album.albumTitle}</str:truncateNicely></div>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <c:if test="${loopStatus.count % model.listColumns == 0}">
                                                </tr>
                                            </c:if>
                                        </c:forEach>
                                    </table>
                                    <c:if test="${not empty model.welcomeMessage}">
                                        </td><td style="vertical-align:top;">
                                            <div class="welcomeMessage">
                                                <sub:wiki text="${model.welcomeMessage}"/>
                                                <span>${model.welcomeSubtitle}</span>
                                            </div>
                                        </td></tr></table>
                                    </c:if>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
