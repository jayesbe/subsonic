<%@ include file="include.jsp" %>

<!--[if lt IE 7.]>
    <script defer type="text/javascript" src="<c:url value='/script/pngfix.js'/>"></script>
<![endif]-->

<meta http-equiv="content-type" content="text/html; charset=utf-8" />

<c:set var="styleSheet"><spring:theme code="styleSheet"/></c:set>
<c:set var="faviconImage"><spring:theme code="faviconImage"/></c:set>
<link href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/themes/base/jquery-ui.css" type="text/css" rel="Stylesheet" />
<link rel="stylesheet" href="<c:url value='/${styleSheet}'/>" type="text/css">
<link rel="shortcut icon" href="<c:url value='/${faviconImage}'/>" type="text/css">

<script type="text/javascript" src="<c:url value='/script/ba-debug.min.js'/>"></script>

<script type="text/javascript" src="/script/LAB.min.js"></script>
<script type="text/javascript" src="/script/cdnLAB.min.js"></script>
<script type="text/javascript" src="/script/jsLoad.js"></script>

<script type="text/javascript" src="<c:url value='/script/webfont.js'/>"></script>

<script>//debug.setLevel(5);</script>

<title>Subsonic</title>
