$.ajaxSetup({
  'beforeSend': function(xhr) { xhr.setRequestHeader('Accept', 'text/javascript') }
});

var Tweasier = {
	
	init : function(){
		this.hideLoader(true, true);
	},
	
	// Helpers
	// could eventually do with finding a live event for this?
	forceExternalLinks : function(){
		// Added an additional scope to links with the class of
		// 'local'. IE will still open a #anchor in a new window even
		// if that link is on the same domain...
		$('a[href^="http://"][class!=local]').attr({
			target: "_blank",
			title: "Opens this link in a new window"
		});
	},
	
	// JSON parser
	parseJSON : function(response){
		return JSON.parse(response);
	},
	
	// Ajax loaders
	showLoader : function(text){
		this.setLoaderText(text);
		$("#loader").slideDown(300);
	},
	
	setLoaderText : function(text) {
		$("#loader > h4").html(text ? text : "Talking to Twitter");
	},
	
	hideLoader : function(reset, force){
		force = force || false;
		if(force)
		{
			$("#loader").hide()
		}
		else
		{
			$("#loader").slideUp(300, function(){
				if(reset != null && reset === true) this.setLoaderText();
			});
		}
	},
	
	// Status functions
	setTop : function(){
		window.scrollTo(0, 0);
	},
	
	disableStatusForm : function(){
		$('#status_form_submit').attr({disabled:"disabled"});
		$('#text').attr({disabled:"disabled"});
	},
	
	enableStatusForm : function(){
		$('#status_form_submit').removeAttr("disabled");
		$('#text').removeAttr("disabled");
	},
	
	submitStatusForm : function(){
		$('#status_form').submit();
	},
	
	setStatusFormLabel : function(label) {
		$('label[for=text]').text(label);
	},
	
	setStatusFormAction : function(path){
		$('#status_form').attr("action", path);
	},
	
	setStatusFormSubmit : function(text){
		$('#status_form_submit').val(text);
	},
	
	setStatusFormHiddenField : function(name, value){
		if($('#status_' + name).val() != null)
			$('#status_' + name).val(value);
		else
			$('#status_form').append("<input type='hidden' name='" + name + "' value='" + value + "' id='status_" + name + "'/>");
	},
	
	setStatusFormFocus : function(text){
		$('#text').focus().val(text);
	},
	
	// Poll form
	setupPollForm : function(){
		// Don't hide the feedback form if the poll isn't available
		if($("#poll_form:visible").length != 0) $("#feedback_form").hide();
	},
	
	showPollResponse : function(response){
		response = this.parseJSON(response);
		$("#poll_form").empty().html("<h3 id='poll_response'>" + response.text + "</h3>");
		// Now show the additional feedback form
		$("#feedback_form").show();
	},
	
	// Feedback form
	showFeedbackResponse : function(response){
		response = this.parseJSON(response);
		$("#poll_form").hide()
		$("#feedback_form").empty().html("<h3 id='feedback_response'>" + response.text + "</h3>");
	},
	
	// Statistics form
	showStatisticsResponse : function(response){
		response = this.parseJSON(response);
		$("#tweet_statistics").empty().html("<h3>" + response.text + "</h3>");
		Tweasier.hideLoader();
	},
	
	// Link requests
	replaceLinkRequestResponse : function(response){
		object = JSON.parse(response)
		Tweasier.enableStatusForm();
		Tweasier.hideLoader(true);
		
		if(object.text) {
			Tweasier.setStatusFormLabel("URL's successfully shortened");
			Tweasier.setStatusFormFocus(object.text);
		}
		else
		{
			Tweasier.setStatusFormLabel(object.error);
		}
	},
	
	// Search requests
	replaceSearchResponse : function(response){
		$("#search_results").empty().append(response);
		Tweasier.hideLoader(true);
		Tweasier.forceExternalLinks(); // remove eventually
	},
	
	// Retweets requests
	replaceSpamReportResponse : function(response){
		object = this.parseJSON(response);
		$("#spam_report_message").html(object.text);
	},
	
	poller : {
		pollerClass   : '.resque_poller',
		pollerTimeout : 3000,
		
		setup : function(){
			this.removeClickEvents();
			this.hideAll();
			this.run();
		},
		
		removeClickEvents : function()
		{
			$(this.pollerClass).each(function(){
				$(this).click(function(e){ e.preventDefault(); });
			})
		},
		
		hideAll : function()
		{
			$(this.pollerClass).hide();
		},
		
		showAll : function()
		{
			$(this.pollerClass).show();
		},
		
		run : function()
		{
			var context = this;
			
			$(this.pollerClass).each(function(){
				context.poll($(this));
			});
		},
		
		queuePollingFor : function(poller)
		{
			var context = this;
			setTimeout(function() { context.poll(poller); }, context.pollerTimeout);
		},
		
		poll : function(poller)
		{
			var context = this;
			var type    = poller.attr('rel');
			
			poller.show();
			
			$.ajax({ url: poller.attr('href'),
							 context: $(),
							 data: { user_id:window._current_user,
											 account_id:window._current_account },
							 success: function(data, status, request){
							   $('#' + type).replaceWith(data);
								 poller.hide();
							 },
					     error: function(request, status, error) {
								 context.queuePollingFor(poller);
						   }
			});
		}
	}
}

jQuery(function($) {
	
  Tweasier.poller.setup();
  var countdown = $('#countdown');
  var allowedCount = parseInt(countdown.text());

  $('#text').keydown(function() {
    var length = $(this).val().length;
    countdown.text(allowedCount - length);
  });
  
	$("#status_form").submit(function(){
		if($("#status_form > #text").val() == "")
		{
			Tweasier.setStatusFormLabel("Please enter some text");
			return false;
		}
	});

  $('a.dm').live('click', function() {
    var screen_name = $(this).attr('rel');
		
		if(window._current_account == screen_name)
		{
			alert("You can't direct message yourself!");
			return false;
		}
		
		Tweasier.setTop();
		Tweasier.setStatusFormLabel("New direct message to " + screen_name);
		Tweasier.setStatusFormSubmit("Message " + screen_name);
		Tweasier.setStatusFormAction(window.direct_messages_path);
		Tweasier.setStatusFormHiddenField("recipient_id", screen_name);
		Tweasier.setStatusFormFocus("");
    return false;
  });

  $('a.retweet').live('click', function(event) {
		event.preventDefault();
		
		var statusID    = this.rel
		var formName    = "#retweet_form_for-" + statusID;
		var messageName = "#retweet_link_for-" + statusID;
		
		Tweasier.showLoader("Retweeting status...")
		
		$.ajax({ type: "POST",
		 				 url: $(formName).attr("action"),
						 data: $(formName).serialize(),
						 success: function(response){ $(messageName).addClass("retweet_selected"); Tweasier.hideLoader(); },
						 error: function(response){ alert("Couldn't retweet status!") }
		});
		
    return false;
  });
  
  $('a.reply').live('click', function() {
		Tweasier.setTop();
		Tweasier.setStatusFormAction(window.statuses_path);
		
    var pieces = $(this).attr('rel').split(':');
    var screen_name = pieces[0];
    var id 					= pieces[1];
		
		$('#in_reply_to_status_id').val(id);
		
		Tweasier.setStatusFormFocus("@" + screen_name + " ");
		Tweasier.setStatusFormLabel("Replying to " + screen_name + "'s tweet")
		Tweasier.setStatusFormSubmit("Reply to " + screen_name);
    return false;
  });

  $('a.link_request').live('click', function() {
		Tweasier.disableStatusForm();
		Tweasier.showLoader("Shortening URLs, one moment please");
		
		$.ajax({ type: "POST",
		 				 url: this.href,
						 data: { text:$("#text").val() },
						 success: function(response){ Tweasier.replaceLinkRequestResponse(response); },
						 error: function(response){ Tweasier.replaceLinkRequestResponse(response); }
		});
		
    return false;
  });
	
  $('a#create_scheduled_status').live('click', function(e) {
		e.preventDefault();
		
		$.post(this.href, { text: $('#text').val() }, function(data){
      $.facybox(data);
    });
    
    return false;
  });
	
	$('a#submit_status_form').live('click', function(e) {
		e.preventDefault();
		Tweasier.submitStatusForm();
    return false;
  });
	
  $('#perform_search').submit(function(e) {
		e.preventDefault();
		Tweasier.showLoader("Running search '" + $("#search_title").val() + "'");
		
		$.ajax({ type: "POST",
		 				 url: this.action,
						 data: {},
						 success: function(response){ Tweasier.replaceSearchResponse(response); },
						 error: function(response){ Tweasier.replaceSearchResponse(response); }
		});
		
    return false;
  });
	
  $('a.inline_follow').live('click', function(event) {
		event.preventDefault();
		
		Tweasier.showLoader("Sending follow request");
		
		var userId   				 = this.rel;
		var followFormName   = ".follow_form_for-" + userId;
		var unfollowFormName = ".unfollow_form_for-" + userId;
		
		$.ajax({ type: "POST",
		 				 url: $(followFormName).attr("action"),
						 data: $(followFormName).serialize(),
						 success: function(response){ $(followFormName).hide(); $(unfollowFormName).show(); Tweasier.hideLoader(); },
						 error: function(response){ alert("Could not follow user inline, they may have a protected profile"); Tweasier.hideLoader(); }
		});
		
    return false;
  });
	
  $('a.inline_unfollow').live('click', function(event) {
		event.preventDefault();
		
		Tweasier.showLoader("Sending unfollow request");
		
		var userId   = this.rel
		var followFormName   = ".follow_form_for-" + userId;
		var unfollowFormName = ".unfollow_form_for-" + userId;
		
		$.ajax({ type: "POST",
		 				 url: $(unfollowFormName).attr("action"),
						 data: $(unfollowFormName).serialize(),
						 success: function(response){ $(unfollowFormName).hide(); $(followFormName).show(); Tweasier.hideLoader(); },
						 error: function(response){ alert("Could not unfollow user inline, they may have a protected profile"); Tweasier.hideLoader(); }
		});
		
    return false;
  });


  $('a.report_spam').live('click', function(event) {
		event.preventDefault();
		
		if(!confirm("Are you sure you want to report this user as spam?!")) return false;
		
		$(this).hide();
		
		var form_name    = "#spam_report_form";
		var message_name = "#spam_report_message";
		
		$(message_name).attr("style","display:inline");
		
		$.ajax({ type: "POST",
		 				 url: $(form_name).attr("action"),
						 data: $(form_name).serialize(),
						 success: function(response){ Tweasier.replaceSpamReportResponse(response); },
						 error: function(response){ Tweasier.replaceSpamReportResponse(response); }
		});
		
    return false;
  });
	
	// External links
	Tweasier.forceExternalLinks();
	
	// Poll observer
	Tweasier.setupPollForm();
	
	$(".poll_entry").change(function(){
		$.ajax({ type: "POST",
		 				 url: this.form.action,
						 data: $(this.form).serialize(),
						 success: function(response){ Tweasier.showPollResponse(response); },
						 error: function(response){ Tweasier.showPollResponse(response); }
		});
		return false;
	});
	
	// Feedback observer
	//Tweasier.setupPollForm();
	$("#feedback_entry_form").submit(function(){
		$.ajax({ type: "POST",
		 				 url: this.action,
						 data: $(this).serialize(),
						 success: function(response){ Tweasier.showFeedbackResponse(response); },
						 error: function(response){ Tweasier.showFeedbackResponse(response); }
		});
		return false;
	});
	
	// Statistics observer
	$("#statistics_form").live('submit', function(){
		Tweasier.showLoader("Tweeting statistics");
		
		$.ajax({ type: "POST",
		 				 url: this.action,
						 data: $(this).serialize(),
						 success: function(response){ Tweasier.showStatisticsResponse(response); },
						 error: function(response){ Tweasier.showStatisticsResponse(response); }
		});
		return false;
	});
	
	$('a.loading_message').live('click', function() {
		Tweasier.showLoader($(this).attr('rel') || "Loading...");
  });
  
	// Check for conditions that dont require a value and hide value text box if so
	$("#condition_search_condition_type_id").change(function(){
		(jQuery.inArray(this.value, window._valid_empty_conditions) != -1) ? $("#condition_value_wrapper").hide() : $("#condition_value_wrapper").show();
	});
	
	// Search batch amount selector
	$("#search_batch_count_selector").change(function(){
		if(this.value == "") return false;
		window.location = window.new_search_batches_path + "?count=" + this.value;
	});
	
	// Sort selector
	$("#sort_users_form > select").change(function(){
		if(this.value == "") return false;
		$("#sort_users_form").submit();
	});
	
	// Search batch amount selector
	$("#retweets_selector").change(function(){
		if(this.value == "") return false;
		window.location = "?filter=" + this.value;
	});
	
	// Setup Tweasier
	Tweasier.init();
	
	// Init FacyBox
	$('a[rel*=facybox]').facybox()
	
	// FAQ section
	$('#faq').makeFAQ({faqHeader: "h5", indexTitle:"Tweasier FAQ"});
	
});
