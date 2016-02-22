<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1" %>
<%--<!DOCTYPE html>--%>
<html>
<head>
    <%@ include file="head.jsp" %>
    <%@ include file="jquery.jsp" %>
    <link rel="stylesheet" href="//releases.flowplayer.org/6.0.5/skin/minimalist.css">
    <script src="script/flowplayer-6.0.5/flowplayer.min.js"></script>

    <script src="script/flowplayer-6.0.5/flowplayer.hlsjs.min.js"></script>


</head>

<body>
<div class="flowplayer" style="width:50%">
    <video>
        <%--<source type="video/webm"--%>
                <%--src="//stream.flowplayer.org/drive.webm">--%>
        <%--<source type="video/mp4"--%>
                <%--src="stream?id=7452&player=6&auth=330893274&format=raw&converted=false">--%>
        <source type="application/x-mpegurl"
                <%--src="http://stream.flowplayer.org/FlowplayerHTML5forWordPress.m3u8">--%>
                src="hls?id=7452&player=6&auth=330893274&bitRate=4000">

    </video>
</div>

</body>
</html>