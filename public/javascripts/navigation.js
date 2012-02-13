$(document).ready(function(){
	if($.browser.msie && parseInt($.browser.version) < 7){
		$('#account_nav li').mouseenter(function(e){
			e.stopPropagation();
		
			var item, top;
		
			// Quick fix for flash message
			top  = ($('.flash:visible').length > 0) ? ($(this).offset().top - 138) : ($(this).offset().top - 100)
			item = $('ul', this);
			item.css("top", top);
			item.css("left", $(this).width());
	    item.show();
		});
	
		$('#account_nav li').mouseleave(function(e){
			e.stopPropagation();
			$('ul', this).hide(200);
		});
	
		$('#nav ul li').mouseenter(function(e){
				e.stopPropagation();
				var item;
				item = $('ul', this);
				item.css("top", $(this).offset().top);
	      item.slideDown(100);
		});
	
		$('#nav ul li').mouseleave(function(e){
			e.stopPropagation();
			$('ul', this).slideUp(200);
		});
	}
});
