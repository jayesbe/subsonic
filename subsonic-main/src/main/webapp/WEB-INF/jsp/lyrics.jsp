<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1" %>
<%@ include file="doctype.jsp" %>

<html>
    <head>
        <%@ include file="head.jsp" %>
        <title><fmt:message key="lyrics.title"/></title>
        <script type="text/javascript" src="<c:url value="/dwr/interface/lyricsService.js"/>"></script>
        <script type="text/javascript" src="<c:url value="/dwr/engine.js"/>"></script>
    </head>
    <body class="mainframe bgcolor1">
        <div id="mainframecontainer">
            <div id="mainframemenucontainer" class="bgcolor1 fade">
                <span id="mainframemenuleft">
                    <table>
                        <tr>
                            <td><fmt:message key="lyrics.artist"/></td>
                            <td style="padding-left:0.50em">
                                <input id="artist" type="text" size="40" value="${model.artist}" tabindex="1" validation="required" onClick="select();"
                                    onFocus="if(this.value=='${model.artist}'){this.value='';}else{this.select();}"
                                    onBlur="if(this.value==''){$('#error_artist').remove();this.value='${model.artist}';}" />
                            </td>
                            <td style="padding-left:0.75em">
                                <button type="submit" onclick="getLyrics($('#artist').val(), $('#track').val())" tabindex="3" class="ui-icon-script"><fmt:message key="lyrics.search"/></button>
                            </td>
                        </tr>
                        <tr>
                            <td><fmt:message key="lyrics.track"/></td>
                            <td style="padding-left:0.50em">
                                <input id="track" type="text" size="40" value="${model.track}" tabindex="2" validation="required" onClick="select();"
                                    onFocus="if(this.value=='${model.track}'){this.value='';}else{this.select();}"
                                    onBlur="if(this.value==''){$('#error_track').remove();this.value='${model.track}';}" />
                            </td>
                            <td style="padding-left:0.75em"><button onclick="self.close()" tabindex="4" class="ui-icon-cancel"><fmt:message key="common.close"/></button></td>
                        </tr>
                    </table>
                </span>
            </div>

            <div id="mainframecontentcontainer">
                <div id="mainframecontent">
                    <div id="mainframecontentheader" class="fade">
                        <span class="desc">
                            <h2 id="wait"><fmt:message key="lyrics.wait"/></h2>
                            <h2 id="noLyricsFound" style="display:none"><fmt:message key="lyrics.nolyricsfound"/></h2>
                        </span>
                    </div>
                    <div id="lyrics" style="display:none;">
                        <h2 id="lyricsHeader" style="text-align:center;margin-bottom:1em"></h2>
                        <div id="lyricsText"></div>
                    </div>

                    <hr/>
                    <p style="text-align:center">
                        <a href="javascript:self.close()">[<fmt:message key="common.close"/>]</a>
                    </p>
                    <div id="lyricsCopyright"></div>
                    <span id="lyricsTracker"></span>
                    <hr/>
                </div>
            </div>
        </div>
    </body>

    <script type="text/javascript" language="javascript">
        dwr.engine.setErrorHandler(null);

        function getLyrics(artist, track, apikey) {
            //debug.log(artist, track, apikey);
            lyricsService.getLyrics(artist, track, apikey, getLyricsCallback);
            $("#wait").show();
            $("#lyrics, #noLyricsFound").hide();
        }

        function getLyricsCallback(lyricsInfo) {
            $("#lyricsHeader").html(lyricsInfo.artist + " - " + lyricsInfo.track);
            var lyrics;
            if (lyricsInfo.lyrics != null) {
                debug.log(lyricsInfo.lyrics);
                lyrics = lyricsInfo.lyrics.replace(/\n/g, "<br>");
                lyrics = lyrics.replace("******* This Lyrics is NOT for Commercial use *******", "");
                mmid = lyricsInfo.MMID;
                mbid = lyricsInfo.MBID;
                tracker = "<script type=\"text\\javascript\" src=\"" + lyricsInfo.tracker + "\">";
                copyright = lyricsInfo.copyright.replace(/\. /g, ". <br>");
            }
            $("#lyricsText").html(lyrics);
            $("#lyricsCopyright").html(copyright);
            $("#lyricsTracker").html(tracker);
            $("#wait").hide();
            if (lyrics != null) {
                $("#lyrics").show();
            } else {
                $("#noLyricsFound").show();
            }
        }

        jQueryLoad.wait(function() {
            getLyrics("${model.artist}", "${model.track}", "${model.apikey}");
            jQueryUILoad.wait(function() {
                $("#mainframemenucontainer").validation().stylize();
            });
        });
    </script>
</html>
