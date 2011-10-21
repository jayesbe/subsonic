<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1"%>
<%@ include file="doctype.jsp" %>

<html>
    <head>
        <%@ include file="head.jsp" %>
        <script type="text/javascript" src="<c:url value="/script/scripts.js"/>"></script>
    </head>
    <body class="mainframe bgcolor1">
        <div id="mainframecontainer">

            <div id="mainframemenucontainer" class="bgcolor1">
                <div id="mainframemenu"
                    <div class="mainframemenuleft">
                    </div>
                    <div class="mainframemenucenter">
                    </div>
                    <div class="mainframemenuright">
                    </div>
                </div>
            </div>
    
            <div id="mainframecontentcontainer">
                <div id="mainframecontent">
                    <h1>
                        <img id="pageimage" src="<spring:theme code="helpImage"/>" alt="">
                        <span class="desc"><fmt:message key="help.title"><fmt:param value="${model.brand}"/></fmt:message></span>
                    </h1>

                </div>
            </div>
        </div>
    </body>
</html>