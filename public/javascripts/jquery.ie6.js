$(function(){
	
	$('<div id="ie_warning"></div>')
	.html("This site does not support Internet Explorer 6. Please consider downloading <a href='http://www.google.com/chrome'>a newer browser</a>.")
	.hide()
	.prependTo(document.body)
	.slideDown(500);
	
});
