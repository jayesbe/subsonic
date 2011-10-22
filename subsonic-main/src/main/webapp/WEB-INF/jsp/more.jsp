<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1"%>
<%@ include file="doctype.jsp" %>

<html>
    <head>
        <%@ include file="head.jsp" %>
        <style type="text/css">
            #progressBar {width: 350px; height: 10px; border: 1px solid black; display:none;}
            #progressBarContent {width: 0; height: 10px; background: url("<c:url value="/icons/progress.png"/>") repeat;}
        </style>
        <script type="text/javascript" src="<c:url value="/dwr/interface/transferService.js"/>"></script>
        <script type="text/javascript" src="<c:url value="/dwr/engine.js"/>"></script>
        <script type="text/javascript" src="<c:url value="/dwr/util.js"/>"></script>
        <script type="text/javascript" src="<c:url value="/script/niceforms2.js"/>"></script>
        <script type="text/javascript" src="<c:url value="/script/prototype.js"/>"></script>
        <script type="text/javascript" src="<c:url value="/script/upload.js"/>"></script>

        <script type="text/javascript">
            function miniwindow() {
                window.open('/minisub.html','minisub','width=860,height=604,resizable=no,scrollbars=no,toolbar=no,status=no');
            }
            function uploadwindow() {
                window.open('upload.view', 'upload', 'width=200,height=100,resizable=no,scrollbars=no,toolbar=no,status=no');
            }
        </script>
    </head>
    <body class="mainframe bgcolor1">

        <c:if test="${model.user.uploadRole}">
            <%@ include file="uploadForm.jsp" %>
        </c:if>

        <div id="mainframecontainer">
            <div id="mainframemenucontainer" class="bgcolor1">
                <span id="mainframemenuleft">
                    <b><span id="minisub" class="mainframemenuitem" style="background-image: url('<spring:theme code='miniSubImage'/>')"><a href="javascript:miniwindow()">&nbsp;Mini Subsonic</a></span></b>

                    <c:if test="${model.user.uploadRole}">
                        <span id="upload" class="mainframemenuitem" style="background-image: url('<spring:theme code='uploadImage'/>')"><a href="#" onClick="javascript:toggleUploadFile()">Upload File</a></span>
                    </c:if>
                </span>
                <span id="mainframemenuright">
                    <c:if test="${model.user.adminRole}">
                        <span class="mainframemenuitem forward right"><a href="db.view?"><fmt:message key="help.db"/></a></span>
                    </c:if>
                </span>
            </div>

            <div id="mainframecontentcontainer">
                <div id="mainframecontent">
                    <h1>
                        <img id="pageimage" src="<spring:theme code="moreImage"/>" alt="" />
                        <span class="desc"><fmt:message key="more.title"/></span>
                    </h1>

                    <c:if test="${model.user.streamRole}">
                        <div id="niceformcontainer" style="width:100%">
                            <form id="randomplaylistgenerator" class="niceform" method="post" action="randomPlaylist.view?">
                            <fieldset>
                               <legend class="bgcolor1"><img src="<spring:theme code="randomImage"/>" alt=""/>&nbsp;<fmt:message key="more.random.title"/></legend>
                                <label style="float:left"><fmt:message key="more.random.text"/></label>
                                <select name="size" class="niceform" style="float:left">
                                    <option value="5"><fmt:message key="more.random.songs"><fmt:param value="5"/></fmt:message></option>
                                    <option value="10" selected="true"><fmt:message key="more.random.songs"><fmt:param value="10"/></fmt:message></option>
                                    <option value="20"><fmt:message key="more.random.songs"><fmt:param value="20"/></fmt:message></option>
                                    <option value="50"><fmt:message key="more.random.songs"><fmt:param value="50"/></fmt:message></option>
                                    <option value="80"><fmt:message key="more.random.songs"><fmt:param value="80"/></fmt:message></option>
                                    <option value="90"><fmt:message key="more.random.songs"><fmt:param value="90"/></fmt:message></option>
                                    <option value="100"><fmt:message key="more.random.songs"><fmt:param value="100"/></fmt:message></option>
                                    <option value="150"><fmt:message key="more.random.songs"><fmt:param value="150"/></fmt:message></option>
                                    <option value="200"><fmt:message key="more.random.songs"><fmt:param value="200"/></fmt:message></option>
                                    <option value="250"><fmt:message key="more.random.songs"><fmt:param value="250"/></fmt:message></option>
                                    <option value="300"><fmt:message key="more.random.songs"><fmt:param value="300"/></fmt:message></option>
                                    <option value="350"><fmt:message key="more.random.songs"><fmt:param value="350"/></fmt:message></option>
                                </select>
                                <label style="float:left"><fmt:message key="more.random.genre"/></label>
                                <select style="float:left" class="niceform" name="genre">
                                    <option value="any"><fmt:message key="more.random.anygenre"/></option>
                                    <c:forEach items="${model.genres}" var="genre">
                                        <option value="${genre}"><str:truncateNicely upper="20">${genre}</str:truncateNicely></option>
                                    </c:forEach>
                                </select>
                                <label style="float:left"><fmt:message key="more.random.year"/></label>
                                <select style="float:left" class="niceform" name="year">
                                    <option value="any"><fmt:message key="more.random.anyyear"/></option>

                                    <c:forEach begin="0" end="${model.currentYear - 2006}" var="yearOffset">
                                        <c:set var="year" value="${model.currentYear - yearOffset}"/>
                                        <option value="${year} ${year}">${year}</option>
                                    </c:forEach>

                                    <option value="2005 2010">2005 &ndash; 2010</option>
                                    <option value="2000 2005">2000 &ndash; 2005</option>
                                    <option value="1990 2000">1990 &ndash; 2000</option>
                                    <option value="1980 1990">1980 &ndash; 1990</option>
                                    <option value="1970 1980">1970 &ndash; 1980</option>
                                    <option value="1960 1970">1960 &ndash; 1970</option>
                                    <option value="1950 1960">1950 &ndash; 1960</option>
                                    <option value="0 1949">&lt; 1950</option>
                                </select>
                                <label style="float:left"><fmt:message key="more.random.folder"/></label>
                                <select style="float:left" class="niceform" name="musicFolderId">
                                    <option value="-1"><fmt:message key="more.random.anyfolder"/></option>
                                    <c:forEach items="${model.musicFolders}" var="musicFolder">
                                        <option value="${musicFolder.id}">${musicFolder.name}</option>
                                    </c:forEach>
                                </select>
                                <br>
                                <input type="submit" value="<fmt:message key="more.random.ok"/>">

                                <c:if test="${not model.clientSidePlaylist}">
                                    <input style="float:right" type="checkbox" name="autoRandom" id="autoRandom" class="checkbox"/>
                                    <label style="float:left" for="autoRandom"><fmt:message key="more.random.auto"/></label>
                                </c:if>
                            </fieldset>
                            </form>
                        </div>
                    </c:if>

                    <div id="moreitemscontainer">
                        <h2><img src="<spring:theme code="androidImage"/>" alt=""/>&nbsp;<fmt:message key="more.apps.title"/></h2>
                        <blockquote><fmt:message key="more.apps.text"/></blockquote>

                        <h2><img src="<spring:theme code="wapImage"/>" alt=""/>&nbsp;<fmt:message key="more.mobile.title"/></h2>
                        <blockquote><fmt:message key="more.mobile.text"><fmt:param value="${model.brand}"/></fmt:message></blockquote>

                        <h2><img src="<spring:theme code="podcastImage"/>" alt=""/>&nbsp;<fmt:message key="more.podcast.title"/></h2>
                        <blockquote><fmt:message key="more.podcast.text"/></blockquote>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>