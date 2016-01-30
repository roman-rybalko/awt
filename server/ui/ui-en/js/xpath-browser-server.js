$(error_handler(function($) {
	var started = false;
	messaging.recv(error_handler(function() {
		if (started)
			return;
		var cur_selection = {top: -1, left: -1, width: -1, height: -1};
		$(document).on('xpath-browser-selection', error_handler(function(ev, target, scroll) {
			var pos = $(target).offset();
			var size = {width: $(target).width(), height: $(target).height()};
			if (cur_selection.top == pos.top && cur_selection.left == pos.left && cur_selection.width == size.width && cur_selection.height == size.height)
				return;
			cur_selection = {top: pos.top, left: top.left, width: size.width, height: size.height};
			pos.top -= 5;
			pos.left -= 5;
			size.width += 10;
			size.height += 10;
			if (pos.top < 0)
				pos.top = 0;
			if (pos.left < 0)
				pos.left = 0;
			$('.xpath-browser-selection').remove();
			$('body').append(
				'<div class="xpath-browser-selection" style="position: absolute; border-top: 1px dotted red; z-index: 7777777;'
				+ ' top: ' + pos.top + 'px;'
				+ ' left: ' + pos.left + 'px;'
				+ ' width: ' + size.width + 'px;'
				+ ' height: 1px;'
				+ '"></div>'
				+ '<div class="xpath-browser-selection" style="position: absolute; border-left: 1px dotted red; z-index: 7777777;'
				+ ' top: ' + pos.top + 'px;'
				+ ' left: ' + (pos.left + size.width) + 'px;'
				+ ' width: 1px;'
				+ ' height: ' + size.height + 'px;'
				+ '"></div>'
				+ '<div class="xpath-browser-selection" style="position: absolute; border-top: 1px dotted red; z-index: 7777777;'
				+ ' top: ' + (pos.top + size.height) + 'px;'
				+ ' left: ' + pos.left + 'px;'
				+ ' width: ' + size.width + 'px;'
				+ ' height: 1px;'
				+ '"></div>'
				+ '<div class="xpath-browser-selection" style="position: absolute; border-left: 1px dotted red; z-index: 7777777;'
				+ ' top: ' + pos.top + 'px;'
				+ ' left: ' + pos.left + 'px;'
				+ ' width: 1px;'
				+ ' height: ' + size.height + 'px;'
				+ '"></div>');
			if (scroll) {
				var win_size = {
					width: window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth,
					height: window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight
				};
				pos.left -= Math.round(win_size.width / 2);  // the center of the window
				pos.top -= Math.round(win_size.height / 2);  // the center of the window
				if (pos.top < 0)
					pos.top = 0;
				if (pos.left < 0)
					pos.left = 0;
				window.scrollTo(pos.left, pos.top);
			}
		}));
		$('body *').on('mouseover', error_handler(function(ev) {
			if (ev.eventPhase != Event.AT_TARGET)
				return;
			$(document).triggerHandler('xpath-browser-selection', [ev.target]);
		}));
		messaging.send({type: 'xpath-browser-url', url: window.location.href});
		started = true;
	}));
}));
