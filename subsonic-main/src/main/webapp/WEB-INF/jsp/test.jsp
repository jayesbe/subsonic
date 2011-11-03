<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1" %>
<%@ include file="doctype.jsp" %>

<html>
    <head>
        <%@ include file="head.jsp" %>
		
		<script type="text/javascript">
			var updateGainTimeoutId = 0;
			function updateGain() {
				var value = $( "#slider" ).slider( "option", "value" );
				$("#sliderValue").html(value);
				debug.log(value);
			}
			jQueryLoad.wait(function() {
				jQueryUILoad.wait(function() {
					$("#slider").slider({
						slide: function(event, ui) {
							clearTimeout(updateGainTimeoutId);
							updateGainTimeoutId = setTimeout("updateGain()", 250);
						}
					});
					$( "#slider" ).slider("option", "value", 25 );
				});
			});
		</script>
    </head>

    <body class="bgcolor2">
        <div id="sliderContainer" style="padding:10px;text-align:center">
            <div id="sliderValue" style="width:3em:margin:0px auto">25</div>
            <div id="slider" class="slider bgcolor2" style="margin:0px auto">
                
            </div>
        </div>

      <div id="slider" style="margin:0px auto"></div>

    </body>
</html>