$(error_handler(function($) {
	var started = false;
	messaging.recv(error_handler(function(data) {
		if (started)
			return;
		var cur_selection = {top: -1, left: -1, width: -1, height: -1};
		$('body *').on('mouseover', error_handler(function(ev) {
			if (ev.eventPhase != Event.AT_TARGET)
				return;
			var pos = $(ev.target).offset();
			var size = {width: $(ev.target).width(), height: $(ev.target).height()};
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
		}));
		messaging.send({type: 'xpath-browser-url', url: window.location.href});
		started = true;
	}));
}));
