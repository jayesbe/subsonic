//debug.log("Loading javascript modules via LABSjs");

var jQueryLoad = null;
var jQueryUILoad = null;
var prototypeLoad = null;
var scriptaculousLoad = null;

function scriptaculousLoaded() {
    if (typeof(Scriptaculous) !== "undefined") {
        //debug.log("Scriptaculous loaded successfully!", typeof(Scriptaculous));
    }
}

function prototypeLoaded() {
    if (typeof(Prototype) !== "undefined") {
        //debug.log("Prototype loaded successfully!", typeof(Prototype));

        scriptaculousLoad = $LAB
            .script({src:"http://ajax.googleapis.com/ajax/libs/scriptaculous/1/scriptaculous.js",
                     alt:"script/scriptaculous.min.js",
                     test:"Scriptaculous"})
            .wait(function() { scriptaculousLoaded(); });
    }
}

function jQueryUILoaded() {
    if (typeof(jQuery.ui) !== "undefined") {
        //debug.log("jQueryUI loaded successfully!", typeof(jQuery.ui));
        
        // Common or shared jQuery UI animations to be fired off.
        jQuery(".fade").each(function(i) {
            jQuery(this).css({ 'visibility' : 'visible', "display" : "none" });
            jQuery(this).delay(i * 30).fadeIn(600);
        });
    }
}

function jQueryLoaded() {
    if (typeof(jQuery) !== "undefined") {
        //debug.log("jQuery loaded successfully!", typeof(jQuery));

        try { $.noConflict(); } catch(Exception) { debug.log(Exception) }

        jQueryUILoad = $LAB
            .script({src:"http://ajax.googleapis.com/ajax/libs/jqueryui/1/jquery-ui.min.js",
                alt:"script/jquery-ui-1.8.16.custom.min.js",
                test:"jQuery.ui"})
            .wait(function() { jQueryUILoaded(); } );

        prototypeLoad = $LAB
            .script({src:"http://ajax.googleapis.com/ajax/libs/prototype/1/prototype.js",
                     alt:"script/prototype.min.js",
                     test:"Prototype"})
            .wait(function() { prototypeLoaded(); });
    }
}

jQueryLoad = $LAB
    .script({src:"http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js",
             alt:"script/jquery-1.6.4.min.js",
             test:"jQuery"})
    .wait(function() { jQueryLoaded(); });