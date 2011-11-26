<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1" %>
<%@ include file="doctype.jsp" %>

<html>
    <head>
        <%@ include file="head.jsp" %>
        <script>webfont = getWebFont("PT Sans", "PT Sans")//getWebFont("${model.userWebFont}", "${model.systemWebFont}");</script>
        <style>
        object {
            padding:0;
            margin:0;
        }
        </style>
        
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
        <div id="layoutcontainer">
        </div>
        <!--[if IE]>
            <div style="width: 100%; height: 10%;min-height:80px;">
                <object id="top" name="top" classid="clsid:25336920-03F9-11CF-8FD0-00AA00686F13" data="top.view?" style="width: 100%; height: 100%;"> 
                    <p>Oops! That didn't work...</p> 
                </object>
            </div>
            
            <div style="position:fixed;width: 100%; height: 90%;">
                <object id="left" name="left" classid="clsid:25336920-03F9-11CF-8FD0-00AA00686F13" data="left.view?" style="width: 15%;min-width:245px;height:100%;float:left;overflow:hidden;"> 
                    <p>Oops! That didn't work...</p> 
                </object>
                <object id="main" name="main" classid="clsid:25336920-03F9-11CF-8FD0-00AA00686F13" data="home.view?" style="width: 70%;height: 100%;float:left"> 
                    <p>Oops! That didn't work...</p> 
                </object>
                <object id="right" name="right" classid="clsid:25336920-03F9-11CF-8FD0-00AA00686F13" data="right.view?" style="width: 15%; height: 100%;float:right;"> 
                    <p>Oops! That didn't work...</p> 
                </object>
            </div>
        <![endif]-->
        <!--[if !IE]> <-->
            <div style="width: 100%; height: 8%;min-height:80px;">
                <object id="top" name="top" type="text/html" data="top.view?" style="width: 100%; height: 100%;"> 
                    <p>Oops! That didn't work...</p> 
                </object>
            </div>
            
            <div style="position:fixed;width: 100%; height: 92%;">
                <object id="left" name="left" type="text/html" data="left.view?" style="width: 15%;min-width:245px;height:100%;float:left;overflow:hidden;"> 
                    <p>Oops! That didn't work...</p> 
                </object>
                <object id="right" name="right" type="text/html" data="right.view?" style="width: 15%; height: 100%;float:right;"> 
                    <p>Oops! That didn't work...</p> 
                </object>
                <div>
                    <object id="main" name="main" type="text/html" data="home.view?" style="width: 70%;height: 75%;float:left"> 
                        <p>Oops! That didn't work...</p> 
                    </object>
                    <object id="playlist" name="playlist" type="text/html" data="playlist.view?" style="width: 70%;height: 25%;float:left"> 
                        <p>Oops! That didn't work...</p> 
                    </object>
                </div>
            </div>
<!--> <![endif]-->
    </body>
</html>