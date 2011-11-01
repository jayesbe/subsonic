function getWebFont(userWebFont, systemWebFont) {
    if (userWebFont == "") {
        return systemWebFont;
    }
    return userWebFont;
}

function setWebFont() {
    if (parent.webfont != undefined) {
        webfont = parent.webfont
        var html = "<link href=\"http://fonts.googleapis.com/css?family=" + webfont.replace(" ", "+") + "\" rel=\"stylesheet\" type=\"text/css\">" + 
                   "<style type=\"text/css\">* { font-family: '" + webfont.replace(/:.*/, "") + "', sans-serif; }</style>";
        document.write(html);
    }
}
setWebFont();