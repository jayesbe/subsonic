<link rel="stylesheet" href="<c:url value="/style/smoothness/jquery-ui-1.8.18.custom.css"/>" type="text/css">
<link rel="stylesheet" href="<c:url value="/script/jquery.toastmessage/css/jquery.toastmessage.css" />" type="text/css" >
<link rel="stylesheet" href="<c:url value="/style/jquery.contextMenu.css"/>" type="text/css" >
<script type="text/javascript" src="<c:url value='/script/jquery-1.7.1.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/script/jquery-ui-1.11.1.min.js'/>"></script>
<script type="text/javascript" src="<c:url value="/script/jquery.toastmessage/jquery.toastmessage.js"/>"></script>
<script type="text/javascript" src="<c:url value="/script/jquery.contextMenu.js"/>"></script>

<%-- Disable animation (of artist list and play queue) in Chrome. It stopped working in Chrome 44. --%>
<script type="text/javascript">
    if (navigator.userAgent.indexOf("Chrome") != -1) {
        $.fx.off = true;
    }
</script>
