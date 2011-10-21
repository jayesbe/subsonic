
var repeat = 0
var start = 1
var title = parent.document.title
var leng = title.length
	
function doScrollTitle() {
	title = parent.document.title
	leng = title.length
	scrollTitle();
}

function scrollTitle() {
	scrollingtitle = title.substring(start, leng) + " " + title.substring(0, start)
	parent.document.title = scrollingtitle
	start++
	if (start == leng+1) {
		start = 0
		if (repeat == 0)
		return
	}
	setTimeout("scrollTitle()",60)
}

function updateTitle(opt) {
	parent.document.title = (opt == "Subsonic") ? "Subsonic" : "Subsonic (" + opt + ")";
	if (opt != "Subsonic") doScrollTitle();
}