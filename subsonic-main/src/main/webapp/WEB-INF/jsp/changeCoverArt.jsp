<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1" %>
<%@ include file="doctype.jsp" %>
<% 
    int imagesPerPage = 8;
    int imagesPerRow = 4;
    pageContext.setAttribute("imagesPerPage", imagesPerPage); 
    pageContext.setAttribute("imagesPerRow", imagesPerRow); 
%>

<html>
    <head>
        <%@ include file="head.jsp" %>
        <sub:url value="main.view" var="backUrl"><sub:param name="path" value="${model.path}"/></sub:url>
        <script type="text/javascript" src="<c:url value="/dwr/engine.js"/>"></script>
        <script type="text/javascript" src="<c:url value="/dwr/interface/coverArtService.js"/>"></script>
        <script type="text/javascript" src="<c:url value="/script/scripts.js"/>"></script>
        <link rel="stylesheet" href="/script/plugins/jquery.fancybox-1.3.4.css" type="text/css" media="screen" />

        <script type="text/javascript" src="http://www.google.com/jsapi"></script>
        <style type="text/css">
            /*Google powered by branding*/
            td.gsc-branding-text div.gsc-branding-text, td.gcsc-branding-text div.gcsc-branding-text { display: none; }
            td.gsc-branding-img-noclear, td.gcsc-branding-img-noclear { display: none; }
        </style>
    </head>
    <body class="mainframe bgcolor1">

        <div id="addCoverArtFormContainer" class="bgcolor1 mainmenudropdown vcenterouter fillwidth" style="display:none">
            <span class="aligncenter vcenterinner">
                <form id="addCoverArtForm" name="addCoverArtForm" method="post" action="javascript:setImage($('#addCoverArtForm')[0].url.value)" class="vcenter">
                    <input id="path" type="hidden" name="path" value="${model.path}"/>
                    <label for="url"><fmt:message key="changecoverart.address"/></label>
                    <input type="text" name="url" placeholder="http://" style="width:30em" validation="required url"/>
                    <button type="reset" onClick="toggleAddFromURI()"><fmt:message key="common.cancel"/></button>
                    <button type="submit"><fmt:message key="common.ok"/></button>
                </form>
            </span>
        </div>

        <div id="mainframecontainer" class="fillframe">
            <div id="mainframemenucontainer" class="bgcolor1 fade vcenterouter fillwidth">
                <span id="mainframemenuleft" class="vcenterinner">
                    <button id="cancelCoverArtChange" class="ui-icon-close ui-icon-primary"><fmt:message key="common.cancel"/></button>
                    <button id="addFromURILink" class="ui-icon-link ui-icon-primary" onClick="toggleAddFromURI()"><fmt:message key="changecoverart.addfromuri"/></button>
                </span>
                <span id="mainframemenucenter" class="aligncenter vcenterinner">
                    <span id="pages" class="vcenter"></span>
                </span>
                <span id="mainframemenuright" class="vcenterinner">
                    <span class="vcenter right">
                    <c:set var="query" value="${model.artist} ${model.album}"/>
                    <c:import url="searchbox.jsp">
                        <c:param name="action" value="javascript:doSearch()"/>
                        <c:param name="value" value="${query}"/>
                    </c:import>
                    </span>
                </span>
            </div>

            <div id="mainframecontentcontainer">
                <div id="mainframecontent">

                    <h1><fmt:message key="changecoverart.title"/></h1>

                    <h2 id="wait" class="ui-helper-hidden"><fmt:message key="changecoverart.wait"/></h2>
                    <h2 id="noImagesFound" class="ui-helper-hidden"><fmt:message key="changecoverart.noimagesfound"/></h2>
                    <h2 id="success" class="ui-helper-hidden"><fmt:message key="changecoverart.success"/></h2>
                    <h2 id="error" class="ui-helper-hidden"><fmt:message key="changecoverart.error"/></h2>
                    <div id="errorDetails" class="warning ui-helper-hidden">
                    </div>

                    <div id="imagesearchresultcontainer" class="center">
                        <div id="imagesearchresults" class="ui-helper-hidden">
                            <div id="branding" style="float:right;padding-right:1em;padding-top:0.5em"></div>
                            <div style="clear:both;"></div>
                            <div id="images" style="padding-bottom:2em" class="fillwidth"></div>
                            <div style="clear:both;"></div>
                        </div>
                    </div>

                    <div id="coverarttemplate" class="left" style="visibility:hidden;height:190px; width:220px;padding:10px;text-align:center;position:relative;vertical-align:bottom;display:none">
                        <div style="position: absolute;bottom:0;" class="center">
                            <div class="search-result-thumb">&nbsp;</div>
                            <a class="search-result-thumbnail-zoom"><img class="search-result-thumbnail" style="padding:1px; border:1px solid #021a40; background-color:white;"></a>
                            <div><a class="search-result-setimage">Set as Cover Image</a></div>
                            <div class="search-result-title"></div>
                            <div class="search-result-dimension detail"></div>
                            <div class="search-result-url detail"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
    <script type="text/javascript">
        var imageSearch;
        dwr.engine.setErrorHandler(null);
        google.load('search', '1');

        function searchComplete() {
            $("#wait").hide();
            if (imageSearch.results && imageSearch.results.length > 0) {
                $("#imagesearchresultcontainer").css({ "maxWidth" : 240 * (imageSearch.results.length / 2) + "px" });
                $("#images").html("");
                var results = imageSearch.results;
                for (var i = 0; i < results.length; i++) {
                    var result = results[i];
                    var node = $("#coverarttemplate").clone();
                    node.find(".search-result-thumbnail-zoom").attr("href" , result.url).addClass("coverart");
                    node.find(".search-result-thumbnail").attr("src", result.tbUrl);
                    node.find(".search-result-setimage").attr("href", "javascript:setImage('" + result.url + "');");
                    node.find(".search-result-title").html(result.contentNoFormatting);
                    node.find(".search-result-dimension").html(result.width + " &#215; " + result.height);
                    node.find(".search-result-url").html(result.visibleUrl);
                    $("#images").append(node);
                    $(node).css({ 'visibility' : 'visible', "display" : "none" });
                    $(node).delay(30).fadeIn(600);
                }
                addPaginationLinks();
                $("#imagesearchresults").show();
                $(".coverart").fancybox({
                    'type' : 'image', 
                    'overlayShow' : false, 
                    'hideOnContentClick' : true, 
                    'padding' : 0
                });
            } else {
                $("#noImagesFound").show();
            }
        }

        function onLoad() {
            imageSearch = new google.search.ImageSearch();
            imageSearch.setNoHtmlGeneration();
            imageSearch.setResultSetSize(${imagesPerPage});
            //google.search.Search.getBranding("branding");
            imageSearch.setSearchCompleteCallback(this, searchComplete, null);
        }
        google.setOnLoadCallback(onLoad);

        function doSearch() {
            imageSearch.execute($("#searchFormQuery").val()); 
        }

        function addPaginationLinks() {
            // To paginate search results, use the cursor function.
            var cursor = imageSearch.cursor;
            var curPage = cursor.currentPageIndex; // check what page the app is on
            $("#pages").html("");

            // Create link to prev page.
            $("#pages").append('<button class="ui-icon-triangle-1-w ui-icon-primary"><fmt:message key="common.previous"/></button>');
            if (curPage == 0) {
                $("#pages button").attr("disabled", "disabled");
            } else {
                $("#pages button").removeAttr("disabled").click(function() {
                    if (imageSearch.cursor.currentPageIndex == 0) return;
                    imageSearch.gotoPage(imageSearch.cursor.currentPageIndex - 1);
                });
            }

            for (var i = 0; i < cursor.pages.length; i++) {
                var page = cursor.pages[i];
                if (curPage == i) {
                    $("#pages").append('<span class="ui-state-active"><h2 class="inline"></h2></span>')
                    $("#pages h2").html(page.label)
                } else {
                    $("#pages").append('<button onClick="imageSearch.gotoPage(' + i + ')">' + page.label + "</button>")
                }
            }

            // Create link to next page.
            $("#pages").append('<button class="ui-icon-triangle-1-e ui-icon-secondary"><fmt:message key="common.next"/></button>')
            if (curPage == 7) {
                $("#pages button:last").attr("disabled", "disabled");
            } else {
                $("#pages button:last").removeAttr("disabled").click(function() {
                    if (imageSearch.cursor.currentPageIndex == 7) return;
                    imageSearch.gotoPage(imageSearch.cursor.currentPageIndex + 1);
                });
            }
            $("#mainframemenucontainer .ui-state-active").button().hover(function() { $(this).removeClass("ui-state-active"); }, function() { $(this).addClass("ui-state-active"); }).click(function() { $(this).addClass("ui-state-active"); });
            $("#pages").stylize().buttonset();
        }

        function setImage(imageUrl) {
            $("#wait").show();
            $("#success, #error, #errorDetails, #noImagesFound, #pages, #cancelCoverArtChange, #addFromURILink, #imagesearchresults").hide();
            coverArtService.setCoverArtImage($("#path").val(), imageUrl, setImageComplete);
        }

        function setImageComplete(errorDetails) {
            $("#wait").hide();
            if (errorDetails != null) {
                $("#errorDetails").html("<br/>" + errorDetails);
                $("#error, #errorDetails, #pages, #addFromURILink").show();
            } else {
                $("#success, #cancelCoverArtChange").show();
                $(".ui-button-text", "#cancelCoverArtChange").html("<fmt:message key='common.back'/>")
                $(".ui-icon", "#cancelCoverArtChange").removeClass("ui-icon-close").addClass("ui-icon-triangle-1-w");
            }
        }

        function toggleAddFromURI() {
            $("#addCoverArtFormContainer").toggle("blind");
        }

        jQueryLoad.wait(function() {
            $("#wait").show();
            jQueryUILoad.wait(function() {
                jFancyboxLoad = $LAB
                    .script({src:"script/plugins/jquery.fancybox.min.js", test:"$.fancybox"})
                        .wait(function() {
                            imageSearch.execute($("#searchFormQuery").val()); 
                            $("#cancelCoverArtChange").click(function() { location.href = '${backUrl}' });
                            $("#addCoverArtForm").validation().stylize();
                            $("#mainframemenucontainer").stylize();
                        });
            });
        });
    </script>
</html>