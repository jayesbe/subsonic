<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1"%>
<%@ include file="doctype_frameset.jsp" %>

<html>
	<head>
		<%@ include file="head.jsp" %>
		<link rel="alternate" type="application/rss+xml" title="Subsonic Podcast" href="podcast.view?suffix=.rss">
	</head>

	<frameset rows="80,*" border="0">
		<frame name="upper" src="top.view?" scrolling="No" noresize="noresize" />
		<frameset rows="*" cols="245,*,${model.showRight ? 240 : 0}" border="0">
			<frame name="left" src="left.view?" scrolling="No" noresize="noresize" />
			<frameset rows="*,25%" cols="*" border="0"></>
				<frame name="main" src="home.view?listType=${model.listType}&listRows=${model.listRows}&listColumns=${model.listColumns}" scrolling="No"/>
				<frame name="playlist" src="playlist.view?" id="playlistframe" scrolling="No" />
			</frameset>
			<frame name="right" src="right.view?" scrolling="No" noresize="noresize" />	
		</frameset>
	</frameset>

	<noframes></noframes>

</html>