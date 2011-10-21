<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1" %>
<%@ include file="doctype.jsp" %>

<html>
    <head>
        <%@ include file="head.jsp" %>
        <script type="text/javascript" src="<c:url value="/dwr/engine.js"/>"></script>
        <script type="text/javascript" src="<c:url value="/dwr/util.js"/>"></script>
        <script type="text/javascript" src="<c:url value="/script/webfx/range.js"/>"></script>
        <script type="text/javascript" src="<c:url value="/script/webfx/timer.js"/>"></script>
        <script type="text/javascript" src="<c:url value="/script/webfx/slider.js"/>"></script>
        <link type="text/css" rel="stylesheet" href="<c:url value="/script/webfx/luna.css"/>"/>
    </head>

    <body class="bgcolor2">

        <div id="sliderContainer" style="padding:10px;text-align:center">
            <div id="sliderValue" style="width:3em:margin:0px auto">50</div>
            <div class="slider bgcolor2" id="slider-1" style="margin:0px auto">
                <input class="slider-input" id="slider-input-1" name="slider-input-1"/>
            </div>
        </div>

        <script type="text/javascript">
            //    var slider = new Slider(document.getElementById("slider-1"), null);
            var updateGainTimeoutId = 0;
            var slider = new Slider(document.getElementById("slider-1"), document.getElementById("slider-input-1"));
            slider.setValue(50);
            

            slider.onchange = function () {
                clearTimeout(updateGainTimeoutId);
                updateGainTimeoutId = setTimeout("updateGain()", 250);
            };

            function updateGain() {
                    var value = slider.getValue();
                    $("sliderValue").innerHTML = value;
            }
        </script>

    </body>
</html>