//debug.log("Loading javascript modules via LABSjs");

var jQueryLoad;
var jQueryUILoad;

jQueryLoad = $LAB
    .script({src:"http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js",
             alt:"script/jquery.min.js",
             test:"$"})
    .wait(function() {
        if (typeof($) !== "undefined") {
            //debug.log("jQuery loaded successfully!", typeof($));
            jQueryUILoad = $LAB
                .script({src:"http://ajax.googleapis.com/ajax/libs/jqueryui/1/jquery-ui.min.js",
                    alt:"script/jquery-ui.min.js",
                    test:"jQuery.ui"})
                .wait(function() {
                    if (typeof(jQuery.ui) !== "undefined") {
                        //debug.log("jQueryUI loaded successfully!", typeof(jQuery.ui));
                        // Common or shared jQuery UI animations to be fired off.
                        $(".fade").each(function(i) {
                            $(this).css({ 'visibility' : 'visible', "display" : "none" });
                            $(this).delay(i * 30).fadeIn(600);
                        });
                    }
            });
        }
});