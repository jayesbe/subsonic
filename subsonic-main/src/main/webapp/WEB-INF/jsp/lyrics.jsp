<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1" %>
<%@ include file="doctype.jsp" %>

<html><head>
    <%@ include file="head.jsp" %>
    <title><fmt:message key="lyrics.title"/></title>
    <script type="text/javascript" src="<c:url value="/dwr/interface/lyricsService.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/dwr/engine.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/dwr/util.js"/>"></script>

    <script type="text/javascript" language="javascript">

        dwr.engine.setErrorHandler(null);

        function init() {
            getLyrics('${model.artist}', '${model.track}', '${model.apikey}');
        }

        function getLyrics(artist, track, apikey) {
            $("wait").style.display = "inline";
            $("lyrics").style.display = "none";
            $("noLyricsFound").style.display = "none";
            lyricsService.getLyrics(artist, track, apikey, getLyricsCallback);
        }

        function getLyricsCallback(lyricsInfo) {
            dwr.util.setValue("lyricsHeader", lyricsInfo.artist + " - " + lyricsInfo.track);
            var lyrics;
            if (lyricsInfo.lyrics != null) {
                lyrics = lyricsInfo.lyrics.replace(/\n/g, "<br>");
                lyrics = lyrics.replace("******* This Lyrics is NOT for Commercial use *******", "");
                mmid = lyricsInfo.MMID;
                mbid = lyricsInfo.MBID;
                tracker = "<script type=\"text\\javascript\" src=\"" + lyricsInfo.tracker + "\">";
                copyright = lyricsInfo.copyright.replace(/\. /g, ". <br>");
            }
            dwr.util.setValue("lyricsText", lyrics, { escapeHtml:false });
            dwr.util.setValue("lyricsCopyright", copyright, { escapeHtml:false });
            dwr.util.setValue("lyricsTracker", tracker, { escapeHtml:false });
            $("wait").style.display = "none";
            if (lyrics != null) {
                $("lyrics").style.display = "inline";
            } else {
                $("noLyricsFound").style.display = "inline";
            }
        }
    </script>

</head>
<body class="mainframe bgcolor1" onload="init();">

<table>
    <tr>
        <td><fmt:message key="lyrics.artist"/></td>
        <td style="padding-left:0.50em"><input id="artist" type="text" size="40" value="${model.artist}" tabindex="1"/></td>
        <td style="padding-left:0.75em"><input type="submit" value="<fmt:message key='lyrics.search'/>" style="width:6em"
                                               onclick="getLyrics(dwr.util.getValue('artist'), dwr.util.getValue('track'))" tabindex="3"/></td>
    </tr>
    <tr>
        <td><fmt:message key="lyrics.track"/></td>
        <td style="padding-left:0.50em"><input id="track" type="text" size="40" value="${model.track}" tabindex="2"/></td>
        <td style="padding-left:0.75em"><input type="submit" value="<fmt:message key='common.close'/>" style="width:6em"
                                               onclick="self.close()" tabindex="4"/></td>
    </tr>
</table>

<hr/>
<h2 id="wait"><fmt:message key="lyrics.wait"/></h2>
<h2 id="noLyricsFound" style="display:none"><fmt:message key="lyrics.nolyricsfound"/></h2>

<div id="lyrics" style="display:none;">
    <h2 id="lyricsHeader" style="text-align:center;margin-bottom:1em"></h2>

    <div id="lyricsText"></div>
</div>

<hr/>
<p style="text-align:center">
    <a href="javascript:self.close()">[<fmt:message key="common.close"/>]</a>
</p>
<div id="lyricsCopyright"></div>
<span id="lyricsTracker"></div>
</body>
</html>
